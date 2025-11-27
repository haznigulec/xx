import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/quick_portfolio_asset_model.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/symbol_chips_widget.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

//hazır portfoyler butonlar widgetı
class QuickPortfolioButtonsWidget extends StatelessWidget {
  final List<QuickPortfolioAssetModel> symbols;
  final bool? isSpecificList;
  final Function() buyButtonOnPressed;
  final String portfolioKey;
  final String? listSymbolType;
  const QuickPortfolioButtonsWidget({
    super.key,
    required this.symbols,
    this.isSpecificList = false,
    required this.buyButtonOnPressed,
    required this.portfolioKey,
    required this.listSymbolType,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (!isSpecificList!) ...[
            SizedBox(
              height: 23,
              child: PCustomOutlinedButtonWithIcon(
                text: L10n.tr('satin_al'),
                icon: const Icon(
                  Icons.arrow_outward_rounded,
                  size: Grid.m,
                ),
                foregroundColorApllyBorder: false,
                foregroundColor: context.pColorScheme.lightHigh,
                backgroundColor: context.pColorScheme.primary,
                onPressed: buyButtonOnPressed,
              ),
            ),
            const SizedBox(
              width: Grid.xs,
            ),
          ],
          Expanded(
            child: SymbolChipsWidget(
              key: ValueKey('SYMBOLCHIPS_${symbols.join(',')}'),
              symbolList: symbols.map((e) => e.code).toList(),
              symbolListType: listSymbolType,
            ),
          ),
        ],
      ),
    );
  }
}
