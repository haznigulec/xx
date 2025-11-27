import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/profit/model/potential_profit_loss_model.dart';
import 'package:piapiri_v2/app/profit/widgets/potential_profit_loss_detail_list.dart';
import 'package:piapiri_v2/app/profit/widgets/profit_loss_row.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class PotentialProfitLossList extends StatelessWidget {
  final List<OverallItemGroups>? overallItemGroups;
  const PotentialProfitLossList({
    super.key,
    this.overallItemGroups,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: overallItemGroups?.length ?? 0,
      separatorBuilder: (context, index) {
        if (overallItemGroups?[index].instrumentCategory == 'cash') {
          return const SizedBox.shrink();
        }
        return const PDivider();
      },
      itemBuilder: (context, index) {
        if (overallItemGroups![index].instrumentCategory == 'cash') {
          return const SizedBox.shrink();
        }

        return InkWell(
          onTap: () {
            PBottomSheet.show(
              context,
              titlePadding: const EdgeInsets.only(
                top: Grid.m,
              ),
              titleWidgetPadding: const EdgeInsets.only(
                top: Grid.m,
              ),
              titleWidget: Column(
                spacing: Grid.m,
                children: [
                  Text(
                    L10n.tr('potential_profit_loss'),
                    style: context.pAppStyle.labelMed14textPrimary,
                  ),
                  ProfitLossRow(
                    title: L10n.tr(
                      'portfolio.${overallItemGroups![index].instrumentCategory!}',
                    ),
                    value: overallItemGroups![index].totalPotentialProfitLoss ?? 0.0,
                    hasIcon: false,
                    padding: EdgeInsets.zero,
                    fromMainTitle: ':',
                  )
                ],
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.7,
                ),
                child: PotentialProfitLossDetailList(
                  overallItemList: overallItemGroups?[index].overallItems,
                  type: overallItemGroups?[index].instrumentCategory ?? '',
                ),
              ),
            );
          },
          child: ProfitLossRow(
            title: L10n.tr(
              'portfolio.${overallItemGroups![index].instrumentCategory!}',
            ),
            value: overallItemGroups![index].totalPotentialProfitLoss ?? 0.0,
            iconName: ImagesPath.chevron_right,
          ),
        );
      },
    );
  }
}
