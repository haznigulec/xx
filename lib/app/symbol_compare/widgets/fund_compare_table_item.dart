import 'dart:async';

import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/charts/risk_bar.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_bloc.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_event.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_bloc.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_event.dart';
import 'package:piapiri_v2/app/symbol_compare/compare_constants.dart';
import 'package:piapiri_v2/app/symbol_compare/widgets/search_fund_page.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/diff_percentage.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/chart_performance_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/fund_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class FundCompareTableItem extends StatefulWidget {
  final FundDetailModel? fundDetailModel;
  final Function(FundDetailModel fund)? onTapSymbol;
  const FundCompareTableItem({
    super.key,
    this.fundDetailModel,
    this.onTapSymbol,
  });

  @override
  State<FundCompareTableItem> createState() => _FundCompareTableItemState();
}

class _FundCompareTableItemState extends State<FundCompareTableItem> {
  final FundBloc _fundBloc = getIt<FundBloc>();
  final SymbolChartBloc _symbolChartBloc = getIt<SymbolChartBloc>();
  late FundDetailModel? _fundDetailModel;
  bool _isLoading = false;


  @override
  Widget build(BuildContext context) {
    _fundDetailModel = widget.fundDetailModel;

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
              text: _fundDetailModel?.code ?? L10n.tr('select'),
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
                  title: L10n.tr('search_fund'),
                  scrollPhysics: const NeverScrollableScrollPhysics(),
                  child: SearchFundPage(
                          onTapSymbol: (symbol) {
                            setState(() {
                              _isLoading = true;
                            });

                            _fundBloc.add(
                              GetDetailEvent(
                                fundCode: symbol.name,
                                callBack: (fundDetail) async {
                                  final Completer<void> chartCompleter = Completer<void>();

                                  _symbolChartBloc.add(
                                    AddPerformanceEvent(
                                      index: widget.fundDetailModel != null
                                          ? _symbolChartBloc.state.performanceData.indexWhere(
                                              (element) => element.symbolName == widget.fundDetailModel!.code,
                                            )
                                          : null,
                                      chartPerformance: ChartPerformanceModel(
                                        symbolName: symbol.name,
                                        underlyingName: fundDetail.institutionCode,
                                        subType: fundDetail.subType,
                                        description: '${fundDetail.code} • ${fundDetail.founder}',
                                        symbolType: stringToSymbolType(
                                          symbol.typeCode,
                                        ),
                                      ),
                                      callback: (_, __) {
                                        chartCompleter.complete();
                                      },
                                    ),
                                  );
                                  await chartCompleter.future;
                                  setState(() {
                                    widget.onTapSymbol?.call(fundDetail);
                                    _isLoading = false;
                                  });
                                },
                              ),
                            );
                          },
                  ),
                );
              },
            ),
          ),
          const PDivider(),
          _cellItem(
            child: widget.fundDetailModel == null
                ? Text(
                    '-',
                    style: context.pAppStyle.labelMed14textPrimary,
                  )
                : DiffPercentage(
                    percentage: widget.fundDetailModel!.performance1M,
                    rowMainAxisAlignment: MainAxisAlignment.center,
                  ),
          ),
          const PDivider(),
          _cellItem(
            child: widget.fundDetailModel == null
                ? Text(
                    '-',
                    style: context.pAppStyle.labelMed14textPrimary,
                  )
                : DiffPercentage(
                    percentage: widget.fundDetailModel!.performance1Y,
                    rowMainAxisAlignment: MainAxisAlignment.center,
                  ),
          ),
          const PDivider(),
          _cellItem(
            child: widget.fundDetailModel == null || widget.fundDetailModel!.riskLevel == 0
                ? Text(
                    '-',
                    style: context.pAppStyle.labelMed14textPrimary,
                  )
                : RiskBar(riskLevel: widget.fundDetailModel!.riskLevel!),
          ),
          const PDivider(),
          _cellItem(
            child: Text(
              widget.fundDetailModel?.numberOfPeople.toInt().toString() ?? '-',
              style: context.pAppStyle.labelMed14textPrimary,
            ),
          ),
          const PDivider(),
          _cellItem(
            child: Text(
              widget.fundDetailModel == null
                  ? '-'
                  : '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().compactMoney(
                      widget.fundDetailModel!.portfolioSize,
                    )}',
              style: context.pAppStyle.labelMed14textPrimary,
            ),
          ),
          const PDivider(),
          _cellItem(
            child: Text(
              widget.fundDetailModel == null
                  ? '-'
                  : '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().compactMoney(
                      widget.fundDetailModel!.numberOfShares,
                    )}',
              style: context.pAppStyle.labelMed14textPrimary,
            ),
          ),
          const PDivider(),
          _cellItem(
            child: Text(
              widget.fundDetailModel == null
                  ? '-'
                  : '%${MoneyUtils().readableMoney(widget.fundDetailModel!.sellMaturity)}',
              style: context.pAppStyle.labelMed14textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cellItem({
    required Widget child,
    EdgeInsetsGeometry? padding,
    bool ignoreShimmer = false,
  }) {
    return Shimmerize(
      enabled: ignoreShimmer == true ? false : _isLoading,
      child: Container(
        height: CompareConstants().cellHeight.toDouble(),
        alignment: Alignment.center,
        padding: padding,
        child: child,
      ),
    );
  }
}
