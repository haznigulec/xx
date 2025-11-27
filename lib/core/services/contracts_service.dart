import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/set_answer_model.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class ContractsService {
  final ApiClient api;

  ContractsService(this.api);
  static const String _getSurveyQuestion = '/AdkSurvey/getquestions';
  static const String _getCustomerAnswers = '/adksurvey/getcustomeranswers';
  static const String _setSurveyAnswers = '/adksurvey/setsurveyanswers';
  static const String _getRequiredContracts = '/adkcontract/getrequiredcontracts';
  static const String _approveUserContracts = '/adkcontract/approveusercontract';
  static const String _getUserContractFile = '/adkcontract/getusercontracfile';
  static const String _getCustomerApprovedContracts = '/AdkContract/getcustomerapprovedcontracts';
  static const String _getContractPdf = '/AdkContract/getcontractpdf';
  static const String _approvegtpcontract = '/AdkContract/approvegtpcontract';
  static const String _getGetContract = '/adkContract/getgtpcontracts';

  Future<ApiResponse> getSurveyQuestion() {
    return getIt<PPApi>().contractsService.api.post(
      _getSurveyQuestion,
      body: {
        'customerExtId': UserModel.instance.customerId,
      },
    );
  }

  Future<ApiResponse> getCustomerAnswers() async {
    return getIt<PPApi>().contractsService.api.post(
      _getCustomerAnswers,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
      },
    );
  }

  Future<ApiResponse> setSurveyAnswers({
    required List<SetAnswersModel> answers,
    required String accountId,
  }) async {
    return getIt<PPApi>().contractsService.api.post(
      _setSurveyAnswers,
      tokenized: true,
      body: {
        'answers': answers.map((e) => e.toJson()).toList(),
        'accountExtId': accountId,
        'customerExtId': UserModel.instance.customerId,
      },
    );
  }

  Future<ApiResponse> getRequiredContracts() async {
    return getIt<PPApi>().contractsService.api.post(
      _getRequiredContracts,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
      },
    );
  }

  Future<ApiResponse> approveUserContract({
    required List<String> contractRefCode,
  }) async {
    return getIt<PPApi>().contractsService.api.post(
      _approveUserContracts,
      tokenized: true,
      body: {
        'contractRefCode': contractRefCode,
        'customerExtId': UserModel.instance.customerId,
      },
    );
  }

  Future<ApiResponse> getUserContractFile({
    required String refCode,
  }) async {
    return getIt<PPApi>().contractsService.api.post(
      _getUserContractFile,
      tokenized: true,
      body: {
        'refCode': refCode,
        'customerExtId': UserModel.instance.customerId,
      },
    );
  }

  Future<ApiResponse> getCustomerApprovedContracts() async {
    return getIt<PPApi>().contractsService.api.post(
      _getCustomerApprovedContracts,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
      },
    );
  }

  Future<ApiResponse> getContractPdf({
    required String contractCode,
  }) async {
    return getIt<PPApi>().contractsService.api.post(
      _getContractPdf,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'contractCode': contractCode,
      },
    );
  }

  Future<ApiResponse> approveGtpContract({
    required String contractCode,
    required String accountExtId,
    required String contractRefCode,
  }) async {
    return getIt<PPApi>().contractsService.api.post(
      _approvegtpcontract,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'contractCode': contractCode,
        'accountExtId': accountExtId,
        'contractRefCode': contractRefCode,
      },
    );
  }

  Future<ApiResponse> getGtpContract() async {
    return api.post(
      _getGetContract,
      body: {
        'customerExtId': UserModel.instance.customerId,
      },
      tokenized: true,
    );
  }
}
