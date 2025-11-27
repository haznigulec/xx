import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/set_answer_model.dart';

abstract class ContractsRepository {
  Future<ApiResponse> getSurveyQuestion();

  Future<ApiResponse> getCustomerAnswers();

  Future<ApiResponse> setSurveyAnswers({
    required List<SetAnswersModel> answers,
    required String accountId,
  });

  Future<ApiResponse> getRequiredContracts();

  Future<ApiResponse> approveUserContract({
    required List<String> contractRefCode,
  });

  Future<ApiResponse> getUserContractFile({
    required String refCode,
  });

  Future<ApiResponse> getContractPdf({
    required String contractCode,
  });

  Future<ApiResponse> approveGtpContract({
    required String contractCode,
    required String accountExtId,
    required String contractRefCode,
  });

  Future<ApiResponse> getCustomerApprovedContracts();

  Future<ApiResponse> getGtpContract();
}
