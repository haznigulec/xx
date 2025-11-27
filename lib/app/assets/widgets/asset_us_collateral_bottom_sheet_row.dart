import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class AssetUsCollateralBottomSheetRow extends StatelessWidget {
  final String title;
  final String description;
  final String value;
  const AssetUsCollateralBottomSheetRow({
    super.key,
    required this.title,
    required this.description,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                textAlign: TextAlign.start,
                style: context.pAppStyle.labelMed14textPrimary,
              ),
              const SizedBox(
                height: Grid.xxs,
              ),
              Text(
                description,
                textAlign: TextAlign.start,
                style: context.pAppStyle.labelMed12textSecondary,
              ),
            ],
          ),
        ),
        const SizedBox(
          width: Grid.s,
        ),
        Text(
          value,
          textAlign: TextAlign.end,
          style: context.pAppStyle.labelMed14textPrimary,
        ),
      ],
    );
  }
}
