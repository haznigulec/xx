import 'dart:ui';
import 'package:piapiri_v2/app/contracts/model/get_customer_answers_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/model/set_answer_model.dart';

abstract class ContractsEvent extends PEvent {}

class GetSurveyQuestionEvent extends ContractsEvent {}

class GetGtpContractEvent extends ContractsEvent {
  final VoidCallback? onSuccess;
  final VoidCallback? onErrorCallback;

  GetGtpContractEvent({
    this.onSuccess,
    this.onErrorCallback,
  });
}

class GetCustomerAnswersEvent extends ContractsEvent {
  final Function(GetCustomerAnswersModel)? onSuccess;
  GetCustomerAnswersEvent({
    this.onSuccess,
  });
}

class RequiredContractsEvent extends ContractsEvent {
  final Function(String)? callback;
  RequiredContractsEvent({
    this.callback,
  });
}

class SurveyAnswersEvent extends ContractsEvent {
  final List<SetAnswersModel> answers;
  final String? accountId;
  final Function(SetSurveyAnswersModel)? onSuccess;

  SurveyAnswersEvent({
    required this.answers,
    this.accountId,
    this.onSuccess,
  });
}

class ApproveUserContractEvent extends ContractsEvent {
  final List<String> contractRefCode;
  final Function(bool)? onSuccess;

  ApproveUserContractEvent({
    required this.contractRefCode,
    this.onSuccess,
  });
}

class UserContactFileEvent extends ContractsEvent {
  final String refCode;
  final Function(String)? onSuccess;

  UserContactFileEvent({
    required this.refCode,
    this.onSuccess,
  });
}

class GetCustomerApprovedContractsEvent extends ContractsEvent {
  final String contractCode;
  final VoidCallback onErrorCallback;

  GetCustomerApprovedContractsEvent({
    required this.contractCode,
    required this.onErrorCallback,
  });
}

class ApproveGptConractEvent extends ContractsEvent {
  final String contractCode;
  final String accountExtId;
  final String contractRefCode;
  final VoidCallback? successCallback;

  ApproveGptConractEvent({
    required this.contractCode,
    required this.accountExtId,
    required this.contractRefCode,
    this.successCallback,
  });
}

class GetContractPdfEvent extends ContractsEvent {
  final String contractCode;
  final Function(String)? onContractCode;

  GetContractPdfEvent({
    required this.contractCode,
    this.onContractCode,
  });
}
