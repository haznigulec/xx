import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class SymbolPriceInfo extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final String? leadingIconPath;
  const SymbolPriceInfo({
    super.key,
    required this.label,
    required this.value,
    this.color,
    this.leadingIconPath,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: Column(
        children: [
          Text(
            label,
            style: context.pAppStyle.labelMed12textSecondary,
          ),
          const SizedBox(
            height: Grid.xxs / 2,
          ),
          Row(
            children: [
              if (leadingIconPath != null) ...[
                SvgPicture.asset(
                  leadingIconPath!,
                  width: Grid.m,
                  height: Grid.m,
                  colorFilter: ColorFilter.mode(
                    color ?? context.pColorScheme.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(
                  width: Grid.xxs,
                ),
              ],
              Text(
                value,
                style: context.pAppStyle.labelMed14textPrimary.copyWith(
                  color: color ?? context.pColorScheme.textPrimary,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
