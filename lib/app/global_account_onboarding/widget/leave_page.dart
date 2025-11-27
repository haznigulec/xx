import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

void toGlobalOnboardingPage(BuildContext context) {
  PBottomSheet.showError(
    context,
    isDismissible: false,
    enableDrag: false,
    content: L10n.tr('leave_page_warning'),
    showFilledButton: true,
    showOutlinedButton: true,
    filledButtonText: L10n.tr('onayla'),
    outlinedButtonText: L10n.tr('vazgec'),
    onFilledButtonPressed: () async {
      router.popUntilRouteWithName(GlobalAccountOnboardingRoute.name);
    },
    onOutlinedButtonPressed: () {
      router.maybePop();
    },
  );
}
