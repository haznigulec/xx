import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AdviceEmptyWidget extends StatelessWidget {
  final String mainGroup;
  const AdviceEmptyWidget({
    super.key,
    required this.mainGroup,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Grid.s,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Grid.s + Grid.xs,
        children: [
          Text(
            L10n.tr('advice_history_description'),
            style: context.pAppStyle.labelReg14textSecondary,
          ),
          SizedBox(
            height: 30,
            child: PCustomOutlinedButtonWithIcon(
              text: L10n.tr('advices_history'),
              iconSource: ImagesPath.arrow_up_right,
              buttonType: PCustomOutlinedButtonTypes.mediumSecondary,
              foregroundColor: context.pColorScheme.primary,
              onPressed: () {
                router.push(
                  AdviceAllHistoryListRoute(
                    mainGroup: mainGroup,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
