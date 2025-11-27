import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_bloc.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/symbol_types.dart';

class OptionOrderContractDetail extends StatelessWidget {
  const OptionOrderContractDetail({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double dropdownWitdth = (MediaQuery.of(context).size.width - Grid.l) / 2;
    return PBlocBuilder<OrdersBloc, OrdersState>(
      bloc: getIt<OrdersBloc>(),
      builder: (context, state) {
        return ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // SlidingSegmentedControl(
            //   groupValue: state.newOptionOrder.symbolType,
            //   height: 52,
            //   backgroundColor: context.pColorScheme.darkLow,
            //   onSelected: (SymbolTypes val) {
            //     OptionOrderTypeEnum orderType = OptionOrderTypeEnum.marketToLimit;
            //     OptionOrderValidityEnum orderValidity = OptionOrderValidityEnum.daily;
            //     int quantity = 1;
            //     SettingsModel orderSendingSettings = getIt<AppInfoBloc>().state.customerSettings.profile.firstWhere(
            //           (element) => element.key == 'order_sending_settings',
            //           orElse: () => SettingsModel.decoy(),
            //         );
            //     for (var element in orderSendingSettings.children) {
            //       if (element.key == 'viop_order_sending_settings') {
            //         for (var item in element.children) {
            //           if (item.key == 'viop_order_sending_settings_default_quantity') {
            //             quantity = int.parse(item.value.toString());
            //           } else if (item.key == 'viop_order_sending_settings_default_order_type') {
            //             orderType = settingsToOptionOrderTypeEnum(viopDefaultOrderTypeValueToOrder[item.value] ?? '2');
            //           } else if (item.key == 'viop_order_sending_settings_default_validity') {
            //             orderValidity = settingsToOptionOrderValidityEnum(item.value);
            //           }
            //         }
            //       }
            //     }
            //     getIt<OrdersBloc>().add(
            //       CreateOptionOrder(
            //         symbolType: val,
            //         orderType: orderType,
            //         orderValidity: orderValidity,
            //         quantity: quantity,
            //       ),
            //     );
            //   },
            //   children: [
            //     SlidingSegmentedChild(
            //       value: SymbolTypes.future,
            //       text: Text(
            //         'VIOP',
            //         style: Theme.of(context).textTheme.titleSmall!.copyWith(
            //               color: state.newOptionOrder.symbolType == SymbolTypes.future
            //                   ? context.pColorScheme.darkHigh
            //                   : context.pColorScheme.lightLow,
            //             ),
            //       ),
            //       color: Colors.white,
            //     ),
            //     SlidingSegmentedChild(
            //       value: SymbolTypes.option,
            //       text: Text(
            //         L10n.tr('option'),
            //         style: Theme.of(context).textTheme.titleSmall!.copyWith(
            //               color: state.newOptionOrder.symbolType == SymbolTypes.option
            //                   ? context.pColorScheme.darkHigh
            //                   : context.pColorScheme.lightLow,
            //             ),
            //       ),
            //       color: Colors.white,
            //     ),
            //   ],
            // ),
            const SizedBox(
              height: Grid.s,
            ),
            Wrap(
              spacing: Grid.s,
              runSpacing: Grid.s,
              children: [
                Container(
                  width: dropdownWitdth,
                  color: context.pColorScheme.darkLow,
                  // child: PPDropdown(
                  //   title: Utils.tr('underlying_asset'),
                  //   isExpanded: true,
                  //   items: (state.newOptionOrder.symbolType == SymbolTypes.future
                  //           ? state.futureUnderlyingList
                  //           : state.optionUnderlyingList)
                  //       .map<DropdownModel>(
                  //         (e) => DropdownModel(
                  //           name: e,
                  //           value: e,
                  //         ),
                  //       )
                  //       .toList(),
                  //   onChanged: (value, _) {
                  //     getIt<OrdersBloc>().add(
                  //       UpdateOptionOrderEvent(
                  //         assetName: value,
                  //       ),
                  //     );
                  //   },
                  //   selectedWidget: Text(state.newOptionOrder.assetName, style: const TextStyle(color: Colors.white)),
                  //   selectedValue: state.newOptionOrder.assetName,
                  //   titleTextStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                  //         color: Colors.white,
                  //       ),
                  // ),
                ),
                if (state.newOptionOrder.symbolType == SymbolTypes.option) ...[
                  Container(
                    width: dropdownWitdth,
                    color: context.pColorScheme.darkLow,
                    // child: PPDropdown(
                    //   title: L10n.tr('process_type'),
                    //   isExpanded: true,
                    //   items: [
                    //     DropdownModel(
                    //       name: ProcessType.call.name.toString().toTitleCaseTr(),
                    //       value: ProcessType.call,
                    //     ),
                    //     DropdownModel(
                    //       name: ProcessType.put.name.toString().toTitleCaseTr(),
                    //       value: ProcessType.put,
                    //     ),
                    //   ],
                    //   onChanged: (value, _) {
                    //     getIt<OrdersBloc>().add(
                    //       UpdateOptionOrderEvent(
                    //         processType: value,
                    //       ),
                    //     );
                    //   },
                    //   selectedWidget: Text(
                    //     state.newOptionOrder.processType.name.toString().toTitleCaseTr(),
                    //     style: const TextStyle(color: Colors.white),
                    //   ),
                    //   selectedValue: state.newOptionOrder.processType,
                    //   titleTextStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                    //         color: Colors.white,
                    //       ),
                    // ),
                  ),
                  Container(
                    width: dropdownWitdth,
                    color: context.pColorScheme.darkLow,
                    // child: PPDropdown(
                    //   title: L10n.tr('maturity'),
                    //   isExpanded: true,
                    //   items: state.newOptionOrder.maturityDateList
                    //       .map<DropdownModel>(
                    //         (e) => DropdownModel(
                    //           name: DateTimeUtils.monthAndYear(
                    //             e,
                    //             Localizations.localeOf(context).languageCode,
                    //           ),
                    //           value: e,
                    //         ),
                    //       )
                    //       .toList(),
                    //   onChanged: (value, _) {
                    //     getIt<OrdersBloc>().add(
                    //       UpdateOptionOrderEvent(
                    //         maturityDate: value,
                    //       ),
                    //     );
                    //   },
                    //   selectedWidget: Text(
                    //     state.newOptionOrder.maturityDate.isNotEmpty
                    //         ? DateTimeUtils.monthAndYear(
                    //             state.newOptionOrder.maturityDate,
                    //             Localizations.localeOf(context).languageCode,
                    //           )
                    //         : '',
                    //     style: const TextStyle(color: Colors.white),
                    //   ),
                    //   selectedValue: state.newOptionOrder.maturityDate,
                    //   titleTextStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                    //         color: Colors.white,
                    //       ),
                    // ),
                  ),
                ],
                Container(
                  width: dropdownWitdth,
                  color: context.pColorScheme.darkLow,
                  // child: PPDropdown(
                  //   title: Utils.tr('contract'),
                  //   isExpanded: true,
                  //   items: state.newOptionOrder.contractList
                  //       .map<DropdownModel>(
                  //         (e) => DropdownModel(
                  //           name: e,
                  //           value: e,
                  //         ),
                  //       )
                  //       .toList(),
                  //   onChanged: (value, _) {
                  //     getIt<OrdersBloc>().add(
                  //       UpdateOptionOrderEvent(
                  //         contract: value,
                  //       ),
                  //     );
                  //   },
                  //   selectedWidget: Text(
                  //     state.newOptionOrder.contract,
                  //     style: const TextStyle(color: Colors.white),
                  //   ),
                  //   selectedValue: state.newOptionOrder.contract,
                  //   titleTextStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                  //         color: Colors.white,
                  //       ),
                  // ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
