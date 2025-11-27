import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/fund/model/fund_financial_founder_list_model.dart';
import 'package:piapiri_v2/app/fund/widgets/fund_founders_tile.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class FundFoundersWidget extends StatelessWidget {
  final List<GetFinancialFounderListModel> institutionList;
  const FundFoundersWidget({
    super.key,
    required this.institutionList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Grid.m,
            vertical: Grid.m,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                L10n.tr(
                  'fund_founders',
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
                    FundFoundersRoute(
                      institutionList: institutionList,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(
          height: Grid.s,
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 145,
          ),
          child: ListView.builder(
            padding: const EdgeInsets.only(
              left: Grid.m,
              right: Grid.m,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: institutionList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return FundFoundersTile(
                institution: institutionList[index],
              );
            },
          ),
        ),
        const SizedBox(
          height: Grid.m,
        ),
      ],
    );
  }
}
