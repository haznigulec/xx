import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';

abstract class AppInfoEvent extends PEvent {}

class InitEvent extends AppInfoEvent {
  final Function(bool) onSuccess;
  final Function(String) onError;

  InitEvent({
    required this.onSuccess,
    required this.onError,
  });
}

class SetDeviceIdEvent extends AppInfoEvent {
  final String deviceId;

  SetDeviceIdEvent({
    required this.deviceId,
  });
}

class SetAppThemeEvent extends AppInfoEvent {
  final ThemeMode appTheme;

  SetAppThemeEvent({
    required this.appTheme,
  });
}

class GetAppSettingsEvent extends AppInfoEvent {
  final VoidCallback? callback;
  final Function(String, String)? onThemeAndLanguageChanged;

  GetAppSettingsEvent({
    this.callback,
    this.onThemeAndLanguageChanged,
  });
}

class GetTabSettingsByIdEvent extends AppInfoEvent {
  final int tabId;
  final VoidCallback? callback;
  final Function(String, String)? onThemeAndLanguageChanged;

  GetTabSettingsByIdEvent({
    required this.tabId,
    this.callback,
    this.onThemeAndLanguageChanged,
  });
}

class GetAppSettingsByDeviceIdEvent extends AppInfoEvent {
  GetAppSettingsByDeviceIdEvent();
}

class GetTabSettingsByDeviceIdEvent extends AppInfoEvent {
  final int tabId;
  GetTabSettingsByDeviceIdEvent({
    required this.tabId,
  });
}

class UpdateApplicationSettings extends AppInfoEvent {
  final int id;
  final List<Map<String, dynamic>> list;
  final VoidCallback? callback;

  UpdateApplicationSettings({
    required this.id,
    required this.list,
    this.callback,
  });
}

class GetUpdatedRecords extends AppInfoEvent {
  final VoidCallback callback;

  GetUpdatedRecords({
    required this.callback,
  });
}

class ErrorAlertEvent extends AppInfoEvent {
  final bool status;
  final Function()? callback;

  ErrorAlertEvent({
    required this.status,
    this.callback,
  });
}

class SetMaxInstrumentCount extends AppInfoEvent {
  final int maxInstrumentCount;
  final int maxGridCount;

  SetMaxInstrumentCount({
    required this.maxInstrumentCount,
    required this.maxGridCount,
  });
}

class GetProfileSettingsEvent extends AppInfoEvent {
  GetProfileSettingsEvent();
}

class InvalidateCacheEvent extends AppInfoEvent {}

class GetCautionListEvent extends AppInfoEvent {}

class ChangeEnv extends AppInfoEvent {
  final VoidCallback callback;

  ChangeEnv({
    required this.callback,
  });
}

class ChangeBiometricSettings extends AppInfoEvent {
  final bool enableBiometric;

  ChangeBiometricSettings({
    this.enableBiometric = true,
  });
}

class WriteHasMembershipEvent extends AppInfoEvent {
  final String gsm;
  final bool status;

  WriteHasMembershipEvent({
    required this.gsm,
    required this.status,
  });
}

class ReadHasMembershipEvent extends AppInfoEvent {
  final Function(Map<dynamic, dynamic> membership, String? customerId) callback;
  ReadHasMembershipEvent({
    required this.callback,
  });
}

class ReadLoginCountEvent extends AppInfoEvent {
  final Function(Map<dynamic, dynamic>)? callback;
  ReadLoginCountEvent({
    this.callback,
  });
}

class ReadShowAccountEvent extends AppInfoEvent {
  final Function(bool?) callback;
  ReadShowAccountEvent({
    required this.callback,
  });
}

class GetUSClockEvent extends AppInfoEvent {
  final Function()? onSuccessCallback;
  GetUSClockEvent({
    this.onSuccessCallback,
  });
}

class ChangeSelectedMarketMenuEvent extends AppInfoEvent {
  final int selectedIndex;
  ChangeSelectedMarketMenuEvent({
    required this.selectedIndex,
  });
}

class GetSessionHoursEvent extends AppInfoEvent {}

class GetIosDeviceModelsEvent extends AppInfoEvent {
  final Function(Map<String, dynamic>)? onSuccessCallback;
  GetIosDeviceModelsEvent({
    this.onSuccessCallback,
  });
}

class CheckAppFirstOpenEvent extends AppInfoEvent {
  final Function()? callBack;
  CheckAppFirstOpenEvent({
    this.callBack,
  });
}

class GetSplashStoriesEvent extends AppInfoEvent {
  GetSplashStoriesEvent();
}
