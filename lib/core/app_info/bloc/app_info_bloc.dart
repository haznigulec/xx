import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:p_core/keys/navigator_keys.dart';
import 'package:p_core/utils/log_utils.dart';
import 'package:p_core/utils/platform_utils.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_bloc.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_event.dart';
import 'package:piapiri_v2/app/campaigns/bloc/campaigns_bloc.dart';
import 'package:piapiri_v2/app/campaigns/bloc/campaigns_event.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_bloc.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_event.dart';
import 'package:piapiri_v2/core/model/splash_story_model.dart';
import 'package:piapiri_v2/app/create_us_order/bloc/create_us_orders_bloc.dart';
import 'package:piapiri_v2/app/create_us_order/bloc/create_us_orders_event.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_event.dart';
import 'package:piapiri_v2/app/money_transfer/model/bank_model.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_bloc.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_event.dart';
import 'package:piapiri_v2/app/sectors/bloc/sectors_bloc.dart';
import 'package:piapiri_v2/app/sectors/bloc/sectors_event.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/app/warrant/bloc/warrant_bloc.dart';
import 'package:piapiri_v2/app/warrant/bloc/warrant_event.dart' as warrant_event;
import 'package:piapiri_v2/common/utils/local_keys.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_event.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_state.dart';
import 'package:piapiri_v2/core/app_info/repository/app_info_repository.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/bloc/language/bloc/language_bloc.dart';
import 'package:piapiri_v2/core/bloc/language/bloc/language_event.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/bloc/time/time_bloc.dart';
import 'package:piapiri_v2/core/bloc/time/time_event.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/notification_handler.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/config/service_locator_manager.dart';
import 'package:piapiri_v2/core/config/session_timer.dart';
import 'package:piapiri_v2/core/database/db_helper.dart';
import 'package:piapiri_v2/core/model/app_settings.dart';
import 'package:piapiri_v2/core/model/precaution_model.dart';
import 'package:piapiri_v2/core/model/session_model.dart';
import 'package:piapiri_v2/core/model/symbol_suffix_list_model.dart';
import 'package:piapiri_v2/core/model/us_time_model.dart';
import 'package:piapiri_v2/core/services/token_service.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AppInfoBloc extends PBloc<AppInfoState> {
  final AppInfoRepository _appInfoRepository;

  AppInfoBloc({required AppInfoRepository appInfoRepository})
      : _appInfoRepository = appInfoRepository,
        super(initialState: const AppInfoState()) {
    on<InitEvent>(_onInit);
    on<SetDeviceIdEvent>(_onSetDeviceId);
    on<SetAppThemeEvent>(_onSetAppTheme);
    on<GetUpdatedRecords>(_onGetUpdatedRecords); // db bloc
    on<ErrorAlertEvent>(_onErrorAlertEvent);
    on<SetMaxInstrumentCount>(_onSetMaxInstrumentCount); // symbol bloc
    on<InvalidateCacheEvent>(_onInvalidateCache); // profile bloc
    on<GetCautionListEvent>(_onGetCautionList);
    on<ChangeEnv>(_onChangeEnv);
    on<WriteHasMembershipEvent>(_onWriteHasMembership);
    on<ReadHasMembershipEvent>(_onReadHasMembership);
    on<ReadLoginCountEvent>(_onReadLoginCount);
    on<ReadShowAccountEvent>(_onReadShowCreateAccount);
    on<GetUSClockEvent>(_onGetUSClockEvent);
    on<ChangeSelectedMarketMenuEvent>(_onChangeSelectedMarketMenu);
    on<GetSessionHoursEvent>(_onGetSessionHours);
    on<GetIosDeviceModelsEvent>(_onGetIosDeviceModels);
    on<CheckAppFirstOpenEvent>(_onCheckAppFirstOpen);
    on<GetSplashStoriesEvent>(_onGetSplashStories);
  }

  FutureOr<void> _onInit(
    InitEvent event,
    Emitter<AppInfoState> emit,
  ) async {
    try {
      getIt<PPApi>().matriksService.deleteMatriksTokens();
      getIt<LocalStorage>().delete(LocalKeys.customerInfo);
      emit(
        state.copyWith(
          type: PageState.loading,
        ),
      );

      final bool hasConnection = await InternetConnectionChecker().hasConnection;
      DatabaseHelper dbHelper = DatabaseHelper();

      dbHelper.cleanLogs();
      if (hasConnection) {
        bool healthCheck = remoteConfig.getBool('isServerHealthy');
        if (healthCheck) {
          getIt<TimeBloc>().add(TimeConnectEvent());
          getIt<UsEquityBloc>().add(GetPolygonApiKeyEvent());
          int buildNumber = int.parse(getIt<AppInfo>().appVersion.split('+').last);
          RemoteConfigValue minBuildValue = remoteConfig.getValue('minBuild');
          int minBuild = jsonDecode(minBuildValue.asString())[PlatformUtils.isIos ? 'ios' : 'android'];
          List<SymbolSuffixListModel> symbolSuffixList =
              (jsonDecode(remoteConfig.getValue('symbolSuffixList').asString())['environments']
                      [AppConfig.instance.flavor == Flavor.dev ? 'dev' : 'prod']['symbolList'] as List)
                  .map((e) => SymbolSuffixListModel.fromJson(e))
                  .toList();
          String realEstateCertificateContractCode = remoteConfig.getString('realEstateCertificateContractCode');
          getIt<AppSettingsBloc>().add(
            GetLocalGeneralSettingsEvent(
              onSuccess: (generalSettings) {
                getIt<LanguageBloc>().add(
                  LanguageSetEvent(
                    languageCode: generalSettings.language.value,
                  ),
                );
              },
            ),
          );
          final cdnUrl = json.decode(remoteConfig.getString('cdnUrl'));
          getIt<AppInfo>().cdnUrlSetter = (AppConfig.instance.flavor == Flavor.dev ? cdnUrl['dev'] : cdnUrl['prod'])!;
          AppSettings deviceSettings = AppSettings();
          Map<String, String> memberShortNames = {};
          String deviceId = getIt<AppInfo>().deviceId;
          bool? isFirstTime = getIt<LocalStorage>().read(LocalKeys.firstOpen);

          add(
            ReadHasMembershipEvent(
              callback: (Map<dynamic, dynamic> hasMembership, _) async {
                if (hasMembership['status']) {
                  await getIt<NotificationHandler>().registerForNotifications();
                }
              },
            ),
          );

          getIt<Analytics>().setFirebaseUserProperties(
            customerId: '',
            deviceId: getIt<AppInfo>().deviceId,
          );
          ThemeMode appTheme = getIt<LocalStorage>().read(LocalKeys.appTheme) == null ||
                  getIt<LocalStorage>().read(LocalKeys.appTheme) == '1'
              ? ThemeMode.light
              : ThemeMode.dark;
          Map<String, dynamic> depositBankInfos = json.decode(remoteConfig.getString('bankInfos'));
          BankModel bankModel = BankModel.fromJson(depositBankInfos);
          bankModel.bankInfos?.sort((a, b) => a.id!.compareTo(b.id!));
          List<String> holidays = getIt<LocalStorage>().read(LocalKeys.holidays) ?? [];
          if (holidays.isEmpty || holidays.first.startsWith(DateTime.now().year.toString())) {
            ApiResponse holidaysResponse = await getIt<PPApi>().matriksService.getHolidays(
                  getIt<MatriksBloc>().state.endpoints!.rest!.holidays!.url!,
                );
            if (holidaysResponse.success) {
              holidays = List<String>.from(holidaysResponse.data);
              getIt<LocalStorage>().write(LocalKeys.holidays, holidays);
            }
          }
          ApiResponse priceStepsResponse = await getIt<PPApi>().appInfoService.getPriceSteps();
          Map<String, dynamic> viopPriceSteps = AppConfig.instance.flavor == Flavor.dev
              ? jsonDecode(remoteConfig.getString('DevViopPriceSteps'))
              : jsonDecode(remoteConfig.getString('ViopPriceSteps'));
          Map<String, dynamic> priceSteps = {};
          if (priceStepsResponse.success) {
            List<dynamic> completeSteps = priceStepsResponse.data.map((steps) => steps['values']).toList();
            List<dynamic> flatSteps = completeSteps.expand((e) => e).toList();
            for (Map<String, dynamic> steps in flatSteps) {
              priceSteps.addAll(
                {steps['symbolType'] ?? steps['submarketCode']: steps['PriceRanges']},
              );
            }
          }

          if (priceSteps['SSF'] == null) {
            priceSteps['SSF'] = viopPriceSteps['SSF'];
          }

          Future.microtask(() {
            add(ReadLoginCountEvent());
            getIt<CreateUsOrdersBloc>().add(GetComissionEvent());
            getIt<SymbolSearchBloc>().add(GetSymbolSortEvent());
            getIt<SectorsBloc>().add(GetBistSectorsEvent());
            getIt<FavoriteListBloc>().add(GetQuickListEvent());
            getIt<SymbolBloc>().add(GetMarketCarouselEvent());
            getIt<UsEquityBloc>().add(GetActiveSymbols());
            getIt<UsEquityBloc>().add(GetFavoriteSymbols());
            getIt<UsEquityBloc>().add(GetFractionableSymbols());
            getIt<CampaignsBloc>().add(GetCampaignIsAvailable());
            getIt<WarrantBloc>().add(warrant_event.GetWarrantUsUnderlyingEvent());
            getIt<SymbolChartBloc>().add(GetFundCompareSymbolsEvent());
            add(GetUSClockEvent());
          });

          ApiResponse codesResponse = await _appInfoRepository.fetchMemberCodes(
            getIt<MatriksBloc>().state.endpoints!.rest!.metaData!.members!.url ?? '',
          );
          if (codesResponse.success) {
            for (var memberCode in codesResponse.data) {
              memberShortNames[memberCode['memberCode']] =
                  (memberCode['shortName'] ?? memberCode['description'].toString().split(' ')[0]).toString();
            }
          }
          add(GetSessionHoursEvent());
          emit(
            state.copyWith(
              type: PageState.success,
              deviceId: deviceId,
              appTheme: appTheme,
              deviceSettings: deviceSettings,
              memberCodeShortNames: memberShortNames,
              holidays: holidays,
              priceSteps: priceSteps,
              bankModel: bankModel,
              symbolSuffixList: symbolSuffixList,
              realEstateCertificateContractCode: realEstateCertificateContractCode,
            ),
          );
          if (buildNumber >= minBuild) {
            add(GetCautionListEvent());
            event.onSuccess(isFirstTime ?? true);
          } else {
            PBottomSheet.showError(
              NavigatorKeys.navigatorKey.currentContext!,
              isDismissible: false,
              enableDrag: false,
              content: L10n.tr('should_update'),
              showFilledButton: true,
              filledButtonText: L10n.tr('guncelle'),
              onFilledButtonPressed: () async =>
                  await const MethodChannel('PIAPIRI_CHANNEL').invokeMethod('marketRedirect'),
            );
          }

          await getIt<NotificationHandler>().executePendingNavigationIfExists();
        } else {
          Map<String, dynamic> unhealtyStateMessage = jsonDecode(remoteConfig.getString('unhealtyStateMessage'));
          PBottomSheet.showError(
            NavigatorKeys.navigatorKey.currentContext!,
            content: unhealtyStateMessage[Intl.defaultLocale],
          );
        }
      } else {
        Utils().showConnectivityAlert(
          context: NavigatorKeys.navigatorKey.currentContext!,
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          type: PageState.failed,
        ),
      );
      event.onError(e.toString());
    }
  }

  FutureOr<void> _onSetDeviceId(
    SetDeviceIdEvent event,
    Emitter<AppInfoState> emit,
  ) async {
    emit(
      state.copyWith(
        deviceId: event.deviceId,
      ),
    );
  }

  FutureOr<void> _onSetAppTheme(
    SetAppThemeEvent event,
    Emitter<AppInfoState> emit,
  ) {
    emit(
      state.copyWith(
        appTheme: event.appTheme,
      ),
    );
  }

  FutureOr<void> _onGetUSClockEvent(
    GetUSClockEvent event,
    Emitter<AppInfoState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse usTimeResponse = await _appInfoRepository.getUSClock();

    if (usTimeResponse.success) {
      USTimeModel usTime = USTimeModel.fromJson(usTimeResponse.data);
      emit(
        state.copyWith(
          type: PageState.success,
          usTime: usTime,
        ),
      );
      event.onSuccessCallback?.call();
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: false,
            message: usTimeResponse.error?.message ?? '',
            errorCode: '99USCL01',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetUpdatedRecords(
    GetUpdatedRecords event,
    Emitter<AppInfoState> emit,
  ) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    String? lastUpdatedDate = getIt<LocalStorage>().read(LocalKeys.lastUpdateDate);
    String latestUpdateDate = lastUpdatedDate != null
        ? DateTime.parse(
            lastUpdatedDate,
          ).formatToJsonWithHours()
        : '2025-11-25 10:05';

    talker.critical(latestUpdateDate);

    ApiResponse response = await _appInfoRepository.getUpdatedRecords(
      lastDate: latestUpdateDate,
    );

    if (response.success) {
      await dbHelper.updateRecords(response.data).then((_) => event.callback());
      getIt<LocalStorage>().write(LocalKeys.lastUpdateDate, DateTime.now().toString());
    }
  }

  FutureOr<void> _onErrorAlertEvent(
    ErrorAlertEvent event,
    Emitter<AppInfoState> emit,
  ) {
    if (!state.hasErrorAlert) {
      event.callback?.call();
    }
    emit(
      state.copyWith(
        hasErrorAlert: event.status,
      ),
    );
  }

  FutureOr<void> _onSetMaxInstrumentCount(
    SetMaxInstrumentCount event,
    Emitter<AppInfoState> emit,
  ) {
    emit(
      state.copyWith(
        maxInstrumentCount: event.maxInstrumentCount,
        maxGridCount: event.maxGridCount,
      ),
    );
  }

  FutureOr<void> _onInvalidateCache(
    InvalidateCacheEvent event,
    Emitter<AppInfoState> emit,
  ) {
    DateTime now = DateTime.now();
    DateTime lastMidnight = DateTime(now.year, now.month, now.day);
    String? lastUpdatedDate = getIt<LocalStorage>().read(LocalKeys.lastUpdateDate);
    if (lastUpdatedDate != null && lastMidnight.isAfter(DateTime.parse(lastUpdatedDate))) {
      DefaultCacheManager().emptyCache();
    }
  }

  FutureOr<void> _onGetCautionList(
    GetCautionListEvent event,
    Emitter<AppInfoState> emit,
  ) async {
    File precautionFile = await _appInfoRepository.getPrecautionList();
    List<PrecautionModel> precautionList = [];
    try {
      await precautionFile.readAsLines().then((lines) {
        for (int i = 2; i < lines.length; i++) {
          List<String> elements = lines[i].split(';');
          if (elements.length >= 6) {
            precautionList.add(
              PrecautionModel(
                elements[0],
                elements[1],
                elements[2],
                elements[3],
                elements[4],
                elements[5],
              ),
            );
          }
        }
        emit(
          state.copyWith(
            precautionList: precautionList,
          ),
        );
      });
    } catch (e) {
      LogUtils.pLog(e.toString());
    }
  }

  FutureOr<void> _onChangeEnv(
    ChangeEnv event,
    Emitter<AppInfoState> emit,
  ) async {
    emit(
      state.copyWith(
        customerId: '',
        customerSettings: AppSettings(),
      ),
    );
    getIt<LocalStorage>().delete(LocalKeys.customerInfo);
    getIt<LocalStorage>().delete(LocalKeys.otpTimeOut);
    getIt<LocalStorage>().delete(LocalKeys.customerType);
    getIt<TokenService>().clearToken();
    ServiceLocatorManager.cancelQueue();
    SessionTimer.instance?.cancelTimer();
    event.callback();
  }

  FutureOr<void> _onWriteHasMembership(
    WriteHasMembershipEvent event,
    Emitter<AppInfoState> emit,
  ) async {
    _appInfoRepository.writeHasMembership(
      status: event.status,
      gsm: event.gsm,
    );
  }

  FutureOr<void> _onReadHasMembership(
    ReadHasMembershipEvent event,
    Emitter<AppInfoState> emit,
  ) async {
    state.copyWith(
      type: PageState.loading,
    );
    Map? loginCount = _appInfoRepository.readLoginCount();
    String? customerId =
        loginCount.isEmpty ? null : await getIt<LocalStorage>().readSecure(LocalKeys.loginTcCustomerNo);
    Map<dynamic, dynamic> membership = _appInfoRepository.readHasMembership();
    await event.callback(membership, customerId);

    emit(
      state.copyWith(
        type: PageState.success,
        hasMembership: membership,
      ),
    );
  }

  FutureOr<void> _onReadLoginCount(
    ReadLoginCountEvent event,
    Emitter<AppInfoState> emit,
  ) async {
    state.copyWith(
      type: PageState.loading,
    );
    await event.callback?.call(_appInfoRepository.readLoginCount());
    emit(
      state.copyWith(
        type: PageState.success,
        loginCount: _appInfoRepository.readLoginCount(),
      ),
    );
  }

  FutureOr<void> _onReadShowCreateAccount(
    ReadShowAccountEvent event,
    Emitter<AppInfoState> emit,
  ) async {
    state.copyWith(
      type: PageState.loading,
    );
    event.callback(
      _appInfoRepository.readShowCreateAccount(),
    );
    emit(
      state.copyWith(
        type: PageState.success,
        showCreateAccount: _appInfoRepository.readShowCreateAccount(),
      ),
    );
  }

  FutureOr<void> _onChangeSelectedMarketMenu(
    ChangeSelectedMarketMenuEvent event,
    Emitter<AppInfoState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedMarketMenuIndex: event.selectedIndex,
      ),
    );
  }

  FutureOr<void> _onGetSessionHours(
    GetSessionHoursEvent event,
    Emitter<AppInfoState> emit,
  ) async {
    ApiResponse response = await _appInfoRepository.getSessionHours();
    Map<String, dynamic> data = response.data;
    SessionModel bistPPSession = SessionModel(
      marketCode: 'BISTPP',
      openHour: data['BISTPP'][0],
      closeHour: data['BISTPP'][1],
    );

    List<SessionModel> bistViopSession = [];
    for (String key in data.keys.where((element) => element.startsWith('BISTVIOP'))) {
      bistViopSession.add(
        SessionModel(
          marketCode: key.split('/').last,
          openHour: data[key][0],
          closeHour: data[key][1],
        ),
      );
    }

    emit(state.copyWith(
      bistPPSession: bistPPSession,
      bistViopSession: bistViopSession,
    ));
  }

  FutureOr<void> _onGetIosDeviceModels(
    GetIosDeviceModelsEvent event,
    Emitter<AppInfoState> emit,
  ) async {
    Map<String, dynamic> iosDeviceModels = await _appInfoRepository.getIosDeviceModels();
    event.onSuccessCallback?.call(iosDeviceModels);
    emit(
      state.copyWith(
        iosDeviceModels: iosDeviceModels,
      ),
    );
  }

  FutureOr<void> _onCheckAppFirstOpen(
    CheckAppFirstOpenEvent event,
    Emitter<AppInfoState> emit,
  ) async {
    String deviceId = getIt<AppInfo>().deviceId;
    bool? isFirstTime = getIt<LocalStorage>().read(LocalKeys.firstOpen);

    if (isFirstTime == null || isFirstTime == true) {
      final ApiResponse firstOpenResponse = await _appInfoRepository.checkAppFirstOpen(deviceId);
      if (firstOpenResponse.success) {
        getIt<LocalStorage>().write(LocalKeys.firstOpen, false);
      }
    }
    event.callBack?.call();
  }

  FutureOr<void> _onGetSplashStories(
    GetSplashStoriesEvent event,
    Emitter emit,
  ) async {
    try {
      String? lastModified;
      Map<String, dynamic>? localSplashStories = await _appInfoRepository.readSplashStoriesLocal();
      if (localSplashStories != null) {
        ApiResponse headerResponse = await _appInfoRepository.getSplashStoriesHead();
        if (headerResponse.success) {
          final headers = headerResponse.dioResponse?.headers;
          lastModified = headers?['last-modified']?.first;
        }
      }

      if (localSplashStories == null || (lastModified != null && localSplashStories['lastModified'] != lastModified)) {
        ApiResponse response = await _appInfoRepository.getSplashStories();
        if (response.success && response.data != null) {
          final List<dynamic> jsonList = response.data as List<dynamic>;
          List<SplashStoryModel> splashStories =
              jsonList.map((jsonItem) => SplashStoryModel.fromJson(jsonItem as Map<String, dynamic>)).toList();

          _appInfoRepository.writeSplashStoriesLocal({
            'lastModified': response.dioResponse?.headers['last-modified']?.first,
            'splashStories': json.encode(jsonList),
          });

          emit(
            state.copyWith(
              splashStories: splashStories,
            ),
          );
          return;
        }
      }

      if (localSplashStories != null) {
        final List<dynamic> cachedJsonList = json.decode(localSplashStories['splashStories']) as List<dynamic>;
        List<SplashStoryModel> splashStories =
            cachedJsonList.map((jsonItem) => SplashStoryModel.fromJson(jsonItem as Map<String, dynamic>)).toList();

        emit(
          state.copyWith(
            splashStories: splashStories,
          ),
        );
      }
    } catch (error) {
      log('found an error in GetSplashStoriesEvent : $error');
    }
  }
}
