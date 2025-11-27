import 'package:collection/collection.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/diff_percentage.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/us_symbol_snapshot.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

class UsSymbolDividendCarouselWidget extends StatefulWidget {
  final String title;
  final List<String> symbolList;
  final EdgeInsetsGeometry padding;
  final bool showAllButton;
  const UsSymbolDividendCarouselWidget({
    super.key,
    required this.title,
    required this.symbolList,
    this.padding = const EdgeInsets.symmetric(horizontal: Grid.m),
    this.showAllButton = true,
  });


  @override
  State<UsSymbolDividendCarouselWidget> createState() => _UsSymbolDividendCarouselWidgetState();
}

class _UsSymbolDividendCarouselWidgetState extends State<UsSymbolDividendCarouselWidget> {
  final UsEquityBloc _usEquityBloc = getIt<UsEquityBloc>();
  List<UsSymbolSnapshot> _symbolList = [];
  List<String> _ignoreSubscription = [];
  bool _isLoading = true;

  @override
  void initState() {
    if (widget.symbolList.isNotEmpty) {      
    _usEquityBloc.add(
      SubscribeSymbolEvent(
        symbolName: widget.symbolList,
          callback: (symbols, alreadySubscribedList) {
          _symbolList = symbols;
            _ignoreSubscription = alreadySubscribedList;
          _isLoading = false;
        },
      ),
    );
    }

    super.initState();
  }


  @override
  dispose() {
    _usEquityBloc.add(
      UnsubscribeSymbolEvent(
        symbolName: _symbolList.where((e) => !_ignoreSubscription.contains(e.ticker)).map((e) => e.ticker).toList(),
      ),
    );
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<UsEquityBloc, UsEquityState>(
      bloc: _usEquityBloc,
      builder: (context, state) {
        if (_symbolList.isEmpty || _isLoading) {
          return const Padding(
            padding: EdgeInsets.only(
              top: Grid.l,
            ),
            child: PLoading(),
          );
        }
        return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Padding(
              padding: widget.padding,
            child: Text(
                widget.title,
              style: context.pAppStyle.labelMed18textPrimary,
            ),
          ),
          Container(
            height: 60,
            color: context.pColorScheme.transparent,
            alignment: Alignment.center,
            child: NotificationListener<ScrollNotification>(
              child: ListView.separated(
                  padding: widget.padding,
                physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                itemCount: _symbolList.length,
                separatorBuilder: (context, index) => const SizedBox(
                  width: Grid.s,
                ),
                itemBuilder: (context, index) {
                    UsSymbolSnapshot usSymbol = state.polygonWatchingItems.firstWhereOrNull(
                          (e) => e.ticker == _symbolList[index].ticker,
                      ) ??
                      _symbolList[index];
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
                          SymbolUsDetailRoute(
                              symbolName: usSymbol.ticker,
                              ignoreUnsubscribeSymbols: true,
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: Grid.s - Grid.xxs,
                        children: [
                          SymbolIcon(
                              symbolName: usSymbol.ticker,
                            symbolType: SymbolTypes.foreign,
                            size: 28,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  usSymbol.ticker,
                                style: context.pAppStyle.labelReg12textPrimary,
                              ),
                                DiffPercentage(
                                    fontSize: Grid.m - Grid.xs,
                                    iconSize: Grid.m - Grid.xxs,
                                  percentage: usSymbol.session?.regularTradingChangePercent ?? 0.0,
                                )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
            if (widget.showAllButton) 
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: PCustomOutlinedButtonWithIcon(
              text: L10n.tr('show_all_dividends'),
              iconSource: ImagesPath.arrow_up_right,
              buttonType: PCustomOutlinedButtonTypes.mediumSecondary,
              onPressed: () {
                  router.push(
                  UsDividendRoute(
                    symbolList: state.allIncomingDividends.isNotEmpty
                        ? state.allIncomingDividends
                        : state.favoriteIncomingDividends,
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: Grid.l,
          ),
        ],
        );
      },
    );
  }
}
