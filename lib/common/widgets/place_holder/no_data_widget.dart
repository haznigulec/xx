import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoDataWidget extends StatelessWidget {
  final String message;
  final ThemeMode themeMode;
  final String? iconName;
  const NoDataWidget({
    super.key,
    required this.message,
    this.themeMode = ThemeMode.light,
    this.iconName,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconName ?? ImagesPath.search,
            width: 32,
          ),
          const SizedBox(
            height: Grid.m,
          ),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.pAppStyle.labelReg14textPrimary,
          ),
        ],
      ),
    );
  }
}
