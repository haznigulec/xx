import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_bloc.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_event.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/titled_info.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class LimitRow extends StatelessWidget {
  final double cashLimit;
  final double quantityLimit;

  const LimitRow({
    super.key,
    required this.cashLimit,
    required this.quantityLimit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            child: TitledInfo(
              title: L10n.tr('cash_limit'),
              info: MoneyUtils().readableMoney(cashLimit),
            ),
            onTap: () {
              int units = (cashLimit / getIt<OrdersBloc>().state.newOrder.price).floor();
              getIt<OrdersBloc>().add(
                UpdateOrderEvent(
                  quantity: units,
                ),
              );
            },
          ),
        ),
        Expanded(
          child: GestureDetector(
            child: TitledInfo(
              title: L10n.tr('islem_limiti'),
              info: MoneyUtils().readableMoney(quantityLimit),
            ),
            onTap: () {
              int units = (quantityLimit / getIt<OrdersBloc>().state.newOrder.price).floor();
              getIt<OrdersBloc>().add(
                UpdateOrderEvent(
                  quantity: units,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
