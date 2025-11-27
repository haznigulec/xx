import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class GlobalAccountOnboardingService {
  final ApiClient api;

  GlobalAccountOnboardingService(this.api);

  static const String _accountSettingStatus = '/Capra/getaccountsettingstatus';
  static const String _getAccountInfo = '/Capra/getaccountinfo';
  static const String _uploadAccountInfo = '/Capra/updateaccountinfo';

  Future<ApiResponse> accountSettingStatus() async {
    return api.post(
      _accountSettingStatus,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
      },
    );
  }

  Future<ApiResponse> getAccountInfo({
    required int listType,
  }) async {
    return api.post(
      _getAccountInfo,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'listType': listType,
      },
    );
  }

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
    return api.post(
      _uploadAccountInfo,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'countryOfCitizenship': countryOfCitizenship,
        'countryOfTaxResidence': countryOfTaxResidence,
        'employmentStatus': employmentStatus,
        'totalAssets': totalAssets,
        'fundingSource': fundingSource,
        'isAffiliatedFinra': isAffiliatedFinra,
        'isControlPerson': isControlPerson,
        'isPoliticallyExposed': isPoliticallyExposed,
        'immediateFamilyExposed': immediateFamilyExposed,
        'employerName': employerName,
        'employerAddress': employerAddress,
        'employmentPosition': employmentPosition,
        'agreementAcknowledgement': agreementAcknowledgement,
        'digitalSignatureAcknowledgement': digitalSignatureAcknowledgement,
        'agreementSignedAt': agreementSignedAt,
        'agreementIpAddress': agreementIpAddress,
        'createAccount': createAccount,
      },
    );
  }
}
