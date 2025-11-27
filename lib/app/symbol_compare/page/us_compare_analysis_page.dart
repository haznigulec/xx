import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_bloc.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_state.dart';
import 'package:piapiri_v2/app/symbol_compare/compare_constants.dart';
import 'package:piapiri_v2/app/symbol_compare/widgets/compare_table_header.dart';
import 'package:piapiri_v2/app/symbol_compare/widgets/us_compare_table_item.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_listener.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class UsCompareAnalysisPage extends StatefulWidget {
  final String symbolName;
  final SymbolTypes symbolType;

  const UsCompareAnalysisPage({
    super.key,
    required this.symbolName,
    required this.symbolType,
  });

  @override
  State<UsCompareAnalysisPage> createState() => _UsCompareAnalysisPageState();
}

class _UsCompareAnalysisPageState extends State<UsCompareAnalysisPage> with AutomaticKeepAliveClientMixin {
  final SymbolChartBloc _symbolChartBloc = getIt<SymbolChartBloc>();
  final ScrollController _horizontalController = ScrollController();
  List<String> symbolList = [];
  bool _showDivider = false;

  @override
  bool get wantKeepAlive => true;

  @override
  initState() {
    super.initState();
    symbolList = [widget.symbolName];
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PBlocListener<SymbolChartBloc, SymbolChartState>(
      bloc: _symbolChartBloc,
      listenWhen: (previous, current) =>
          previous.performanceData.map((e) => e.symbolName).toList().toString() !=
          current.performanceData.map((e) => e.symbolName).toList().toString(),
      listener: (context, state) async {
        final performanceSymbols = state.performanceData.map((e) => e.symbolName).toList();

        // 1. PerformanceData’da olmayanları fundDetailModels’den çıkar
        symbolList.removeWhere(
          (usModel) => !performanceSymbols.contains(usModel),
        );

        // 2. PerformanceData’daki her item için kontrol et
        for (final perf in state.performanceData) {
          final exists = symbolList.any((usModel) => usModel == perf.symbolName);

          if (!exists) {
            symbolList.add(
              perf.symbolName,
            );
          }
        }
        setState(() {});
      },
      child: Padding(
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
                      (usModel) => UsCompareTableItem(
                        key: ValueKey(usModel),
                        symbolName: usModel,
                        onTapSymbol: (symbolName) {
                          int index = symbolList.indexWhere(
                            (element) => element == usModel,
                          );
                          symbolList.removeAt(index);
                          symbolList.insert(index, symbolName);
                          setState(() {});
                        },
                      ),
                    ),
                    if (symbolList.length < 5)
                      UsCompareTableItem(
                        symbolName: null,
                        onTapSymbol: (symbolName) {
                          setState(() {
                            if (!symbolList.any((element) => element == symbolName)) {
                              symbolList.add(symbolName);
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
    );
  }
}
