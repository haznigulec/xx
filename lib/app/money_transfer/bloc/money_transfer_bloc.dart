import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/assets/model/collateral_info_model.dart';
import 'package:piapiri_v2/app/currency_buy_sell/bloc/currency_buy_sell_bloc.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_trade_limit_model.dart';
import 'package:piapiri_v2/app/money_transfer/bloc/money_transfer_event.dart';
import 'package:piapiri_v2/app/money_transfer/bloc/money_transfer_state.dart';
import 'package:piapiri_v2/app/money_transfer/model/virement_institution_model.dart';
import 'package:piapiri_v2/app/money_transfer/repository/money_transfer_repository.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/assets_model.dart';
import 'package:piapiri_v2/core/model/transection_expense_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class MoneyTransferBloc extends PBloc<MoneyTransferState> {
  final MoneyTransferRepository _moneyTransferRepository;

  MoneyTransferBloc({
    required MoneyTransferRepository moneyTransferRepository,
  })  : _moneyTransferRepository = moneyTransferRepository,
        super(initialState: const MoneyTransferState()) {
    on<GetCustomerBankAccountsEvent>(_onGetCustomerBankAccounts);
    on<DeleteCustomerBankAccountEvent>(_onDeleteBankAccount);
    on<GetEftInfoEvent>(_onGetEftInfo);
    on<GetVirementInstitutionsEvent>(_onGetVirementInstitutions);
    on<GetTradeLimitEvent>(_onGetTradeLimit);
    on<GetInstantCashAmountEvent>(_onGetInstantCashAmount);
    on<GetTradeLimitForAllAccountsEvent>(_onGetTradeLimitForAllAccounts);
    on<RequestOTPEvent>(_onRequestOTP);
    on<MoneyTransferOrderEvent>(_onMoneyTransferOrder);
    on<AddVirmanOrderEvent>(_onAddVirmanOrderEvent);
    on<AddCustomerBankAccountEvent>(_onAddCustomerBankAccount);
    on<GetCashBalance>(_onGetCashBalance);
    on<GetCollateralInfoEvent>(_onGetCollateralInfo);
    on<CollateralAdministrationDataEvent>(_onCollateralAdministrationDataEvent);
    on<GetTradeLimitBySenderRecipientEvent>(_onGetTradeLimitBySenderRecipient);
    on<GetConvertT0Event>(_onGetConvertT0Event);
    on<GetT0CreditTransactionExpenseInfoEvent>(_onGetT0CreditTransactionExpenseInfoEvent);
    on<AddT0CreditTransactionEvent>(_onAddT0CreditTransactionEvent);
  }

  FutureOr<void> _onGetCustomerBankAccounts(
    GetCustomerBankAccountsEvent event,
    Emitter<MoneyTransferState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    final ApiResponse response = await _moneyTransferRepository.getCustomerBankAccounts(
      accountId: event.accountId,
    );

    if (response.success) {
      List<CustomerBankAccountModel> customerBankAccountList = [];
      if (response.data['customerBankAccountsItem'] != null) {
        customerBankAccountList = response.data['customerBankAccountsItem']
            .map<CustomerBankAccountModel>(
              (e) => CustomerBankAccountModel.fromJson(e),
            )
            .toList();
      }

      emit(
        state.copyWith(
          type: PageState.success,
          customerBankAccountList: customerBankAccountList,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '04PORT03',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onDeleteBankAccount(
    DeleteCustomerBankAccountEvent event,
    Emitter<MoneyTransferState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    final ApiResponse response = await _moneyTransferRepository.deleteCustomerBankAccount(
      accountId: event.accountId,
      bankAccountId: event.bankAccountId,
    );

    if (response.success) {
      List<CustomerBankAccountModel> bankAccounts = List.from(
        state.customerBankAccountList ?? [],
      );

      bankAccounts.removeWhere(
        (element) => element.bankAccId == event.bankAccountId,
      );

      emit(
        state.copyWith(
          type: PageState.success,
          customerBankAccountList: bankAccounts,
        ),
      );

      event.onSuccess(response.data['result']);
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: L10n.tr('portfolio.iban.delete.error'),
            errorCode: '04PORT17',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetEftInfo(
    GetEftInfoEvent event,
    Emitter<MoneyTransferState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    final ApiResponse response = await _moneyTransferRepository.getEftInfo(
      accountId: event.accountExtId,
    );

    if (response.success) {
      EftInfoModel eftInfoModel = EftInfoModel.fromJson(response.data);

      emit(
        state.copyWith(
          type: PageState.success,
          eftInfo: eftInfoModel,
        ),
      );
      event.callback(eftInfoModel);
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '04PORT06',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetVirementInstitutions(
    GetVirementInstitutionsEvent event,
    Emitter<MoneyTransferState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse response = await _moneyTransferRepository.getVirementInstitutions();

    if (response.success) {
      List<VirementInstitutionModel> virementInstitutions = (response.data['institutions'] as List)
          .map<VirementInstitutionModel>((e) => VirementInstitutionModel.fromJson(e))
          .toList();

      emit(
        state.copyWith(
          type: PageState.success,
          virementInstitutions: virementInstitutions,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '04PORT12',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetTradeLimit(
    GetTradeLimitEvent event,
    Emitter<MoneyTransferState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _moneyTransferRepository.getTradeLimit(
      accountId: event.accountId,
      typeName: event.typeName,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
          tradeLimit: response.data['tradeLimit'],
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '04PORT17',
          ),
        ),
      );
    }
  }

  /// Döviz hesapları için işlem limitini çektiğimiz endpoint.
  FutureOr<void> _onGetInstantCashAmount(
    GetInstantCashAmountEvent event,
    Emitter<MoneyTransferState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _moneyTransferRepository.getInstantCashAmount(
      accountId: event.accountId,
      finInstName: event.finInstName,
    );

    if (response.success) {
      if (event.isSender) {
        emit(
          state.copyWith(
            type: PageState.success,
            senderTradeLimit: response.data['amount'],
          ),
        );
      } else {
        emit(
          state.copyWith(
            type: PageState.success,
            recipientTradeLimit: response.data['amount'],
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '04PORT20',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetTradeLimitForAllAccounts(
    GetTradeLimitForAllAccountsEvent event,
    Emitter<MoneyTransferState> emit,
  ) async {
    emit(
      state.copyWith(
        tradeLimitState: PageState.loading,
      ),
    );

    List<Future<ApiResponse>> requests = event.accountList
        .map(
          (accountId) => _moneyTransferRepository.getTradeLimit(
            accountId: accountId.split('-')[1],
            typeName: event.typeName,
          ),
        )
        .toList();

    List<ApiResponse> tradeLimitsResponse = await Future.wait(requests); // Paralel istek

    if (tradeLimitsResponse.every((element) => element.success)) {
      emit(
        state.copyWith(
          tradeLimitState: PageState.success,
          tradeLimitAllAccounts: tradeLimitsResponse.map((element) => element.data['tradeLimit'] as double).toList(),
        ),
      );
    } else {
      emit(
        state.copyWith(
          tradeLimitState: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: L10n.tr(
              tradeLimitsResponse.firstWhere((element) => !element.success).error?.message ?? '',
            ),
            errorCode: '04PORT17',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onRequestOTP(
    RequestOTPEvent event,
    Emitter<MoneyTransferState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    final ApiResponse response = await _moneyTransferRepository.requestOTP();

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      event.onSuccess?.call(response.data);
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '04PORT17',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onMoneyTransferOrder(
    MoneyTransferOrderEvent event,
    Emitter<MoneyTransferState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    final ApiResponse response = await _moneyTransferRepository.addMoneyTransferOrder(
      accountId: event.accountId,
      bankAccId: event.bankAccId,
      amount: event.amount,
      description: event.description,
      finInstName: event.finInstName,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      event.onSuccess?.call();
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: L10n.tr(
              response.error?.message ?? '',
            ),
            errorCode: '04PORT17',
          ),
        ),
      );
      event.onFailed?.call(
        response.error?.message ?? '',
      );
    }
  }

  FutureOr<void> _onAddVirmanOrderEvent(
    AddVirmanOrderEvent event,
    Emitter<MoneyTransferState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    final ApiResponse response = await _moneyTransferRepository.addVirmanOrder(
      accountId: event.accountId,
      toAccountId: event.toAccountId,
      amount: event.amount,
      description: event.description ?? '',
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );

      event.onSuccess();
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '04PORT17',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onAddCustomerBankAccount(
    AddCustomerBankAccountEvent event,
    Emitter<MoneyTransferState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    final ApiResponse response = await _moneyTransferRepository.addCustomerBankAccount(
      accountId: event.customerAccountId,
      ibanNo: event.ibanNo,
      otpCode: event.otpCode,
      name: event.name,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );

      event.onSuccess(
        response.data['result'] ?? '',
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: L10n.tr(
              response.error?.message ?? '',
            ),
            errorCode: '04PORT18',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetCashBalance(
    GetCashBalance event,
    Emitter<MoneyTransferState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    final ApiResponse response = await _moneyTransferRepository.getTradeLimit(
      accountId: event.accountId,
      typeName: event.typeName,
    );

    if (response.success) {
      IpoTradeLimitModel ipoTradeLimitModel = IpoTradeLimitModel.fromJson(response.data);

      emit(
        state.copyWith(
          type: PageState.success,
          cashBalance: ipoTradeLimitModel.tradeLimit,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '04PORT19',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetCollateralInfo(
    GetCollateralInfoEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    final ApiResponse response = await _moneyTransferRepository.getCollateralInfo(
      accountId: event.accountId,
    );

    if (response.success) {
      CollateralInfo collateralInfoModel = CollateralInfo.fromJson(
        response.data['collateralInfo'],
      );

      emit(
        state.copyWith(
          type: PageState.success,
          collateralInfo: collateralInfoModel,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '04PORT08',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onCollateralAdministrationDataEvent(
    CollateralAdministrationDataEvent event,
    Emitter<MoneyTransferState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    final ApiResponse response = await _moneyTransferRepository.collateralAdministrationData(
      customerExtId: event.customerExtId,
      accountExtId: event.accountExtId,
      amount: event.amount,
      source: event.source,
      target: event.target,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      event.onSuccess();
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: false,
            message: response.error?.message ?? '',
            errorCode: '04PORT10',
          ),
        ),
      );
      event.onFailed(
        response.error?.message ?? '',
      );
    }
  }

  FutureOr<void> _onGetTradeLimitBySenderRecipient(
    GetTradeLimitBySenderRecipientEvent event,
    Emitter<MoneyTransferState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _moneyTransferRepository.getTradeLimit(
      accountId: event.accountId,
      typeName: event.typeName,
    );

    if (response.success) {
      if (event.isSender) {
        emit(
          state.copyWith(
            type: PageState.success,
            senderTradeLimit: response.data['tradeLimit'],
          ),
        );
      } else {
        emit(
          state.copyWith(
            type: PageState.success,
            recipientTradeLimit: response.data['tradeLimit'],
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '04PORT17',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetConvertT0Event(
    GetConvertT0Event event,
    Emitter<MoneyTransferState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _moneyTransferRepository.getCustomerT0CreditNetLimits();
    double? t1CreditNetLimit;
    double? t2CreditNetLimit;

    if (response.success) {
      t1CreditNetLimit = response.data['t1CreditNetLimit'] == null
          ? null
          : double.tryParse(
              response.data['t1CreditNetLimit'].toString(),
            );
      t2CreditNetLimit = response.data['t2CreditNetLimit'] == null
          ? null
          : double.tryParse(
              response.data['t2CreditNetLimit'].toString(),
            );
      emit(
        state.copyWith(
          type: PageState.success,
          t1CreditNetLimit: t1CreditNetLimit,
          t2CreditNetLimit: t2CreditNetLimit,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '04PORT18',
          ),
        ),
      );
    }

    event.callBack?.call(
      t1CreditNetLimit ?? 0,
      t2CreditNetLimit ?? 0,
    );
  }

  FutureOr<void> _onGetT0CreditTransactionExpenseInfoEvent(
    GetT0CreditTransactionExpenseInfoEvent event,
    Emitter<MoneyTransferState> emit,
  ) async {
    emit(
      state.copyWith(
        t0ProcessState: PageState.loading,
      ),
    );

    ApiResponse response = await _moneyTransferRepository.getT0CreditTransactionExpenseInfo(
      accountExtId: event.accountExtId,
      t1CreditAmount: event.t1CreditAmount,
      t2CreditAmount: event.t2CreditAmount,
    );

    if (response.success) {
      emit(
        state.copyWith(
          t0ProcessState: PageState.success,
          transactionExpense: TransactionExpenseModel.fromJson(response.data),
        ),
      );
    } else {
      event.onErrorCallback();
      String errorMessage = '';
      // 12060301 -- max
      if (response.error?.message == '12060301') {
        double t0CreditInstitutionUpperLimit =
            getIt<CurrencyBuySellBloc>().state.systemParametersModel?.t0CreditInstitutionUpperLimit ?? 0;
        errorMessage = L10n.tr(
          response.error!.message!,
          args: [
            MoneyUtils().readableMoney(t0CreditInstitutionUpperLimit),
          ],
        );
      }
      // 12060302 -- min
      else if (response.error?.message == '12060302') {
        double t0CreditInstitutionLowerLimit =
            getIt<CurrencyBuySellBloc>().state.systemParametersModel?.t0CreditInstitutionLowerLimit ?? 0;
        errorMessage = L10n.tr(
          response.error!.message!,
          args: [
            MoneyUtils().readableMoney(t0CreditInstitutionLowerLimit),
          ],
        );
      } else {
        errorMessage = response.error?.message ?? '';
      }
      emit(
        state.copyWith(
          t0ProcessState: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: errorMessage,
            errorCode: '04PORT21',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onAddT0CreditTransactionEvent(
    AddT0CreditTransactionEvent event,
    Emitter<MoneyTransferState> emit,
  ) async {
    emit(
      state.copyWith(
        t0ProcessState: PageState.loading,
      ),
    );

    ApiResponse response = await _moneyTransferRepository.addT0CreditTransaction(
      accountExtId: event.accountExtId,
      t1CreditAmount: event.t1CreditAmount,
      t2CreditAmount: event.t2CreditAmount,
    );
    if (response.success) {
      emit(
        state.copyWith(
          t0ProcessState: PageState.success,
          t0TransactionIsCompleted: true,
        ),
      );
      event.onSuccesCallback();
    } else {
      event.onErrorCallback();
      emit(
        state.copyWith(
          t0ProcessState: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '04PORT22',
          ),
        ),
      );
    }
  }
}
