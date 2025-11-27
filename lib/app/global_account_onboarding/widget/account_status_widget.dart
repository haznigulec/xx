import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/info_widget.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AccountStatusWidget extends StatelessWidget {
  final String infoText;
  final String? iconPath;
  final String description;

  const AccountStatusWidget({
    super.key,
    required this.infoText,
    this.iconPath,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: Grid.m + Grid.xxs,
        ),
        PInfoWidget(
          infoText: L10n.tr(infoText),
          textColor: context.pColorScheme.primary,
          iconPath: iconPath ?? ImagesPath.info,
        ),
        const SizedBox(
          height: Grid.s + Grid.xs,
        ),
        Text(
          description,
          style: context.pAppStyle.labelReg16textPrimary,
        ),
      ],
    );
  }
}
