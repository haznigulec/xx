import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/profit/model/tax_detail_model.dart';
import 'package:piapiri_v2/app/profit/widgets/completed_profit_loss_detail_list.dart';
import 'package:piapiri_v2/app/profit/widgets/profit_loss_row.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class CompletedProfitLossList extends StatelessWidget {
  final List<TaxDetails> taxDetails;
  const CompletedProfitLossList({
    super.key,
    required this.taxDetails,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: taxDetails.length,
        separatorBuilder: (context, index) {
          if (taxDetails[index].totalPrice == 0 || taxDetails[index + 1].totalPrice == 0) {
            return const SizedBox.shrink();
          }
          return const PDivider();
        },
        itemBuilder: (context, index) {
          if (taxDetails[index].totalPrice == 0) {
            return const SizedBox.shrink();
          }

          return InkWell(
            onTap: () {
              if (taxDetails[index].taxDetails == null) {
                return;
              }

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
                      L10n.tr('completed_profit_loss'),
                      style: context.pAppStyle.labelMed14textPrimary,
                    ),
                    ProfitLossRow(
                      title: L10n.tr('portfolio.${taxDetails[index].finType ?? ''}'),
                      value: taxDetails[index].totalPrice ?? 0.0,
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
                  child: CompletedProfitLossDetailList(
                    taxDetailList: taxDetails[index].taxDetails!,
                  ),
                ),
              );
            },
            child: ProfitLossRow(
              title: L10n.tr('portfolio.${taxDetails[index].finType ?? ''}'),
              value: taxDetails[index].totalPrice ?? 0.0,
              iconName: ImagesPath.chevron_right,
            ),
          );
        });
  }
}
