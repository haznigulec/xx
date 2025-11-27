import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_bloc.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_state.dart';
import 'package:piapiri_v2/app/symbol_compare/compare_constants.dart';
import 'package:piapiri_v2/app/symbol_compare/widgets/bist_compare_table_item.dart';
import 'package:piapiri_v2/app/symbol_compare/widgets/compare_table_header.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_listener.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class BistCompareAnalysisPage extends StatefulWidget {
  final MarketListModel symbol;
  final SymbolTypes symbolType;

  const BistCompareAnalysisPage({
    super.key,
    required this.symbol,
    required this.symbolType,
  });

  @override
  State<BistCompareAnalysisPage> createState() => _BistCompareAnalysisPageState();
}

class _BistCompareAnalysisPageState extends State<BistCompareAnalysisPage> with AutomaticKeepAliveClientMixin {
  final SymbolChartBloc _symbolChartBloc = getIt<SymbolChartBloc>();
  final SymbolBloc _symbolBloc = getIt<SymbolBloc>();
  final ScrollController _horizontalController = ScrollController();
  List<String> symbolList = [];
  bool _showDivider = false;

  @override
  bool get wantKeepAlive => true;

  @override
  initState() {
    super.initState();
    symbolList = [widget.symbol.symbolCode];

    _horizontalController.addListener(() {
      if (_horizontalController.offset > 0 && !_showDivider) {
        setState(() => _showDivider = true);
      } else if (_horizontalController.offset <= 0 && _showDivider) {
        setState(() => _showDivider = false);
      }
    });
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    _symbolBloc.add(
      SymbolUnsubsubscribeEvent(
        symbolList: symbolList
            .where((e) => e != widget.symbol.symbolCode)
            .map(
              (e) => MarketListModel(
                symbolCode: e,
                type: e.endsWith('V') ? SymbolTypes.warrant.matriks : SymbolTypes.equity.matriks,
                updateDate: '',
              ),
            )
            .toList(),
      ),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        PBlocListener<SymbolChartBloc, SymbolChartState>(
          bloc: _symbolChartBloc,
          listenWhen: (previous, current) =>
              previous.performanceData.map((e) => e.symbolName).toList().toString() !=
              current.performanceData.map((e) => e.symbolName).toList().toString(),
          listener: (context, state) async {
            final performanceSymbols = state.performanceData.map((e) => e.symbolName).toList();

            // 1. PerformanceData’da olmayanları fundDetailModels’den çıkar
            symbolList.removeWhere(
              (symbol) => !performanceSymbols.any((perf) => perf == symbol),
            );

            // 2. PerformanceData’daki her item için kontrol et
            for (final perf in state.performanceData) {
              final exists = symbolList.any((symbol) => symbol == perf.symbolName);

              if (!exists) {
                symbolList.add(
                  perf.symbolName,
                );
              }
            }
            symbolList.sort(
              (a, b) => performanceSymbols.indexOf(a).compareTo(
                    performanceSymbols.indexOf(b),
                  ),
            );
            setState(() {});
          },
          child: const SizedBox(),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: Grid.m,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Sol sabit header sütun
              CompareTableHeader(
                symbolType: widget.symbolType,
              ),

              /// Aradaki dikey ayırıcı
              if (_showDivider)
                Container(
                  height: (CompareConstants().usHeaders.length * CompareConstants().cellHeight).toDouble(),
                  width: 1, // VerticalDivider kalınlığı
                  decoration: BoxDecoration(
                    color: context.pColorScheme.line, // divider rengi
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1), // gölge rengi
                        blurRadius: 4, // yayılma
                        offset: const Offset(2, 0), // sağ tarafa gölge
                      ),
                    ],
                  ),
                ),

              /// Sağ taraf: yatay kaydırılabilir fund tabloları
              Expanded(
                child: SingleChildScrollView(
                  controller: _horizontalController,
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  child: Row(
                    children: [
                      ...symbolList.map(
                        (symbol) {
                          return BistCompareTableItem(
                            key: ValueKey(symbol),
                            symbol: symbol,
                            onTapSymbol: (newSymbol) {
                              int index = symbolList.indexWhere(
                                (element) => element == symbol,
                              );
                              symbolList.removeAt(index);
                              symbolList.insert(index, newSymbol);
                              if (symbol != widget.symbol.symbolCode) {
                                _symbolBloc.add(
                                  SymbolUnsubsubscribeEvent(
                                    symbolList: [
                                      MarketListModel(
                                        symbolCode: symbol,
                                        type: symbol.endsWith('V')
                                            ? SymbolTypes.warrant.matriks
                                            : SymbolTypes.equity.matriks,
                                        updateDate: '',
                                      )
                                    ],
                                  ),
                                );
                              }
                              setState(() {});
                            },
                          );
                        },
                      ),
                      if (symbolList.length < 5)
                        BistCompareTableItem(
                          symbol: null,
                          onTapSymbol: (symbol) {
                            setState(() {
                              if (!symbolList.any((element) => element == symbol)) {
                                symbolList.add(symbol);
                              }
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
