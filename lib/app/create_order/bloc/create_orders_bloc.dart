import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/assets/model/collateral_info_model.dart';
import 'package:piapiri_v2/app/create_order/bloc/create_orders_event.dart';
import 'package:piapiri_v2/app/create_order/bloc/create_orders_state.dart';
import 'package:piapiri_v2/app/create_order/repository/create_orders_repository.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/bloc/time/time_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_model.dart';
import 'package:piapiri_v2/core/model/order_type_enum.dart';
import 'package:piapiri_v2/core/model/order_validity_enum.dart';
import 'package:piapiri_v2/core/model/stock_item_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class CreateOrdersBloc extends PBloc<CreateOrdersState> {
  final CreateOrdersRepository _createOrdersRepository;

  CreateOrdersBloc({required CreateOrdersRepository createOrdersRepository})
      : _createOrdersRepository = createOrdersRepository,
        super(initialState: const CreateOrdersState()) {
    on<GetTradeLimitEvent>(_onGetTradeLimit);
    on<GetPositionListEvent>(_onGetPositionList);
    on<GetDetailsOfSymbolsEvent>(_onGetDetailsOfSymbols);
    on<CreateOrderEvent>(_onCreateOrder);
    on<ClearChainOrderListEvent>(_onClearChainOrderList);
    on<AddChainListEvent>(_onAddChainList);
    on<AddChainListByIndexEvent>(_onAddChainListByIndex);
    on<UpdateChainListByIndexEvent>(_onUpdateChainListByIndex);
    on<RemoveChainListEvent>(_onRemoveChainList);
    on<CreateOptionOrderEvent>(_onCreateOptionOrder);
    on<GetSuffixEvent>(_onGetSuffix);
    on<GetCashLimitEvent>(_onGetCashLimit);
    on<GetCollateralInfoEvent>(_onGetCollateralInfo);
    on<GetViopDataEvent>(_onGetViopData);
    on<AddSubMarketContractEvent>(_onAddSubMarketContract);
    on<GetViopInitialRequirementEvent>(_onGetViopInitialRequirement);
  }

  FutureOr<void> _onGetTradeLimit(
    GetTradeLimitEvent event,
    Emitter<CreateOrdersState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse tradeLimit = await _createOrdersRepository.getTradeLimit(
      equityName: event.symbolName,
      accountId: event.accountId,
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
          error: PBlocError(
            showErrorWidget: true,
            message: tradeLimit.error?.message ?? '',
            errorCode: '01GTRD12',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetPositionList(
    GetPositionListEvent event,
    Emitter<CreateOrdersState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    String account = event.accountId;

    ApiResponse response = await _createOrdersRepository.getPositionList(
      selectedAccount: account,
    );

    if (response.success) {
      List<StockItemModel> positionList = response.data['customerStockList']
          .map<StockItemModel>(
            (e) => StockItemModel.fromJson(
              e,
            ),
          )
          .toList();
      positionList.sort((a, b) => a.name.compareTo(b.name));
      emit(
        state.copyWith(
          type: PageState.success,
          positionList: positionList,
        ),
      );
      event.callback?.call(positionList);
      add(
        GetDetailsOfSymbolsEvent(
          symbolNameList: positionList.map((e) => e.name).toList(),
        ),
      );
      emit(
        state.copyWith(
          type: PageState.success,
          positionList: positionList,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '01GPOS04',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetCashLimit(
    GetCashLimitEvent event,
    Emitter<CreateOrdersState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    final ApiResponse cashLimit = await _createOrdersRepository.getCashFlow(
      accountId: event.accountId,
    );
    if (cashLimit.success) {
      Map<String, dynamic>? todaysCashFlow = (cashLimit.data['cashFlowList'] as List).firstWhereOrNull((e) {
        return e['valueDate'].split('T')[0] == DateTimeUtils.serverDate(DateTime.now());
      });
      emit(
        state.copyWith(
          type: PageState.success,
          cashLimit: double.parse((todaysCashFlow?['cashValue'] ?? 0).toString()),
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: L10n.tr(cashLimit.error?.message ?? ''),
            errorCode: '01GACL01',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetDetailsOfSymbols(
    GetDetailsOfSymbolsEvent event,
    Emitter<CreateOrdersState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    List<MarketListModel> detailedSymbols =
        await _createOrdersRepository.getDetailsOfSymbols(symbolCodes: event.symbolNameList);
    event.callback?.call(detailedSymbols);
    emit(
      state.copyWith(
        type: PageState.success,
        positionDetailedList: detailedSymbols,
      ),
    );
  }

  FutureOr<void> _onCreateOrder(
    CreateOrderEvent event,
    Emitter<CreateOrdersState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response;

    if (event.condition != null) {
      response = await _createOrdersRepository.createConditionalOrder(
        symbolName: Utils.symbolNameWithoutSuffix(
          event.symbolName,
          event.symbolType,
          suffix: await _createOrdersRepository.getSuffix(name: event.symbolName),
        ),
        account: event.account.split('-')[1],
        units: event.unit,
        orderActionType: event.orderActionType,
        orderType: event.orderType,
        orderValidity: event.orderValidity,
        price:
            event.orderType == OrderTypeEnum.market || event.orderType == OrderTypeEnum.marketToLimit ? 0 : event.price,
        conditionSymbolCode: Utils.symbolNameWithoutSuffix(
          event.condition!.symbol.symbolCode,
          stringToSymbolType(event.condition!.symbol.type),
          suffix: await _createOrdersRepository.getSuffix(name: event.symbolName),
        ),
        conditionType: event.condition!.condition.value.toString(),
        conditionPrice: event.condition!.price,
      );
    } else {
      DateTime earliestPeriodEndDate = DateTimeUtils().checkStopLossDate(getIt<TimeBloc>().state.now ?? DateTime.now());
      DateTime periodEndDate = event.stopLossTakeProfit?.validityDate ?? DateTime.now().add(const Duration(days: 1));
      periodEndDate = DateTimeUtils().checkStopLossDate(periodEndDate);

      periodEndDate = DateTime(
        periodEndDate.year,
        periodEndDate.month,
        periodEndDate.day,
        23,
        59,
        59,
      );

      response = await _createOrdersRepository.createOrder(
        symbolName: Utils.symbolNameWithoutSuffix(
          event.symbolName,
          event.symbolType,
          suffix: await _createOrdersRepository.getSuffix(name: event.symbolName),
        ),
        quantity: event.unit.toString(),
        orderActionType: event.orderActionType.value,
        orderType: event.orderType.value,
        orderValidity: event.orderValidity.value,
        account: event.account,
        price: event.orderType == OrderTypeEnum.market || event.orderType == OrderTypeEnum.marketToLimit
            ? '0'
            : event.price.toStringAsFixed(2),
        orderCompletionType: event.orderCompletionType,
        shownQuantity: event.orderType == OrderTypeEnum.reserve ? event.shownUnit : null,
        sellLossPrice: event.stopLossTakeProfit?.stopLossPrice,
        takeProfitPrice: event.stopLossTakeProfit?.takeProfitPrice,
        periodEndDate: DateTimeUtils().isSameDay(periodEndDate, earliestPeriodEndDate) ? null : periodEndDate,
        hasStopLoss: event.stopLossTakeProfit != null,
      );
    }

    if (!response.success) {
      String errorMessage = '';

      if (response.error?.message == 'CannotSendActiveConditionalOrder' && event.condition?.price != null) {
        if (event.condition?.condition.value == 3) {
          errorMessage = L10n.tr('CannotSendActiveConditionalOrderLessThanEqual');
        } else if (event.condition?.condition.value == 2) {
          errorMessage = L10n.tr('CannotSendActiveConditionalOrderGreaterThanEqual');
        }
      }
      if (response.error?.message == 'CustomerAccounthavenotaGMSRBFContract') {
        errorMessage = 'CustomerAccounthavenotaGMSRBFContract';
      } else if (response.error?.message != null) {
        errorMessage =
            L10n.tr('${event.condition != null ? 'order.conditional_order_error.' : ''}${response.error?.message}');
      }

      event.callback(errorMessage, true);
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: false,
            message: response.error?.message ?? '',
            errorCode: '01CORD03',
          ),
        ),
      );
      return;
    } else {
      List<String> failedSymbols = [];

      if (state.chainOrderList.isNotEmpty) {
        String transactionId = event.condition?.price != null && event.condition!.price > 0
            ? response.data['result']['result']['transactionId']
            : response.data['result']['transactionId'];

        int chainNo = 0;
        for (int i = 0; i < state.chainOrderList.length; i++) {
          ChainOrderModel chainOrder = state.chainOrderList[i];
          ApiResponse chainResponse = await _createOrdersRepository.createChainOrder(
            chainOrder: chainOrder.copyWith(
              marketListModel: chainOrder.marketListModel.copyWith(
                symbolCode: Utils.symbolNameWithoutSuffix(
                  chainOrder.marketListModel.symbolCode,
                  stringToSymbolType(chainOrder.marketListModel.type),
                  suffix: await _createOrdersRepository.getSuffix(
                    name: chainOrder.marketListModel.symbolCode,
                  ),
                ),
              ),
            ),
            parentTransactionId: transactionId,
            chainNo: chainNo,
            accountId: event.account.split('-')[1],
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
        if (failedSymbols.isNotEmpty) {
          event.callback(
            L10n.tr(
              'chain_order_error',
              args: [
                '(${failedSymbols.toString().substring(1, failedSymbols.toString().length - 1)}) ${failedSymbols.length}',
              ],
            ),
            failedSymbols.isNotEmpty,
          );
        } else {
          event.callback(
            L10n.tr(response.data['result']['successMessage']),
            failedSymbols.isNotEmpty,
          );
        }
      } else {
        ///success message True donerse succes message False donerse error message donuduroruz
        ///bu ikisi haricinde bir sey dondugunde servisten gelen mesaji gosteiryoruz
        event.callback(
          L10n.tr(
            response.data['result']['successMessage'] == 'True'
                ? 'success_order'
                : response.data['result']['successMessage'] == 'False'
                    ? 'error_order'
                    : event.condition != null
                        ? 'HISSEOK'
                        : response.data['result']['successMessage'],
          ),
          failedSymbols.isNotEmpty ||
              response.data['result']?['successMessage']?.toString().toLowerCase() == false.toString().toLowerCase(),
        );
        emit(
          state.copyWith(
            type: PageState.success,
            chainOrderList: [],
          ),
        );
      }
    }
  }

  FutureOr<void> _onClearChainOrderList(
    ClearChainOrderListEvent event,
    Emitter<CreateOrdersState> emit,
  ) {
    emit(
      state.copyWith(
        chainOrderList: [],
      ),
    );
  }

  FutureOr<void> _onAddChainList(
    AddChainListEvent event,
    Emitter<CreateOrdersState> emit,
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

  FutureOr<void> _onAddChainListByIndex(
    AddChainListByIndexEvent event,
    Emitter<CreateOrdersState> emit,
  ) {
    emit(
      state.copyWith(
        type: PageState.updating,
      ),
    );

    List<ChainOrderModel> chainOrderList = List.from(state.chainOrderList);
    chainOrderList.insert(
        event.index + 1,
        ChainOrderModel(
          chainNo: 0,
          parentTransactionId: '',
          marketListModel: event.marketListModel,
          orderAction: event.orderAction,
          price: event.price,
          units: event.unit,
          orderValidity: OrderValidityEnum.daily,
          orderType: OrderTypeEnum.limit,
        ));

    emit(
      state.copyWith(
        type: PageState.updated,
        chainOrderList: chainOrderList,
      ),
    );
  }

  FutureOr<void> _onUpdateChainListByIndex(
    UpdateChainListByIndexEvent event,
    Emitter<CreateOrdersState> emit,
  ) {
    emit(
      state.copyWith(
        type: PageState.updating,
      ),
    );

    List<ChainOrderModel> chainOrderList = List.from(state.chainOrderList);

    chainOrderList[event.index] = ChainOrderModel(
      chainNo: 0,
      parentTransactionId: '',
      marketListModel: event.marketListModel,
      orderAction: event.orderAction,
      price: event.price,
      units: event.unit,
      orderValidity: OrderValidityEnum.daily,
      orderType: OrderTypeEnum.limit,
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
    Emitter<CreateOrdersState> emit,
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

  FutureOr<void> _onGetCollateralInfo(
    GetCollateralInfoEvent event,
    Emitter<CreateOrdersState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    final ApiResponse response = await _createOrdersRepository.getCollateralInfo(
      accountId: event.accountId,
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
            message: L10n.tr(response.error?.message ?? ''),
            errorCode: '01GCI01',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onCreateOptionOrder(
    CreateOptionOrderEvent event,
    Emitter<CreateOrdersState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    SymbolTypes symbolType = stringToSymbolType(event.symbol.type);
    String symbolName = event.symbol.symbolCode;
    ApiResponse response = await _createOrdersRepository.createViopOrder(
      accountId: event.accountId,
      orderAction: event.orderAction,
      symbolName: symbolName,
      units: event.units,
      symbolType: symbolType,
      optionOrderType: event.optionOrderType,
      orderValidity: event.orderValidity,
      price: event.price,
      validityDate: event.validityDate,
      viopSession: event.viopSession,
    );
    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      event.callback(true, response.data['successMessage'] ?? L10n.tr('order_success'));
    } else {
      event.callback(
          false, response.error?.message != null ? L10n.tr('order.viop_error.${response.error?.message}') : '');
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: false,
            message: response.error?.message != null ? L10n.tr('order.viop_error.${response.error?.message}') : '',
            errorCode: '01SNDO10',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onAddSubMarketContract(
    AddSubMarketContractEvent event,
    Emitter<CreateOrdersState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _createOrdersRepository.addSubMarketContract(
      equityName: event.equityName,
      accountId: event.accountId,
    );
    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      event.callback(response.success);
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(showErrorWidget: true, message: response.error?.message ?? '', errorCode: '01SMCA12'),
        ),
      );
    }
  }

  FutureOr<void> _onGetViopData(
    GetViopDataEvent event,
    Emitter<CreateOrdersState> emit,
  ) async {
    List<Map<String, dynamic>> multipliers = await _createOrdersRepository.getMultipliersByContract(
      contract: event.asset,
    );

    bool? multiSession = await _createOrdersRepository.getViopMultiSesison(
      name: event.asset,
    );

    num multiplier = multipliers.isNotEmpty ? multipliers.first['Multiplier'] : 1;
    event.callback(multiplier, multiSession == true);
  }

  FutureOr<void> _onGetSuffix(
    GetSuffixEvent event,
    Emitter<CreateOrdersState> emit,
  ) async {
    String suffix = await _createOrdersRepository.getSuffix(
      name: event.symbolName,
    );
    event.callback(suffix);
  }
  FutureOr<void> _onGetViopInitialRequirement(
    GetViopInitialRequirementEvent event,
    Emitter<CreateOrdersState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.fetching,
      ),
    );
    ApiResponse response = await _createOrdersRepository.getViopInitialRequirement(
      symbolName: event.symbolName,
      orderAction: event.orderAction,
      units: event.unit,
      accountId: event.accountId,
    );
    double? initialRequirements;
    if (response.success) {
      initialRequirements = response.data['initialRequirements'];
    }
    event.callback(initialRequirements);
    emit(
      state.copyWith(
        type: PageState.fetched,
      ),
    );
  }

}
