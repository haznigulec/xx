import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_bloc.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_event.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_state.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

class UsableCollateralWidget extends StatefulWidget {
  const UsableCollateralWidget({
    super.key,
  });

  @override
  State<UsableCollateralWidget> createState() => _UsableCollateralWidgetState();
}

class _UsableCollateralWidgetState extends State<UsableCollateralWidget> {
  late OrdersBloc _ordersBloc;
  @override
  void initState() {
    _ordersBloc = getIt<OrdersBloc>();
    _ordersBloc.add(
      GetCollateralInfoEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<OrdersBloc, OrdersState>(
      bloc: _ordersBloc,
      builder: (context, state) {
        if (state.isLoading) {
          return const PLoading();
        }

        return Text(
          MoneyUtils().readableMoney(state.collateralInfo?.usableColl ?? 0),
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Colors.white,
              ),
        );
      },
    );
  }
}
