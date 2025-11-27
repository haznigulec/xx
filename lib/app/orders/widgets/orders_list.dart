import 'dart:async';

import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_bloc.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_event.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_state.dart';
import 'package:piapiri_v2/app/orders/widgets/order_tile.dart';
import 'package:piapiri_v2/app/orders/widgets/order_us_card.dart';
import 'package:piapiri_v2/app/orders/widgets/orders_list_header_buttons.dart';
import 'package:piapiri_v2/app/orders/widgets/shimmer_orders_list_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/order_list_model.dart';
import 'package:piapiri_v2/core/model/order_status_enum.dart';
import 'package:piapiri_v2/core/model/settings_model.dart';
import 'package:piapiri_v2/core/model/symbol_type_enum.dart';
import 'package:piapiri_v2/core/model/transaction_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class OrdersList extends StatefulWidget {
  final OrderStatusEnum orderStatus;
  final List<SettingsModel> ordersSettings;
  final bool isActive;
  final int duration;
  final String sortKey;

  const OrdersList({
    super.key,
    required this.orderStatus,
    required this.ordersSettings,
    required this.isActive,
    required this.duration,
    required this.sortKey,
  });

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  late final OrdersBloc _ordersBloc;
  SymbolTypeEnum _selectedSymbolType = SymbolTypeEnum.all;
  List<String> _accountNames = [];
  String _selectedAccount = 'tum_hesaplar';
  Timer? _periodicTimer;

  @override
  void initState() {
    _ordersBloc = getIt<OrdersBloc>();
    _accountNames = [
      'tum_hesaplar',
      ...getIt<AppInfo>().accountList.map(
            (e) => e['accountExtId'].toString(),
          ),
    ];

    _ordersBloc.add(
      GetOrdersEvent(
        account: _selectedAccount == 'tum_hesaplar' ? 'ALL' : _selectedAccount,
        symbolType: _selectedSymbolType,
        orderStatus: widget.orderStatus,
        refreshData: true,
        isLoading: true,
      ),
    );

    if (widget.duration != 0 && widget.orderStatus == OrderStatusEnum.pending) {
      _periodicTimer = _prepareTime(
        Duration(milliseconds: widget.duration),
      );
    }

    super.initState();
  }

  Timer _prepareTime(Duration duration) {
    _periodicTimer?.cancel();

    return Timer.periodic(
      duration,
      (timer) {
        _ordersBloc.add(
          GetOrdersEvent(
            account: _selectedAccount == 'tum_hesaplar' ? 'ALL' : _selectedAccount,
            symbolType: _selectedSymbolType,
            orderStatus: widget.orderStatus,
            refreshData: true,
            isLoading: false,
            invalidTokenCallBack: () {
              _periodicTimer?.cancel();
            },
          ),
        );
      },
    );
  }

  @override
  void didUpdateWidget(OrdersList oldWidget) {
    _periodicTimer?.cancel();
    if (widget.duration != oldWidget.duration) {
      if (widget.isActive) {
        _prepareTime(Duration(milliseconds: widget.duration));
      } else {
        _periodicTimer?.cancel();
      }
    }

    if (widget.orderStatus != oldWidget.orderStatus) {}
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _periodicTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: Grid.m,
        right: Grid.m,
        left: Grid.m,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrdersListHeaderButtons(
            selectedAccount: _selectedAccount,
            accountNames: _accountNames,
            selectedSymbolType: _selectedSymbolType,
            onTapSymbolType: (symbolType) {
              setState(() {
                _selectedSymbolType = symbolType;

                _ordersBloc.add(
                  GetOrdersEvent(
                    account: _selectedAccount == 'tum_hesaplar' ? 'ALL' : _selectedAccount,
                    symbolType: _selectedSymbolType,
                    orderStatus: widget.orderStatus,
                    refreshData: true,
                    isLoading: true,
                  ),
                );
                router.maybePop();
              });
            },
            onTapAccount: (account) {
              setState(() {
                _selectedAccount = account;

                _ordersBloc.add(
                  GetOrdersEvent(
                    account: _selectedAccount == 'tum_hesaplar' ? 'ALL' : _selectedAccount,
                    symbolType: _selectedSymbolType,
                    orderStatus: widget.orderStatus,
                    refreshData: true,
                    isLoading: true,
                  ),
                );
                router.maybePop();
              });
            },
          ),
          const SizedBox(
            height: Grid.s,
          ),
          PBlocBuilder<OrdersBloc, OrdersState>(
            bloc: _ordersBloc,
            builder: (context, state) {
              final OrderListModel? currentModel = state.orderListMap?[widget.orderStatus];

              if (state.orderListState == PageState.loading || currentModel == null) {
                // Hâlâ veri gelmedi veya yükleniyor, beklemeye devam
                return const Shimmerize(
                  enabled: true,
                  child: ShimmerOrdersListWidget(),
                );
              }

              List<TransactionModel> orderList = _prepareData(currentModel);

              if (widget.orderStatus == OrderStatusEnum.pending) {
                orderList = orderList
                    .where(
                      (element) =>
                          element.parentTransactionId == null ||
                          (element.parentTransactionId != null &&
                              !orderList.any(
                                (anyElement) => anyElement.transactionId == element.parentTransactionId,
                              )),
                    )
                    .toList();
              }

              if (orderList.isEmpty) {
                return Expanded(
                  child: NoDataWidget(
                    message: widget.orderStatus == OrderStatusEnum.pending
                        ? L10n.tr('no_pending_orders')
                        : widget.orderStatus == OrderStatusEnum.filled
                            ? L10n.tr('no_executed_orders')
                            : L10n.tr('no_canceled_orders'),
                    iconName: ImagesPath.telescope_on,
                  ),
                );
              }

              return Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: Grid.xl),
                  itemCount: orderList.length,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: Grid.m,
                    ),
                    child: Divider(),
                  ),
                  itemBuilder: (context, index) {
                    if (orderList[index].isAmericanStockExchangeOrder) {
                      return OrderUsCard(
                        index: index,
                        order: orderList[index],
                        orderStatus: widget.orderStatus,
                      );
                    }

                    return OrderTile(
                      index: index,
                      order: orderList[index],
                      orderStatus: widget.orderStatus,
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }

  List<TransactionModel> _prepareData(
    OrderListModel orderList,
  ) {
    switch (_selectedSymbolType) {
      case SymbolTypeEnum.eqList:
        return orderList.equityList;
      case SymbolTypeEnum.mfList:
        return orderList.fundList;
      case SymbolTypeEnum.viopList:
        return orderList.viopList;
      case SymbolTypeEnum.wrList:
        return orderList.warrantList;
      case SymbolTypeEnum.fincList:
        return orderList.fincList;
      case SymbolTypeEnum.americanStockExchangeList:
        return orderList.americanStockExchangeList;
      default:
        return orderList.equityList +
            orderList.fundList +
            orderList.viopList +
            orderList.warrantList +
            orderList.fincList +
            orderList.americanStockExchangeList;
    }
  }
}
