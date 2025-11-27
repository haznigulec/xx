import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/data_grid/utils/column_utils.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/diff_percentage.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class GridBox extends StatefulWidget {
  final MarketListModel symbol;
  final Function(MarketListModel) onTapGrid;
  final double multiplier;

  const GridBox({
    super.key,
    required this.symbol,
    required this.onTapGrid,
    this.multiplier = 1,
  });

  @override
  State<GridBox> createState() => _GridBoxState();
}

class _GridBoxState extends State<GridBox> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: context.pColorScheme.transparent,
      highlightColor: context.pColorScheme.transparent,
      onTap: () => widget.onTapGrid(widget.symbol),
      child: Container(
        color: ColumnUtils().getGridBoxColor(context, widget.symbol.differencePercent),
        padding: const EdgeInsets.all(Grid.s),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _topWidget(),
            _bottomWidget(),
          ],
        ),
      ),
    );
  }

  TextStyle _textStyle() {
    return context.pAppStyle.interRegularBase.copyWith(
      fontSize: Grid.m - Grid.xxs,
      color: context.pColorScheme.lightHigh,
    );
  }

  Widget _topWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SymbolIcon(
              symbolName: widget.symbol.symbolCode,
              size: 28,
              symbolType: SymbolTypes.equity,
              borderWidth: 3,
            ),
            const SizedBox(width: Grid.xs),
            Text(
              widget.symbol.symbolCode,
              style: context.pAppStyle.interRegularBase.copyWith(
                fontSize: Grid.m,
                color: context.pColorScheme.lightHigh,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _bottomWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FittedBox(
                child: Text(
                  '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(MoneyUtils().getPrice(widget.symbol, null))}',
                  textAlign: TextAlign.right,
                  style: _textStyle(),
                ),
              ),
              FittedBox(
                child: DiffPercentage(
                  percentage: widget.symbol.differencePercent,
                  color: context.pColorScheme.lightHigh,
                ),
              ),
              FittedBox(
                child: Text(
                  widget.symbol.updateDate.isEmpty ? '-' : widget.symbol.updateDate,
                  textAlign: TextAlign.right,
                  style: _textStyle(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
