import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/fund/widgets/fund_founder_list_item_widget.dart';
import 'package:piapiri_v2/core/model/fund_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class FundFounderListWidget extends StatelessWidget {
  final List<FundModel> fundProfitsList;
  final String filterCategory;
  final String filterPeriod;
  final ScrollController controller;
  final double horizontalPadding;

  const FundFounderListWidget({
    super.key,
    required this.fundProfitsList,
    required this.filterCategory,
    required this.filterPeriod,
    required this.controller,
    this.horizontalPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return fundProfitsList.isEmpty
        ? Expanded(
            child: Container(
              color: context.pColorScheme.transparent,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
              ),
              child: NoDataWidget(
                message: L10n.tr(
                  'no_funds_found',
                ),
              ),
            ),
          )
        : Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
              ),
              child: ListView.separated(
                controller: controller,
                shrinkWrap: true,
                itemCount: fundProfitsList.length,
                separatorBuilder: (context, index) => const PDivider(),
                itemBuilder: (context, index) {
                  final fund = fundProfitsList[index];
                  return FundFounderListItemWidget(
                    key: ValueKey('$index${fund.code}${fund.institutionCode}'),
                    fund: fund,
                    filterCategory: filterCategory,
                    filterPeriod: filterPeriod,
                  );
                },
              ),
            ),
          );
  }
}
