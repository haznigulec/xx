import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ConsistentEquivalence extends StatelessWidget {
  final String title;
  final String titleValue;
  final String? subTitle;
  final String? subTitleValue;
  final String? subTitle2;
  final String? subTitleValue2;
  final String? errorMessage;
  final Function(num value)? onTapSubtitle;
  final Function(num value)? onTapSubtitle2;
  final bool shimmerizesubTitle2;
  const ConsistentEquivalence({
    super.key,
    required this.title,
    required this.titleValue,
    this.subTitle,
    this.subTitleValue,
    this.subTitle2,
    this.subTitleValue2,
    this.errorMessage,
    this.onTapSubtitle,
    this.onTapSubtitle2,
    this.shimmerizesubTitle2 = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: context.pAppStyle.labelReg14textPrimary,
              ),
              const SizedBox(
                width: Grid.s,
              ),
              Text(
                titleValue,
                style: context.pAppStyle.labelMed18textPrimary.copyWith(
                  color: errorMessage != null ? context.pColorScheme.critical : context.pColorScheme.textPrimary,
                  fontSize: Grid.m + Grid.xxs,
                  height: 1,
                ),
              ),
            ],
          ),
          if (errorMessage != null) ...[
          const SizedBox(
            height: Grid.xs,
            ),
            Text(
              errorMessage ?? L10n.tr('insufficient_transaction_limit'),
              style: context.pAppStyle.labelReg12textPrimary.copyWith(
                color: context.pColorScheme.critical,
              ),
            ),
          ],
          if (subTitle != null && subTitleValue != null) ...[
            const SizedBox(
              height: Grid.m,
            ),
            InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    subTitle!,
                    style: context.pAppStyle.labelMed12textSecondary,
                  ),
                  const SizedBox(
                    width: Grid.xs,
                  ),
                  Text(
                    subTitleValue!,
                    style: context.pAppStyle.labelMed14textPrimary,
                  ),
                ],
              ),
              onTap: () {
                onTapSubtitle?.call(num.parse(subTitleValue!));
              },
            ),
          ],
          if (subTitle2 != null && subTitleValue2 != null) ...[
            const SizedBox(
              height: Grid.s,
            ),
            InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    subTitle2!,
                    style: context.pAppStyle.labelMed12textSecondary,
                  ),
                  const SizedBox(
                    width: Grid.xs,
                  ),
                  Shimmerize(
                    enabled: shimmerizesubTitle2,
                    child: Text(
                      subTitleValue2!,
                      style: context.pAppStyle.labelMed14textPrimary,
                    ),
                  ),
                ],
              ),
              onTap: () {
                onTapSubtitle2?.call(num.parse(subTitleValue2!));
              },
            ),
          ],
        ],
      ),
    );
  }
}
