import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/assets/model/collateral_info_model.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_event.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_state.dart';
import 'package:piapiri_v2/app/orders/repository/orders_repository.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/order_list_model.dart';
import 'package:piapiri_v2/core/model/order_model.dart';
import 'package:piapiri_v2/core/model/order_status_enum.dart';
import 'package:piapiri_v2/core/model/order_type_enum.dart';
import 'package:piapiri_v2/core/model/order_validity_enum.dart';
import 'package:piapiri_v2/core/model/symbol_type_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/transaction_model.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class OrdersBloc extends PBloc<OrdersState> {
  final OrdersRepository _ordersRepository;

  OrdersBloc({
    required OrdersRepository ordersRepository,
  })  : _ordersRepository = ordersRepository,
        super(initialState: const OrdersState()) {
    on<GetOrdersEvent>(_onGetOrders);
    on<RefreshOrdersEvent>(_onRefreshOrders);
    on<CreateChainOrderEvent>(_onCreateChainOrder);
    on<CreateConditionOrderEvent>(_onCreateConditionalOrder);
    on<UpdateOrderEvent>(_onUpdateOrder);
    on<AddChainListEvent>(_onAddChainList);
    on<RemoveChainListEvent>(_onRemoveChainList);
    on<UpdateChainListEvent>(_onUpdateChainList);
    on<CancelOrderEvent>(_onCancelOrder);
    on<CancelChainOrderEvent>(_onCancelChainOrder);
    on<CancelConditionalOrderEvent>(_onCancelConditionalOrder);
    on<CancelViopOrderEvent>(_onCancelViopOrder);
    on<CancelFundOrderEvent>(_onCancelFundOrder);
    on<CancelBulkOrderEvent>(_onCancelBulkOrder);
    on<UpdateViopOrderEvent>(_onUpdateViopOrder);
    on<BulkUpdateEvent>(_onBulkUpdate);
    on<CreateBulkOrderEvent>(_onCreateBulkOrder);
    on<GetCollateralInfoEvent>(_onGetCollateralInfo);
    on<GetTradeLimitEvent>(_onGetTradeLimit);
    on<RemoveConditionEvent>(_onRemoveCondition);
    on<ReplaceOrderEvent>(_onReplaceOrder);
    on<UpdateChainOrderEvent>(_onUpdateChainOrder);
    on<ReplaceUsOrderEvent>(_onReplaceUsOrder);
    on<DeleteUsOrderEvent>(_onDeleteUsOrder);
    on<GetPeriodicOrdersEvent>(_onGetPeriodicOrders);
  }

  FutureOr<void> _onGetOrders(
    GetOrdersEvent event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          type: state.orderListMap == null || event.isLoading ? PageState.loading : PageState.fetching,
          orderListState: event.isLoading ? PageState.loading : null,
          selectedAccount: event.account,
          selectedSymbolType: event.symbolType == SymbolTypeEnum.wrList ? SymbolTypeEnum.eqList : event.symbolType,
          selectedOrderStatus: event.orderStatus,
        ),
      );
      ApiResponse response = await _ordersRepository.getOrders(
        symbolType: state.selectedSymbolType,
        account: state.selectedAccount,
        orderStatus: state.selectedOrderStatus,
      );

      if (response.success) {
        List<TransactionModel> totalEquityList = response.data['equityTransactionList'].map<TransactionModel>((json) {
          json['symbolType'] = json['equityGroupCode'] == 'V' ? SymbolTypeEnum.wrList : SymbolTypeEnum.eqList;
          return TransactionModel.fromJson(json);
        }).toList();

        List<TransactionModel> updatedList = [];
        for (final equity in totalEquityList) {
          final symbolName = equity.symbol ?? '';
          final symbolGroupCode = equity.equityGroupCode ?? '';
          final symbolSuffixList = getIt<AppInfoBloc>().state.symbolSuffixList;
          if (symbolName.isNotEmpty) {
            final inSuffixList = symbolSuffixList.isNotEmpty && symbolSuffixList.any((e) => e.name == symbolName);
            if (inSuffixList) {
              final updatedSymbolName =
                  getIt<AppInfoBloc>().state.symbolSuffixList.firstWhere((e) => e.name == symbolName).nameWithSuffix;
              updatedList.add(equity.copyWith(symbol: updatedSymbolName));
            } else {
              SymbolTypes? symbolType = Utils.getSybolTypeFromGroupCode(symbolGroupCode);
              String? symbolSuffix = symbolType != null
                  ? await _ordersRepository.getSuffixByBistCodeForTypeCode(
                      name: symbolName,
                      typeCode: symbolType.dbKey,
                    )
                  : null;
              String updatedSymbolName = Utils.symbolNameAddSuffix(
                symbolName,
                symbolType,
                suffix: symbolSuffix,
              );
              updatedList.add(
                equity.copyWith(symbol: updatedSymbolName),
              );
            }
          }
        }
        totalEquityList = updatedList;
        totalEquityList.sort(
          (a, b) => (b.orderDate ?? b.valueDate ?? '').compareTo(a.orderDate ?? a.valueDate ?? ''),
        );

        List<TransactionModel> viopList = await Future.wait(
          response.data['viopTransactionList']
              .map<Future<TransactionModel>>((json) async => _viopListGenerator(json))
              .toList(),
        );

        List<TransactionModel> fundList = await Future.wait(
          response.data['fundTransactionList']
              .map<Future<TransactionModel>>((json) => _fundListGenerator(json))
              .toList(),
        );

        List<TransactionModel> fincList = response.data['fincTransactionList'].map<TransactionModel>((json) {
          json['symbolType'] = SymbolTypeEnum.fincList;
          return TransactionModel.fromJson(json);
        }).toList();

        List<TransactionModel> pureEquityList =
            totalEquityList.where((element) => element.equityGroupCode != 'V').toList();
        List<TransactionModel> pureWarrantList =
            totalEquityList.where((element) => element.equityGroupCode == 'V').toList();
        pureWarrantList = await _warrantListGenerator(pureWarrantList);

        List<TransactionModel> americanStockExchangeList = [];

        if ((event.symbolType == SymbolTypeEnum.all || event.symbolType == SymbolTypeEnum.americanStockExchangeList) &&
            UserModel.instance.alpacaAccountStatus) {
          ApiResponse americanReponse = await _ordersRepository.getCapraDailyOrders(
            orderStatus: state.selectedOrderStatus.name.toUpperCase(),
          );

          if (americanReponse.success) {
            for (var element in americanReponse.data['retrieveAListOfOrders']) {
              americanStockExchangeList.add(
                TransactionModel(
                  isAmericanStockExchangeOrder: true,
                  id: element['id'],
                  accountExtId: '',
                  customerExtId: '',
                  transactionPrice: element['price'],
                  orderAmount: element['notional'] != null ? double.parse(element['notional'].toString()) : null,
                  orderPrice: element['limit_price'] != null ? double.parse(element['limit_price']) : null,
                  orderUnit: element['qty'] != null ? num.parse(element['qty']) : null,
                  orderDate: element['created_at'],
                  orderType: element['order_type'] ?? '',
                  orderTime: element['created_at'],
                  symbol: element['symbol'],
                  transactionExtId: '',
                  realizedUnit: double.parse(element['filled_qty'] ?? '0'),
                  remainingUnit: 0,
                  transactionType: element['side'] ?? '',
                  orderStatus: element['status'],
                  validity: element['time_in_force'],
                  transactionId: element[''],
                  chainNo: null,
                  session: null,
                  tpPrice: element['tpPrice'],
                  slPrice: element['slPrice'],
                  symbolType: SymbolTypeEnum.americanStockExchangeList,
                  stopPrice: element['stop_price'] != null ? double.parse(element['stop_price']) : null,
                  filledAvgPrice: element['filled_avg_price'],
                  filledAt: element['filled_at'],
                  extendedHours: element['extended_hours'],
                  commission: element['commission'],
                ),
              );
            }
          } else {
            if (response.error?.message == 'Invalid Token' ||
                response.error?.message == 'invalid_token' ||
                response.error?.message == 'Unauthorized' ||
                response.error?.message == '900000001') {
              event.invalidTokenCallBack?.call();
            }
            emit(
              state.copyWith(
                type: PageState.failed,
                error: PBlocError(
                  showErrorWidget: true,
                  message: americanReponse.error?.message ?? '',
                  errorCode: '01ORD001',
                ),
              ),
            );
          }
        }

        Map<OrderStatusEnum, OrderListModel> orderListMap = {};

        OrderListModel orderListModel = OrderListModel(
          equityList: pureEquityList,
          warrantList: pureWarrantList,
          viopList: viopList,
          fundList: fundList,
          fincList: fincList,
          americanStockExchangeList: americanStockExchangeList,
        );

        orderListMap[event.orderStatus] = orderListModel;
        if (state.orderListMap != orderListMap || event.refreshData) {
          emit(
            state.copyWith(
              type: PageState.success,
              orderListState: PageState.success,
              orderListMap: orderListMap,
            ),
          );
          event.callBack?.call(orderListModel);
        }
      } else {
        if (response.error?.message == 'Invalid Token' ||
            response.error?.message == 'invalid_token' ||
            response.error?.message == 'Unauthorized' ||
            response.error?.message == '900000001') {
          event.invalidTokenCallBack?.call();
        }
        emit(
          state.copyWith(
            type: PageState.failed,
            orderListState: event.isLoading ? PageState.failed : null,
            error: PBlocError(
              showErrorWidget: true,
              message: response.error?.message ?? '',
              errorCode: '01GORD01',
            ),
          ),
        );
      }
    } catch (e, s) {
      talker.critical(
        e.toString(),
        s.toString(),
      );
    }
  }

  Future<TransactionModel> _fundListGenerator(json) async {
    json['symbolType'] = SymbolTypeEnum.mfList;
    json['underlying'] = await _ordersRepository.getFundFounderCode(
      code: json['symbol'],
    );
    return TransactionModel.fromJson(json);
  }

  Future<TransactionModel> _viopListGenerator(json) async {
    json['symbolType'] = SymbolTypeEnum.viopList;
    json['transactionType'] = settingsToOptionOrderTypeEnum(json['orderType']).value;
    json['orderAmount'] = json['unitNominal'] * (json['orderUnit'] ?? 0) * (json['orderPrice'] ?? json['price'] ?? 0);
    List<MarketListModel> detail = await _ordersRepository.getDetailsOfSymbols(
      symbolCodes: [json['symbol']],
    );
    json['underlying'] = detail.isNotEmpty ? detail[0].underlying : '';
    json['decimalCount'] = detail.isNotEmpty ? detail[0].decimalCount : 0;
    return TransactionModel.fromJson(json);
  }

  Future<List<TransactionModel>> _warrantListGenerator(List<TransactionModel> warrantList) async {
    Future<List<TransactionModel>> warrantList0 = Future.wait(
      warrantList.map((element) async {
        List<MarketListModel> detail = await _ordersRepository.getDetailsOfSymbols(symbolCodes: [element.symbol ?? '']);
        if (detail.isNotEmpty) {
          return element.copyWith(underlying: detail[0].underlying);
        }
        return element;
      }).toList(),
    );
    return warrantList0;
  }

  FutureOr<void> _onRefreshOrders(
    RefreshOrdersEvent event,
    Emitter<OrdersState> emit,
  ) async {
    if (state.isSuccess) {
      add(
        GetOrdersEvent(
          account: event.account,
          symbolType: event.symbolType,
          orderStatus: event.orderStatus,
          refreshData: true,
          isLoading: event.isLoading,
          callBack: (_) {
            event.onFetched?.call();
          },
        ),
      );
    }
  }

  FutureOr<void> _onCreateChainOrder(
    CreateChainOrderEvent event,
    Emitter<OrdersState> emit,
  ) async {
    if (state.chainOrderList.isNotEmpty) {
      emit(
        state.copyWith(
          type: PageState.loading,
        ),
      );

      int chainNo = event.chainNo;
      List<String> failedSymbols = [];
      for (int i = 0; i < state.chainOrderList.length; i++) {
        ChainOrderModel chainOrder = state.chainOrderList[i];
        ApiResponse chainResponse = await _ordersRepository.createChainOrder(
          chainOrder: chainOrder,
          parentTransactionId: event.parentTransactionId,
          chainNo: chainNo,
          accountId: event.accountExtId,
        );

        if (!chainResponse.success) {
          failedSymbols.add(chainOrder.marketListModel.symbolCode);
        } else {
          chainNo = chainResponse.data['chainOrder']['chainNo'];
        }
      }
      emit(
        state.copyWith(
          type: PageState.success,
          chainOrderList: [],
        ),
      );
      add(
        GetOrdersEvent(
          account: '${UserModel.instance.customerId}-${event.accountExtId}',
          orderStatus: OrderStatusEnum.pending,
          symbolType: SymbolTypeEnum.all,
          refreshData: true,
        ),
      );
      await event.callback(failedSymbols);
    }
  }

  FutureOr<void> _onCreateConditionalOrder(
    CreateConditionOrderEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _ordersRepository.createConditionalOrder(
      transactionId: event.transactionId,
      symbolName: event.symbolName,
      account: event.account,
      units: event.units,
      orderActionType: event.orderActionType,
      orderType: event.orderType,
      orderValidity: event.orderValidity,
      price: event.price,
      conditionSymbolCode: event.conditionSymbolCode,
      conditionType: event.conditionType,
      conditionPrice: event.conditionPrice,
    );

    if (response.success) {
      event.callback(
        L10n.tr('success_order'),
        false,
      );
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: false,
            message: response.error?.message ?? '',
            errorCode: '01GORD14',
          ),
        ),
      );

      String errorMessage = '';

      if (response.error?.message == 'CannotSendActiveConditionalOrder') {
        if (event.conditionType == '2') {
          errorMessage = L10n.tr('CannotSendActiveConditionalOrderLessThanEqual');
        } else if (event.conditionType == '3') {
          errorMessage = L10n.tr('CannotSendActiveConditionalOrderGreaterThanEqual');
        }
      } else if (response.error?.message != null) {
        errorMessage = L10n.tr('order.conditional_order_error.${response.error?.message}');
      }

      event.callback(
        errorMessage,
        true,
      );
    }
  }

  FutureOr<void> _onUpdateOrder(
    UpdateOrderEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(
      state.copyWith(
        newOrder: state.newOrder.copyWith(
          isTransfer: event.isTransfer,
          quantity: event.quantity,
          price: event.price,
          selectedSymbol: event.selectedSymbol ?? state.newOrder.selectedSymbol,
          selectedAccount: event.selectedAccount,
          selectedOrderCompletion: event.selectedOrderCompletion,
          selectedOrderType: event.selectedOrderType,
          selectedStockItem: event.selectedStockItem,
          selectedOrderCompletionName: event.selectedOrderCompletionName,
          selectedValidity: event.selectedValidity,
          selectedOrderActionType: event.selectedOrderActionType,
          shownQuantity: event.shownQuantity,
          symbolType: event.symbolType,
          conditionSymbol: event.conditionSymbol,
          conditionType: event.conditionType,
          conditionPrice: event.conditionPrice,
          stopLossPrice: event.stopLossPrice,
          takeProfitPrice: event.takeProfitPrice,
          periodEndDate: event.periodEndDate,
          isStopLossExpanded: event.isStopLossExpanded,
          isConditionExpanded: event.isConditionExpanded,
        ),
        type: PageState.updated,
      ),
    );
  }

  FutureOr<void> _onAddChainList(
    AddChainListEvent event,
    Emitter<OrdersState> emit,
  ) {
    emit(
      state.copyWith(
        type: PageState.updating,
      ),
    );
    List<ChainOrderModel> chainOrderList = List.from(state.chainOrderList);
    chainOrderList.add(
      ChainOrderModel(
        chainNo: 0,
        parentTransactionId: '',
        marketListModel: event.marketListModel,
        orderAction: event.orderAction,
        price: event.price,
        units: event.unit,
        orderValidity: OrderValidityEnum.daily,
        orderType: OrderTypeEnum.limit,
      ),
    );
    emit(
      state.copyWith(
        type: PageState.updated,
        chainOrderList: chainOrderList,
      ),
    );
  }

  FutureOr<void> _onRemoveChainList(
    RemoveChainListEvent event,
    Emitter<OrdersState> emit,
  ) {
    emit(
      state.copyWith(
        type: PageState.updating,
      ),
    );
    if (event.removeAll) {
      emit(
        state.copyWith(
          chainOrderList: [],
          type: PageState.updated,
        ),
      );
    } else {
      List<ChainOrderModel> chainOrderList = List.from(state.chainOrderList);

      chainOrderList.removeAt(event.index);

      emit(
        state.copyWith(
          chainOrderList: chainOrderList,
          type: PageState.updated,
        ),
      );
    }
  }

  FutureOr<void> _onUpdateChainList(
    UpdateChainListEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.updating,
      ),
    );
    ChainOrderModel chainOrder = state.chainOrderList[event.index];
    List<ChainOrderModel> chainOrderList = List.from(state.chainOrderList);

    chainOrderList[event.index] = await chainOrder.copyWith(
      marketListModel: event.marketListModel,
      orderAction: event.orderAction,
      price: event.price,
      units: event.units,
      orderValidity: event.orderValidity,
      orderType: event.orderType,
    );

    emit(
      state.copyWith(
        type: PageState.updated,
        chainOrderList: chainOrderList,
      ),
    );
  }

  FutureOr<void> _onCancelOrder(
    CancelOrderEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.deleting,
      ),
    );

    ApiResponse response = await _ordersRepository.cancelOrder(
      transactionId: event.transactionId,
      accountId: event.accountId,
      periodicTransactionId: event.periodicTransactionId,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      add(
        GetOrdersEvent(
          account: '${UserModel.instance.customerId}-${event.accountId}',
          orderStatus: OrderStatusEnum.pending,
          symbolType: SymbolTypeEnum.all,
          refreshData: true,
        ),
      );
      event.succesCallBack();
      event.completedCallBack?.call(true, L10n.tr(response.data['successMessage']));
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: event.completedCallBack == null,
            message: 'orders.cancel.${response.error?.message ?? ''}',
            errorCode: '01CORD06',
          ),
        ),
      );
      event.completedCallBack?.call(false, L10n.tr('orders.cancel.${response.error?.message ?? ''}'));
    }
  }

  FutureOr<void> _onCancelBulkOrder(
    CancelBulkOrderEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _ordersRepository.cancelBulkOrder(
      transactionIdsList: event.transactionIdsList,
      selectedAccount: event.selectedAccount,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      add(
        GetOrdersEvent(
          account: '${UserModel.instance.customerId}-${UserModel.instance.accountId}',
          orderStatus: OrderStatusEnum.canceled,
          symbolType: SymbolTypeEnum.all,
          refreshData: true,
        ),
      );

      event.callback?.call();
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: 'orders.cancel.${response.error?.message ?? ''}',
            errorCode: '01CORD06',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onCancelChainOrder(
    CancelChainOrderEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.deleting,
      ),
    );

    ApiResponse response = await _ordersRepository.cancelChainOrder(
      chainNo: event.chainNo,
      transactionId: event.transactionId,
      accountExtId: event.accountExtId,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      add(
        GetOrdersEvent(
          account: '${UserModel.instance.customerId}-${event.accountExtId}',
          orderStatus: OrderStatusEnum.pending,
          symbolType: SymbolTypeEnum.all,
          refreshData: true,
        ),
      );
      event.completedCallBack?.call(true, L10n.tr(response.data['transactionSuccessMessage']));
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: event.completedCallBack == null,
            message: response.error?.message ?? '',
            errorCode: '01CORD06',
          ),
        ),
      );
      event.completedCallBack?.call(false, L10n.tr(response.error?.message ?? ''));
    }
  }

  FutureOr<void> _onCancelConditionalOrder(
    CancelConditionalOrderEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.deleting,
      ),
    );

    ApiResponse response = await _ordersRepository.cancelConditionalOrder(
      accountExtId: event.accountExtId,
      transactionId: event.transactionId,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      add(
        GetOrdersEvent(
          account: '${UserModel.instance.customerId}-${event.accountExtId}',
          orderStatus: OrderStatusEnum.pending,
          symbolType: SymbolTypeEnum.all,
          refreshData: true,
        ),
      );
      event.completedCallBack?.call(true, L10n.tr(response.data['transactionSuccessMessage']));
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: event.completedCallBack == null,
            message: response.error?.message ?? '',
            errorCode: '01CORD06',
          ),
        ),
      );
      event.completedCallBack?.call(false, L10n.tr(response.error?.message ?? ''));
    }
  }

  FutureOr<void> _onCancelViopOrder(
    CancelViopOrderEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.deleting,
      ),
    );

    ApiResponse response = await _ordersRepository.cancelViopOrder(
      transactionId: event.transactionId,
      accountId: event.accountId,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      add(
        GetOrdersEvent(
          account: '${UserModel.instance.customerId}-${event.accountId}',
          orderStatus: OrderStatusEnum.pending,
          symbolType: SymbolTypeEnum.all,
          refreshData: true,
        ),
      );
      event.completedCallBack?.call(true, L10n.tr('order.viop_delete_success'));
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: event.completedCallBack == null,
            message: response.error?.message ?? '',
            errorCode: '01VORD06',
          ),
        ),
      );
      event.completedCallBack?.call(false, L10n.tr(response.error?.message ?? ''));
    }
  }

  FutureOr<void> _onCancelFundOrder(
    CancelFundOrderEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.deleting,
      ),
    );

    ApiResponse response = await _ordersRepository.cancelFundOrder(
      transactionId: event.transactionId,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      add(
        GetOrdersEvent(
          account: '${UserModel.instance.customerId}-${event.accountId}',
          orderStatus: OrderStatusEnum.pending,
          symbolType: SymbolTypeEnum.all,
          refreshData: true,
        ),
      );
      event.completedCallBack?.call(true, L10n.tr('order.fund_delete_success'));
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: event.completedCallBack == null,
            message: response.error?.message ?? '',
            errorCode: '01FUND06',
          ),
        ),
      );
      event.completedCallBack?.call(false, L10n.tr(response.error?.message ?? ''));
    }
  }

  FutureOr<void> _onUpdateViopOrder(
    UpdateViopOrderEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.updating,
      ),
    );

    ApiResponse response = await _ordersRepository.updateViopOrder(
      transactionId: event.transactionId,
      accountId: event.accountId,
      price: event.price,
      endingDate: event.endingDate,
      units: event.units,
      orderType: event.orderType,
      timeInForce: event.timeInForce,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      add(
        GetOrdersEvent(
          account: '${UserModel.instance.customerId}-${event.accountId}',
          orderStatus: OrderStatusEnum.pending,
          symbolType: SymbolTypeEnum.all,
          refreshData: true,
        ),
      );
      event.callback(
        L10n.tr('order.viop_update_success'),
      );
    } else {
      event.onFailed();
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: L10n.tr(
              response.error?.message ?? '',
            ),
            errorCode: '01VORD06',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onBulkUpdate(
    BulkUpdateEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    String account = event.list[0]['selectedAccounts'];

    String accountId = account.split('-')[1];

    List<Map<String, dynamic>> updateList = event.list
        .map(
          (e) => {
            'AccountExtId': e['selectedAccounts'].split('-')[1],
            'customerExtId': UserModel.instance.customerId,
            'transactionId': e['transactionExtId'],
            'ImprovePrice': double.parse(event.price.toStringAsFixed(2).toString()),
            'ImproveUnits': int.parse(e['OldUnits']),
            'OldUnits': int.parse(e['OldUnits']),
            'OldPrice': double.parse(e['OldPrice'].toString().replaceAll(',', '.')),
            'Session': 1,
            'OldSession': 1,
            'TimeInForce': '0',
            'ExpireDate': '2022-05-04',
            'MaxFloor': 0,
          },
        )
        .toList();

    ApiResponse response = await _ordersRepository.updateBulkOrder(
      list: updateList,
      accountId: accountId,
    );

    if (response.success) {
      String message = '';
      bool isSuccess = true;
      if (response.data['resultReplaceBulkOrderList'][0]['errorMessage'] != null &&
          response.data['resultReplaceBulkOrderList'][0]['errorMessage'].toString().isNotEmpty) {
        message = response.data['resultReplaceBulkOrderList'][0]['errorMessage'];
        isSuccess = false;
      } else {
        message = response.data['resultReplaceBulkOrderList'][0]['result']['successMessage'];
        add(
          GetOrdersEvent(
            account: account,
            orderStatus: OrderStatusEnum.pending,
            symbolType: SymbolTypeEnum.all,
            refreshData: true,
          ),
        );
      }
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      event.callback(message, isSuccess);
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '01BUPT07',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onReplaceOrder(
    ReplaceOrderEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _ordersRepository.replaceOrder(
      transactionId: event.transactionId,
      oldPrice: event.oldPrice,
      oldUnit: event.oldUnit,
      newPrice: event.newPrice,
      newUnit: event.newUnit,
      slPrice: event.stopLossPrice,
      tpPrice: event.takeProfitPrice,
      periodicTransactionId: event.periodicTransactionId,
      timeInForce: event.timeInForce,
      periodEndingDate: event.periodEndingDate,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      event.successCallback('order.replace_order.${response.data['result']['successMessage']}');
    } else {
      event.errorCallback(response.error?.message ?? 'order_update_page Error');
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: L10n.tr('order.replace_order.${response.error?.message ?? ''}'),
            errorCode: '01RORD01',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onUpdateChainOrder(
    UpdateChainOrderEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _ordersRepository.updateChainOrder(
      chainNo: event.chainNo,
      transactionExtId: event.transactionExtId,
      equityName: event.equityName,
      debitCredit: event.debitCredit,
      session: event.session,
      price: event.price,
      units: event.units,
      transactionTypeName: event.transactionTypeName,
      orderValidity: event.orderValidity,
      accountExtId: event.accountExtId,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );

      event.onSuccess(
        '${response.data['transactionSuccessMessage'] ?? ''}',
      );
    } else {
      event.onFailed();
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: L10n.tr(response.error?.message ?? 'order_update_page Error'),
            errorCode: '01RORD01',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onCreateBulkOrder(
    CreateBulkOrderEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    //Suffix-Dev
    //Burada sadece Bist 100 sembolleri gelecek.
    //ALTINS1 ve GMSTRF gibi semollerin gelmesi beklenmiyor.
    //Eski kontroller bırakıldı.

    final orderList = event.list.map(
      (e) {
        final symbolCode = e['symbolCode'];
        return {
          'side': OrderActionTypeEnum.buy.value,
          'name': symbolCode == 'ALTINS1'
              ? 'ALTIN'
              : getIt<AppInfoBloc>().state.symbolSuffixList.any((a) => a.nameWithSuffix == symbolCode)
                  ? getIt<AppInfoBloc>().state.symbolSuffixList.firstWhere((a) => a.nameWithSuffix == symbolCode).name
                  : symbolCode,
          'units': e['count'],
          'price': 0,
          'orderDate': DateTimeUtils.serverDate(DateTime.now()),
          'orderSession': 0,
          'amountType': OrderTypeEnum.market.value,
          'timeInForce': OrderValidityEnum.cancelRest.value,
          'customerExtId': UserModel.instance.customerId,
          'accountExtId': event.account,
          'smsFillNotification': false,
          'emailFillNotification': false,
          'pushFillNotification': false,
          'shortfall': 0,
        };
      },
    ).toList();

    event.trackEvent?.call();
    ApiResponse response = await _ordersRepository.createBulkOrder(
      orders: orderList,
      account: event.account,
    );

    if (response.success) {
      int failedCount =
          (response.data['resultBulkOrderList'] as List).where((e) => e['errorMessage'].toString().isNotEmpty).length;

      event.callback(
        orderList.length - failedCount,
        failedCount,
      );

      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '01BORD09',
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

    final ApiResponse response = await _ordersRepository.getCollateralInfo(
      accountId: UserModel.instance.accountId,
    );

    if (response.success) {
      CollateralInfo collateralInfoModel = CollateralInfo.fromJson(response.data['collateralInfo']);
      event.callback?.call(collateralInfoModel);
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
            errorCode: '01CINF11',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetTradeLimit(
    GetTradeLimitEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse tradeLimit = await _ordersRepository.getTradeLimit(
      equityName: event.symbolName,
      accountId: event.accountId != null
          ? event.accountId!
          : state.newOrder.selectedAccount.isNotEmpty
              ? state.newOrder.selectedAccount.split('-')[1]
              : UserModel.instance.accountId,
    );

    if (tradeLimit.success) {
      event.callback?.call(tradeLimit.data['tradeLimit']);
      emit(
        state.copyWith(
          type: PageState.success,
          tradeLimit: tradeLimit.data['tradeLimit'],
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(showErrorWidget: true, message: tradeLimit.error?.message ?? '', errorCode: '01GTRD12'),
        ),
      );
    }
  }

  FutureOr<void> _onRemoveCondition(
    RemoveConditionEvent event,
    Emitter<OrdersState> emit,
  ) {
    OrderModel newest = state.newOrder.resetCondition();
    emit(
      state.copyWith(
        newOrder: newest,
        type: PageState.updated,
      ),
    );
  }

  FutureOr<void> _onReplaceUsOrder(
    ReplaceUsOrderEvent event,
    Emitter<OrdersState> emit,
  ) async {
    ApiResponse response = await _ordersRepository.replaceUsOrder(
      id: event.id,
      qty: event.qty,
      price: event.price,
      stopPrice: event.stopPrice,
      trail: event.trail,
      tpPrice: event.tpPrice,
      slPrice: event.slPrice,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      event.callback?.call(true, null);
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: false,
            message: response.error?.message ?? '',
            errorCode: '01GORD12',
          ),
        ),
      );
      event.callback?.call(false, 'american.update.order.${response.dioResponse?.data['errorCode']}');
    }
  }

  FutureOr<void> _onDeleteUsOrder(
    DeleteUsOrderEvent event,
    Emitter<OrdersState> emit,
  ) async {
    ApiResponse response = await _ordersRepository.deleteUsOrder(
      id: event.id,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      event.callback?.call(true, null);
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: false,
            message: response.error?.message ?? '',
            errorCode: '01GORD13',
          ),
        ),
      );
      event.callback?.call(false, 'american.delete.order.${response.dioResponse?.data['errorCode']}');
    }
  }

  FutureOr<void> _onGetPeriodicOrders(
    GetPeriodicOrdersEvent event,
    Emitter<OrdersState> emit,
  ) async {
    ApiResponse response = await _ordersRepository.getPeriodicOrders(
      accountId: event.accountId,
    );

    List<dynamic>? orderList;

    if (response.success && response.data['periodicOrderList'] != null) {
      orderList = response.data['periodicOrderList'];
    }

    if (orderList?.isNotEmpty == true) {
      Map<String, dynamic>? matchedOrder = orderList!.whereType<Map<String, dynamic>>().firstWhere(
            (order) => order['orderReferance']?.toString() == event.transactionExidId,
            orElse: () => {},
          );
      final String? strPeriodEndDate = matchedOrder['periodEndDate']?.toString();
      if (strPeriodEndDate?.isNotEmpty == true) {
        event.successCallback?.call(
          DateTimeUtils.fromString(strPeriodEndDate!),
        );
      }
    } else {
      event.onErrorCallBack?.call();
    }
  }
}
