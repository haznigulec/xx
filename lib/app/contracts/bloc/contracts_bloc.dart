import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_event.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_state.dart';
import 'package:piapiri_v2/app/contracts/model/get_contract_pdf_model.dart';
import 'package:piapiri_v2/app/contracts/model/get_customer_answers_model.dart';
import 'package:piapiri_v2/app/contracts/model/get_gtp_contract_model.dart';
import 'package:piapiri_v2/app/contracts/model/get_required_contracts_model.dart';
import 'package:piapiri_v2/app/contracts/model/get_survey_question_model.dart';
import 'package:piapiri_v2/app/contracts/repository/contracts_repository.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/set_answer_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ContractsBloc extends PBloc<ContractsState> {
  final ContractsRepository _contractsRepository;

  ContractsBloc({
    required ContractsRepository contractsRepository,
  })  : _contractsRepository = contractsRepository,
        super(initialState: const ContractsState()) {
    on<GetCustomerAnswersEvent>(_onGetCustomerAnswers);
    on<RequiredContractsEvent>(_onRequiredContracts);
    on<ApproveUserContractEvent>(_onApproveUserContract);
    on<UserContactFileEvent>(_onUserContractFile);
    on<SurveyAnswersEvent>(_onSurveyAnswers);
    on<GetSurveyQuestionEvent>(_onGetQuestions);
    on<GetCustomerApprovedContractsEvent>(_onGetCustomerApprovedContracts);
    on<ApproveGptConractEvent>(_onApproveGptConractEvent);
    on<GetContractPdfEvent>(_onGetContractPdfEvent);
    on<GetGtpContractEvent>(_onGetGtpContract);
  }
  FutureOr<void> _onGetCustomerAnswers(
    GetCustomerAnswersEvent event,
    Emitter<ContractsState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _contractsRepository.getCustomerAnswers();

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
          getCustomerAnswersModel: GetCustomerAnswersModel.fromJson(response.data),
        ),
      );
      event.onSuccess?.call(GetCustomerAnswersModel.fromJson(response.data));
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message:
                response.error?.message != null ? L10n.tr('form.customer_answer_error.${response.error?.message}') : '',
            errorCode: '05CONT01',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onRequiredContracts(
    RequiredContractsEvent event,
    Emitter<ContractsState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _contractsRepository.getRequiredContracts();

    if (response.success) {
      List<RequiredContractsModel> getRequiredContractsModel = response.data['requiredContracts']
          .map<RequiredContractsModel>((e) => RequiredContractsModel.fromJson(e))
          .toList();

      emit(
        state.copyWith(
          type: PageState.success,
          getRequiredContractsModel: getRequiredContractsModel,
        ),
      );
      if (event.callback != null) {
        event.callback!(
          getRequiredContractsModel[0].contractRefCode ?? '',
        );
      }
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05CONT02',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetQuestions(
    GetSurveyQuestionEvent event,
    Emitter<ContractsState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse response = await _contractsRepository.getSurveyQuestion();

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
          questions: response.data['questionList']
              .map<GetSurveyQuestionModel>((e) => GetSurveyQuestionModel.fromJson(e))
              .toList(),
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05CONT03',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onApproveUserContract(
    ApproveUserContractEvent event,
    Emitter<ContractsState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _contractsRepository.approveUserContract(
      contractRefCode: event.contractRefCode,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      event.onSuccess!(response.data['isSucceed']);
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05CONT04',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onUserContractFile(
    UserContactFileEvent event,
    Emitter<ContractsState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _contractsRepository.getUserContractFile(
      refCode: event.refCode,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      event.onSuccess!(response.data['byteArr']);
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05CONT05',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onSurveyAnswers(
    SurveyAnswersEvent event,
    Emitter<ContractsState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _contractsRepository.setSurveyAnswers(
      accountId: event.accountId!,
      answers: event.answers,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
          setSurveyAnswersModel: SetSurveyAnswersModel.fromJson(response.data),
          answers: event.answers,
        ),
      );
      event.onSuccess!(state.setSurveyAnswersModel!);
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05CONT06',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetCustomerApprovedContracts(
    GetCustomerApprovedContractsEvent event,
    Emitter<ContractsState> emit,
  ) async {
    emit(
      state.copyWith(
        t0ProcessState: PageState.loading,
      ),
    );

    ApiResponse approvedResponse = await _contractsRepository.getCustomerApprovedContracts();
    if (approvedResponse.success) {
      bool isAccepted = (approvedResponse.data?['contractItems'] as List?)
              ?.firstWhereOrNull((e) => e['contractCode'] == event.contractCode)?['approvedDate']
              ?.toString()
              .isNotEmpty ==
          true;
      if (isAccepted) {
        emit(
          state.copyWith(
            t0ProcessState: PageState.success,
            t0ContractIsAccepted: isAccepted,
          ),
        );
        return;
      }
      add(
        GetContractPdfEvent(contractCode: event.contractCode),
      );
    } else {
      event.onErrorCallback();
      emit(
        state.copyWith(
          t0ProcessState: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: approvedResponse.error?.message ?? '',
            errorCode: '05CONT07',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onApproveGptConractEvent(
    ApproveGptConractEvent event,
    Emitter<ContractsState> emit,
  ) async {
    emit(
      state.copyWith(
        t0ProcessState: PageState.loading,
      ),
    );

    ApiResponse response = await _contractsRepository.approveGtpContract(
      contractCode: event.contractCode,
      accountExtId: event.accountExtId,
      contractRefCode: event.contractRefCode,
    );
    if (response.success) {
      emit(
        state.copyWith(
          t0ProcessState: PageState.success,
          t0ContractIsAccepted: true,
        ),
      );
      event.successCallback?.call();
    } else {
      emit(
        state.copyWith(
          t0ProcessState: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05CONT08',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetContractPdfEvent(
    GetContractPdfEvent event,
    Emitter<ContractsState> emit,
  ) async {
    emit(
      state.copyWith(t0ProcessState: PageState.loading, type: PageState.loading),
    );

    ApiResponse response = await _contractsRepository.getContractPdf(
      contractCode: event.contractCode,
    );
    if (response.success) {
      GetContractPdfModel contractPdf = GetContractPdfModel.fromJson(response.data);
      event.onContractCode?.call(contractPdf.contractRefCode ?? '');
      emit(
        state.copyWith(
          type: PageState.success,
          t0ProcessState: PageState.success,
          contractPdf: contractPdf,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          t0ProcessState: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05CONT09',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetGtpContract(
    GetGtpContractEvent event,
    Emitter<ContractsState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _contractsRepository.getGtpContract();

    if (response.success) {
      List<GetGtpContractModel> contractItems =
          response.data['contractItems'].map<GetGtpContractModel>((e) => GetGtpContractModel.fromJson(e)).toList();

      List<GetGtpContractModel> canSignContracts = contractItems
          .where((e) =>
              e.canSignContract == true &&
              e.cmContractCode != null &&
              e.cmContractCode!.isNotEmpty &&
              e.enumCode != null &&
              e.enumCode!.isNotEmpty)
          .toList();

      List<String> typeList =
          (jsonDecode(remoteConfig.getValue('getContractsDefaultSorting').asString())['contractTypes'] as List)
              .map((e) => e.toString())
              .toList();

      // typeList sırasına göre canSignContracts'ı sıralıyoruz
      List<GetGtpContractModel> sortedCanSignContracts = [];

      for (String type in typeList) {
        final isAmericanMarketEnabled = Utils().canTradeAmericanMarket();

        GetGtpContractModel? match = canSignContracts.firstWhereOrNull((contract) {
          if (contract.enumCode != 'ALPACA') {
            return contract.enumCode == type;
          } else {
            return contract.cmContractApprovedDate != null && isAmericanMarketEnabled;
          }
        });

        if (match != null && !sortedCanSignContracts.contains(match)) {
          sortedCanSignContracts.add(match);
        }
      }

      bool t0ContractsIsAproved = false;
      GetGtpContractModel? t0Contract = contractItems.firstWhereOrNull((e) => e.enumCode == 'T0_CONTRACT');
      if (t0Contract != null) {
        t0ContractsIsAproved = t0Contract.gtpContractCreatedDate != null && t0Contract.gtpContractExists == true;
      }

      event.onSuccess?.call();
      emit(
        state.copyWith(
          type: PageState.success,
          contractItems: contractItems,
          canSignContracts: sortedCanSignContracts,
          t0ContractIsAccepted: t0ContractsIsAproved,
        ),
      );
    } else {
      event.onErrorCallback?.call();
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05CONT10',
          ),
        ),
      );
    }
  }
}
