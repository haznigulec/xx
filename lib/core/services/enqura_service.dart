import 'dart:convert';
import 'dart:developer';

import 'package:piapiri_v2/app/enqura/model/enqura_create_user_model.dart';
import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/client/enqura_api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';

class EnquraService {
  final EnquraApiClient api;
  final ApiClient apiClient;

  EnquraService(
    this.api,
    this.apiClient,
  );

  static const String _authLogin = '/Auth/Login';
  static const String _authRefresh = '/Auth/Refresh';
  static const String _sendOtp = '/sms/sendotp';
  static const String _checkOtp = '/sms/checkotp';
  static const String _createOrUpdateUser = '/Onboarding/createorupdateuser';
  static const String _validateReferanceCode = '/Onboarding/refcodevalidate';
  static const String _getuser = '/Onboarding/getuser';

//Dictionary
  static const String _countries = '/Dictionary/GetCountries';
  static const String _cities = '/Dictionary/GetCities';
  static const String _district = '/Dictionary/GetDistincts';
  static const String _professions = '/Dictionary/GetProfessions';
  static const String _receiptTypes = '/Dictionary/GetReceiptTypes';
  static const String _workingHours = '/Dictionary/GetWorkingHours';
//Contract
  static const String _contractList = '/Contract/GetContractList';
  static const String _onboardingContracts = '/Contract/GetOnboardingContracts';
  static const String _approveContracts = '/Contract/ApproveContracts';
  static const String _customerContract = '/Contract/GetCustomerContract';
//Onboarding
  static const String _onboardingStartIntegration = '/Onboarding/StartIntegration';
  static const String _validateOCR = '/Onboarding/ValidateOCR';
  static const String _onboardingCheckCustomer = '/Onboarding/CheckIsCustomer';
  static const String _onboardingGetNfcRequriedData = '/Onboarding/GetNfcRequriedData';
  static const String _onboardingCustomerObject = '/Onboarding/GetCustomerIdentityObject';
  static const String _onboardingGetMeeting = '/Onboarding/GetMeetingData';
  static const String _onboardingGetVideoCallAvailability = '/Onboarding/GetVideoCallAvailability';
  static const String _onboardingSetMeeting = '/Onboarding/SetMeetingData';

  Future<ApiResponse> authLogin() async {
    return api.post(
      _authLogin,
      body: {
        'email': 'enqura',
        'password': 'ky5enq3!Aed6',
      },
    );
  }

  Future<ApiResponse> authRefresh({
    required String refreshToken,
  }) async {
    return api.post(
      _authRefresh,
      body: {
        'refreshToken': refreshToken,
      },
    );
  }

  Future<ApiResponse> sendOtp({
    required String sessionNo,
    required String phoneNo,
  }) async {
    return api.post(
      _sendOtp,
      tokenized: true,
      body: {
        'vendorCode': 'Piapiri-Enqura',
        'sessionNo': sessionNo,
        'to': phoneNo,
        'sendFor': 'register',
      },
    );
  }

  Future<ApiResponse> checkOtp({
    required String sessionNo,
    required String phoneNo,
    required String otpCode,
  }) async {
    return api.post(
      _checkOtp,
      tokenized: true,
      body: {
        'vendorCode': 'Piapiri-Enqura',
        'sessionNo': sessionNo,
        'to': phoneNo,
        'otpCode': otpCode,
      },
    );
  }

  Future<ApiResponse> createOrUpdateUser({
    required EnquraCreateUserModel user,
  }) async {
    final body = user.toJson();
    log(jsonEncode(body));
    return apiClient.post(
      _createOrUpdateUser,
      body: body,
    );
  }

  Future<ApiResponse> refCodeValidate({
    required String refCode,
  }) async {
    return apiClient.post(
      _validateReferanceCode,
      body: {
        'refCode': refCode,
      },
    );
  }

  Future<ApiResponse> getUser({
    required String gsm,
    required String guid,
  }) async {
    return apiClient.post(
      _getuser,
      body: {
        'phoneNumber': gsm.replaceAll(' ', ''),
        'guid': guid,
      },
    );
  }
//

//Ülkeleri listeler
  Future<ApiResponse> getCountries() async {
    return api.get(
      _countries,
      tokenized: true,
    );
  }

//Şehirleri listeler
  Future<ApiResponse> getCities() async {
    return api.get(
      '$_cities?CountryCode=TR',
      tokenized: true,
    );
  }

//ilçeleri listeler
  Future<ApiResponse> getDistrict({
    required String cityCode,
  }) async {
    return api.get(
      '$_district?CityCode=$cityCode',
      tokenized: true,
    );
  }

//meslekleri listeler
  Future<ApiResponse> getProfessions() async {
    return api.get(
      _professions,
      tokenized: true,
    );
  }

//çalışma saatlerini çeker
  Future<ApiResponse> getWorkingHours() async {
    return api.get(
      _workingHours,
      tokenized: true,
    );
  }

//ekstre tercihlerini çeker
  Future<ApiResponse> getReceiptTypes() async {
    return api.get(
      _receiptTypes,
      tokenized: true,
    );
  }

  //sözleşme listesini çeker
  Future<ApiResponse> getContractList() async {
    return api.get(
      _contractList,
      tokenized: true,
    );
  }

//Gelen parametrelere göre onboarding sürecinde gerekli olan sözleşmeleri verir
  Future<ApiResponse> getOnboardingContracts({
    required String sessionNo,
    required String referenceCode,
  }) async {
    return api.post(
      _onboardingContracts,
      tokenized: true,
      body: {
        'vendorCode': 'Piapiri-Enqura',
        'sessionNo': sessionNo,
        'referenceCode': referenceCode,
      },
    );
  }

  //Müşteri bilgisine göre sözleşmeleri döner
  Future<ApiResponse> getCustomerContract({
    required String sessionNo,
    required String identityNumber,
  }) async {
    return api.post(
      _customerContract,
      tokenized: true,
      body: {
        'vendorCode': 'Piapiri-Enqura',
        'sessionNo': sessionNo,
        'tckn': identityNumber,
      },
    );
  }

  //Kullanıcının onay verip devam ettiği sözleşmelerinin kayıtlarını gerçekleştirmek için
  Future<ApiResponse> approveContracts({
    required String sessionNo,
    required List<String> contractRefCode,
  }) async {
    return api.post(
      _approveContracts,
      tokenized: true,
      body: {
        'vendorCode': 'Piapiri-Enqura',
        'sessionNo': sessionNo,
        'contractRefCode': contractRefCode,
      },
    );
  }

  //Enqualify backoffice üzerinde Session oluşturmak için kullanılır
  Future<ApiResponse> startIntegration({
    required String sessionNo,
    required int identityNumber,
    required int birthYear,
    required int birthMonth,
    required int birthDay,
    required String phone,
    required bool etk,
  }) async {
    return api.post(
      _onboardingStartIntegration,
      tokenized: true,
      body: {
        'vendorCode': 'Piapiri-Enqura',
        'sessionNo': sessionNo,
        'identityNumber': identityNumber,
        'birthYear': birthYear,
        'birthMonth': birthMonth,
        'birthDay': birthDay,
        'phone': phone,
        'IysOptIn': etk,
      },
    );
  }

  //OCR NFC - Id registiration bilgisi kıyaslanacak
  Future<ApiResponse> validateOcr({
    required String sessionNo,
    required String refCode,
  }) async {
    return api.post(
      _validateOCR,
      tokenized: true,
      body: {
        'vendorCode': 'Piapiri-Enqura',
        'sessionNo': sessionNo,
        'referenceCode': refCode,
      },
    );
  }

  //Kullanıcı halihazır da piapiri müşterisi mi
  Future<ApiResponse> checkIsCustomer({
    required String sessionNo,
    required String tckn,
    String? vkn,
  }) async {
    return api.post(
      _onboardingCheckCustomer,
      tokenized: true,
      body: {
        'vendorCode': 'Piapiri-Enqura',
        'sessionNo': sessionNo,
        'tckn': tckn,
        'vkn': vkn ?? '',
      },
    );
  }

  //OCR NFC - Id registiration bilgisi kıyaslanacak
  Future<ApiResponse> getNfcRequiredData({
    required String sessionNo,
    required String referanceCode,
  }) async {
    return api.post(
      _onboardingGetNfcRequriedData,
      tokenized: true,
      body: {
        'vendorCode': 'Piapiri-Enqura',
        'sessionNo': sessionNo,
        'referenceCode': referanceCode,
      },
    );
  }

  //Enqura'ya gönderilmek üzere kullanıcı datası alınması için kullanılır
  Future<ApiResponse> getCustomerIdentyObject({
    required String sessionNo,
    required String identityNumber,
    required String birthYear,
    required String birthMonth,
    required String birthDay,
    required String phoneNumber,
  }) async {
    return api.post(
      _onboardingCustomerObject,
      tokenized: true,
      body: {
        'vendorCode': 'Piapiri-Enqura',
        'sessionNo': sessionNo,
        'identityNumber': identityNumber,
        'birthYear': birthYear,
        'birthMonth': birthMonth,
        'birthDay': birthDay,
        'phoneNumber': phoneNumber
      },
    );
  }

  //Randevu kaydetmek için kullanılır
  Future<ApiResponse> setMeetingData({
    required String sessionNo,
    required String referenceCode,
    required String meetingTime,
  }) async {
    return api.post(
      _onboardingSetMeeting,
      tokenized: true,
      body: {
        'vendorCode': 'Piapiri-Enqura',
        'sessionNo': sessionNo,
        'referenceCode': referenceCode,
        'meetingTime': meetingTime,
      },
    );
  }

  //Randevu saati sorgulamak için kullanılır
  Future<ApiResponse> getMeetingData({
    required String sessionNo,
    required String identityNo,
  }) async {
    return api.post(
      _onboardingGetMeeting,
      tokenized: true,
      body: {
        'vendorCode': 'Piapiri-Enqura',
        'sessionNo': sessionNo,
        'identityNo': identityNo,
      },
    );
  }

  //Çağrı tipi özelnde aktif olan agent var mı bilgisini döner
  Future<ApiResponse> getVideoCallAvailability({
    required String sessionNo,
  }) {
    return api.post(
      _onboardingGetVideoCallAvailability,
      tokenized: true,
      body: {
        'vendorCode': 'Piapiri-Enqura',
        'sessionNo': sessionNo,
      },
    );
  }
}
