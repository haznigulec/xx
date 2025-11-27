import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/order_completion_enum.dart';
import 'package:piapiri_v2/core/model/order_model.dart';
import 'package:piapiri_v2/core/model/order_type_enum.dart';
import 'package:piapiri_v2/core/model/order_validity_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/model/viop_session_enum.dart';


abstract class CreateOrdersRepository {
  Future<ApiResponse> getCashFlow({
    String accountId = '',
    bool allAccounts = false,
  });

  Future<ApiResponse> getTradeLimit({
    required String equityName,
    required String accountId,
  });

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
  });

  Future<ApiResponse> createChainOrder({
    required ChainOrderModel chainOrder,
    required String parentTransactionId,
    required int chainNo,
    required String accountId,
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

  Future<ApiResponse> getPositionList({
    required String selectedAccount,
  });

  Future<ApiResponse> getViopPositionList();

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
  });

  Future<ApiResponse> addSubMarketContract({
    required String equityName,
    required String accountId,
  });

  Future<ApiResponse> getCollateralInfo({
    String accountId = '',
  });

  Future<List<MarketListModel>> getDetailsOfSymbols({
    required List<String> symbolCodes,
  });

  Future<List<Map<String, dynamic>>> getMultipliersByContract({
    required String contract,
  });

  Future<String> getSuffix({
    required String name,
  });

  
  Future<List<SymbolModel>> getViopByFilters({
    required String? filter,
    required String? underlyingName,
  });
  
  Future<bool?> getViopMultiSesison({
    required String name,
  });

  Future<ApiResponse> getViopInitialRequirement({
    required String accountId,
    required String symbolName,
    required OrderActionTypeEnum orderAction,
    required int units,
  });
}
