import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class DepositCurrencyWidget extends StatelessWidget {
  const DepositCurrencyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CurrencyEnum> currencies =
        CurrencyEnum.values.where((e) => e == CurrencyEnum.turkishLira || e == CurrencyEnum.dollar).toList();
    return ListView.separated(
      shrinkWrap: true,
      itemCount: currencies.length,
      separatorBuilder: (context, index) => const PDivider(),
      itemBuilder: (context, index) {
        final currency = currencies[index];
        return InkWell(
          onTap: () {
            Navigator.of(context).pop(currency);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Grid.m,
            ),
            child: Text(
              L10n.tr(currency.shortName),
              style: context.pAppStyle.labelReg16textPrimary,
            ),
          ),
        );
      },
    );
  }
}
