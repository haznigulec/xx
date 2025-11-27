import 'package:piapiri_v2/app/enqura/model/enqura_create_user_model.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class EnquraRepository {
  Future<ApiResponse> authLogin();

  Future<ApiResponse> sendOtp({
    required String sessionNo,
    required String phoneNo,
  });

  Future<ApiResponse> checkOtp({
    required String sessionNo,
    required String phoneNo,
    required String otpCode,
  });

  Future<ApiResponse> authRefresh({
    required String refreshToken,
  });

  Future<ApiResponse> sendRegisterOtp({
    required String sessionNo,
    required String phoneNo,
  });

  Future<ApiResponse> createOrUpdateUser({
    required EnquraCreateUserModel user,
  });

  Future<ApiResponse> refCodeValidate({
    required String refCode,
  });

  Future<ApiResponse> getUsers({
    required String gsm,
    required String guid,
  });

  Future<ApiResponse> getCountries();

  Future<ApiResponse> getCities();

  Future<ApiResponse> getDistrict({
    required String cityCode,
  });

  Future<ApiResponse> getProfessions();

  Future<ApiResponse> getWorkingHours();

  Future<ApiResponse> getReceiptTypes();

  Future<ApiResponse> getContractList();

  Future<ApiResponse> getOnboardingContracts({
    required String sessionNo,
    required String referenceCode,
  });

  Future<ApiResponse> approveContracts({
    required String sessionNo,
    required List<String> contractRefCode,
  });

  Future<ApiResponse> startIntegration({
    required String sessionNo,
    required int identityNumber,
    required int birthYear,
    required int birthMonth,
    required int birthDay,
    required String phone,
    required bool etk,
  });

  Future<ApiResponse> getCustomerContract({
    required String sessionNo,
    required String identityNumber,
  });

  Future<ApiResponse> validateOcr({
    required String sessionNo,
    required String refCode,
  });

  Future<ApiResponse> checkIsCustomer({
    required String sessionNo,
    required String tckn,
    String? vkn,
  });

  Future<ApiResponse> getNfcRequiredData({
    required String sessionNo,
    required String referanceCode,
  });

  Future<ApiResponse> getCustomerIdentyObject({
    required String sessionNo,
    required String identityNumber,
    required String birthYear,
    required String birthMonth,
    required String birthDay,
    required String phoneNumber,
  });

  Future<ApiResponse> setMeetingData({
    required String sessionNo,
    required String referanceCode,
    required String meetingTime,
  });

  Future<ApiResponse> getMeetingData({
    required String sessionNo,
    required String identityNo,
  });

  Future<ApiResponse> getVideoCallAvailability({
    required String sessionNo,
  });

  Future generateSessionNo();

  Future<String> readSessionNo();

  deleteSessionNo();

  Future generateGuid();

  Future<String> readGuid();

  deleteGuid();
}
