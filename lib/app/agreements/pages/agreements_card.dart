import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/model/agreements_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AggrementsCard extends StatelessWidget {
  final AgreementsModel reconciliation;
  final Function() onTap;
  const AggrementsCard({
    super.key,
    required this.reconciliation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String date = '';

    if (reconciliation.periodStartDate != null && reconciliation.periodStartDate!.isNotEmpty) {
      date = '$date${DateTimeUtils.dateFormat(
        DateTime.parse(
          reconciliation.periodStartDate ?? DateTime.now().toString(),
        ),
      )} - ';
    }
    if (reconciliation.periodEndDate != null && reconciliation.periodEndDate!.isNotEmpty) {
      date = date +
          DateTimeUtils.dateFormat(
            DateTime.parse(
              reconciliation.periodEndDate ?? DateTime.now().toString(),
            ),
          );
    }

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(
            Grid.s + Grid.xxs,
          ),
          child: Image.asset(
            ImagesPath.mutabakat,
            width: 40,
            scale: 1.8,
          ),
        ),
        const SizedBox(
          width: Grid.s,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '$date ${L10n.tr('dated_agreement')}',
              textAlign: TextAlign.start,
              style: context.pAppStyle.labelReg14textPrimary,
            ),
            const SizedBox(
              height: Grid.xs,
            ),
            Text(
              L10n.tr(
                reconciliation.periodId == 'daily_agreements_period_id'
                    ? 'daily_reconciliation'
                    : 'period_reconciliation',
              ),
              textAlign: TextAlign.start,
              style: context.pAppStyle.labelMed12textSecondary,
            ),
            const SizedBox(
              height: Grid.xs + Grid.xxs,
            ),
            PCustomOutlinedButtonWithIcon(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: onTap,
              text: L10n.tr('mutabakat_yap'),
              icon: SvgPicture.asset(
                ImagesPath.arrow_up_right,
                width: Grid.m,
                colorFilter: ColorFilter.mode(
                  context.pColorScheme.lightHigh,
                  BlendMode.srcIn,
                ),
              ),
              buttonType: PCustomOutlinedButtonTypes.smallPrimary,
              foregroundColorApllyBorder: false,
              backgroundColor: context.pColorScheme.primary,
              foregroundColor: context.pColorScheme.lightHigh,
            ),
          ],
        ),
      ],
    );
  }
}
