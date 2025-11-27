import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/order_model.dart';
import 'package:piapiri_v2/core/model/order_status_enum.dart';
import 'package:piapiri_v2/core/model/order_type_enum.dart';
import 'package:piapiri_v2/core/model/order_validity_enum.dart';
import 'package:piapiri_v2/core/model/symbol_type_enum.dart';

abstract class OrdersRepository {
  Future<ApiResponse> getOrders({
    required SymbolTypeEnum symbolType,
    required String account,
    OrderStatusEnum? orderStatus,
    bool groupBySymbol = false,
    bool includeConditionalOrders = true,
  });

  Future<ApiResponse> getTradeLimit({
    required String equityName,
    required String accountId,
  });

  Future<ApiResponse> createChainOrder({
    required ChainOrderModel chainOrder,
    required String parentTransactionId,
    required int chainNo,
    required String accountId,
  });

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
  });

  Future<ApiResponse> cancelOrder({
    required String transactionId,
    required String accountId,
    required String periodicTransactionId,
  });

  Future<ApiResponse> cancelViopOrder({
    required String transactionId,
    required String accountId,
  });

  Future<ApiResponse> cancelFundOrder({
    required String transactionId,
  });

  Future<ApiResponse> updateViopOrder({
    required String transactionId,
    required String accountId,
    required double price,
    required String endingDate,
    required double units,
    required String orderType,
    required String timeInForce,
  });

  Future<ApiResponse> cancelChainOrder({
    required int chainNo,
    required String transactionId,
    required String accountExtId,
  });

  Future<ApiResponse> cancelConditionalOrder({
    required String transactionId,
    required String accountExtId,
  });

  Future<ApiResponse> updateBulkOrder({
    required List<Map<String, dynamic>> list,
    required String accountId,
  });

  Future<ApiResponse> replaceOrder({
    required String transactionId,
    required double oldPrice,
    required int oldUnit,
    required double newPrice,
    required int newUnit,
    required String timeInForce,
    double? tpPrice,
    double? slPrice,
    String? periodicTransactionId,
    DateTime? periodEndingDate,
  });

  Future<ApiResponse> createBulkOrder({
    required List<Map<String, dynamic>> orders,
    required String account,
  });

  Future<ApiResponse> cancelBulkOrder({
    required List<String> transactionIdsList,
    required String selectedAccount,
  });
  Future<ApiResponse> getCollateralInfo({
    String accountId = '',
  });

  Future<String> getFundFounderCode({
    required String code,
  });

  Future<List<MarketListModel>> getDetailsOfSymbols({
    required List<String> symbolCodes,
  });

  Future<ApiResponse> getCapraDailyOrders({
    required String orderStatus,
  });

  Future<ApiResponse> replaceUsOrder({
    required String id,
    String? qty,
    String? price,
    String? stopPrice,
    String? trail,
    String? tpPrice,
    String? slPrice,
  });

  Future<ApiResponse> deleteUsOrder({
    required String id,
  });

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
  });

  Future<ApiResponse> getPeriodicOrders({
    required String accountId,
  });

  Future<String> getSuffixByBistCodeForTypeCode({
    required String name,
    required String typeCode,
  });
}
