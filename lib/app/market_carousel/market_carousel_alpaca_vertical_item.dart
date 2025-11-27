import 'package:collection/collection.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/ink_wrapper.dart';
import 'package:flutter/material.dart';
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

class MarketCarouselAlpacaVerticalItem extends StatefulWidget {
  final String symbolName;
  final SymbolTypes symbolType;
  final CurrencyEnum currencyType;
  final Duration fadeDuration;
  final Function()? onTap;

  const MarketCarouselAlpacaVerticalItem({
    super.key,
    required this.symbolName,
    required this.symbolType,
    required this.currencyType,
    required this.fadeDuration,
    required this.onTap,
  });

  @override
  State<MarketCarouselAlpacaVerticalItem> createState() =>
      _MarketCarouselAlpacaVerticalItemState();
}

class _MarketCarouselAlpacaVerticalItemState
    extends State<MarketCarouselAlpacaVerticalItem> {
  final UsEquityBloc _usEquityBloc = getIt<UsEquityBloc>();
  late UsSymbolSnapshot _usSymbolSnapshot;

  @override
  initState() {
    super.initState();
    _usSymbolSnapshot = _usEquityBloc.state.polygonWatchingItems
            .firstWhereOrNull(
                (element) => element.ticker == widget.symbolName) ??
        UsSymbolSnapshot(
          ticker: widget.symbolName,
        );
  }

  @override
  Widget build(BuildContext context) {
    return PBlocConsumer<UsEquityBloc, UsEquityState>(
      bloc: _usEquityBloc,
      listenWhen: (previous, current) {
        UsSymbolSnapshot? currenctSymbolSnapshot = current.polygonWatchingItems
            .firstWhereOrNull((element) => element.ticker == widget.symbolName);
        UsSymbolSnapshot? previousSymbolSnapshot = previous.polygonWatchingItems
            .firstWhereOrNull((element) => element.ticker == widget.symbolName);
        return currenctSymbolSnapshot != null &&
            currenctSymbolSnapshot != previousSymbolSnapshot;
      },
      listener: (context, state) {
        UsSymbolSnapshot? newUsSymbolSnapshot = state.polygonWatchingItems
            .firstWhereOrNull((element) => element.ticker == widget.symbolName);
        if (newUsSymbolSnapshot == null) return;
        setState(() {
          _usSymbolSnapshot = newUsSymbolSnapshot;
        });
      },
      builder: (context, state) {
        final regularTradingChangePercent =
            (_usSymbolSnapshot.session?.regularTradingChangePercent ?? 0);
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              width: Grid.m,
            ),
            const Spacer(),
            Expanded(
              flex: 6,
              child: InkWrapper(
                onTap: widget.onTap,
                child: Container(
                  height: Grid.l + Grid.m - Grid.xs,
                  padding: const EdgeInsets.all(
                    Grid.xs,
                  ),
                  decoration: BoxDecoration(
                    color: context.pColorScheme.card,
                    borderRadius: BorderRadius.circular(
                      Grid.m + Grid.xxs,
                    ),
                  ),
                  child: AnimatedSwitcher(
                    duration: widget.fadeDuration,
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: child,
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
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.symbolName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.pAppStyle.labelReg10textPrimary,
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        '${widget.currencyType.symbol}${MoneyUtils().getUsPrice(_usSymbolSnapshot)}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: context
                                            .pAppStyle.labelMed10textPrimary,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: Grid.xs,
                                    ),
                                    DiffPercentage(
                                      percentage: regularTradingChangePercent,
                                      fontSize: Grid.s + Grid.xxs,
                                      iconSize: Grid.s + Grid.xxs,
                                      rowMainAxisAlignment:
                                          MainAxisAlignment.start,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        );
      },
    );
  }
}
