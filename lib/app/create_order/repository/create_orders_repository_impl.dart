import 'package:piapiri_v2/app/create_order/repository/create_orders_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/database/db_helper.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/order_completion_enum.dart';
import 'package:piapiri_v2/core/model/order_model.dart';
import 'package:piapiri_v2/core/model/order_type_enum.dart';
import 'package:piapiri_v2/core/model/order_validity_enum.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/viop_session_enum.dart';

class CreateOrdersRepositoryImpl implements CreateOrdersRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

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
  }) async {
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
  Future<ApiResponse> addSubMarketContract({
    required String equityName,
    required String accountId,
  }) {
    return getIt<PPApi>().ordersService.addSubMarketContract(
          equityName: equityName,
          accountId: accountId,
        );
  }

  @override
  Future<ApiResponse> getCashFlow({
    String accountId = '',
    bool allAccounts = false,
  }) {
    return getIt<PPApi>().ordersService.getCashFlow(
          accountId: accountId,
          allAccounts: allAccounts,
        );
  }

  @override
  Future<ApiResponse> getPositionList({
    required String selectedAccount,
  }) {
    return getIt<PPApi>().ordersService.getPositionList(
          selectedAccount: selectedAccount,
        );
  }

  @override
  Future<ApiResponse> getViopPositionList() {
    return getIt<PPApi>().assetsService.getAccountOverallWithsummary(
          accountId: '',
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
    double? sellLossPrice,
    double? takeProfitPrice,
    DateTime? periodEndDate,
    bool hasStopLoss = false,
  }) {
    return getIt<PPApi>().ordersService.createOrder(
          symbolName: symbolName,
          quantity: quantity,
          orderActionType: orderActionType,
          orderType: orderType,
          orderValidity: orderValidity,
          account: account,
          price: price,
          orderCompletionType: orderCompletionType,
          shownQuantity: shownQuantity,
          sellLossPrice: sellLossPrice,
          takeProfitPrice: takeProfitPrice,
          periodEndDate: periodEndDate,
          hasStopLoss: hasStopLoss,
        );
  }

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
  }) {
    return getIt<PPApi>().ordersService.createViopOrder(
          accountId: accountId,
          orderAction: orderAction,
          symbolName: symbolName,
          units: units,
          symbolType: symbolType,
          orderValidity: orderValidity,
          optionOrderType: optionOrderType,
          price: price,
          viopSession: viopSession,
          validityDate: validityDate,
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
          ),
        )
        .toList();
    return selectedSymbolList;
  }

  @override
  Future<List<Map<String, dynamic>>> getMultipliersByContract({
    required String contract,
  }) {
    return _dbHelper.getMultipliersByContract(contract);
  }

  @override
  Future<String> getSuffix({
    required String name,
  }) async {
    List<Map<String, dynamic>> suffix = await _dbHelper.getSuffix(name);
    return suffix[0]['Suffix'] ?? '';
  }

  @override
  Future<List<SymbolModel>> getViopByFilters({
    required String? filter,
    required String? underlyingName,
  }) async {
    List<Map<String, dynamic>> symbols = await _dbHelper.getViopByFilters(
      onlyTradeable: true,
      filter,
      underlyingName,
      null,
      null,
      null,
    );
    List<SymbolModel> symbolModelList = symbols.map((e) => SymbolModel.fromMap(e)).toList();
    symbolModelList.sort((a, b) => a.maturityDate.compareTo(b.maturityDate));
    return symbolModelList;
  }
  
  @override
  Future<bool?> getViopMultiSesison({
    required String name,
  }) async {
    bool? multiSession = await _dbHelper.getViopMultiSession(name);
    return multiSession;
  }

  @override
  Future<ApiResponse> getViopInitialRequirement({
    required String accountId,
    required String symbolName,
    required OrderActionTypeEnum orderAction,
    required int units,
  }) {
    return getIt<PPApi>().ordersService.getViopInitialRequirement(
          symbolName: symbolName,
          orderAction: orderAction,
          units: units,
          accountId: accountId,
        );
  }
}
