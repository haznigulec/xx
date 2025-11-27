import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/fund/widgets/fund_themes_widget.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class FundGroupsWidget extends StatelessWidget {
  const FundGroupsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(
            Grid.m,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                L10n.tr(
                  'fund_groups',
                ),
                style: context.pAppStyle.labelMed18textPrimary,
              ),
              PCustomPrimaryTextButton(
                margin: EdgeInsets.zero,
                text: L10n.tr(
                  'see_all',
                ),
                onPressed: () {
                  router.push(
                    const FundGroupsRoute(),
                  );
                },
              ),
            ],
          ),
        ),
        const FundThemesWidget(),
      ],
    );
  }
}
