import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class FundReviewTileWidget extends StatelessWidget {
  final String leadingText;
  final String trailingText;
  final String? orderActionType;
  final bool? isLastDivider;

  const FundReviewTileWidget({
    super.key,
    required this.leadingText,
    required this.trailingText,
    this.orderActionType,
    this.isLastDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Grid.m,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                leadingText,
                style: context.pAppStyle.labelReg16textSecondary,
              ),
              const SizedBox(
                width: Grid.m,
              ),
              Expanded(
                child: Text(
                  trailingText,
                  textAlign: TextAlign.end,
                  style: context.pAppStyle.labelMed16textPrimary.copyWith(
                    color: orderActionType == 'B'
                        ? context.pColorScheme.success
                        : orderActionType == 'S'
                            ? context.pColorScheme.critical
                            : context.pColorScheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLastDivider!) const PDivider()
      ],
    );
  }
}
