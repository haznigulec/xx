import 'package:piapiri_v2/app/global_account_onboarding/model/account_setting_status_model.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';

abstract class GlobalAccountOnboardingEvent extends PEvent {}

class AccountSettingStatusEvent extends GlobalAccountOnboardingEvent {
  final Function(AccountSettingStatusModel accountSettingStatus)? succesCallback;
  final Function()? errorCallback;

  AccountSettingStatusEvent({
    this.succesCallback,
    this.errorCallback,
  });
}

class AccountInfoEvent extends GlobalAccountOnboardingEvent {
  final int listType;
  AccountInfoEvent({
    required this.listType,
  });
}

class UploadAccountInfoEvent extends GlobalAccountOnboardingEvent {
  final String? countryOfCitizenship;
  final String? countryOfTaxResidence;
  final String? employmentStatus;
  final String? totalAssets;
  final String? fundingSource;
  final bool? isAffiliatedFinra;
  final bool? isControlPerson;
  final bool? isPoliticallyExposed;
  final bool? immediateFamilyExposed;
  final String? employerName;
  final String? employerAddress;
  final String? employmentPosition;
  final bool? agreementAcknowledgement;
  final bool? digitalSignatureAcknowledgement;
  final String? agreementSignedAt;
  final String? agreementIpAddress;
  final bool? createAccount;
  final Function(ApiResponse) callback;
  UploadAccountInfoEvent({
    this.countryOfCitizenship,
    this.countryOfTaxResidence,
    this.employmentStatus,
    this.totalAssets,
    this.fundingSource,
    this.isAffiliatedFinra,
    this.isControlPerson,
    this.isPoliticallyExposed,
    this.immediateFamilyExposed,
    this.employerName,
    this.employerAddress,
    this.employmentPosition,
    this.agreementAcknowledgement,
    this.digitalSignatureAcknowledgement,
    this.agreementSignedAt,
    this.agreementIpAddress,
    this.createAccount,
    required this.callback,
  });
}
