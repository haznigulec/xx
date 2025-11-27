import 'package:piapiri_v2/app/contracts/repository/contracts_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/set_answer_model.dart';

class ContractsRepositoryImpl extends ContractsRepository {
  @override
  Future<ApiResponse> getSurveyQuestion() {
    return getIt<PPApi>().contractsService.getSurveyQuestion();
  }

  @override
  Future<ApiResponse> getCustomerAnswers() async {
    return getIt<PPApi>().contractsService.getCustomerAnswers();
  }

  @override
  Future<ApiResponse> setSurveyAnswers({
    required List<SetAnswersModel> answers,
    required String accountId,
  }) async {
    return getIt<PPApi>().contractsService.setSurveyAnswers(
          answers: answers,
          accountId: accountId,
        );
  }

  @override
  Future<ApiResponse> getRequiredContracts() async {
    return getIt<PPApi>().contractsService.getRequiredContracts();
  }

  @override
  Future<ApiResponse> approveUserContract({
    required List<String> contractRefCode,
  }) async {
    return getIt<PPApi>().contractsService.approveUserContract(
          contractRefCode: contractRefCode,
        );
  }

  @override
  Future<ApiResponse> getUserContractFile({
    required String refCode,
  }) async {
    return getIt<PPApi>().contractsService.getUserContractFile(
          refCode: refCode,
        );
  }

  @override
  Future<ApiResponse> getContractPdf({
    required String contractCode,
  }) async {
    return getIt<PPApi>().contractsService.getContractPdf(
          contractCode: contractCode,
        );
  }

  @override
  Future<ApiResponse> approveGtpContract({
    required String contractCode,
    required String accountExtId,
    required String contractRefCode,
  }) {
    return getIt<PPApi>().contractsService.approveGtpContract(
          contractCode: contractCode,
          accountExtId: accountExtId,
          contractRefCode: contractRefCode,
        );
  }

  @override
  Future<ApiResponse> getCustomerApprovedContracts() {
    return getIt<PPApi>().contractsService.getCustomerApprovedContracts();
  }

  @override
  Future<ApiResponse> getGtpContract() {
    return getIt<PPApi>().contractsService.getGtpContract();
  }
}
