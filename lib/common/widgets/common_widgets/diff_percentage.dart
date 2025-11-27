import 'package:auto_size_text/auto_size_text.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:p_core/extensions/string_extensions.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';

class DiffPercentage extends StatelessWidget {
  final double percentage;
  final Color? color;
  final double? fontSize;
  final double? iconSize;
  final MainAxisAlignment rowMainAxisAlignment;
  const DiffPercentage({
    super.key,
    required this.percentage,
    this.color,
    this.fontSize,
    this.iconSize,
    this.rowMainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: rowMainAxisAlignment,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          percentage == 0
              ? ImagesPath.trending_notr
              : percentage < 0
                  ? ImagesPath.trending_down
                  : ImagesPath.trending_up,
          width: iconSize ?? Grid.m,
          height: iconSize ?? Grid.m,
          colorFilter: ColorFilter.mode(
              color ??
                  (percentage == 0
                      ? context.pColorScheme.iconPrimary
                      : percentage < 0
                          ? context.pColorScheme.critical
                          : context.pColorScheme.success),
              BlendMode.srcIn),
        ),
        const SizedBox(
          width: Grid.xxs,
        ),
        Text(
          MoneyUtils().ratioFormat(percentage).formatNegativePriceAndPercentage(),
          style: context.pAppStyle.interMediumBase.copyWith(
            fontSize: fontSize ?? Grid.m - Grid.xxs,
            color: color ??
                (percentage == 0
                    ? context.pColorScheme.iconPrimary
                    : percentage < 0
                        ? context.pColorScheme.critical
                        : context.pColorScheme.success),
          ),
        ),
      ],
    );
  }
}

class DiffPercentageAutoSize extends StatelessWidget {
  final double percentage;
  final Color? color;
  final double? fontSize;
  final double minfontSize;

  final double? iconSize;
  final MainAxisAlignment rowMainAxisAlignment;
  const DiffPercentageAutoSize({
    super.key,
    required this.percentage,
    this.color,
    this.fontSize,
    required this.minfontSize,
    this.iconSize,
    this.rowMainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: rowMainAxisAlignment,
      children: [
        SvgPicture.asset(
          percentage == 0
              ? ImagesPath.trending_notr
              : percentage < 0
                  ? ImagesPath.trending_down
                  : ImagesPath.trending_up,
          width: iconSize ?? Grid.m,
          height: iconSize ?? Grid.m,
          colorFilter: ColorFilter.mode(
              color ??
                  (percentage == 0
                      ? context.pColorScheme.iconPrimary
                      : percentage < 0
                          ? context.pColorScheme.critical
                          : context.pColorScheme.success),
              BlendMode.srcIn),
        ),
        const SizedBox(
          width: Grid.xxs,
        ),
        Flexible(
          child: AutoSizeText(
            MoneyUtils().ratioFormat(percentage).formatNegativePriceAndPercentage(),
            maxLines: 1,
            minFontSize: minfontSize,
            overflow: TextOverflow.ellipsis,
            style: context.pAppStyle.interMediumBase.copyWith(
              fontSize: fontSize ?? Grid.m - Grid.xxs,
              color: color ??
                  (percentage == 0
                      ? context.pColorScheme.iconPrimary
                      : percentage < 0
                          ? context.pColorScheme.critical
                          : context.pColorScheme.success),
            ),
          ),
        ),
      ],
    );
  }
}
