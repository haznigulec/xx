import 'package:auto_size_text/auto_size_text.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';

class DateWidget extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback? onTap;

  const DateWidget({
    super.key,
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                ImagesPath.calendar,
                width: 15,
                height: 15,
                colorFilter: ColorFilter.mode(
                  context.pColorScheme.primary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(
                width: Grid.xs,
              ),
              Text(
                title,
                textAlign: TextAlign.left,
                style: context.pAppStyle.labelReg14textPrimary,
              ),
            ],
          ),
          const SizedBox(
            width: Grid.m,
          ),
          Expanded(
            child: Container(
              color: context.pColorScheme.transparent,
              height: Grid.xl,
              alignment: Alignment.centerRight,
              child: AutoSizeText(
                value,
                textAlign: TextAlign.right,
                style: context.pAppStyle.labelReg14textSecondary,
                maxLines: 1,
                minFontSize: Grid.s + Grid.xxs,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ),
    );
  }
}
