import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/client/matriks_api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/order_completion_enum.dart';
import 'package:piapiri_v2/core/model/order_model.dart';
import 'package:piapiri_v2/core/model/order_status_enum.dart';
import 'package:piapiri_v2/core/model/order_type_enum.dart';
import 'package:piapiri_v2/core/model/order_validity_enum.dart';
import 'package:piapiri_v2/core/model/symbol_type_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/model/viop_session_enum.dart';

class OrdersService {
  final ApiClient api;
  final MatriksApiClient matriksApiClient;

  const OrdersService(
    this.api,
    this.matriksApiClient,
  );

  static const String _getDailyTransactionsUrl = '/adkcustomer/getaccountdailytransactions';
  static const String _newOrderUrl = '/adkequity/neworder';
  static const String _newOrderBulkUrl = '/adkequity/newbulkorder';
  static const String _addChainOrder = '/adkequity/addchainorder';
  static const String _updateChainOrder = '/adkequity/replacechainorder';
  static const String _cancelChainOrder = '/adkequity/deletechainorder';
  static const String _cancelOrderUrl = '/adkequity/cancelorder';
  static const String _replaceOrderUrl = '/adkequity/replaceorder';
  static const String _replaceBulkOrderUrl = '/adkequity/replacebulkorder';
  static const String _addConditionalOrder = '/adkequity/addconditionalorder';
  static const String _cancelConditionalOrder = '/adkequity/deleteconditionalorder';
  static const String _newViopOrder = '/adkviop/neworder';
  static const String _cancelViopOrder = '/adkviop/cancelorder';
  static const String _updateViopOrder = '/adkviop/improveorder';
  static const String _cancelFundOrder = '/Fund/deletetrans';
  static const String _getaccountoverallwithsummaryUrl = '/adkcustomer/getaccountoverallwithsummary';
  static const String _gettradelimit = '/adkcustomer/gettradelimit';
  static const String _salableUnit = '/adkequity/getcustomerpositionlist';
  static const String _addSubMarketContract = '/adkcontract/addsubmarketcontract';
  static const String _cancelBulkOrderUrl = '/adkequity/bulkcancelorder';
  static const String _getCapraDailyOrders = '/Capra/GetDailyOrders';
  static const String _replaceUsOrder = '/Capra/ReplaceOrder';
  static const String _deleteUsOrder = '/Capra/CancelOrder';
  static const String _getPeriodicOrders = '/AdkEquity/GetPeriodicOrders';
  static const String _getViopInitialRequirement = '/adkviop/GetViopInitialRequirement';

  Future<ApiResponse> getOrders({
    required SymbolTypeEnum symbolType,
    required String account,
    OrderStatusEnum? orderStatus,
    bool groupBySymbol = false,
    bool includeConditionalOrders = true,
  }) async {
    String accountNumber = account != 'ALL' ? account.split('-')[1] : account;
    return api.post(
      _getDailyTransactionsUrl,
      body: {
        'ListType': symbolType.backendValue,
        'AccountExtId': accountNumber,
        'customerExtId': UserModel.instance.customerId,
        'OrderStatus': orderStatus?.name ?? '',
        'GroupBySymbol': groupBySymbol,
        'IncludeConditionalOrders': includeConditionalOrders,
        'includeChainOrders': true,
      },
      tokenized: true,
    );
  }

  Future<ApiResponse> getCashFlow({
    String accountId = '',
    bool allAccounts = false,
  }) {
    return api.post(
      _getaccountoverallwithsummaryUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'accountExtId': accountId,
        'AllAccounts': allAccounts,
        'GetInstant': true,
        'Consolidate': true,
        'IncludeCashFlow': true,
        'IncludeCreditDetail': true,
        'IncludeSummary': true,
        'CalculateTradeLimit': true,
        'IncludePortfolioAccount': true,
      },
    );
  }

  Future<ApiResponse> getTradeLimit({
    required String equityName,
    required String accountId,
  }) async {
    return api.post(
      _gettradelimit,
      tokenized: true,
      body: {
        'AccountExtId': accountId,
        'CustomerExtId': UserModel.instance.customerId,
        'EquityName': equityName,
        'TypeName': 'EQUITY-T2',
      },
    );
  }

  Future<ApiResponse> createOrder({
    required String symbolName,
    required String quantity,
    required String orderActionType,
    required String orderType,
    required String orderValidity,
    required String account,
    required String price,
    required OrderCompletionEnum orderCompletionType,
    int? shownQuantity,
    //Stop Loss - Take Profit
    double? sellLossPrice,
    double? takeProfitPrice,
    DateTime? periodEndDate,
    bool hasStopLoss = false,
  }) async {
    Map<String, dynamic> body = {
      'Side': orderActionType,
      'Name': symbolName,
      'Units': quantity,
      'Price': price,
      'OrderDate': DateTime.now().formatToJson(),
      'OrderSession': 0,
      'AmountType': orderType,
      'timeInForce': orderValidity,
      'customerExtId': UserModel.instance.customerId,
      'accountExtId': account.split('-')[1],
      'smsFillNotification': orderCompletionType == OrderCompletionEnum.sms,
      'emailFillNotification': orderCompletionType == OrderCompletionEnum.mail,
      'pushFillNotification': orderCompletionType == OrderCompletionEnum.notification,
      'shortfall': orderActionType == OrderActionTypeEnum.shortSell.value ? 1 : 0,
      if (shownQuantity != null) 'maxFloor': shownQuantity,
    };
    if (hasStopLoss) {
      if (sellLossPrice != null) {
        body['SlPrice'] = double.parse(sellLossPrice.toStringAsFixed(2));
      }
      if (takeProfitPrice != null) {
        body['TpPrice'] = double.parse(takeProfitPrice.toStringAsFixed(2));
      }
      if (periodEndDate != null) {
        body['PeriodEndingDate'] = periodEndDate.formatToJsonWithHours();
      }
    }
    return api.post(
      _newOrderUrl,
      tokenized: true,
      body: body,
    );
  }

  Future<ApiResponse> createConditionalOrder({
    String? transactionId,
    required String symbolName,
    required int units,
    required OrderActionTypeEnum orderActionType,
    required OrderTypeEnum orderType,
    required OrderValidityEnum orderValidity,
    required String account,
    required double price,
    required String conditionSymbolCode,
    required String conditionType,
    required double conditionPrice,
  }) async {
    return api.post(
      _addConditionalOrder,
      tokenized: true,
      body: {
        if (transactionId != null) 'TransactionId': transactionId,
        'transactionTypeId': enumToTransactionTypeId(orderType),
        'finInstName': symbolName,
        'orderPrice': price,
        'units': units,
        'debitCredit': orderActionType.value,
        'transactionTypeName': enumToConditionalType(orderType),
        'timeInForce': orderValidity.value,
        'session': 1,
        'conditionFinInstName': conditionSymbolCode,
        'conditionType': conditionType,
        'conditionPrice': conditionPrice,
        'customerExtId': UserModel.instance.customerId,
        'accountExtId': account,
        'shortfall': orderActionType == OrderActionTypeEnum.shortSell ? 1 : 0,
      },
    );
  }

  Future<ApiResponse> getPositionList({
    required String selectedAccount,
  }) async {
    return api.post(
      _salableUnit,
      tokenized: true,
      body: {
        'CustomerExtId': UserModel.instance.customerId,
        'AccountExtId': selectedAccount.split('-').last,
      },
    );
  }

  Future<ApiResponse> createChainOrder({
    required ChainOrderModel chainOrder,
    required String parentTransactionId,
    required int chainNo,
    required String accountId,
  }) {
    Map<String, dynamic> body = chainOrder.toJson();
    body['parentTransactionId'] = parentTransactionId;
    body['chainNo'] = chainNo;
    body['customerExtId'] = UserModel.instance.customerId;
    body['accountExtId'] = accountId;
    // body['transactionTypeName'] = '5'; //TODO : (emre) // burası swagger de yok bunu sor piyasa mı limit mi oldugunu nasıl göndericez backend'e.
    return api.post(
      _addChainOrder,
      body: body,
      tokenized: true,
    );
  }

  Future<ApiResponse> updateChainOrder({
    required int chainNo,
    required String transactionExtId,
    required String equityName,
    required String debitCredit,
    required int session,
    required double price,
    required int units,
    required int transactionTypeName,
    required String orderValidity,
    required String accountExtId,
  }) {
    Map<String, dynamic> body = {
      'customerExtId': UserModel.instance.customerId,
      'accountExtId': accountExtId,
      'chainNo': chainNo,
      'transactionExtId': transactionExtId,
      'equityName': equityName,
      'debitCredit': debitCredit,
      'session': session,
      'price': price,
      'units': units,
      'transactionTypeName': transactionTypeName,
      'timeInForce': orderValidity,
    };
    return api.post(
      _updateChainOrder,
      body: body,
      tokenized: true,
    );
  }

  Future<ApiResponse> cancelOrder({
    required String transactionId,
    required String accountId,
    required String periodicTransactionId,
  }) async {
    final Map<String, dynamic> body = {
      'customerExtId': UserModel.instance.customerId,
      'accountExtId': accountId,
      'transactionId': transactionId,
      'periodicTransactionId': periodicTransactionId,
    };

    return api.post(
      _cancelOrderUrl,
      body: body,
      tokenized: true,
    );
  }

  Future<ApiResponse> cancelViopOrder({
    required String transactionId,
    required String accountId,
  }) async {
    final Map<String, dynamic> body = {
      'customerExtId': UserModel.instance.customerId,
      'accountExtId': accountId,
      'transactionId': transactionId,
    };

    return api.post(
      _cancelViopOrder,
      body: body,
      tokenized: true,
    );
  }

  Future<ApiResponse> cancelFundOrder({
    required String transactionId,
  }) async {
    final Map<String, dynamic> body = {
      'customerExtId': UserModel.instance.customerId,
      'transactionId': transactionId,
    };

    return api.post(
      _cancelFundOrder,
      body: body,
      tokenized: true,
    );
  }

  Future<ApiResponse> updateViopOrder({
    required String transactionId,
    required String accountId,
    required double price,
    required String endingDate,
    required double units,
    required String orderType,
    required String timeInForce,
  }) async {
    final Map<String, dynamic> body = {
      'customerExtId': UserModel.instance.customerId,
      'accountExtId': accountId,
      'transactionId': transactionId,
      'price': price,
      'endingDate': endingDate,
      'units': units,
      'orderType': orderType, // 1:Piyasa 2:Limit K:Piyasadan Limite
      'timeInForce':
          timeInForce, // 0: Günlük 4: Gerçekleşmezse iptal et 3: Kalanı iptal et 1: İptal edilene kadar geçerli 6: Tarihli emir 9: Dengeleyici emirler sadece bu değerle kullanılıyor
    };

    return api.post(
      _updateViopOrder,
      body: body,
      tokenized: true,
    );
  }

  Future<ApiResponse> cancelChainOrder({
    required int chainNo,
    required String transactionId,
    required String accountExtId,
  }) async {
    final Map<String, dynamic> body = {
      'chainNo': chainNo,
      'transactionId': transactionId,
      'customerExtId': UserModel.instance.customerId,
      'accountExtId': accountExtId,
    };

    return api.post(
      _cancelChainOrder,
      body: body,
      tokenized: true,
    );
  }

  Future<ApiResponse> cancelConditionalOrder({
    required String transactionId,
    required String accountExtId,
  }) async {
    final Map<String, dynamic> body = {
      'customerExtId': UserModel.instance.customerId,
      'accountExtId': accountExtId,
      'transactionId': transactionId,
    };

    return api.post(
      _cancelConditionalOrder,
      body: body,
      tokenized: true,
    );
  }

  Future<ApiResponse> updateBulkOrder({
    required List<Map<String, dynamic>> list,
    required String accountId,
  }) async {
    final Map<String, dynamic> body = {
      'customerExtId': UserModel.instance.customerId,
      'accountExtId': accountId,
      'orders': list,
    };

    return api.post(
      _replaceBulkOrderUrl,
      body: body,
      tokenized: true,
    );
  }

  Future<ApiResponse> replaceOrder({
    required String transactionId,
    required double oldPrice,
    required int oldUnit,
    required double newPrice,
    required int newUnit,
    double? tpPrice,
    double? slPrice,
    String? periodicTransactionId,
    required String timeInForce,
    DateTime? periodEndingDate,
  }) async {
    final Map<String, dynamic> params;

    params = {
      'CustomerExtId': UserModel.instance.customerId,
      'AccountExtId': UserModel.instance.accountId,
      'TransactionId': transactionId,
      'ImprovePrice': newPrice,
      'ImproveUnits': newUnit,
      'OldUnits': oldUnit,
      'OldPrice': oldPrice,
      'Session': 1,
      'OldSession': 1,
      'TimeInForce': timeInForce,
      'MaxFloor': 0,
      if (periodEndingDate != null) 'PeriodEndingDate': periodEndingDate.toString().split(' ')[0],
      if (tpPrice != null) 'TpPrice': tpPrice,
      if (slPrice != null) 'SlPrice': slPrice,
      if (periodicTransactionId != null && periodicTransactionId.isNotEmpty)
        'PeriodicTransactionId': periodicTransactionId,
    };

    return api.post(
      _replaceOrderUrl,
      body: params,
      tokenized: true,
    );
  }

  Future<ApiResponse> createBulkOrder({
    required List<Map<String, dynamic>> orders,
    required String account,
  }) async {
    return api.post(
      _newOrderBulkUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'accountExtId': account,
        'orders': orders,
      },
    );
  }

  Future<ApiResponse> createViopOrder({
    required String accountId,
    required OrderActionTypeEnum orderAction,
    required String symbolName,
    required int units,
    required SymbolTypes symbolType,
    required OptionOrderTypeEnum optionOrderType,
    required OptionOrderValidityEnum orderValidity,
    required double price,
    ViopSessionEnum? viopSession,
    DateTime? validityDate,
  }) async {
    return api.post(
      _newViopOrder,
      tokenized: true,
      body: {
        'accountExtId': accountId,
        'customerExtId': UserModel.instance.customerId,
        'debitCredit': orderAction == OrderActionTypeEnum.buy ? 'CREDIT' : 'DEBIT',
        'finInstName': symbolName,
        'units': units,
        'initialMarketSessionDate': validityDate != null ? DateTime.now().toIso8601String() : '0001-01-01T00:00:00',
        'initialMarketSessionSel': 1,
        'endingMarketSessionDate': validityDate != null ? validityDate.toIso8601String() : '0001-01-01T00:00:00',
        'endingMarketSessionSel': 1,
        'subMarketId': symbolType == SymbolTypes.future ? '0000-00000G-SMP' : '0000-00000D-SMP',
        'smsFillNotification': true,
        'emailFillNotification': false,
        'pushFillNotification': false,
        'orderType': optionenumToConditionalType(optionOrderType),
        'timeInForce': orderValidity.value,
        'price':
            optionenumToConditionalType(optionOrderType) == '1' || optionenumToConditionalType(optionOrderType) == 'K'
                ? 0
                : price,
        if (viopSession != null) 'initialMarketSessionSel': viopSession.initialMarketSessionSel.toString(),
        if (viopSession != null) 'endingMarketSessionSel': viopSession.endingMarketSessionSel.toString(),
      },
    );
  }

  Future<ApiResponse> addSubMarketContract({
    required String equityName,
    required String accountId,
  }) async {
    return api.post(
      _addSubMarketContract,
      tokenized: true,
      body: {
        'equityName': equityName,
        'customerExtId': UserModel.instance.customerId,
        'accountExtId': accountId,
      },
    );
  }

  Future<ApiResponse> cancelBulkOrder({
    required List<String> transactionIdsList,
    required String selectedAccount,
  }) async {
    return api.post(
      _cancelBulkOrderUrl,
      tokenized: true,
      body: {
        'AccountExtId': selectedAccount.split('-')[1],
        'customerExtId': UserModel.instance.customerId,
        'transactionIds': transactionIdsList,
      },
    );
  }

  Future<ApiResponse> getCapraDailyOrders({
    required String orderStatus,
  }) async {
    return api.post(
      _getCapraDailyOrders,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'orderstatus': orderStatus,
      },
    );
  }

  Future<ApiResponse> replaceUsOrder({
    required String id,
    String? qty,
    String? price,
    String? stopPrice,
    String? trail,
    String? tpPrice,
    String? slPrice,
  }) async {
    return api.post(
      _replaceUsOrder,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        "orderId": id,
        if (qty != null) "qty": MoneyUtils().fromReadableMoney(qty).toString(),
        if (price != null) "limit_price": price,
        if (stopPrice != null) "stop_price": stopPrice,
        if (trail != null) "trail": trail,
        if (tpPrice != null) "tpPrice": tpPrice,
        if (slPrice != null) "slPrice": slPrice,
      },
    );
  }

  Future<ApiResponse> deleteUsOrder({
    required String id,
  }) async {
    return api.post(
      _deleteUsOrder,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        "orderId": id,
      },
    );
  }

  Future<ApiResponse> getPeriodicOrders({
    required String accountId,
  }) async {
    return api.post(
      _getPeriodicOrders,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'accountExtId': accountId,
        'isActive': 1,
      },
    );
  }
  
  Future<ApiResponse> getViopInitialRequirement({
    required String accountId,
    required String symbolName,
    required OrderActionTypeEnum orderAction,
    required int units,
  }) async {
    return api.post(
      _getViopInitialRequirement,
      tokenized: true,
      body: {
        'FinInstName': symbolName,
        'ShortLong': orderAction == OrderActionTypeEnum.buy ? 'LONG' : 'SHORT',
        'Unit': units,
        'AccountExtId': accountId,
        'CustomerExtId': UserModel.instance.customerId,
      },
    );
  }
}
