import 'package:equatable/equatable.dart';
import 'package:piapiri_v2/app/orders/model/american_order_type_enum.dart';
import 'package:piapiri_v2/core/model/order_completion_enum.dart';
import 'package:piapiri_v2/core/model/order_type_enum.dart';
import 'package:piapiri_v2/core/model/order_validity_enum.dart';
import 'package:piapiri_v2/core/model/statement_preference_enum.dart';
import 'package:piapiri_v2/core/model/depth_type_enum.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class OrderSettings extends Equatable {
  final String equityDefaultAccount;
  final String viopDefaultAccount;
  final String fundDefaultAccount;
  final OrderTypeEnum equityDefaultOrderType;
  final OptionOrderTypeEnum viopDefaultOrderType;
  final AmericanOrderTypeEnum usDefaultOrderType;
  final OrderValidityEnum equityDefaultValidity;
  final OptionOrderValidityEnum viopDefaultValidity;
  final int depthCount;
  final DepthTypeEnum depthType;
  final bool earningInterest;
  final bool transactionApprovalRequest;
  final OrderCompletionEnum orderCompletion;
  final StatementPreferenceEnum statementPreference;

  OrderSettings({
    String? equityDefaultAccount,
    String? viopDefaultAccount,
    String? fundDefaultAccount,
    this.equityDefaultOrderType = OrderTypeEnum.market,
    this.viopDefaultOrderType = OptionOrderTypeEnum.limit,
    this.usDefaultOrderType = AmericanOrderTypeEnum.market,
    this.equityDefaultValidity = OrderValidityEnum.cancelRest,
    this.viopDefaultValidity = OptionOrderValidityEnum.daily,
    this.depthCount = 10,
    this.depthType = DepthTypeEnum.stage,
    this.earningInterest = false,
    this.transactionApprovalRequest = true,
    this.orderCompletion = OrderCompletionEnum.notification,
    this.statementPreference = StatementPreferenceEnum.digital,
  })  : equityDefaultAccount = equityDefaultAccount ?? UserModel.instance.accountId,
        viopDefaultAccount = viopDefaultAccount ?? UserModel.instance.accountId,
        fundDefaultAccount = fundDefaultAccount ?? UserModel.instance.accountId;

  factory OrderSettings.fromJson(Map<String, dynamic> json) {
    return OrderSettings(
      equityDefaultAccount: json['equityDefaultAccount'] ?? UserModel.instance.accountId,
      viopDefaultAccount: json['viopDefaultAccount'] ?? UserModel.instance.accountId,
      fundDefaultAccount: json['fundDefaultAccount'] ?? UserModel.instance.accountId,
      equityDefaultOrderType: OrderTypeEnum.values.firstWhere(
          (e) => e.value.toLowerCase() == json['equityDefaultOrderType'].toLowerCase(),
          orElse: () => OrderTypeEnum.market),
      viopDefaultOrderType: OptionOrderTypeEnum.values.firstWhere(
          (e) => e.value.toLowerCase() == json['viopDefaultOrderType'].toLowerCase(),
          orElse: () => OptionOrderTypeEnum.limit),
      usDefaultOrderType: AmericanOrderTypeEnum.values.firstWhere(
          (e) => e.value.toLowerCase() == json['usDefaultOrderType'].toLowerCase(),
          orElse: () => AmericanOrderTypeEnum.market),
      equityDefaultValidity: OrderValidityEnum.values.firstWhere(
          (e) => e.value.toLowerCase() == json['equityDefaultValidity'].toLowerCase(),
          orElse: () => OrderValidityEnum.cancelRest),
      viopDefaultValidity: OptionOrderValidityEnum.values.firstWhere(
          (e) => e.value.toLowerCase() == json['viopDefaultValidity'].toLowerCase(),
          orElse: () => OptionOrderValidityEnum.daily),
      depthCount: json['depthCount'] ?? 10,
      depthType: DepthTypeEnum.values.firstWhere((e) => e.value.toLowerCase() == json['depthType'].toLowerCase(),
          orElse: () => DepthTypeEnum.stage),
      earningInterest: json['earningInterest'] ?? false,
      transactionApprovalRequest: json['transactionApprovalRequest'] ?? true,
      orderCompletion: OrderCompletionEnum.values.firstWhere(
          (e) => e.value.toLowerCase() == json['orderCompletion'].toLowerCase(),
          orElse: () => OrderCompletionEnum.notification),
      statementPreference: StatementPreferenceEnum.values.firstWhere(
          (e) => e.value.toLowerCase() == json['statementPreference'].toLowerCase(),
          orElse: () => StatementPreferenceEnum.digital),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'equityDefaultAccount': equityDefaultAccount,
      'viopDefaultAccount': viopDefaultAccount,
      'fundDefaultAccount': fundDefaultAccount,
      'equityDefaultOrderType': equityDefaultOrderType.value,
      'viopDefaultOrderType': viopDefaultOrderType.value,
      'usDefaultOrderType': usDefaultOrderType.value,
      'equityDefaultValidity': equityDefaultValidity.value,
      'viopDefaultValidity': viopDefaultValidity.value,
      'depthCount': depthCount,
      'depthType': depthType.value,
      'earningInterest': earningInterest,
      'transactionApprovalRequest': transactionApprovalRequest,
      'orderCompletion': orderCompletion.value,
      'statementPreference': statementPreference.value,
    };
  }

  OrderSettings copyWith({
    String? equityDefaultAccount,
    String? viopDefaultAccount,
    String? fundDefaultAccount,
    OrderTypeEnum? equityDefaultOrderType,
    OptionOrderTypeEnum? viopDefaultOrderType,
    AmericanOrderTypeEnum? usDefaultOrderType,
    OrderValidityEnum? equityDefaultValidity,
    OptionOrderValidityEnum? viopDefaultValidity,
    int? depthCount,
    DepthTypeEnum? depthType,
    bool? earningInterest,
    bool? transactionApprovalRequest,
    OrderCompletionEnum? orderCompletion,
    StatementPreferenceEnum? statementPreference,
  }) {
    return OrderSettings(
      equityDefaultAccount: equityDefaultAccount ?? this.equityDefaultAccount,
      viopDefaultAccount: viopDefaultAccount ?? this.viopDefaultAccount,
      fundDefaultAccount: fundDefaultAccount ?? this.fundDefaultAccount,
      equityDefaultOrderType: equityDefaultOrderType ?? this.equityDefaultOrderType,
      viopDefaultOrderType: viopDefaultOrderType ?? this.viopDefaultOrderType,
      usDefaultOrderType: usDefaultOrderType ?? this.usDefaultOrderType,
      equityDefaultValidity: equityDefaultValidity ?? this.equityDefaultValidity,
      viopDefaultValidity: viopDefaultValidity ?? this.viopDefaultValidity,
      depthCount: depthCount ?? this.depthCount,
      depthType: depthType ?? this.depthType,
      earningInterest: earningInterest ?? this.earningInterest,
      transactionApprovalRequest: transactionApprovalRequest ?? this.transactionApprovalRequest,
      orderCompletion: orderCompletion ?? this.orderCompletion,
      statementPreference: statementPreference ?? this.statementPreference,
    );
  }

  @override
  List<Object?> get props => [
        equityDefaultAccount,
        viopDefaultAccount,
        fundDefaultAccount,
        equityDefaultOrderType,
        viopDefaultOrderType,
        usDefaultOrderType,
        equityDefaultValidity,
        viopDefaultValidity,
        depthCount,
        depthType,
        earningInterest,
        transactionApprovalRequest,
        orderCompletion,
        statementPreference,
      ];
}
