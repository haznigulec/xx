import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_bloc.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_state.dart';
import 'package:piapiri_v2/app/assets/widgets/assets_list.dart';
import 'package:piapiri_v2/app/assets/widgets/calculate_value.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/charts/model/stacked_bar_model.dart';
import 'package:piapiri_v2/common/widgets/charts/stacked_bar_chart.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/assets_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AggrementsInstrumentListWidget extends StatelessWidget {
  const AggrementsInstrumentListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<AssetsBloc, AssetsState>(
      bloc: getIt<AssetsBloc>(),
      builder: (context, state) {
        return state.consolidateAssetState == PageState.loading || state.agreementConsolidatedAssets == null
            ? const PLoading()
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        L10n.tr('total_asset'),
                        style: context.pAppStyle.labelReg14textSecondary,
                      ),
                      Expanded(
                        child: RichText(
                          softWrap: true,
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.visible,
                          text: TextSpan(
                            style: context.pAppStyle.labelMed14textPrimary,
                            children: [
                              TextSpan(
                                  text: '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                                    state.agreementConsolidatedAssets != null
                                        ? calculateTotalAmount(state.agreementConsolidatedAssets!.overallItemGroups)
                                        : 0,
                                  )} ',
                                  style: context.pAppStyle.labelMed14textPrimary),
                              TextSpan(
                                text: '≈${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(
                                  state.agreementConsolidatedAssets != null
                                      ? calculateTotalAmount(state.agreementConsolidatedAssets!.overallItemGroups) /
                                          (state.agreementConsolidatedAssets!.totalUsdOverall)
                                      : 0,
                                )}',
                                style: context.pAppStyle.labelMed14textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: Grid.l / 2,
                  ),
                  StackedBarChart(
                    charDataList: state.agreementConsolidatedAssets != null
                        ? _generateChartModel(context, state.agreementConsolidatedAssets!.overallItemGroups)
                        : [],
                  ),
                  const SizedBox(
                    height: Grid.l / 2,
                  ),
                  state.consolidateAssetState == PageState.loading
                      ? const PLoading()
                      : AssetsList(
                          assets: state.agreementConsolidatedAssets,
                          isFromAgreement: true,
                          isVisible: true,
                          selectedAccount: '',
                          hasViop: state.agreementViop != null,
                          hasIpo: state.ipoStatus ?? false,
                        ),
                ],
              );
      },
    );
  }
}

List<StackedBarModel> _generateChartModel(BuildContext context, List<OverallItemModel> data) {
  List<StackedBarModel> chartData = [];
  data.removeWhere((e) => e.instrumentCategory == 'viop');

  data.sort((a, b) {
    int getPriority(dynamic asset) {
      if (asset.instrumentCategory == 'cash' && asset.totalAmount != 0) return 0;
      if (asset.instrumentCategory == 'equity') return 1;
      if (asset.instrumentCategory == 'viop_collateral' && asset.totalAmount != 0) return 2;
      if (asset.instrumentCategory == 'fund') return 3;
      if ((asset.instrumentCategory == 'cash' || asset.instrumentCategory == 'viop_collateral') &&
          asset.totalAmount == 0) {
        return 99; // Listenin en sonunda olacaklar
      }
      return 5; // Diğer tüm kategoriler
    }

    return getPriority(a).compareTo(getPriority(b));
  });
  //portfolio bar color
  for (var i = 0; i < data.length; i++) {
    if (data[i].ratio.abs() != 0) {
      chartData.add(
        StackedBarModel(
          percent: data[i].ratio.abs(),
          color: context.pColorScheme.assetColors[i],
        ),
      );
    }
  }

  return chartData;
}
