import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_bloc.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_event.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/diff_percentage.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/chart_performance_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class SymbolCompareList extends StatelessWidget {
  final List<ChartPerformanceModel> performanceData;
  const SymbolCompareList({
    super.key,
    required this.performanceData,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: performanceData.length,
      separatorBuilder: (context, index) => const PDivider(),
      itemBuilder: (context, index) {
        return Container(
          height: 64,
          alignment: Alignment.center,
          color: context.pColorScheme.transparent,
          child: Row(
            children: [
              Container(
                height: 30,
                width: 5,
                decoration: BoxDecoration(
                  color: context.pColorScheme.performanceChartColors[index],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
              ),
              const SizedBox(
                width: Grid.s,
              ),
              SymbolIcon(
                symbolName: [
                  SymbolTypes.warrant,
                  SymbolTypes.future,
                  SymbolTypes.option,
                  SymbolTypes.fund,
                ].contains(performanceData[index].symbolType)
                    ? performanceData[index].underlyingName
                    : performanceData[index].symbolName,
                symbolType: performanceData[index].symbolType,
                size: 28,
              ),
              const SizedBox(
                width: Grid.s,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      performanceData[index].symbolType == SymbolTypes.fund
                          ? performanceData[index].subType ?? performanceData[index].symbolName
                          : performanceData[index].symbolName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.pAppStyle.labelReg14textPrimary,
                    ),
                    Text(
                      performanceData[index].description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.pAppStyle.labelMed12textSecondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: Grid.xs,
              ),
              DiffPercentage(
                percentage: (performanceData[index].performance ?? 0),
              ),
              const SizedBox(
                width: Grid.xs,
              ),
              InkWell(
                onTap: () {
                  getIt<SymbolChartBloc>().add(
                    RemovePerformanceEvent(
                      symbolName: performanceData[index].symbolName,
                    ),
                  );
                },
                child: SvgPicture.asset(
                  ImagesPath.x,
                  width: 12,
                  height: 12,
                  colorFilter: ColorFilter.mode(
                    context.pColorScheme.iconPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
