import 'package:collection/collection.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/specific_list_bist_type_enum.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/diff_percentage.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_state.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class SymbolDividendCarouselWidget extends StatefulWidget {
  final List<String> incomingDividends;
  final bool enabled;
  const SymbolDividendCarouselWidget({
    required this.incomingDividends,
    required this.enabled,
    super.key,
  });


  @override
  State<SymbolDividendCarouselWidget> createState() => _SymbolDividendCarouselWidgetState();
}

class _SymbolDividendCarouselWidgetState extends State<SymbolDividendCarouselWidget> {
  late SymbolBloc _symbolBloc;
  @override
  void initState() {
    _symbolBloc = getIt<SymbolBloc>();
    if (widget.incomingDividends.isNotEmpty && widget.enabled) {
      _symbolBloc.add(
        SymbolSubTopicsEvent(
          symbols: widget.incomingDividends
              .map(
                (symbol) => MarketListModel(
                  symbolCode: symbol,
                  updateDate: '',
                ),
              )
              .toList(),
        ),
      );
    }

    super.initState();
  }

  @override
  dispose() {
    if (widget.enabled) {
      _symbolBloc.add(SymbolUnsubsubscribeEvent(
        symbolList: widget.incomingDividends
            .map(
              (symbol) => MarketListModel(
                symbolCode: symbol,
                updateDate: '',
              ),
            )
            .toList(),
      ));
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<SymbolBloc, SymbolState>(
      bloc: _symbolBloc,
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: Grid.l,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: Text(
              L10n.tr('symbol_will_be_dist_divident'),
              style: context.pAppStyle.labelMed18textPrimary,
            ),
          ),
          Container(
            height: 60,
            color: context.pColorScheme.transparent,
            alignment: Alignment.center,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: Grid.m),
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: widget.incomingDividends.length,
              separatorBuilder: (context, index) => const SizedBox(
                width: Grid.s,
              ),
              itemBuilder: (context, index) {
                String symbolName = widget.incomingDividends[index];
                MarketListModel? symbolModel = state.watchingItems.firstWhereOrNull(
                  (e) => e.symbolCode == symbolName,
                );
                return Container(
                  alignment: Alignment.center,
                  color: context.pColorScheme.transparent,
                  child: OutlinedButton(
                    style: context.pAppStyle.oulinedMediumPrimaryStyle.copyWith(
                      fixedSize: const WidgetStatePropertyAll(
                        Size.fromHeight(Grid.l + Grid.s + Grid.xs),
                      ),
                      padding: const WidgetStatePropertyAll(
                        EdgeInsets.only(
                          left: Grid.xs,
                          right: Grid.s + Grid.xs,
                        ),
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Grid.m + Grid.xxs,
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      router.push(
                        SymbolDetailRoute(
                          symbol: MarketListModel(
                            symbolCode: widget.incomingDividends[index],
                            updateDate: '',
                            type: BistType.equityBist.type,
                          ),
                          ignoreDispose: true, 
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: Grid.s - Grid.xxs,
                      children: [
                        SymbolIcon(
                          symbolName: symbolName,
                          symbolType: SymbolTypes.equity,
                          size: 28,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              symbolName,
                              style: context.pAppStyle.labelReg12textPrimary,
                            ),
                            DiffPercentage(
                              fontSize: Grid.m - Grid.xs,
                              iconSize: Grid.m - Grid.xxs,
                              percentage: symbolModel?.differencePercent ?? 0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: Grid.l,
          ),
        ],
      ),
    );
  }
}
