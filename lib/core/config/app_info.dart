import 'dart:async';
import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:p_core/utils/string_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:piapiri_v2/common/utils/local_keys.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_event.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';

class AppInfo {
  late String _deviceId;
  late String _appLaunchId;
  late String _version;
  late String _deviceModel;
  String _cdnUrl = '';
  List<dynamic>? _accountList = [];
  String? _selectedAccount = '';

  Future<void> init() async {
    String? deviceId = await getIt<LocalStorage>().read(LocalKeys.deviceId);
    String deviceModel = '';
    _accountList = getIt<LocalStorage>().read(LocalKeys.accountList);
    if (deviceId == null || deviceId == 'unknown') {
      if (Platform.isIOS) {
        IosDeviceInfo iosDeviceInfo = await DeviceInfoPlugin().iosInfo;
        deviceId = iosDeviceInfo.identifierForVendor ?? '';
      } else {
        AndroidId androidDeviceId = const AndroidId();
        deviceId = await androidDeviceId.getId();
      }
      getIt<LocalStorage>().write(LocalKeys.deviceId, deviceId);
    }
    if (Platform.isIOS) {
      final Completer<void> iosModelsCompleter = Completer<void>();
      getIt<AppInfoBloc>().add(
        GetIosDeviceModelsEvent(
          onSuccessCallback: (iosDeviceModels) async {
            IosDeviceInfo iosDeviceInfo = await DeviceInfoPlugin().iosInfo;
            deviceModel = iosDeviceModels[iosDeviceInfo.data['utsname']['machine'] ?? iosDeviceInfo.model];
            iosModelsCompleter.complete();
          },
        ),
      );
      await iosModelsCompleter.future;
    } else {
      AndroidDeviceInfo androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
      deviceModel = '${StringUtils().capitalizeEachWord(androidDeviceInfo.manufacturer)} ${androidDeviceInfo.model}';
    }
    PackageInfo? packageInfo = await PackageInfo.fromPlatform();
    _version = '${packageInfo.version}+${packageInfo.buildNumber}';
    _deviceId = deviceId ?? '';
    _appLaunchId = StringUtils.generateUuid();
    _deviceModel = deviceModel;
    _selectedAccount = '';
  }

  Future<void> updateAccountList() async {
    _accountList = await getIt<LocalStorage>().read(LocalKeys.accountList);
    _selectedAccount = await getIt<LocalStorage>().read(LocalKeys.defaultAccount);
  }

  set cdnUrlSetter(String value) {
    _cdnUrl = value;
  }

  String get cdnUrl => _cdnUrl;

  String get deviceId => _deviceId;

  String get appVersion => _version;

  String get appLaunchId => _appLaunchId;

  String get deviceModel => _deviceModel;

  List<dynamic> get accountList => _accountList ?? [];

  String get selectedAccount => _selectedAccount ?? '';
  set selectedAccount(String value) => _selectedAccount = value;
}
