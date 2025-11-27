import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/model/splash_story_model.dart';
import 'package:piapiri_v2/app/money_transfer/model/bank_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/app_settings.dart';
import 'package:piapiri_v2/core/model/precaution_model.dart';
import 'package:piapiri_v2/core/model/session_model.dart';
import 'package:piapiri_v2/core/model/settings_model.dart';
import 'package:piapiri_v2/core/model/symbol_suffix_list_model.dart';
import 'package:piapiri_v2/core/model/us_time_model.dart';

class AppInfoState extends PState {
  final String customerId;
  final ThemeMode appTheme;
  final Map<String, dynamic> dictionaryKeyList;
  final Map<String, dynamic> memberCodeShortNames;
  final bool hasErrorAlert;
  final int maxInstrumentCount;
  final int maxGridCount;
  final List<PrecautionModel> precautionList;
  final List<String> holidays;
  final Map<String, dynamic> priceSteps;
  final BankModel? bankModel;
  final List<SettingsModel> ordersSettings;
  final bool showBuySellFloatingButton;
  final List<SettingsModel> viopSettings;
  final List<SettingsModel> equitySettings;
  final List<SettingsModel> fundSettings;
  final List<SettingsModel> securitySettings;
  final List<SettingsModel> applicationSettings;
  final List<SettingsModel> accountSettings;
  final String myReferenceCode;
  final String myReferenceCodeTitle;
  final USTimeModel? usTime;
  final Map<dynamic, dynamic> hasMembership;
  final Map<dynamic, dynamic> loginCount;
  final bool showCreateAccount;
  final int selectedMarketMenuIndex;
  final SessionModel bistPPSession;
  final List<SessionModel> bistViopSession;
  final List<SymbolSuffixListModel> symbolSuffixList;
  final String referanceCode;
  final String budyReferanceCode;
  final String realEstateCertificateContractCode;
  final Map<String, dynamic>? iosDeviceModels;
  final List<SplashStoryModel>? splashStories;

  const AppInfoState({
    super.type = PageState.initial,
    super.error,
    this.customerId = '',
    this.appTheme = ThemeMode.light,
    this.dictionaryKeyList = const {},
    this.memberCodeShortNames = const {},
    this.hasErrorAlert = false,
    this.maxInstrumentCount = 10,
    this.maxGridCount = 12,
    this.precautionList = const [],
    this.holidays = const [],
    this.priceSteps = const {},
    this.bankModel,
    this.ordersSettings = const [],
    this.showBuySellFloatingButton = false,
    this.viopSettings = const [],
    this.equitySettings = const [],
    this.fundSettings = const [],
    this.securitySettings = const [],
    this.applicationSettings = const [],
    this.accountSettings = const [],
    this.myReferenceCode = '',
    this.myReferenceCodeTitle = '',
    this.usTime,
    this.hasMembership = const {'status': false, 'gsm': ''},
    this.loginCount = const {},
    this.showCreateAccount = false,
    this.selectedMarketMenuIndex = 0,
    this.bistPPSession = const SessionModel(
      marketCode: 'BISTPP',
      openHour: '10:00',
      closeHour: '18:05',
    ),
    this.bistViopSession = const [],
    this.symbolSuffixList = const [],
    this.referanceCode = '',
    this.budyReferanceCode = '',
    this.realEstateCertificateContractCode = '',
    this.iosDeviceModels,
    this.splashStories = const [],
  });

  @override
  AppInfoState copyWith({
    PageState? type,
    PBlocError? error,
    String? deviceId,
    String? customerId,
    ThemeMode? appTheme,
    Map<String, dynamic>? dictionaryKeyList,
    AppSettings? deviceSettings,
    AppSettings? customerSettings,
    Map<String, dynamic>? memberCodeShortNames,
    bool? hasErrorAlert,
    int? maxInstrumentCount,
    int? maxGridCount,
    String? versionInfo,
    List<PrecautionModel>? precautionList,
    List<String>? holidays,
    Map<String, dynamic>? priceSteps,
    BankModel? bankModel,
    List<SettingsModel>? ordersSettings,
    bool? showBuySellFloatingButton,
    List<SettingsModel>? viopSettings,
    List<SettingsModel>? equitySettings,
    List<SettingsModel>? fundSettings,
    List<SettingsModel>? securitySettings,
    List<SettingsModel>? applicationSettings,
    List<SettingsModel>? accountSettings,
    String? myReferenceCode,
    String? myReferenceCodeTitle,
    USTimeModel? usTime,
    Map<dynamic, dynamic>? hasMembership,
    Map<dynamic, dynamic>? loginCount,
    bool? showCreateAccount,
    int? selectedMarketMenuIndex,
    SessionModel? bistPPSession,
    List<SessionModel>? bistViopSession,
    List<SymbolSuffixListModel>? symbolSuffixList,
    String? referanceCode,
    String? budyReferanceCode,
    String? realEstateCertificateContractCode,
    Map<String, dynamic>? iosDeviceModels,
    List<SplashStoryModel>? splashStories,
  }) {
    return AppInfoState(
      type: type ?? this.type,
      error: error ?? this.error,
      customerId: customerId ?? this.customerId,
      appTheme: appTheme ?? this.appTheme,
      dictionaryKeyList: dictionaryKeyList ?? this.dictionaryKeyList,
      memberCodeShortNames: memberCodeShortNames ?? this.memberCodeShortNames,
      hasErrorAlert: hasErrorAlert ?? this.hasErrorAlert,
      maxInstrumentCount: maxInstrumentCount ?? this.maxInstrumentCount,
      maxGridCount: maxGridCount ?? this.maxGridCount,
      precautionList: precautionList ?? this.precautionList,
      holidays: holidays ?? this.holidays,
      priceSteps: priceSteps ?? this.priceSteps,
      bankModel: bankModel ?? this.bankModel,
      ordersSettings: ordersSettings ?? this.ordersSettings,
      showBuySellFloatingButton: showBuySellFloatingButton ?? this.showBuySellFloatingButton,
      viopSettings: viopSettings ?? this.viopSettings,
      equitySettings: equitySettings ?? this.equitySettings,
      fundSettings: fundSettings ?? this.fundSettings,
      securitySettings: securitySettings ?? this.securitySettings,
      applicationSettings: applicationSettings ?? this.applicationSettings,
      accountSettings: accountSettings ?? this.accountSettings,
      myReferenceCode: myReferenceCode ?? this.myReferenceCode,
      myReferenceCodeTitle: myReferenceCodeTitle ?? this.myReferenceCodeTitle,
      usTime: usTime ?? this.usTime,
      hasMembership: hasMembership ?? this.hasMembership,
      loginCount: loginCount ?? this.loginCount,
      showCreateAccount: showCreateAccount ?? this.showCreateAccount,
      selectedMarketMenuIndex: selectedMarketMenuIndex ?? this.selectedMarketMenuIndex,
      bistPPSession: bistPPSession ?? this.bistPPSession,
      bistViopSession: bistViopSession ?? this.bistViopSession,
      symbolSuffixList: symbolSuffixList ?? this.symbolSuffixList,
      referanceCode: referanceCode ?? this.referanceCode,
      budyReferanceCode: budyReferanceCode ?? this.budyReferanceCode,
      realEstateCertificateContractCode: realEstateCertificateContractCode ?? this.realEstateCertificateContractCode,
      iosDeviceModels: iosDeviceModels ?? this.iosDeviceModels,
      splashStories: splashStories ?? this.splashStories,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        customerId,
        appTheme,
        dictionaryKeyList,
        memberCodeShortNames,
        hasErrorAlert,
        maxInstrumentCount,
        maxGridCount,
        precautionList,
        holidays,
        priceSteps,
        bankModel,
        ordersSettings,
        showBuySellFloatingButton,
        viopSettings,
        equitySettings,
        fundSettings,
        securitySettings,
        applicationSettings,
        accountSettings,
        myReferenceCode,
        myReferenceCodeTitle,
        usTime,
        hasMembership,
        loginCount,
        showCreateAccount,
        selectedMarketMenuIndex,
        bistPPSession,
        bistViopSession,
        symbolSuffixList,
        referanceCode,
        budyReferanceCode,
        realEstateCertificateContractCode,
        iosDeviceModels,
        splashStories,
      ];
}
