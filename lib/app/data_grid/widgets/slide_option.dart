import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class SlideOptions extends StatelessWidget {
  final String imagePath;
  final Color backgroundColor;
  final Color iconColor;
  final double? height;

  final Function()? onTap;

  const SlideOptions({
    super.key,
    required this.imagePath,
    required this.backgroundColor,
    required this.iconColor,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: context.pColorScheme.transparent,
      highlightColor: context.pColorScheme.transparent,
      onTap: onTap,
      child: Container(
        height: height ?? 56,
        width: (MediaQuery.of(context).size.width - (Grid.m * 4)) * .16,
        color: backgroundColor,
        child: SvgPicture.asset(
          imagePath,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(
            iconColor,
            BlendMode.srcIn,
          ),
          fit: BoxFit.none,
        ),
      ),
    );
  }
}
