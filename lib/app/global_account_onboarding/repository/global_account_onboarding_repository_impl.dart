import 'package:piapiri_v2/app/global_account_onboarding/repository/global_account_onboarding_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class GlobalAccountOnboardingRepositoryImpl extends GlobalAccountOnboardingRepository {
  @override
  Future<ApiResponse> accountSettingStatus() async {
    return getIt<PPApi>().globalAccountOnboardingService.accountSettingStatus();
  }

  @override
  Future<ApiResponse> getAccountInfo({
    required int listType,
  }) async {
    return getIt<PPApi>().globalAccountOnboardingService.getAccountInfo(
          listType: listType,
        );
  }

  @override
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
  }) async {
    return getIt<PPApi>().globalAccountOnboardingService.uploadAccountInfo(
          countryOfCitizenship: countryOfCitizenship,
          countryOfTaxResidence: countryOfTaxResidence,
          employmentStatus: employmentStatus,
          totalAssets: totalAssets,
          fundingSource: fundingSource,
          isAffiliatedFinra: isAffiliatedFinra,
          isControlPerson: isControlPerson,
          isPoliticallyExposed: isPoliticallyExposed,
          immediateFamilyExposed: immediateFamilyExposed,
          employerName: employerName,
          employerAddress: employerAddress,
          employmentPosition: employmentPosition,
          agreementAcknowledgement: agreementAcknowledgement,
          digitalSignatureAcknowledgement: digitalSignatureAcknowledgement,
          agreementSignedAt: agreementSignedAt,
          agreementIpAddress: agreementIpAddress,
          createAccount: createAccount,
        );
  }
}
