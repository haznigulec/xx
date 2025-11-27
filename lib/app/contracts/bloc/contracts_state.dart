import 'package:piapiri_v2/app/contracts/model/get_contract_pdf_model.dart';
import 'package:piapiri_v2/app/contracts/model/get_customer_answers_model.dart';
import 'package:piapiri_v2/app/contracts/model/get_gtp_contract_model.dart';
import 'package:piapiri_v2/app/contracts/model/get_required_contracts_model.dart';
import 'package:piapiri_v2/app/contracts/model/get_survey_question_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/set_answer_model.dart';

class ContractsState extends PState {
  final List<GetSurveyQuestionModel> questions;
  final GetCustomerAnswersModel? getCustomerAnswersModel;
  final List<RequiredContractsModel>? getRequiredContractsModel;
  final SetSurveyAnswersModel? setSurveyAnswersModel;
  final List<SetAnswersModel>? answers;
  final bool t0ContractIsAccepted;
  final GetContractPdfModel? contractPdf;
  final PageState t0ProcessState;
  final List<GetGtpContractModel>? contractItems;
  final List<GetGtpContractModel>? canSignContracts;

  const ContractsState({
    super.type = PageState.initial,
    super.error,
    this.questions = const [],
    this.getCustomerAnswersModel,
    this.getRequiredContractsModel,
    this.setSurveyAnswersModel,
    this.answers,
    this.t0ProcessState = PageState.initial,
    this.t0ContractIsAccepted = false,
    this.contractPdf,
    this.contractItems = const [],
    this.canSignContracts = const [],
  });

  @override
  ContractsState copyWith({
    PageState? type,
    PBlocError? error,
    List<GetSurveyQuestionModel>? questions,
    GetCustomerAnswersModel? getCustomerAnswersModel,
    List<RequiredContractsModel>? getRequiredContractsModel,
    SetSurveyAnswersModel? setSurveyAnswersModel,
    List<SetAnswersModel>? answers,
    PageState? t0ProcessState,
    bool? t0ContractIsAccepted,
    GetContractPdfModel? contractPdf,
    List<GetGtpContractModel>? contractItems,
    List<GetGtpContractModel>? canSignContracts,
  }) {
    return ContractsState(
      type: type ?? this.type,
      error: error ?? this.error,
      questions: questions ?? this.questions,
      getCustomerAnswersModel: getCustomerAnswersModel ?? this.getCustomerAnswersModel,
      getRequiredContractsModel: getRequiredContractsModel ?? this.getRequiredContractsModel,
      setSurveyAnswersModel: setSurveyAnswersModel ?? this.setSurveyAnswersModel,
      answers: answers ?? this.answers,
      t0ProcessState: t0ProcessState ?? this.t0ProcessState,
      t0ContractIsAccepted: t0ContractIsAccepted ?? this.t0ContractIsAccepted,
      contractPdf: contractPdf ?? this.contractPdf,
      contractItems: contractItems ?? this.contractItems,
      canSignContracts: canSignContracts ?? this.canSignContracts,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        questions,
        getCustomerAnswersModel,
        getRequiredContractsModel,
        setSurveyAnswersModel,
        answers,
        t0ProcessState,
        t0ContractIsAccepted,
        contractPdf,
        contractItems,
        canSignContracts,
      ];
}
