import 'package:collection/collection.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/search_symbol/enum/symbol_search_filter_enum.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_bloc.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_event.dart';
import 'package:piapiri_v2/app/symbol_compare/compare_constants.dart';
import 'package:piapiri_v2/app/symbol_compare/widgets/search_us_symbol_page.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/chart_performance_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class BistCompareTableItem extends StatefulWidget {
  final String? symbol;
  final Function(String symbolName)? onTapSymbol;
  const BistCompareTableItem({
    super.key,
    this.symbol,
    this.onTapSymbol,
  });

  @override
  State<BistCompareTableItem> createState() => _BistCompareTableItemState();
}

class _BistCompareTableItemState extends State<BistCompareTableItem> {
  final SymbolChartBloc _symbolChartBloc = getIt<SymbolChartBloc>();
  final SymbolBloc _symbolBloc = getIt<SymbolBloc>();
  MarketListModel? _marketListModel;
  bool _isLoading = false;

  @override
  void initState() {
    if (widget.symbol != null) {
      _marketListModel = _symbolBloc.state.watchingItems.firstWhereOrNull((e) => e.symbolCode == widget.symbol);
      if (_marketListModel == null) {
        _symbolBloc.add(
          SymbolSubOneTopicEvent(symbol: widget.symbol!, symbolType: SymbolTypes.equity),
        );
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocConsumer<SymbolBloc, SymbolState>(
        listenWhen: (previous, current) => current.isUpdated && current.updatedSymbol.symbolCode == widget.symbol,
        listener: (context, state) {
          setState(() {
            _marketListModel = state.watchingItems.firstWhereOrNull((element) => element.symbolCode == widget.symbol) ??
                state.updatedSymbol;
          });
        },
        bloc: _symbolBloc,
        builder: (context, state) {
          return IntrinsicWidth(
            child: Column(
              children: [
                _cellItem(
                  ignoreShimmer: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: Grid.m,
                    vertical: Grid.m,
                  ),
                  child: PCustomOutlinedButtonWithIcon(
                    text: _marketListModel?.symbolCode ?? L10n.tr('select'),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    iconSource: ImagesPath.chevron_down,
                    foregroundColorApllyBorder: false,
                    foregroundColor: context.pColorScheme.primary,
                    backgroundColor: context.pColorScheme.secondary,
                    iconAlignment: IconAlignment.end,
                    onPressed: _isLoading
                        ? null
                        : () {
                            PBottomSheet.show(
                              context,
                              title: L10n.tr('search_bist'),
                              scrollPhysics: const NeverScrollableScrollPhysics(),
                              child: SearchCompareSymbolPage(
                                hintText: 'search_bist',
                                filterDbKeys: [
                                  SymbolSearchFilterEnum.equity.dbKeys!.first,
                                  SymbolSearchFilterEnum.warrant.dbKeys!.first,
                                ],
                                onTapSymbol: (symbol) async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  _symbolChartBloc.add(
                                    AddPerformanceEvent(
                                      index: _marketListModel == null
                                          ? null
                                          : _symbolChartBloc.state.performanceData.indexWhere(
                                              (element) => element.symbolName == _marketListModel!.symbolCode,
                                            ),
                                      chartPerformance: ChartPerformanceModel(
                                        symbolName: symbol.name,
                                        underlyingName: symbol.underlyingName,
                                        description: symbol.description,
                                        symbolType: stringToSymbolType(
                                          symbol.typeCode,
                                        ),
                                      ),
                                    ),
                                  );
                                  setState(() {
                                    widget.onTapSymbol?.call(symbol.name);
                                    _isLoading = false;
                                  });
                                },
                              ),
                            );
                          },
                  ),
                ),
                const PDivider(),
                _cellItem(
                  child: _marketListModel == null
                      ? Text(
                          '-',
                          style: context.pAppStyle.labelMed14textPrimary,
                        )
                      : Text(
                          '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().compactMoney((_marketListModel?.capital ?? 0) * (_marketListModel?.last ?? 0))}',
                          style: context.pAppStyle.labelMed14textPrimary,
                        ),
                ),
                const PDivider(),
                _cellItem(
                  child: _marketListModel == null
                      ? Text(
                          '-',
                          style: context.pAppStyle.labelMed14textPrimary,
                        )
                      : Text(
                          MoneyUtils().readableMoney(
                            ((_marketListModel?.last ?? 0) /
                                    ((_marketListModel?.shiftedNetProceed ?? 1) / (_marketListModel?.capital ?? 1))) /
                                1000,
                          ),
                          style: context.pAppStyle.labelMed14textPrimary,
                        ),
                ),
                const PDivider(),
                _cellItem(
                  child: _marketListModel == null
                      ? Text(
                          '-',
                          style: context.pAppStyle.labelMed14textPrimary,
                        )
                      : Text(
                          MoneyUtils().readableMoney(((_marketListModel?.capital ?? 0) *
                                  (_marketListModel?.last != 0
                                      ? _marketListModel?.last ?? 0
                                      : _marketListModel?.dayClose ?? 0)) /
                              (_marketListModel?.equity ?? 1)),
                          style: context.pAppStyle.labelMed14textPrimary,
                        ),
                ),
                const PDivider(),
                _cellItem(
                  child: _marketListModel == null
                      ? Text(
                          '-',
                          style: context.pAppStyle.labelMed14textPrimary,
                        )
                      : Text(
                          MoneyUtils().compactMoney(_marketListModel?.quantity ?? 0),
                          style: context.pAppStyle.labelMed14textPrimary,
                        ),
                ),
                const PDivider(),
                _cellItem(
                  child: _marketListModel == null
                      ? Text(
                          '-',
                          style: context.pAppStyle.labelMed14textPrimary,
                        )
                      : Text(
                          '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().compactMoney(_marketListModel?.volume ?? 0)}',
                          style: context.pAppStyle.labelMed14textPrimary,
                        ),
                ),
                const PDivider(),
                _cellItem(
                  child: _marketListModel == null
                      ? Text(
                          '-',
                          style: context.pAppStyle.labelMed14textPrimary,
                        )
                      : Text(
                          '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().compactMoney(_marketListModel?.capital ?? 0)}',
                          textAlign: TextAlign.center,
                          style: context.pAppStyle.labelMed14textPrimary,
                        ),
                ),
              ],
            ),
          );
        });
  }

  Widget _cellItem({
    required Widget child,
    EdgeInsetsGeometry? padding,
    bool ignoreShimmer = false,
  }) {
    return Shimmerize(
      enabled: !ignoreShimmer && _isLoading,
      child: Container(
        height: CompareConstants().cellHeight.toDouble(),
        width: MediaQuery.sizeOf(context).width * 0.3,
        alignment: Alignment.center,
        padding: padding,
        child: child,
      ),
    );
  }
}
