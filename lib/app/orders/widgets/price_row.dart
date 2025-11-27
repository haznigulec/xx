import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_bloc.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_event.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/titled_info.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class PriceRow extends StatefulWidget {
  final double lastPrice;
  final double askPrice;
  final double bidPrice;
  final double percentage;
  const PriceRow({
    super.key,
    required this.lastPrice,
    required this.askPrice,
    required this.bidPrice,
    required this.percentage,
  });

  @override
  State<PriceRow> createState() => _PriceRowState();
}

class _PriceRowState extends State<PriceRow> {
  late bool _isAskPriceNegative;
  late bool _isBidPriceNegative;

  @override
  void initState() {
    _isAskPriceNegative = double.parse(widget.percentage.isNaN ? '0' : widget.percentage.toStringAsFixed(2)).isNegative;
    _isBidPriceNegative = double.parse(widget.percentage.isNaN ? '0' : widget.percentage.toStringAsFixed(2)).isNegative;
    super.initState();
  }

  @override
  void didUpdateWidget(PriceRow oldWidget) {
    if (oldWidget.askPrice != widget.askPrice) {
      setState(() {
        _isAskPriceNegative = widget.askPrice < oldWidget.askPrice;
      });
    }
    if (oldWidget.bidPrice != widget.bidPrice) {
      setState(() {
        _isBidPriceNegative = widget.bidPrice < oldWidget.bidPrice;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    bool isAskBidZero = widget.askPrice == 0 && widget.bidPrice == 0;
    return Row(
      children: [
        if (isAskBidZero)
          Expanded(
            child: GestureDetector(
              child: TitledInfo(
                title: L10n.tr('son_fiyat'),
                info: widget.lastPrice == 0 ? '-' : MoneyUtils().readableMoney(widget.lastPrice),
              ),
              onTap: () {
                getIt<OrdersBloc>().add(
                  UpdateOrderEvent(
                    price: widget.lastPrice,
                  ),
                );
              },
            ),
          ),
        Expanded(
          child: GestureDetector(
            child: TitledInfo(
              title: L10n.tr('alis'),
              info: widget.bidPrice == 0 ? '-' : MoneyUtils().readableMoney(widget.bidPrice),
              showArrow: widget.bidPrice != 0,
              isNegative: _isBidPriceNegative,
            ),
            onTap: () {
              getIt<OrdersBloc>().add(
                UpdateOrderEvent(
                  price: widget.bidPrice,
                ),
              );
            },
          ),
        ),
        Expanded(
          child: GestureDetector(
            child: TitledInfo(
              title: L10n.tr('satis'),
              info: widget.askPrice == 0 ? '-' : MoneyUtils().readableMoney(widget.askPrice),
              showArrow: widget.askPrice != 0,
              isNegative: _isAskPriceNegative,
            ),
            onTap: () {
              getIt<OrdersBloc>().add(
                UpdateOrderEvent(
                  price: widget.askPrice,
                ),
              );
            },
          ),
        ),
        if (!isAskBidZero)
          Expanded(
            child: TitledInfo(
              title: '%${L10n.tr('fark')}',
              info: widget.percentage.isNaN ? '-' : widget.percentage.toStringAsFixed(2),
              isPercentage: !widget.percentage.isNaN,
              showArrow: true,
              isNegative: double.parse(widget.percentage.isNaN ? '0' : widget.percentage.toStringAsFixed(2)).isNegative,
            ),
          ),
      ],
    );
  }
}
