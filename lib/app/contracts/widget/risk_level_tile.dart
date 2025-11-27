import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class RiskLevelTile extends StatelessWidget {
  final dynamic suitableRisk;
  final bool status;

  const RiskLevelTile({
    super.key,
    required this.suitableRisk,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Grid.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              status
                  ? statusIcon(
                      backgroundColor: context.pColorScheme.secondary,
                      imagePath: ImagesPath.check,
                      iconColor: context.pColorScheme.primary,
                    )
                  : statusIcon(
                      backgroundColor: context.pColorScheme.stroke,
                      imagePath: ImagesPath.x,
                      iconColor: context.pColorScheme.critical,
                    ),
              const SizedBox(
                width: Grid.s,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      suitableRisk['riskName']!,
                      style: context.pAppStyle.labelReg16textPrimary,
                    ),
                    const SizedBox(height: Grid.s),
                    Text(
                      suitableRisk['description']!,
                      style: context.pAppStyle.labelReg14textPrimary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget statusIcon({
  required Color backgroundColor,
  required String imagePath,
  required Color iconColor,
}) {
  return Container(
    width: Grid.l,
    height: Grid.l,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: backgroundColor,
    ),
    child: Center(
      child: SvgPicture.asset(
        width: Grid.s + Grid.xs,
        imagePath,
        colorFilter: ColorFilter.mode(
          iconColor,
          BlendMode.srcIn,
        ),
      ),
    ),
  );
}
