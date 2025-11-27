import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class FilePickerButton extends StatelessWidget {
  final VoidCallback? onPickImage;
  final VoidCallback? onPickFile;
  final bool hasFiles;
  final bool? fromActiveTicket;

  const FilePickerButton({
    super.key,
    required this.onPickImage,
    required this.onPickFile,
    required this.hasFiles,
    this.fromActiveTicket = false,
  });

  @override
  Widget build(BuildContext context) {
    return fromActiveTicket!
        ? InkWell(
            splashColor: context.pColorScheme.transparent,
            highlightColor: context.pColorScheme.transparent,
            focusColor: context.pColorScheme.transparent,
            onTap: hasFiles
                ? null
                : () {
                    _selectionBottomSheet(
                      context: context,
                      onPickFile: onPickFile,
                      onPickImage: onPickImage,
                    );
                  },
            child: Transform.scale(
              scale: 0.4,
              child: SvgPicture.asset(
                ImagesPath.plus,
                width: 17,
                colorFilter: ColorFilter.mode(
                  hasFiles ? context.pColorScheme.iconSecondary : context.pColorScheme.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          )
        : PTextButtonWithIcon(
            padding: EdgeInsets.zero,
            contentAlignment: Alignment.centerRight,
            text: L10n.tr('report.contract.add'),
            icon: SvgPicture.asset(
              ImagesPath.plus,
              width: 17,
              colorFilter: ColorFilter.mode(
                hasFiles ? context.pColorScheme.textTeritary : context.pColorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            onPressed: hasFiles
                ? null
                : () {
                    _selectionBottomSheet(
                      context: context,
                      onPickFile: onPickFile,
                      onPickImage: onPickImage,
                    );
                  },
          );
  }
}

_selectionBottomSheet({required BuildContext context, Function()? onPickImage, Function()? onPickFile}) {
  PBottomSheet.show(
    context,
    title: L10n.tr('file_preference'),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          splashColor: context.pColorScheme.transparent,
          highlightColor: context.pColorScheme.transparent,
          focusColor: context.pColorScheme.transparent,
          onTap: onPickImage,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Grid.l,
            ),
            child: Text(
              L10n.tr('add_image'),
              style: context.pAppStyle.labelReg16textPrimary,
            ),
          ),
        ),
        const PDivider(),
        InkWell(
          splashColor: context.pColorScheme.transparent,
          highlightColor: context.pColorScheme.transparent,
          focusColor: context.pColorScheme.transparent,
          onTap: onPickFile,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Grid.l,
            ),
            child: Text(
              L10n.tr('add_file'),
              style: context.pAppStyle.labelReg16textPrimary,
            ),
          ),
        ),
      ],
    ),
  );
}
