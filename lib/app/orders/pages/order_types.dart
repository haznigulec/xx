import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_bloc.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_event.dart';
import 'package:piapiri_v2/app/orders/orders_constants.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/order_type_enum.dart';
import 'package:piapiri_v2/core/model/order_validity_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class OrderTypes extends StatelessWidget {
  final Function(OrderTypeEnum, String) onSelectOrderType;

  const OrderTypes({
    required this.onSelectOrderType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> orderTypes = OrdersConstants().orderTypes;
    return Container(
      //color: context.pColorScheme.darkBg500,
      padding: const EdgeInsets.all(Grid.s),
      child: Column(
        children: [
          ListView.builder(
            itemCount: orderTypes.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return InkWell(
                splashColor: context.pColorScheme.transparent,
                highlightColor: context.pColorScheme.transparent,
                onTap: () {
                  getIt<OrdersBloc>().add(
                    UpdateOrderEvent(
                      selectedValidity: orderTypes[index]['value'] == OrderTypeEnum.market
                          ? OrderValidityEnum.cancelRest
                          : OrderValidityEnum.daily,
                    ),
                  );
                  onSelectOrderType(
                    orderTypes[index]['value'],
                    L10n.tr(orderTypes[index]['title']),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: Grid.m),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        L10n.tr(orderTypes[index]['title']),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18, color: Colors.white),
                      ),
                      const SizedBox(height: Grid.s),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              L10n.tr(orderTypes[index]['description']),
                              style:
                                  Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14, color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 8),
                          //const GeneralRightArrowWidget(),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
