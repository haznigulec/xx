import 'package:piapiri_v2/app/assets/model/collateral_info_model.dart';
import 'package:piapiri_v2/app/money_transfer/model/virement_institution_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/assets_model.dart';
import 'package:piapiri_v2/core/model/transection_expense_model.dart';

class MoneyTransferState extends PState {
  final List<CustomerBankAccountModel>? customerBankAccountList;
  final EftInfoModel? eftInfo;
  final List<VirementInstitutionModel>? virementInstitutions;
  final AssetModel? assetsModel;
  final double? tradeLimit;
  final List<double>? tradeLimitAllAccounts;
  final double? cashBalance;
  final CollateralInfo? collateralInfo;
  final double? senderTradeLimit;
  final double? recipientTradeLimit;
  final PageState tradeLimitState;
  final PageState t0ProcessState;
  final double? t1CreditNetLimit;
  final double? t2CreditNetLimit;
  final bool t0ContractIsAccepted;
  final String? t0ContractRefCode;
  final TransactionExpenseModel? transactionExpense;

  const MoneyTransferState({
    super.type = PageState.initial,
    super.error,
    this.customerBankAccountList,
    this.eftInfo,
    this.virementInstitutions,
    this.assetsModel,
    this.tradeLimit,
    this.tradeLimitAllAccounts,
    this.cashBalance,
    this.collateralInfo,
    this.senderTradeLimit,
    this.recipientTradeLimit,
    this.tradeLimitState = PageState.initial,
    this.t1CreditNetLimit,
    this.t2CreditNetLimit,
    this.t0ProcessState = PageState.initial,
    this.t0ContractIsAccepted = false,
    this.t0ContractRefCode,
    this.transactionExpense,
  });

  @override
  MoneyTransferState copyWith({
    PageState? type,
    PBlocError? error,
    List<CustomerBankAccountModel>? customerBankAccountList,
    EftInfoModel? eftInfo,
    List<VirementInstitutionModel>? virementInstitutions,
    AssetModel? assetsModel,
    double? tradeLimit,
    List<double>? tradeLimitAllAccounts,
    double? cashBalance,
    CollateralInfo? collateralInfo,
    double? senderTradeLimit,
    double? recipientTradeLimit,
    PageState? tradeLimitState,
    double? t1CreditNetLimit,
    double? t2CreditNetLimit,
    PageState? t0ProcessState,
    bool? t0ContractIsAccepted,
    String? t0ContractRefCode,
    TransactionExpenseModel? transactionExpense,
    bool? t0TransactionIsCompleted,
  }) {
    return MoneyTransferState(
      type: type ?? this.type,
      error: error ?? this.error,
      customerBankAccountList: customerBankAccountList ?? this.customerBankAccountList,
      eftInfo: eftInfo ?? this.eftInfo,
      virementInstitutions: virementInstitutions ?? this.virementInstitutions,
      assetsModel: assetsModel ?? this.assetsModel,
      tradeLimit: tradeLimit ?? this.tradeLimit,
      tradeLimitAllAccounts: tradeLimitAllAccounts ?? this.tradeLimitAllAccounts,
      cashBalance: cashBalance ?? this.cashBalance,
      collateralInfo: collateralInfo ?? this.collateralInfo,
      senderTradeLimit: senderTradeLimit ?? this.senderTradeLimit,
      recipientTradeLimit: recipientTradeLimit ?? this.recipientTradeLimit,
      tradeLimitState: tradeLimitState ?? this.tradeLimitState,
      t1CreditNetLimit: t1CreditNetLimit ?? this.t1CreditNetLimit,
      t2CreditNetLimit: t2CreditNetLimit ?? this.t2CreditNetLimit,
      t0ProcessState: t0ProcessState ?? this.t0ProcessState,
      t0ContractIsAccepted: t0ContractIsAccepted ?? this.t0ContractIsAccepted,
      t0ContractRefCode: t0ContractRefCode ?? this.t0ContractRefCode,
      transactionExpense: transactionExpense ?? this.transactionExpense,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        customerBankAccountList,
        eftInfo,
        virementInstitutions,
        assetsModel,
        tradeLimit,
        tradeLimitAllAccounts,
        cashBalance,
        collateralInfo,
        senderTradeLimit,
        recipientTradeLimit,
        tradeLimitState,
        t1CreditNetLimit,
        t2CreditNetLimit,
        t0ProcessState,
        t0ContractIsAccepted,
        t0ContractRefCode,
        transactionExpense,
      ];
}
