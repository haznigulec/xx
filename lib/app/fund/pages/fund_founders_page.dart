import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/fund/model/fund_financial_founder_list_model.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/common/widgets/list/p_symbol_tile.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class FundFoundersPage extends StatelessWidget {
  final List<GetFinancialFounderListModel> institutionList;
  const FundFoundersPage({
    super.key,
    required this.institutionList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('fund_founders'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Grid.m),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: institutionList.length,
            separatorBuilder: (context, index) => const PDivider(),
            itemBuilder: (context, index) => Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 64,
                  child: PSymbolTile(
                    variant: PSymbolVariant.marketMakers,
                    titleWidget: SymbolIcon(
                      size: Grid.l + Grid.xxs,
                      symbolName: institutionList[index].code.toString(),
                      symbolType: SymbolTypes.fund,
                    ),
                    title: institutionList[index].name.toString(),
                    trailingWidget: Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: Grid.m,
                      color: context.pColorScheme.iconPrimary,
                    ),
                    onTap: () => {
                      router.push(
                        FundFoundersDetailRoute(
                          institution: institutionList[index],
                        ),
                      ),
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
