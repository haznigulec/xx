import 'package:piapiri_v2/app/enqura/model/enqura_create_user_model.dart';
import 'package:piapiri_v2/app/enqura/repository/enqura_repository.dart';
import 'package:piapiri_v2/app/enqura/utils/enqura_helpers.dart';
import 'package:piapiri_v2/common/utils/local_keys.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';

class EnquraRepositoryImpl extends EnquraRepository {
  @override
  Future<ApiResponse> authLogin() async {
    return getIt<PPApi>().enquraService.authLogin();
  }

  @override
  Future<ApiResponse> sendOtp({
    required String sessionNo,
    required String phoneNo,
  }) async {
    return getIt<PPApi>().enquraService.sendOtp(
          sessionNo: sessionNo,
          phoneNo: phoneNo,
        );
  }

  @override
  Future<ApiResponse> checkOtp({
    required String sessionNo,
    required String phoneNo,
    required String otpCode,
  }) async {
    return getIt<PPApi>().enquraService.checkOtp(
          sessionNo: sessionNo,
          phoneNo: phoneNo,
          otpCode: otpCode,
        );
  }

  @override
  Future<ApiResponse> authRefresh({
    required String refreshToken,
  }) async {
    return getIt<PPApi>().enquraService.authRefresh(
          refreshToken: refreshToken,
        );
  }

  @override
  Future<ApiResponse> sendRegisterOtp({
    required String sessionNo,
    required String phoneNo,
  }) async {
    return getIt<PPApi>().enquraService.sendOtp(
          sessionNo: sessionNo,
          phoneNo: phoneNo,
        );
  }

  @override
  Future<ApiResponse> createOrUpdateUser({
    required EnquraCreateUserModel user,
  }) {
    return getIt<PPApi>().enquraService.createOrUpdateUser(
          user: user,
        );
  }

  @override
  Future<ApiResponse> refCodeValidate({
    required String refCode,
  }) {
    return getIt<PPApi>().enquraService.refCodeValidate(
          refCode: refCode,
        );
  }

  @override
  Future<ApiResponse> getUsers({
    required String gsm,
    required String guid,
  }) async {
    return getIt<PPApi>().enquraService.getUser(
          gsm: gsm,
          guid: guid,
        );
  }

  @override
  Future<ApiResponse> getCountries() async {
    return getIt<PPApi>().enquraService.getCountries();
  }

  @override
  Future<ApiResponse> getCities() async {
    return getIt<PPApi>().enquraService.getCities();
  }

  @override
  Future<ApiResponse> getDistrict({
    required String cityCode,
  }) async {
    return getIt<PPApi>().enquraService.getDistrict(
          cityCode: cityCode,
        );
  }

  @override
  Future<ApiResponse> getProfessions() async {
    return getIt<PPApi>().enquraService.getProfessions();
  }

  @override
  Future<ApiResponse> getWorkingHours() async {
    return getIt<PPApi>().enquraService.getWorkingHours();
  }

  @override
  Future<ApiResponse> getReceiptTypes() async {
    return getIt<PPApi>().enquraService.getReceiptTypes();
  }

  @override
  Future<ApiResponse> getContractList() async {
    return getIt<PPApi>().enquraService.getContractList();
  }

  @override
  Future<ApiResponse> getOnboardingContracts({
    required String sessionNo,
    required String referenceCode,
  }) async {
    return getIt<PPApi>().enquraService.getOnboardingContracts(
          sessionNo: sessionNo,
          referenceCode: referenceCode,
        );
  }

  @override
  Future<ApiResponse> getCustomerContract({
    required String sessionNo,
    required String identityNumber,
  }) async {
    return getIt<PPApi>().enquraService.getCustomerContract(
          sessionNo: sessionNo,
          identityNumber: identityNumber,
        );
  }

  @override
  Future<ApiResponse> approveContracts({
    required String sessionNo,
    required List<String> contractRefCode,
  }) async {
    return getIt<PPApi>().enquraService.approveContracts(
          sessionNo: sessionNo,
          contractRefCode: contractRefCode,
        );
  }

  @override
  Future<ApiResponse> startIntegration({
    required String sessionNo,
    required int identityNumber,
    required int birthYear,
    required int birthMonth,
    required int birthDay,
    required String phone,
    required bool etk,
  }) async {
    return getIt<PPApi>().enquraService.startIntegration(
          sessionNo: sessionNo,
          identityNumber: identityNumber,
          birthYear: birthYear,
          birthMonth: birthMonth,
          birthDay: birthDay,
          phone: phone,
          etk: etk,
        );
  }

  @override
  Future<ApiResponse> validateOcr({
    required String sessionNo,
    required String refCode,
  }) async {
    return getIt<PPApi>().enquraService.validateOcr(
          sessionNo: sessionNo,
          refCode: refCode,
        );
  }

  @override
  Future<ApiResponse> checkIsCustomer({
    required String sessionNo,
    required String tckn,
    String? vkn,
  }) async {
    return getIt<PPApi>().enquraService.checkIsCustomer(
          sessionNo: sessionNo,
          tckn: tckn,
          vkn: vkn,
        );
  }

  @override
  Future<ApiResponse> getNfcRequiredData({
    required String sessionNo,
    required String referanceCode,
  }) async {
    return getIt<PPApi>().enquraService.getNfcRequiredData(
          sessionNo: sessionNo,
          referanceCode: referanceCode,
        );
  }

  @override
  Future<ApiResponse> getCustomerIdentyObject({
    required String sessionNo,
    required String identityNumber,
    required String birthYear,
    required String birthMonth,
    required String birthDay,
    required String phoneNumber,
  }) async {
    return getIt<PPApi>().enquraService.getCustomerIdentyObject(
          sessionNo: sessionNo,
          identityNumber: identityNumber,
          birthYear: birthYear,
          birthMonth: birthMonth,
          birthDay: birthDay,
          phoneNumber: phoneNumber,
        );
  }

  @override
  Future<ApiResponse> setMeetingData({
    required String sessionNo,
    required String referanceCode,
    required String meetingTime,
  }) async {
    return getIt<PPApi>().enquraService.setMeetingData(
          sessionNo: sessionNo,
          referenceCode: referanceCode,
          meetingTime: meetingTime,
        );
  }

  @override
  Future<ApiResponse> getMeetingData({
    required String sessionNo,
    required String identityNo,
  }) async {
    return getIt<PPApi>().enquraService.getMeetingData(
          sessionNo: sessionNo,
          identityNo: identityNo,
        );
  }

  @override
  Future<ApiResponse> getVideoCallAvailability({
    required String sessionNo,
  }) {
    return getIt<PPApi>().enquraService.getVideoCallAvailability(
          sessionNo: sessionNo,
        );
  }

  @override
  Future generateSessionNo() {
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return getIt<LocalStorage>().writeSecureAsync(LocalKeys.sessionNo, timestamp);
  }

  @override
  Future<String> readSessionNo() async {
    return await getIt<LocalStorage>().readSecure(LocalKeys.sessionNo) ?? '';
  }

  @override
  Future generateGuid() {
    final String guid = guidGenerator();
    return getIt<LocalStorage>().writeSecureAsync(LocalKeys.enquraGuid, guid);
  }

  @override
  Future<String> readGuid() async {
    return await getIt<LocalStorage>().readSecure(LocalKeys.enquraGuid) ?? '';
  }

  @override
  void deleteSessionNo() {
    return getIt<LocalStorage>().deleteSecure(LocalKeys.sessionNo);
  }

  @override
  deleteGuid() {
    return getIt<LocalStorage>().deleteSecure(LocalKeys.enquraGuid);
  }
}
