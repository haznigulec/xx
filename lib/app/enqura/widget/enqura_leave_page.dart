import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

Future<bool?> toEnquraOnboardingPage(
  BuildContext context, {
  String? contentText,
  String? aproveText,
  String? rejectText,
}) {
  return PBottomSheet.showError<bool?>(
    context,
    enableDrag: false,
    content: contentText ?? L10n.tr('enqura_leave_page_warning'),
    showFilledButton: true,
    showOutlinedButton: true,
    filledButtonText: aproveText ?? L10n.tr('continue_process'),
    outlinedButtonText: rejectText ?? L10n.tr('do_it_later'),
    onFilledButtonPressed: () {
      Navigator.of(context).pop(true);
    },
    onOutlinedButtonPressed: () {
      Navigator.of(context).pop(false);
    },
    outlinedOrFilledButtonBottomSpacing: Grid.m,
  );
}
