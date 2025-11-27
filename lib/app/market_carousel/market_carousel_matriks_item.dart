import 'package:collection/collection.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/extensions/string_extensions.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/diff_percentage.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class MarketCarouselMatriksItem extends StatefulWidget {
  final String symbolName;
  final SymbolTypes symbolType;
  final CurrencyEnum currencyType;
  const MarketCarouselMatriksItem({
    super.key,
    required this.symbolName,
    required this.symbolType,
    required this.currencyType,
  });

  @override
  State<MarketCarouselMatriksItem> createState() => _MarketCarouselMatriksItemState();
}

class _MarketCarouselMatriksItemState extends State<MarketCarouselMatriksItem> {
  final SymbolBloc _symbolBloc = getIt<SymbolBloc>();
  late MarketListModel _marketListModel;

  @override
  initState() {
    _marketListModel =
        _symbolBloc.state.watchingItems.firstWhereOrNull((element) => element.symbolCode == widget.symbolName) ??
            MarketListModel(symbolCode: widget.symbolName, updateDate: '', type: widget.symbolType.dbKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocConsumer<SymbolBloc, SymbolState>(
        bloc: _symbolBloc,
        listenWhen: (previous, current) => current.isUpdated && current.updatedSymbol.symbolCode == widget.symbolName,
        listener: (context, state) {
          setState(() {
            _marketListModel =
                state.watchingItems.firstWhereOrNull((element) => element.symbolCode == widget.symbolName) ??
                    state.updatedSymbol;
          });
        },
        builder: (context, state) {
          double price = MoneyUtils().getPrice(_marketListModel, null);
          double priceWidth = (widget.currencyType.symbol + MoneyUtils().readableMoney(price)).calculateTextWidth(
            textStyle: context.pAppStyle.labelReg12textPrimary.copyWith(
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          );
          double diffPriceWidth = Grid.m +
              Grid.xxs +
              ('%${MoneyUtils().readableMoney(_marketListModel.differencePercent)}').calculateTextWidth(
                textStyle: context.pAppStyle.labelReg12textPrimary.copyWith(
                  fontFeatures: [const FontFeature.tabularFigures()],
                ),
              );
          return IntrinsicWidth(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Grid.xs),
              child: Container(
                padding: const EdgeInsets.all(Grid.xs),
                decoration: BoxDecoration(
                  color: _marketListModel.differencePercent == 0
                      ? context.pColorScheme.iconPrimary.withValues(alpha: .15)
                      : _marketListModel.differencePercent > 0
                          ? context.pColorScheme.success.withValues(alpha: .15)
                          : context.pColorScheme.critical.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    SymbolIcon(
                      symbolName: widget.symbolName,
                      symbolType: widget.symbolType,
                      size: 28,
                    ),
                    const SizedBox(
                      width: Grid.s,
                    ),
                    const Spacer(),
                    SizedBox(
                      width: priceWidth > diffPriceWidth ? priceWidth : diffPriceWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${widget.currencyType.symbol}${MoneyUtils().readableMoney(price)}',
                            style: context.pAppStyle.labelReg12textPrimary,
                          ),
                          DiffPercentage(
                            percentage: _marketListModel.differencePercent,
                            fontSize: Grid.l / 2,
                            iconSize: Grid.m - Grid.xxs,
                            rowMainAxisAlignment: MainAxisAlignment.end,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: Grid.s,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
