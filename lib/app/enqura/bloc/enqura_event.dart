import 'dart:async';

import 'package:piapiri_v2/app/enqura/model/account_setting_status_model.dart';
import 'package:piapiri_v2/app/enqura/model/enqura_create_user_model.dart';
import 'package:piapiri_v2/app/enqura/model/item_list_model.dart';
import 'package:piapiri_v2/app/enqura/model/start_integration_model.dart';
import 'package:piapiri_v2/app/enqura/utils/enqura_helpers.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';

abstract class EnquraEvent extends PEvent {}

class GetTokenEvent extends EnquraEvent {
  final bool setNewToken;
  final Function()? onSuccess;

  GetTokenEvent({
    this.setNewToken = true,
    this.onSuccess,
  });
}

class CheckActiveProcessEvent extends EnquraEvent {
  final Function(bool)? callback;
  CheckActiveProcessEvent({
    this.callback,
  });
}

class ClearActiveProcessEvent extends EnquraEvent {
  ClearActiveProcessEvent();
}

class GenerateRegisterValuesEvent extends EnquraEvent {
  final bool onGenerateSessionNo;
  final Function()? callback;

  GenerateRegisterValuesEvent({
    this.onGenerateSessionNo = true,
    this.callback,
  });
}

class OtpStatusEvent extends EnquraEvent {
  final bool otpIsRequired;
  OtpStatusEvent({
    required this.otpIsRequired,
  });
}

class SendOtpEvent extends EnquraEvent {
  final String sessionNo;
  final String phoneNo;
  final Function(ApiResponse) onSuccess;

  SendOtpEvent({
    required this.sessionNo,
    required this.phoneNo,
    required this.onSuccess,
  });
}

class CheckOtpEvent extends EnquraEvent {
  final String sessionNo;
  final String phoneNo;
  final String otpCode;
  final Function()? onSuccess;

  CheckOtpEvent({
    required this.sessionNo,
    required this.phoneNo,
    required this.otpCode,
    this.onSuccess,
  });
}

class CreateOrUpdateUserEvent extends EnquraEvent {
  final EnquraCreateUserModel user;
  final Function()? onSuccess;
  CreateOrUpdateUserEvent({
    required this.user,
    this.onSuccess,
  });
}

class GetUserEvent extends EnquraEvent {
  final String phoneNumber;
  final String guid;
  final bool isFirstInitialize;
  final EnquraAccountSettingStatusModel? forceOldStatus;
  final Function()? successCallback;
  final Function(Completer<void> completer)? errorCallback;
  GetUserEvent({
    required this.phoneNumber,
    required this.guid,
    required this.isFirstInitialize,
    this.forceOldStatus,
    this.successCallback,
    this.errorCallback,
  });
}

class EnquraAccountSettingStatusEvent extends EnquraEvent {
  final String currentStep;
  EnquraAccountSettingStatusEvent({
    required this.currentStep,
  });
}

class EnquraCheckReferanceCodeEvent extends EnquraEvent {
  final String refCode;
  final Function(bool) callBack;
  EnquraCheckReferanceCodeEvent({
    required this.refCode,
    required this.callBack,
  });
}

class AuthRefreshEvent extends EnquraEvent {
  final String authRefresh;
  final Function(String)? onAccessToken;

  AuthRefreshEvent({
    required this.authRefresh,
    this.onAccessToken,
  });
}

class GetCountriesEvent extends EnquraEvent {
  final Function(List<ItemListModel>)? onSuccessCallBack;
  GetCountriesEvent({
    this.onSuccessCallBack,
  });
}

class GetCitiesEvent extends EnquraEvent {}

class GetDistrictEvent extends EnquraEvent {
  final String cityCode;

  GetDistrictEvent({
    required this.cityCode,
  });
}

class GetProfessionsEvent extends EnquraEvent {
  final Function(List<ItemListModel>)? onSuccessCallBack;
  GetProfessionsEvent({
    this.onSuccessCallBack,
  });
}

class GetWorkingHoursEvent extends EnquraEvent {}

class GetReceiptTypesEvent extends EnquraEvent {}

class EnquraGetContractListEvent extends EnquraEvent {}

class GetOnboardingContractsEvent extends EnquraEvent {
  final String sessionNo;
  final String referenceCode;

  GetOnboardingContractsEvent({
    required this.sessionNo,
    required this.referenceCode,
  });
}

class StartIntegrationEvent extends EnquraEvent {
  final String sessionNo;
  final int identityNumber;
  final int birthYear;
  final int birthMonth;
  final int birthDay;
  final String phone;
  final bool etk;
  final Function()? successCallback;
  final bool? manualAdresRequired;
  final Function(StartIntegrationModel)? errorCallback;

  StartIntegrationEvent({
    required this.sessionNo,
    required this.identityNumber,
    required this.birthYear,
    required this.birthMonth,
    required this.birthDay,
    required this.phone,
    this.successCallback,
    required this.etk,
    this.manualAdresRequired,
    this.errorCallback,
  });
}

class UpdateManualAdresRequiredEvent extends EnquraEvent {
  final bool manualAdresRequired;

  UpdateManualAdresRequiredEvent({
    required this.manualAdresRequired,
  });
}

class InitializeSDKEvent extends EnquraEvent {
  final bool checkAppointment;
  final Function(bool)? callback;

  InitializeSDKEvent({
    required this.checkAppointment,
    this.callback,
  });
}

class DestroySDKEvent extends EnquraEvent {
  final bool runDestroy;
  DestroySDKEvent({
    this.runDestroy = true,
  });
}

class GetCustomerContractEvent extends EnquraEvent {
  final String sessionNo;
  final String identityNumber;

  GetCustomerContractEvent({
    required this.sessionNo,
    required this.identityNumber,
  });
}

class ApproveContractsEvent extends EnquraEvent {
  final String sessionNo;
  final List<String> contractRefCode;
  final Function(bool)? isValidCallback;

  ApproveContractsEvent({
    required this.sessionNo,
    required this.contractRefCode,
    this.isValidCallback,
  });
}

class ValidateOCREvent extends EnquraEvent {
  final String sessionNo;
  final String refCode;
  final Function(bool)? isValidCallback;

  ValidateOCREvent({
    required this.sessionNo,
    required this.refCode,
    this.isValidCallback,
  });
}

class CheckIsCustomerEvent extends EnquraEvent {
  final String sessionNo;
  final String tckn;
  final String? vkn;
  final Function(bool)? onSuccess;
  CheckIsCustomerEvent({
    required this.sessionNo,
    required this.tckn,
    this.vkn,
    this.onSuccess,
  });
}

class GetNfcRequriedDataEvent extends EnquraEvent {
  final String sessionNo;
  final String referanceCode;

  GetNfcRequriedDataEvent({
    required this.sessionNo,
    required this.referanceCode,
  });
}

class GetCustomerIdentyObjectEvent extends EnquraEvent {
  final String sessionNo;
  final String identityNumber;
  final String birthYear;
  final String birthMonth;
  final String birthDay;
  final String phoneNumber;
  GetCustomerIdentyObjectEvent({
    required this.sessionNo,
    required this.identityNumber,
    required this.birthYear,
    required this.birthMonth,
    required this.birthDay,
    required this.phoneNumber,
  });
}

class SetMeetingDataEvent extends EnquraEvent {
  final String sessionNo;
  final String referanceCode;
  final DateTime meetingTime;
  final Function(bool)? onSuccessCallBack;

  SetMeetingDataEvent({
    required this.sessionNo,
    required this.referanceCode,
    required this.meetingTime,
    this.onSuccessCallBack,
  });
}

class GetMeetingDataEvent extends EnquraEvent {
  final String sessionNo;
  final String identityNo;

  GetMeetingDataEvent({
    required this.sessionNo,
    required this.identityNo,
  });
}

class GetVideoCallAvailabilityEvent extends EnquraEvent {
  final String sessionNo;
  final Function(
    bool,
    Completer<void> completer,
  )? onSuccessCallBack;
  GetVideoCallAvailabilityEvent({
    required this.sessionNo,
    this.onSuccessCallBack,
  });
}

class ReadSessionNoEvent extends EnquraEvent {
  final Function(String?)? onCallBack;
  ReadSessionNoEvent({
    this.onCallBack,
  });
}

class DeleteSessionNoEvent extends EnquraEvent {
  final Function(bool)? onSuccessCallBack;
  DeleteSessionNoEvent({
    this.onSuccessCallBack,
  });
}

class EnqualifyListenerEvent extends EnquraEvent {
  final Function(String?)? onCallBack;
  EnqualifyListenerEvent({
    this.onCallBack,
  });
}

class PostIntegrationAddEvent extends EnquraEvent {
  final Function()? onCallback;
  PostIntegrationAddEvent({
    this.onCallback,
  });
}

class GetAppointmentEvent extends EnquraEvent {
  final Function(
    AppointmentData? appointmentData,
  )? onCallback;

  GetAppointmentEvent({
    this.onCallback,
  });
}

class SaveAppointmentEvent extends EnquraEvent {
  final AppointmentSlotItem appointmentItem;
  final Function(bool)? onCallback;

  SaveAppointmentEvent({
    required this.appointmentItem,
    this.onCallback,
  });
}

class ClearAppointmentEvent extends EnquraEvent {
  final Function()? onCallback;
  ClearAppointmentEvent({
    this.onCallback,
  });
}
