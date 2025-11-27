import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/quick_portfolio_asset_model.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/symbol_list_tile.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/diff_percentage.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/us_symbol_snapshot.dart';

//Amerikan borsası -> portfolio -> list list tile
class UsPortfolioDetailTile extends StatefulWidget {
  final UsSymbolSnapshot? symbol;
  final QuickPortfolioAssetModel item;

  const UsPortfolioDetailTile({
    super.key,
    required this.symbol,
    required this.item,
  });

  @override
  State<UsPortfolioDetailTile> createState() => _UsPortfolioDetailTileState();
}

class _UsPortfolioDetailTileState extends State<UsPortfolioDetailTile> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: context.pColorScheme.transparent,
      highlightColor: context.pColorScheme.transparent,
      focusColor: context.pColorScheme.transparent,
      onTap: () {
        router.push(
          SymbolUsDetailRoute(
            symbolName: widget.item.code,
          ),
        );
      },
      child: SymbolListTile(
        symbolName: widget.item.founderCode ?? 'UNP',
        symbolType: SymbolTypes.foreign,
        leadingText: widget.item.code,
        subLeadingText: '${widget.item.founderName}',
        infoText: '%${MoneyUtils().readableMoney(widget.item.ratio)}',
        trailingWidget: DiffPercentage(
          percentage: widget.symbol?.session?.regularTradingChangePercent ?? 0,
          iconSize: Grid.m,
          fontSize: Grid.m - Grid.xxs,
        ),

  
        onTap: () {
          router.push(
            SymbolUsDetailRoute(
              symbolName: widget.item.code,
            ),
          );
        },
      ),
    );
  }
}
