import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/orders/widgets/limit_row.dart';
import 'package:piapiri_v2/app/orders/widgets/price_row.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';

class AccountsAndSymbol extends StatelessWidget {
  final List<dynamic> accounts;
  final String selectedAccount;
  final Function(String) onAccountChanged;
  final MarketListModel? symbol;
  final bool isLoading;
  final double cashLimit;
  final double tradeLimit;

  const AccountsAndSymbol({
    super.key,
    required this.accounts,
    required this.selectedAccount,
    required this.onAccountChanged,
    this.symbol,
    this.isLoading = false,
    this.cashLimit = 0,
    this.tradeLimit = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Container(
        //   color: PColor.darkLow,
        //   margin: const EdgeInsets.symmetric(horizontal: Grid.s),
        //   child: PPDropdown<String>(
        //     hasBorder: false,
        //     isExpanded: true,
        //     titleColor: Colors.white,
        //     iconColor: Colors.white,
        //     selectedValue: selectedAccount,
        //     titleTextStyle: Theme.of(context).textTheme.labelSmall,
        //     selectedWidget: Text(
        //       selectedAccount,
        //       style: const TextStyle(
        //         color: Colors.white,
        //       ),
        //     ),
        //     items: accounts
        //         .map<DropdownModel>((e) => DropdownModel(name: e['accountExtId'], value: e['accountExtId']))
        //         .toList(),
        //     onChanged: (value, _) {
        //       onAccountChanged(value);
        //     },
        //   ),
        // ),
        const SizedBox(
          height: 10,
        ),
        LimitRow(
          cashLimit: cashLimit,
          quantityLimit: tradeLimit,
        ),
        const SizedBox(
          height: 10,
        ),
        PriceRow(
          lastPrice: symbol?.last ?? symbol?.dayClose ?? 0,
          askPrice: symbol?.ask ?? 0,
          bidPrice: symbol?.bid ?? 0,
          percentage: ((symbol?.ask ?? 0) / (symbol?.dayClose ?? 1.0)) * 100 - 100,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
