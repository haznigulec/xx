import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_bloc.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_event.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_bloc.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_state.dart';
import 'package:piapiri_v2/app/symbol_compare/compare_constants.dart';
import 'package:piapiri_v2/app/symbol_compare/widgets/compare_table_header.dart';
import 'package:piapiri_v2/app/symbol_compare/widgets/fund_compare_table_item.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_listener.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/fund_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class FundCompareAnalysisPage extends StatefulWidget {
  final FundDetailModel fundDetailModel;
  final SymbolTypes symbolType;

  const FundCompareAnalysisPage({
    super.key,
    required this.fundDetailModel,
    required this.symbolType,
  });

  @override
  State<FundCompareAnalysisPage> createState() => _FundCompareAnalysisPageState();
}

class _FundCompareAnalysisPageState extends State<FundCompareAnalysisPage> with AutomaticKeepAliveClientMixin {
  final SymbolChartBloc _symbolChartBloc = getIt<SymbolChartBloc>();
  final FundBloc _fundBloc = getIt<FundBloc>();
  final ScrollController _horizontalController = ScrollController();
  List<FundDetailModel> fundDetailModels = [];
  bool _showDivider = false;

  @override
  bool get wantKeepAlive => true;

  @override
  initState() {
    super.initState();
    fundDetailModels = [widget.fundDetailModel];
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
      listener: (context, state) {
        final performanceSymbols = state.performanceData.map((e) => e.symbolName).toList();

        // 1. PerformanceData’da olmayanları fundDetailModels’den çıkar
        fundDetailModels.removeWhere(
          (fund) => !performanceSymbols.contains(fund.code),
        );

        // 2. PerformanceData’daki her item için kontrol et
        for (final perf in state.performanceData) {
          final exists = fundDetailModels.any((fund) => fund.code == perf.symbolName);

          if (!exists) {
            // Detay çekilecek
            _fundBloc.add(
              GetDetailEvent(
                fundCode: perf.symbolName,
                callBack: (fundDetail) {
                  setState(() {
                    int index = fundDetailModels.indexWhere(
                      (element) => element.code == fundDetail.code,
                    );
                    if (index == -1) {
                      fundDetailModels.add(fundDetail);
                    } else {
                      fundDetailModels.removeAt(index);
                      fundDetailModels.insert(index, fundDetail);
                    }
                    // 3. Sıralamayı performanceData’ya göre yeniden düzenle
                    fundDetailModels.sort(
                        (a, b) => performanceSymbols.indexOf(a.code).compareTo(performanceSymbols.indexOf(b.code)));
                  });
                },
              ),
            );
          }
        }

        // Eğer hiç yeni ekleme yoksa bile mevcut listeyi sıralayalım
        setState(() {
          fundDetailModels
              .sort((a, b) => performanceSymbols.indexOf(a.code).compareTo(performanceSymbols.indexOf(b.code)));
        });
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
                height: (CompareConstants().fundHeaders.length * CompareConstants().cellHeight).toDouble(),
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
                    ...fundDetailModels.map(
                      (fundDetailModel) => FundCompareTableItem(
                        fundDetailModel: fundDetailModel,
                        onTapSymbol: (fund) {
                          setState(() {
                            int index = fundDetailModels.indexWhere(
                              (element) => element.code == fundDetailModel.code,
                            );
                            fundDetailModels.removeAt(index);
                            fundDetailModels.insert(index, fund);
                          });
                        },
                      ),
                    ),
                    if (fundDetailModels.length < 5)
                      FundCompareTableItem(
                        onTapSymbol: (fund) {
                          setState(() {
                            if (!fundDetailModels.any((element) => element.code == fund.code)) {
                              fundDetailModels.add(fund);
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
