import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_bloc.dart';
import 'package:piapiri_v2/app/orders/widgets/chain_detail_card.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_listener.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/order_status_enum.dart';
import 'package:piapiri_v2/core/model/transaction_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class OrderChainDetailsPage extends StatefulWidget {
  final TransactionModel selectedOrder;
  const OrderChainDetailsPage({super.key, required this.selectedOrder});

  @override
  State<OrderChainDetailsPage> createState() => _OrderChainDetailsPageState();
}

class _OrderChainDetailsPageState extends State<OrderChainDetailsPage> {
  final double _myWidth =
      MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first).size.width - Grid.m;

  late OrdersBloc _ordersBloc;
  int _counter = 0;
  late int _maxStep;
  final int _branchWidth = 20;
  final Map<String, bool> _expandedMap = {};
  final List<TransactionModel> _dataList = [];
  @override
  void initState() {
    _ordersBloc = getIt<OrdersBloc>();
    _dataList.addAll(
      (_ordersBloc.state.orderListMap?[OrderStatusEnum.pending]?.equityList ?? []).where(
        (element) => element.chainNo == widget.selectedOrder.chainNo,
      ),
    );

    int branchCount = _dataList.map((e) => e.parentTransactionId).toSet().toList().length - 1;
    _maxStep = (_myWidth - 280) ~/ _branchWidth;
    if (_maxStep < branchCount) {
      _counter = branchCount - _maxStep + 1;
    }
    for (TransactionModel element in _dataList) {
      _expandedMap[element.transactionId ?? ''] = element.parentTransactionId == null;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('chain_detail'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(
            Grid.s,
          ),
          child: PBlocListener(
            bloc: _ordersBloc,
            listenWhen: (PState previous, PState current) {
              return (previous.isLoading || previous.isFetching) && current.isSuccess;
            },
            listener: (context, PState state) {
              _dataList.clear();
              _dataList.addAll(
                (_ordersBloc.state.orderListMap?[OrderStatusEnum.pending]?.equityList ?? []).where(
                  (element) => element.chainNo == widget.selectedOrder.chainNo,
                ),
              );

              int branchCount = _dataList.map((e) => e.parentTransactionId).toSet().toList().length - 1;
              _maxStep = (_myWidth - 280) ~/ _branchWidth;
              if (_maxStep < branchCount) {
                _counter = branchCount - _maxStep + 1;
              }
              setState(() {});
            },
            child: SingleChildScrollView(
              child: SizedBox(
                width: _myWidth + (_counter * _branchWidth),
                child: ChainDetailCard(
                  isMainOrder: true,
                  selected: widget.selectedOrder,
                  subChainUnit: _dataList
                      .where((element) => element.parentTransactionId == widget.selectedOrder.transactionId)
                      .toList()
                      .length,
                  rightPadding: _counter <= 0 ? 0 : (_counter * _branchWidth).toDouble(),
                  symbolCode: widget.selectedOrder.symbol ?? '',
                  sideType: widget.selectedOrder.sideType ?? 0,
                  remainingUnit: widget.selectedOrder.remainingUnit ?? 0,
                  realizedUnit: widget.selectedOrder.realizedUnit ?? 0,
                  expanded: generateExpanded(
                    widget.selectedOrder,
                    _counter == 0 ? _myWidth - _branchWidth : _myWidth,
                    _counter,
                  ),
                  initExpanded: _expandedMap[widget.selectedOrder.transactionId] ?? false,
                  onTap: (bool isExpanded) {
                    _expandedMap[widget.selectedOrder.transactionId ?? ''] = isExpanded;
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget generateExpanded(
    TransactionModel selectedOrder,
    double cardWidth,
    int counter,
  ) {
    List<TransactionModel> chainList =
        _dataList.where((element) => element.parentTransactionId == selectedOrder.transactionId).toList();
    if (counter > 0) {
      counter--;
    }
    chainList.sort((a, b) => a.transactionId!.compareTo(b.transactionId!));
    return Column(
      children: [
        ...chainList.map(
          (e) => SizedBox(
            width: cardWidth + (counter * _branchWidth),
            child: ChainDetailCard(
              initExpanded: _expandedMap[e.transactionId] ?? false,
              selected: e,
              subChainUnit:
                  _dataList.where((element) => element.parentTransactionId == e.transactionId).toList().length,
              rightPadding: counter == 0 ? 0 : (counter * _branchWidth).toDouble(),
              symbolCode: e.symbol ?? '',
              sideType: e.sideType ?? 0,
              remainingUnit: e.remainingUnit ?? 0,
              realizedUnit: e.realizedUnit ?? 0,
              expanded: _dataList.any((element) => element.parentTransactionId == e.transactionId)
                  ? generateExpanded(e, counter == 0 ? cardWidth - _branchWidth : _myWidth, counter)
                  : const SizedBox(),
              onTap: (bool isExpanded) {
                _expandedMap[e.transactionId ?? ''] = isExpanded;
              },
            ),
          ),
        ),
      ],
    );
  }
}
