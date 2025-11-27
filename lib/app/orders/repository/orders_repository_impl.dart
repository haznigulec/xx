import 'package:piapiri_v2/app/orders/repository/orders_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/database/db_helper.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/order_model.dart';
import 'package:piapiri_v2/core/model/order_status_enum.dart';
import 'package:piapiri_v2/core/model/order_type_enum.dart';
import 'package:piapiri_v2/core/model/order_validity_enum.dart';
import 'package:piapiri_v2/core/model/symbol_type_enum.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Future<ApiResponse> createChainOrder({
    required ChainOrderModel chainOrder,
    required String parentTransactionId,
    required int chainNo,
    required String accountId,
  }) {
    return getIt<PPApi>().ordersService.createChainOrder(
          chainOrder: chainOrder,
          parentTransactionId: parentTransactionId,
          chainNo: chainNo,
          accountId: accountId,
        );
  }

  @override
  Future<ApiResponse> updateBulkOrder({
    required List<Map<String, dynamic>> list,
    required String accountId,
  }) {
    return getIt<PPApi>().ordersService.updateBulkOrder(
          list: list,
          accountId: accountId,
        );
  }

  @override
  Future<ApiResponse> cancelBulkOrder({
    required List<String> transactionIdsList,
    required String selectedAccount,
  }) {
    return getIt<PPApi>().ordersService.cancelBulkOrder(
          transactionIdsList: transactionIdsList,
          selectedAccount: selectedAccount,
        );
  }

  @override
  Future<ApiResponse> cancelChainOrder({
    required int chainNo,
    required String transactionId,
    required String accountExtId,
  }) {
    return getIt<PPApi>().ordersService.cancelChainOrder(
          chainNo: chainNo,
          transactionId: transactionId,
          accountExtId: accountExtId,
        );
  }

  @override
  Future<ApiResponse> cancelConditionalOrder({
    required String transactionId,
    required String accountExtId,
  }) {
    return getIt<PPApi>().ordersService.cancelConditionalOrder(
          transactionId: transactionId,
          accountExtId: accountExtId,
        );
  }

  @override
  Future<ApiResponse> cancelOrder({
    required String transactionId,
    required String accountId,
    required String periodicTransactionId,
  }) {
    return getIt<PPApi>().ordersService.cancelOrder(
          transactionId: transactionId,
          accountId: accountId,
          periodicTransactionId: periodicTransactionId,
        );
  }

  @override
  Future<ApiResponse> cancelViopOrder({
    required String transactionId,
    required String accountId,
  }) {
    return getIt<PPApi>().ordersService.cancelViopOrder(
          transactionId: transactionId,
          accountId: accountId,
        );
  }

  @override
  Future<ApiResponse> cancelFundOrder({
    required String transactionId,
  }) {
    return getIt<PPApi>().ordersService.cancelFundOrder(
          transactionId: transactionId,
        );
  }

  @override
  Future<ApiResponse> getOrders(
      {required SymbolTypeEnum symbolType,
      required String account,
      OrderStatusEnum? orderStatus,
      bool groupBySymbol = false,
      bool includeConditionalOrders = true}) {
    return getIt<PPApi>().ordersService.getOrders(
          symbolType: symbolType,
          account: account,
          orderStatus: orderStatus,
          groupBySymbol: groupBySymbol,
          includeConditionalOrders: includeConditionalOrders,
        );
  }

  @override
  Future<ApiResponse> getTradeLimit({
    required String equityName,
    required String accountId,
  }) {
    return getIt<PPApi>().ordersService.getTradeLimit(
          equityName: equityName,
          accountId: accountId,
        );
  }

  @override
  Future<ApiResponse> createBulkOrder({
    required List<Map<String, dynamic>> orders,
    required String account,
  }) {
    return getIt<PPApi>().ordersService.createBulkOrder(
          orders: orders,
          account: account,
        );
  }

  @override
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
  }) {
    return getIt<PPApi>().ordersService.replaceOrder(
          transactionId: transactionId,
          timeInForce: timeInForce,
          oldPrice: oldPrice,
          oldUnit: oldUnit,
          newPrice: newPrice,
          newUnit: newUnit,
          tpPrice: tpPrice,
          slPrice: slPrice,
          periodicTransactionId: periodicTransactionId,
          periodEndingDate: periodEndingDate,
        );
  }

  @override
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
    return getIt<PPApi>().ordersService.updateChainOrder(
          chainNo: chainNo,
          transactionExtId: transactionExtId,
          equityName: equityName,
          debitCredit: debitCredit,
          session: session,
          price: price,
          units: units,
          transactionTypeName: transactionTypeName,
          orderValidity: orderValidity,
          accountExtId: accountExtId,
        );
  }

  @override
  Future<ApiResponse> updateViopOrder({
    required String transactionId,
    required String accountId,
    required double price,
    required String endingDate,
    required double units,
    required String orderType,
    required String timeInForce,
  }) {
    return getIt<PPApi>().ordersService.updateViopOrder(
          transactionId: transactionId,
          accountId: accountId,
          price: price,
          endingDate: endingDate,
          units: units,
          orderType: orderType,
          timeInForce: timeInForce,
        );
  }

  @override
  Future<ApiResponse> getCollateralInfo({
    String accountId = '',
  }) {
    return getIt<PPApi>().assetsService.getCollateralInfo(
          accountId: accountId,
        );
  }

  @override
  Future<String> getFundFounderCode({
    required String code,
  }) {
    return _dbHelper.getFundFounderCode(
      code,
    );
  }

  @override
  Future<List<MarketListModel>> getDetailsOfSymbols({
    required List<String> symbolCodes,
  }) async {
    List<Map<String, dynamic>> selectedListItems = await _dbHelper.getDetailsOfSymbols(symbolCodes);
    List<MarketListModel> selectedSymbolList = selectedListItems
        .map(
          (e) => MarketListModel(
            symbolCode: e['Name'],
            updateDate: '',
            type: e['TypeCode'],
            marketCode: e['MarketCode'] ?? '',
            swapType: e['SwapType'] ?? '',
            actionType: e['ActionType'] ?? '',
            underlying: e['UnderlyingName'] ?? '',
            description: e['Description'] ?? '',
            decimalCount: e['DecimalCount'] ?? 0,
          ),
        )
        .toList();
    return selectedSymbolList;
  }

  @override
  Future<ApiResponse> getCapraDailyOrders({
    required String orderStatus,
  }) {
    return getIt<PPApi>().ordersService.getCapraDailyOrders(
          orderStatus: orderStatus,
        );
  }

  @override
  Future<ApiResponse> replaceUsOrder({
    required String id,
    String? qty,
    String? price,
    String? stopPrice,
    String? trail,
    String? tpPrice,
    String? slPrice,
  }) {
    return getIt<PPApi>().ordersService.replaceUsOrder(
          id: id,
          qty: qty,
          price: price,
          stopPrice: stopPrice,
          trail: trail,
          tpPrice: tpPrice,
          slPrice: slPrice,
        );
  }

  @override
  Future<ApiResponse> deleteUsOrder({
    required String id,
  }) {
    return getIt<PPApi>().ordersService.deleteUsOrder(
          id: id,
        );
  }

  @override
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
  }) {
    return getIt<PPApi>().ordersService.createConditionalOrder(
          transactionId: transactionId,
          symbolName: symbolName,
          units: units,
          orderActionType: orderActionType,
          orderType: orderType,
          orderValidity: orderValidity,
          account: account,
          price: price,
          conditionSymbolCode: conditionSymbolCode,
          conditionType: conditionType,
          conditionPrice: conditionPrice,
        );
  }

  @override
  Future<ApiResponse> getPeriodicOrders({
    required String accountId,
  }) {
    return getIt<PPApi>().ordersService.getPeriodicOrders(
          accountId: accountId,
        );
  }

  @override
  Future<String> getSuffixByBistCodeForTypeCode({
    required String name,
    required String typeCode,
  }) async {
    final suffixList = await _dbHelper.getSuffixByBistCodeForTypeCode(name, typeCode);
    return suffixList.firstOrNull?['Suffix'] as String? ?? '';
  }
}
