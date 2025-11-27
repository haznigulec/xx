import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/model/symbol_type_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class OrdersListHeaderButtons extends StatelessWidget {
  final SymbolTypeEnum selectedSymbolType;
  final Function(SymbolTypeEnum) onTapSymbolType;
  final List<String> accountNames;
  final String selectedAccount;
  final Function(String) onTapAccount;
  const OrdersListHeaderButtons({
    super.key,
    required this.selectedSymbolType,
    required this.onTapSymbolType,
    required this.accountNames,
    required this.selectedAccount,
    required this.onTapAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        PCustomOutlinedButtonWithIcon(
          text: L10n.tr(selectedSymbolType.name == 'all' ? 'allOrders' : selectedSymbolType.name),
          iconSource: ImagesPath.chevron_down,
          onPressed: () {
            PBottomSheet.show(
              context,
              title: L10n.tr('stock_exchanges'),
              child: ListView.separated(
                itemCount: SymbolTypeEnum.values.length,
                shrinkWrap: true,
                separatorBuilder: (context, index) => const PDivider(),
                itemBuilder: (context, index) {
                  final exchange = SymbolTypeEnum.values[index];
                  return BottomsheetSelectTile(
                    title: L10n.tr(
                      exchange.name == 'all' ? 'allOrders' : exchange.name,
                    ),
                    value: exchange,
                    isSelected: selectedSymbolType == exchange,
                    onTap: (title, value) {
                      onTapSymbolType(value);
                    },
                  );
                },
              ),
            );
          },
        ),
        const SizedBox(
          width: Grid.s,
        ),
        PCustomOutlinedButtonWithIcon(
          text: L10n.tr(selectedAccount),
          iconSource: ImagesPath.chevron_down,
          onPressed: () {
            PBottomSheet.show(
              context,
              title: L10n.tr('stock_exchanges'),
              child: Column(
                children: accountNames.map((account) {
                  return BottomsheetSelectTile(
                    title: L10n.tr(
                      account,
                    ),
                    value: account,
                    isSelected: selectedAccount == account,
                    onTap: (title, value) {
                      onTapAccount(value);
                    },
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}
