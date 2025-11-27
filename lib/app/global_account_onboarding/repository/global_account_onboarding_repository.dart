import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class GlobalAccountOnboardingRepository {
  Future<ApiResponse> accountSettingStatus();

  Future<ApiResponse> getAccountInfo({
    required int listType,
  });

  Future<ApiResponse> uploadAccountInfo({
    String? countryOfCitizenship,
    String? countryOfTaxResidence,
    String? employmentStatus,
    String? totalAssets,
    String? fundingSource,
    bool? isAffiliatedFinra,
    bool? isControlPerson,
    bool? isPoliticallyExposed,
    bool? immediateFamilyExposed,
    String? employerName,
    String? employerAddress,
    String? employmentPosition,
    bool? agreementAcknowledgement,
    bool? digitalSignatureAcknowledgement,
    String? agreementSignedAt,
    String? agreementIpAddress,
    bool? createAccount,
  });
}
