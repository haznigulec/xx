import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:p_core/utils/platform_utils.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_bloc.dart';
import 'package:piapiri_v2/app/enqura/model/configuration_model.dart';
import 'package:piapiri_v2/app/enqura/utils/enqura_helpers.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

typedef EnqualifyCallbackHandler = void Function(
  String method,
  Map<String, dynamic>? arguments,
);

class EnqualifyHelper {
  // Flutter -> Native
  static const MethodChannel _channel = MethodChannel('PIAPIRI_CHANNEL');
  //static StreamSubscription<Map<String, dynamic>>? _eventSub;
  // --- Internal guard: EventBridge init once before listening
  static bool _bridgeInited = false;
  static Future<void> _ensureBridgeInited() async {
    if (_bridgeInited) return;
    await EnqualifyEventBridge.init();
    _bridgeInited = true;
  }

  // -------------------- YÜKSEK SEVİYE AKIŞLAR --------------------

  /// Init akışı: startSelfServiceVerify -> onSessionStartSucceed/onSelfServiceReady
  ///

  static Future<bool> initialize({
    required ConfigurationModel config,
    required String referenceId,
  }) async {
    try {
      await _channel.invokeMethod('initialize', {
        'config': config.toJson(),
        'referenceId': referenceId,
      });
      return true;
    } on PlatformException catch (e) {
      talker.error('initialize() failed: ${e.message}');
      return false;
    }
  }

  static void setEventHandler(Function(String event, dynamic data) callback) async {
    const EventChannel eventChannel = EventChannel('PIAPIRI_EVENT_CHANNEL');
    eventChannel.receiveBroadcastStream().listen((event) {
      if (event is Map) {
        final e = event['event'] as String?;
        final data = event['data'];

        switch (e) {
          case 'idFrontCompleted':
            getIt<Analytics>().track(
              AnalyticsEvents.idFrontsideView,
            );
            break;
          case 'idBackCompleted':
            getIt<Analytics>().track(
              AnalyticsEvents.idBacksideView,
            );
            break;
          case 'faceDetectStart':
            getIt<Analytics>().track(
              AnalyticsEvents.livenessCheckCameraView,
            );
            break;
          case 'callWait':
            getIt<Analytics>().track(
              AnalyticsEvents.videoCallWaitingView,
            );
            break;
          case 'callStart':
            getIt<Analytics>().track(
              AnalyticsEvents.videoCallView,
            );
            break;
          default:
        }

        if (e != null) {
          callback(e, data);
        }
      }
    });
  }

  static Future<void> startIdVerify() async {
    try {
      await _channel.invokeMethod('startIDVerification');
    } on PlatformException catch (e) {
      talker.error('startIDVerification() failed: ${e.message}');
    }
  }

  static Future<bool> startIdFront() async {
    try {
      final result = await _channel.invokeMethod('startIDTypeCheckFront');
      return result;
    } on PlatformException catch (e) {
      talker.error('startIDVerification() failed: ${e.message}');
      return false;
    }
  }

  static Future<void> setUserInfo({
    required String purpose,
    required bool isHandicapped,
    required String tckn,
    required String phone,
    required String identityType,
    required String email,
  }) async {
    try {
      await _channel.invokeMethod('setUserInfo', {
        'purpose': purpose,
        'isHandicapped': isHandicapped,
        'tckn': tckn,
        'phone': phone,
        'identityType': identityType,
        'email': email,
      });
    } on PlatformException catch (e) {
      talker.error('setUserInfo() failed: ${e.message}');
      rethrow;
    }
  }

  static Future<bool> startSession() async {
    await _ensureBridgeInited();
    bool result = false;
    try {
      final response = await EnqualifyHelper.callAndWait(
        'startSelfServiceVerify',
        expectEvents: [
          'onSessionStartSucceed',
          'onSelfServiceReady',
        ],
        timeout: const Duration(seconds: 30),
      );

      if (response['event'] != 'onSessionStartSucceed') {
        var subResponse = await EnqualifyHelper.awaitEvent(
          'onSessionStartSucceed',
          timeout: const Duration(seconds: 30),
        );
        if (subResponse['event'] == 'onSessionStartSucceed') result = true;
      } else if (response['event'] != 'onSelfServiceReady') {
        var subResponse = await EnqualifyHelper.awaitEvent(
          'onSelfServiceReady',
          timeout: const Duration(seconds: 30),
        );
        if (subResponse['event'] == 'onSelfServiceReady') result = true;
      }

      talker.info('[Init] ready');
    } on PlatformException catch (e) {
      talker.error('[Init] failed: ${e.code} ${e.message}');
    }
    return result;
  }

  /// Log akışınla uyumlu OCR (Front) akışı
  static Future<bool> runOcrFrontFlow() async {
    await _ensureBridgeInited();
    try {
      getIt<Analytics>().track(
        AnalyticsEvents.idFrontsideView,
      );
      await EnqualifyHelper.callAndWait(
        'startIDTypeCheckFront',
        expectEvents: [
          'onIdTypeVerified',
        ],
        timeout: const Duration(seconds: 60),
      );

      await EnqualifyHelper.callAndWait(
        'fakeCheck',
        expectEvents: [
          'onFakeChecked',
        ],
        timeout: const Duration(seconds: 60),
      );

      await EnqualifyHelper.callAndWait(
        'startIDDoc',
        expectEvents: [
          'onIdDocCompleted',
        ],
        timeout: const Duration(seconds: 60),
      );
      getIt<Analytics>().track(
        AnalyticsEvents.idBacksideView,
      );
      await EnqualifyHelper.awaitEvent(
        'onIdDocStored',
        timeout: const Duration(seconds: 60),
      );

      return true;
    } on PlatformException catch (e) {
      talker.error('[OCR] failed: ${e.code} ${e.message}');
      return false;
    }
  }

  static Future<bool> runNfcFlow() async {
    await _ensureBridgeInited();
    try {
      final result = await EnqualifyHelper.callAndWait(
        'startNFC',
        expectEvents: [
          'onNfcVerified',
          'onNfcCompleted',
        ],
      );
      log(jsonEncode(result));
      return true;
    } on PlatformException catch (e) {
      talker.error('[NFC] failed: ${e.code} ${e.message}');
      return false;
    }
  }

  static Future<bool> runFaceFlow() async {
    await _ensureBridgeInited();
    try {
      getIt<Analytics>().track(
        AnalyticsEvents.livenessCheckCameraView,
      );
      await EnqualifyHelper.callAndWait(
        'startFaceDetect',
        expectEvents: [
          'onFaceDetected',
          'onFaceCompleted',
        ],
        timeout: const Duration(seconds: 60),
      );

      await EnqualifyHelper.callAndWait(
        'smileDetect',
        expectEvents: [
          'onSmileDetected',
        ],
        timeout: const Duration(seconds: 60),
      );

      await EnqualifyHelper.callAndWait(
        'eyeCloseDetect',
        expectEvents: [
          'onEyeCloseDetected',
          'onLeftEyeCloseDetected',
          'onRightEyeCloseDetected',
          'onEyeCloseIntervalDetected',
        ],
        timeout: const Duration(seconds: 60),
      );

      var sfc = await EnqualifyHelper.callAndWait(
        'setFaceCompleted',
        expectEvents: [
          'onFaceStoreCompleted',
          'onFaceStoreFailed',
        ],
        timeout: const Duration(seconds: 60),
      );

      if (sfc['event'] == 'onFaceStoreFailed') {
        talker.error('onFaceStoreFailed failed');
        return false;
      }

      await EnqualifyHelper.awaitEvent(
        'onFaceStored',
        timeout: const Duration(seconds: 10),
      );

      await EnqualifyHelper.awaitEvent(
        'onFaceCompleted',
        timeout: const Duration(seconds: 10),
      );

      return true;
    } on PlatformException catch (e) {
      talker.error('[FACE] failed: ${e.code} ${e.message}');
      return false;
    }
  }

  static Future runCallFlow() async {
    await _ensureBridgeInited();
    try {
      // final sh = await EnqualifyHelper.callAndWait(
      //   'setIsHandicapped',
      //   expectEvents: [
      //     'onSessionUpdateSucceed',
      //     'onSessionUpdateFailed',
      //   ],
      //   timeout: const Duration(seconds: 30),
      // );

      // if (sh['event'] == 'onSessionUpdateFailed') {
      //   talker.error('[CALL] failed : onSessionUpdateFailed');
      //   return false;
      // }

      await EnqualifyHelper.callAndWait(
        'startVideoChat',
        timeout: const Duration(seconds: 30),
      );

      var sc = await EnqualifyHelper.callAndWait(
        'startCall',
        expectEvents: [
          'onCallStarted',
          'onRoomIdSendSucceed',
          'onRoomIDSendFailed',
        ],
        timeout: const Duration(minutes: 10),
      );
      getIt<Analytics>().track(
        AnalyticsEvents.videoCallView,
      );
      if (sc['event'] == 'onCallStarted') {
        await EnqualifyHelper.callAndWait(
          'restartVideoChat',
          timeout: const Duration(seconds: 30),
        );
      }
    } on PlatformException catch (e) {
      talker.error('[CALL] failed: ${e.code} ${e.message}');
    }
  }

  // -------------------- ENV & SESSION --------------------

  static Future<void> setSessionId(String referenceId) async {
    try {
      await _channel.invokeMethod('setSessionId', {'referenceId': referenceId});
    } on PlatformException catch (e) {
      talker.error('setSessionId() failed: ${e.message}');
    }
  }

  // -------------------- EVENT UTILITIES --------------------

  static Future<Map<String, dynamic>> callAndWait(
    String method, {
    Map<String, dynamic>? args,
    List<String>? expectEvents,
    bool Function(String event, Map<String, dynamic> data)? where,
    Duration timeout = const Duration(seconds: 300),
  }) async {
    await _ensureBridgeInited();

    StreamSubscription? sub;
    final completer = Completer<Map<String, dynamic>>();

    if (expectEvents != null && expectEvents.isNotEmpty) {
      sub = EnqualifyEventBridge.stream.listen((payload) {
        final name = payload['event'] as String?;
        final data = (payload['data'] as Map?)?.cast<String, dynamic>() ?? const {};

        if (name == 'onFailure' && !completer.isCompleted) {
          completer.completeError(
            PlatformException(
              code: (data['code'] ?? 'UNKNOWN').toString(),
              message: (data['message'] ?? 'Bilinmeyen hata').toString(),
              details: data,
            ),
          );
          return;
        }

        if (name != null && expectEvents.contains(name)) {
          if (where == null || where(name, data)) {
            if (!completer.isCompleted) {
              completer.complete(<String, dynamic>{'event': name, 'data': data});
            }
          }
        }
      });
    }

    try {
      await _channel.invokeMethod(method, args);
    } catch (e) {
      // 🔴 ÖNEMLİ: invokeMethod patladıysa dinleyiciyi kapat
      await sub?.cancel();
      rethrow;
    }

    if (sub == null) {
      return <String, dynamic>{'event': '__NO_EVENT__', 'data': <String, dynamic>{}};
    }

    try {
      final res = await completer.future.timeout(
        timeout,
        onTimeout: () {
          throw PlatformException(
            code: 'TIMEOUT',
            message: 'Method $method timed out after ${timeout.inSeconds} seconds',
          );
        },
      );
      return res;
    } finally {
      await sub.cancel();
    }
  }

  static Future<Map<String, dynamic>> awaitEvent(
    String event, {
    Duration timeout = const Duration(seconds: 30),
    bool Function(Map<String, dynamic> data)? where,
  }) async {
    await _ensureBridgeInited();

    final completer = Completer<Map<String, dynamic>>();
    late final StreamSubscription sub;

    sub = EnqualifyEventBridge.stream.listen((payload) {
      final name = payload['event'] as String?;
      final data = (payload['data'] as Map?)?.cast<String, dynamic>() ?? const {};

      if (name == 'onFailure' && !completer.isCompleted) {
        completer.completeError(
          PlatformException(
            code: (data['code'] ?? 'UNKNOWN').toString(),
            message: (data['message'] ?? 'Bilinmeyen hata').toString(),
            details: data,
          ),
        );
        return;
      }

      if (name == event) {
        if (where == null || where(data)) {
          if (!completer.isCompleted) {
            completer.complete(<String, dynamic>{'event': name, 'data': data});
          }
        }
      }
    });

    try {
      final res = await completer.future.timeout(
        timeout,
        onTimeout: () {
          throw PlatformException(
            code: 'TIMEOUT',
            message: 'Method $event timed out after ${timeout.inSeconds} seconds',
          );
        },
      );
      return res;
    } finally {
      await sub.cancel();
    }
  }

  /// Tek event bekler, timeout’ta **null** döner (fallback senaryoları için).
  static Future<Map<String, dynamic>?> awaitEventOrNull(
    String event, {
    Duration timeout = const Duration(seconds: 30),
    bool Function(Map<String, dynamic> data)? where,
  }) async {
    await _ensureBridgeInited();

    final completer = Completer<Map<String, dynamic>?>();
    late final StreamSubscription sub;

    sub = EnqualifyEventBridge.stream.listen((payload) {
      final name = payload['event'] as String?;
      final data = (payload['data'] as Map?)?.cast<String, dynamic>() ?? const {};

      if (name == 'onFailure' && !completer.isCompleted) {
        completer.completeError(
          PlatformException(
            code: (data['code'] ?? 'UNKNOWN').toString(),
            message: (data['message'] ?? 'Bilinmeyen hata').toString(),
            details: data,
          ),
        );
        return;
      }

      if (name == event) {
        if (where == null || where(data)) {
          if (!completer.isCompleted) {
            completer.complete(<String, dynamic>{'event': name, 'data': data});
          }
        }
      }
    });

    try {
      final res = await completer.future.timeout(timeout, onTimeout: () => null);
      return res;
    } finally {
      await sub.cancel();
    }
  }

  // -------------------- OCR / TEKİL KOMUTLAR --------------------

  static Future<void> postIntegrationAddRequest(
    String type,
    String referance,
    String data,
  ) async {
    try {
      await _channel.invokeMethod(
        'postIntegrationAddRequest',
        {
          'type': type,
          'referance': referance,
          'data': data,
        },
      );
    } on PlatformException catch (e) {
      talker.error('postIntegrationAddRequest() failed: ${e.message}');
    }
  }

  static Future<void> startCardFrontDetect() async {
    try {
      await _channel.invokeMethod('startCardFrontDetect');
    } on PlatformException catch (e) {
      talker.error('startCardFrontDetect() failed: ${e.message}');
    }
  }

  static Future<void> startCardHoloDetect() async {
    try {
      await _channel.invokeMethod('startCardHoloDetect');
    } on PlatformException catch (e) {
      talker.error('startCardHoloDetect() failed: ${e.message}');
    }
  }

  static Future<void> startIDFrontAfterDetect() async {
    try {
      await _channel.invokeMethod('startIDFrontAfterDetect');
    } on PlatformException catch (e) {
      talker.error('startIDFrontAfterDetect() failed: ${e.message}');
    }
  }

  static Future<void> startIDTypeCheckBack() async {
    try {
      await _channel.invokeMethod('startIDTypeCheckBack');
    } on PlatformException catch (e) {
      talker.error('startIDTypeCheckBack() failed: ${e.message}');
    }
  }

  static Future<void> startIDBackAfterDetect() async {
    try {
      await _channel.invokeMethod('startIDBackAfterDetect');
    } on PlatformException catch (e) {
      talker.error('startIDBackAfterDetect() failed: ${e.message}');
    }
  }

  static Future<void> startMRZ() async {
    try {
      await _channel.invokeMethod('startMRZ');
    } on PlatformException catch (e) {
      talker.error('startMRZ() failed: ${e.message}');
    }
  }

  static Future<void> startIDDoc() async {
    try {
      await _channel.invokeMethod('startIDDoc');
    } on PlatformException catch (e) {
      talker.error('startIDDoc() failed: ${e.message}');
    }
  }

  static Future<void> fakeCheck() async {
    try {
      await _channel.invokeMethod('fakeCheck');
    } on PlatformException catch (e) {
      talker.error('fakeCheck() failed: ${e.message}');
    }
  }

  static Future<void> startCardBackDetect() async {
    try {
      await _channel.invokeMethod('startCardBackDetect');
    } on PlatformException catch (e) {
      talker.error('startCardBackDetect() failed: ${e.message}');
    }
  }

  // -------------------- NFC --------------------

  static Future<bool> isDeviceHasNfc() async {
    try {
      bool result = await _channel.invokeMethod('isDeviceHasNfc');
      return result;
    } on PlatformException catch (e) {
      talker.error('isDeviceHasNfc() failed: ${e.message}');
      return false;
    }
  }

  static Future<bool> isNfcEnabled() async {
    try {
      bool result = await _channel.invokeMethod('isNfcEnabled');
      return result;
    } on PlatformException catch (e) {
      talker.error('isNfcEnabled() failed: ${e.message}');
      return false;
    }
  }

  static Future<bool> startNFC() async {
    try {
      bool result = await _channel.invokeMethod('startNFC');
      return result;
    } on PlatformException catch (e) {
      talker.error('startNFC() failed: ${e.message}');
      return false;
    }
  }

  static Future<void> startNFCWithValues({
    required String serialNo,
    required String birthDate,
    required String expiryDate,
  }) async {
    try {
      await _channel.invokeMethod('startNFCWithValues', {
        'serialNo': serialNo,
        'birthDate': birthDate,
        'expiryDate': expiryDate,
      });
    } on PlatformException catch (e) {
      talker.error('startNFCWithValues() failed: ${e.message}');
    }
  }

  static Future<void> isCameraCloseNFC(bool isCameraCloseNFC) async {
    try {
      await _channel.invokeMethod('isCameraCloseNFC', {'isCameraCloseNFC': isCameraCloseNFC});
    } on PlatformException catch (e) {
      talker.error('isCameraCloseNFC() failed: ${e.message}');
    }
  }

  static Future<void> startNfcRetried(String title, String subTitle) async {
    await _channel.invokeMethod('startNfcRetried', {
      'title': title,
      'subtitle': subTitle,
    });
  }

  // -------------------- FACE / LIVENESS --------------------

  static Future<bool> startFaceDetect() async {
    try {
      await _channel.invokeMethod('startFaceDetect');
      getIt<Analytics>().track(
        AnalyticsEvents.livenessCheckCameraView,
      );
      return true;
    } on PlatformException catch (e) {
      talker.error('startFaceDetect() failed: ${e.message}');
      return false;
    }
  }

  static Future<void> smileDetect() async {
    try {
      await _channel.invokeMethod('smileDetect');
    } on PlatformException catch (e) {
      talker.error('smileDetect() failed: ${e.message}');
    }
  }

  static Future<void> eyeCloseDetect() async {
    try {
      await _channel.invokeMethod('eyeCloseDetect');
    } on PlatformException catch (e) {
      talker.error('eyeCloseDetect() failed: ${e.message}');
    }
  }

  static Future<void> eyeCloseIntervalDetect() async {
    try {
      await _channel.invokeMethod('eyeCloseIntervalDetect');
    } on PlatformException catch (e) {
      talker.error('eyeCloseIntervalDetect() failed: ${e.message}');
    }
  }

  static Future<void> faceRightDetect() async {
    try {
      await _channel.invokeMethod('faceRightDetect');
    } on PlatformException catch (e) {
      talker.error('faceRightDetect() failed: ${e.message}');
    }
  }

  static Future<void> faceLeftDetect() async {
    try {
      await _channel.invokeMethod('faceLeftDetect');
    } on PlatformException catch (e) {
      talker.error('faceLeftDetect() failed: ${e.message}');
    }
  }

  static Future<void> faceUpDetect() async {
    try {
      await _channel.invokeMethod('faceUpDetect');
    } on PlatformException catch (e) {
      talker.error('faceUpDetect() failed: ${e.message}');
    }
  }

  static Future<void> setFaceCompleted() async {
    try {
      await _channel.invokeMethod('setFaceCompleted');
    } on PlatformException catch (e) {
      talker.error('setFaceCompleted() failed: ${e.message}');
    }
  }

  // -------------------- VIDEO / CALL --------------------

  static Future<void> startVideoVerify() async {
    try {
      await _channel.invokeMethod('startVideoVerify');
    } on PlatformException catch (e) {
      talker.error('startVideoVerify() failed: ${e.message}');
    }
  }

  static Future<(bool, bool)> startVideoCall() async {
    try {
      final data = await _channel.invokeMethod('startVideoCall');
      final successResponse = L10n.tr('new_customer_result_success');
      final pendingResponse = L10n.tr('new_customer_result_pending');
      bool isSuccess = data['result'] == pendingResponse || data['result'] == successResponse;
      return (isSuccess, data['result'] == pendingResponse);
    } on PlatformException catch (e) {
      talker.error('startVideoCall() failed: ${e.message}');
      return (false, false);
    }
  }

  static Future<(bool, bool)> startAppointmentCall() async {
    try {
      final data = await _channel.invokeMethod('startAppointmentCall');
      final successResponse = L10n.tr('new_customer_result_success');
      final pendingResponse = L10n.tr('new_customer_result_pending');
      bool isSuccess = data['result'] == pendingResponse || data['result'] == successResponse;
      return (isSuccess, data['result'] == pendingResponse);
    } on PlatformException catch (e) {
      talker.error('startAppointmentCall() failed: ${e.message}');
      return (false, false);
    }
  }

  static Future<void> startVideoChat() async {
    try {
      await _channel.invokeMethod('startVideoChat');
    } on PlatformException catch (e) {
      talker.error('startVideoChat() failed: ${e.message}');
    }
  }

  static Future<void> startCall() async {
    try {
      await _channel.invokeMethod('startCall');
    } on PlatformException catch (e) {
      talker.error('startCall() failed: ${e.message}');
    }
  }

  static Future<void> restartVideoChat() async {
    try {
      await _channel.invokeMethod('restartVideoChat');
    } on PlatformException catch (e) {
      talker.error('restartVideoChat() failed: ${e.message}');
    }
  }

  static Future<void> hangupCall() async {
    try {
      await _channel.invokeMethod('hangupCall');
    } on PlatformException catch (e) {
      talker.error('hangupCall() failed: ${e.message}');
    }
  }

  static Future<void> exit() async {
    try {
      await _channel.invokeMethod('exit');
    } on PlatformException catch (e) {
      talker.error('exit() failed: ${e.message}');
    }
  }

  static Future<void> exitCall() async {
    try {
      await _channel.invokeMethod('exitCall');
    } on PlatformException catch (e) {
      talker.error('exitCall() failed: ${e.message}');
    }
  }

  // static Future<List<EnquraCallType>> getCallTypes() async {
  //   try {
  //     final jsonValue = await _channel.invokeMethod('getCallTypes');
  //     final dataList = (json.decode(jsonValue)['Data'] as List?)
  //             ?.map((e) => EnquraCallType.fromJson(Map<String, dynamic>.from(e)))
  //             .toList() ??
  //         [];
  //     return dataList;
  //   } on PlatformException catch (e) {
  //     talker.error('getCallTypes() failed: ${e.message}');
  //     return [];
  //   }
  // }

  static Future<AppointmentResponse> getAppointments() async {
    try {
      final jsonValue = PlatformUtils.isIos
          ? await _channel.invokeMethod('getAppointments', {
              'identityNo': getIt<EnquraBloc>().state.user?.identityNumber ?? '',
              'identityType': getIt<EnquraBloc>().state.identityType,
            })
          : await _channel.invokeMethod('getAppointments');
      final Map<String, dynamic> jsonMap = json.decode(jsonValue);
      return AppointmentResponse.fromJson(jsonMap);
    } on PlatformException catch (e) {
      talker.error('getAppointments() failed: ${e.message}');
    }
    return AppointmentResponse(data: [], isSuccessful: false, referenceId: '');
  }

  static String _formatWithUtcOffset(DateTime dt) {
    final iso = dt.toIso8601String().split('.').first;
    return '$iso+00:00';
  }

  static Future<AppointmentSlotsResponse?> getAvailableAppointments(
    String callType,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final startDateStr = _formatWithUtcOffset(startDate);
      final endDateStr = _formatWithUtcOffset(endDate);
      final jsonValue = await _channel.invokeMethod('getAvailableAppointments', {
        'callType': callType,
        'startDate': startDateStr,
        'endDate': endDateStr,
      });
      if (jsonValue != null) {
        final Map<String, dynamic> jsonMap = json.decode(jsonValue);
        final response = AppointmentSlotsResponse.fromJson(jsonMap);
        return response;
      }
    } on PlatformException catch (e) {
      talker.error('getAvailableAppointment() failed: ${e.message}');
    }
    return null;
  }

  static Future<AppointmentSlotsResponse?> saveAppointment(
    String callType,
    String? id,
    String? uuid,
    DateTime appointmentDate,
    String startTime,
  ) async {
    try {
      final appointmentDateStr = _formatWithUtcOffset(appointmentDate);
      final jsonValue = await _channel.invokeMethod('saveAppointment', {
        'callType': callType,
        'id': id,
        'uuid': uuid,
        'appointmentDate': appointmentDateStr,
        'startTime': startTime,
      });

      if (jsonValue != null) {
        final Map<String, dynamic> jsonMap = json.decode(jsonValue);
        final response = AppointmentSlotsResponse.fromJson(jsonMap);
        return response;
      }
    } on PlatformException catch (e) {
      talker.error('saveAppointment() failed: ${e.message}');
    }
    return null;
  }

  static Future<void> cancelAppointment() async {
    try {
      await _channel.invokeMethod(
        'cancelAppointment',
        {
          'identityNo': getIt<EnquraBloc>().state.user?.identityNumber ?? '',
        },
      );
    } on PlatformException catch (e) {
      talker.error('cancelAppointment() failed: ${e.message}');
    }
  }

  // -------------------- SELF SERVICE / MISC --------------------

  static Future<void> startSelfServiceVerify() async {
    try {
      await _channel.invokeMethod('startSelfServiceVerify');
    } on PlatformException catch (e) {
      talker.error('startSelfServiceVerify() failed: ${e.message}');
    }
  }

  static Future<void> startSelfService() async {
    try {
      await _channel.invokeMethod('startSelfService');
    } on PlatformException catch (e) {
      talker.error('startSelfService() failed: ${e.message}');
    }
  }

  static Future<void> startScreenRecording() async {
    try {
      await _channel.invokeMethod('startScreenRecording');
    } on PlatformException catch (e) {
      talker.error('startScreenRecording() failed: ${e.message}');
    }
  }

  static Future<void> stopScreenRecording() async {
    try {
      await _channel.invokeMethod('stopScreenRecording');
    } on PlatformException catch (e) {
      talker.error('stopScreenRecording() failed: ${e.message}');
    }
  }

  static Future<void> verificationCompleted() async {
    try {
      await _channel.invokeMethod('verificationCompleted');
    } on PlatformException catch (e) {
      talker.error('verificationCompleted() failed: ${e.message}');
    }
  }

  static Future<void> askUserScreenRecordPermission() async {
    try {
      await _channel.invokeMethod('askUserScreenRecordPermission');
    } on PlatformException catch (e) {
      talker.error('askUserScreenRecordPermission() failed: ${e.message}');
    }
  }

  // === Kamera kapatma/replace için eklenen methodlar ===

  /// SDK'nın confirmVerification(IDVerifyState) çağrısı (A_CONFIRM_VERIFICATION)
  /// state: 'IDText' | 'NFC' | 'Face'
  static Future<void> confirmVerification(String state) async {
    try {
      await _channel.invokeMethod('confirmVerification', {'state': state});
    } on PlatformException catch (e) {
      talker.error('confirmVerification($state) failed: ${e.message}');
    }
  }

  static Future<void> replaceFragment() async {
    try {
      await _channel.invokeMethod('replaceFragment');
    } on PlatformException catch (e) {
      talker.error('replaceWithCameraCloseFragment() failed: ${e.message}');
    }
  }

  /// OCR fail senaryosunda SDK'nın kendi close ekranını otomatik göstermesi için
  static Future<void> setOcrCameraCloseScreenEnabled(bool enabled) async {
    try {
      await _channel.invokeMethod('setOcrCameraCloseScreenEnabled', {'enabled': enabled});
    } on PlatformException catch (e) {
      talker.error('setOcrCameraCloseScreenEnabled() failed: ${e.message}');
    }
  }

  // === Genel methodlar ===

  static Future<void> onDestroySDK() async {
    try {
      await _channel.invokeMethod('destroy');
    } on PlatformException catch (e) {
      talker.error('onDestroySDK() failed: ${e.message}');
    }
  }

  static Future<void> closeFragmentByTag(String fragmentTag) async {
    await _channel.invokeMethod('closeFragmentByTag', {'tag': fragmentTag});
  }

  static Future<void> setIsContinue(bool isContinue) async {
    await _channel.invokeMethod('setIsContinue', {'aContinue': isContinue});
  }

  static Future<bool> getContinue() async {
    final result = await _channel.invokeMethod(
      'getIsContinue',
    );
    return result;
  }
}

// -------------------- EVENT BRIDGE --------------------

class EnqualifyEventBridge {
  static const MethodChannel _events = MethodChannel('PIAPIRI_CALLBACK');
  // static const EventChannel _iosEvents = EventChannel('piapiri/enqura_events');

  static final _controller = StreamController<Map<String, dynamic>>.broadcast();
  static Stream<Map<String, dynamic>> get stream => _controller.stream;

  static bool _inited = false;
  static EnqualifyCallbackHandler? _delegate;

  static Future<void> init() async {
    if (_inited) return;
    _inited = true;
    _events.setMethodCallHandler((call) async {
      final args = (call.arguments as Map?)?.cast<String, dynamic>();
      final payload = {
        'event': call.method,
        'data': args ?? const <String, dynamic>{},
      };
      // 1) Stream yayını
      _controller.add(payload);
      // 2) Opsiyonel delegate (UI katmanına doğrudan iletmek istersen)
      _delegate?.call(call.method, args);
    });

    // _iosEvents.receiveBroadcastStream().listen((event) {
    //   if (event is Map) {
    //     final payload = {
    //       'event': event['event'] ?? 'unknown',
    //       'data': event['data'] ?? const <String, dynamic>{},
    //     };
    //     _controller.add(payload);
    //     _delegate?.call(payload['event'] as String, payload['data'] as Map<String, dynamic>?);
    //   }
    // });
  }

  static void setDelegate(EnqualifyCallbackHandler? onEvent) {
    _delegate = onEvent;
  }
}
