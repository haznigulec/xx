import 'package:collection/collection.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/extensions/string_extensions.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/diff_percentage.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/us_symbol_snapshot.dart';

class MarketCarouselAlpacaItem extends StatefulWidget {
  final String symbolName;
  final SymbolTypes symbolType;
  final CurrencyEnum currencyType;
  const MarketCarouselAlpacaItem({
    super.key,
    required this.symbolName,
    required this.symbolType,
    required this.currencyType,
  });

  @override
  State<MarketCarouselAlpacaItem> createState() => _MarketCarouselAlpacaItemState();
}

class _MarketCarouselAlpacaItemState extends State<MarketCarouselAlpacaItem> {
  final UsEquityBloc _usEquityBloc = getIt<UsEquityBloc>();
  late UsSymbolSnapshot _usSymbolSnapshot;

  @override
  initState() {
    super.initState();
    _usSymbolSnapshot =
        _usEquityBloc.state.polygonWatchingItems.firstWhereOrNull((element) => element.ticker == widget.symbolName) ??
            UsSymbolSnapshot(
              ticker: widget.symbolName,
            );
  }

  @override
  Widget build(BuildContext context) {
    return PBlocConsumer<UsEquityBloc, UsEquityState>(
        bloc: _usEquityBloc,
        listenWhen: (previous, current) {
          UsSymbolSnapshot? currenctSymbolSnapshot =
              current.polygonWatchingItems.firstWhereOrNull((element) => element.ticker == widget.symbolName);
          UsSymbolSnapshot? previousSymbolSnapshot =
              previous.polygonWatchingItems.firstWhereOrNull((element) => element.ticker == widget.symbolName);
          return currenctSymbolSnapshot != null && currenctSymbolSnapshot != previousSymbolSnapshot;
        },
        listener: (context, state) {
          UsSymbolSnapshot? newUsSymbolSnapshot =
              state.polygonWatchingItems.firstWhereOrNull((element) => element.ticker == widget.symbolName);
          if (newUsSymbolSnapshot == null) return;
          setState(() {
            _usSymbolSnapshot = newUsSymbolSnapshot;
          });
        },
        builder: (context, state) {
          double priceWidth =
              (widget.currencyType.symbol + MoneyUtils().getUsPrice(_usSymbolSnapshot)).calculateTextWidth(
            textStyle: context.pAppStyle.labelReg12textPrimary.copyWith(
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          );
          double diffPriceWidth = Grid.m +
              Grid.xxs +
              ('%${MoneyUtils().readableMoney(_usSymbolSnapshot.session?.regularTradingChangePercent ?? 0)}')
                  .calculateTextWidth(
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
                  color: _usSymbolSnapshot.session?.regularTradingChangePercent == 0
                      ? context.pColorScheme.iconPrimary.withValues(alpha: .15)
                      : (_usSymbolSnapshot.session?.regularTradingChangePercent ?? 0) > 0
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
                            '${widget.currencyType.symbol}${MoneyUtils().getUsPrice(_usSymbolSnapshot)}',
                            style: context.pAppStyle.labelReg12textPrimary,
                          ),
                          DiffPercentage(
                            percentage: _usSymbolSnapshot.session?.regularTradingChangePercent ?? 0,
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
