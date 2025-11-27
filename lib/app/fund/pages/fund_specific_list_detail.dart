import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_bloc.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_event.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_state.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/fund_special_list_model.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/specific_list_model.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/symbol_list_tile.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/table_title_widget.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

@RoutePage()
class FundSpecificListDetailPage extends StatefulWidget {
  final SpecificListModel specificListItem;
  const FundSpecificListDetailPage({
    super.key,
    required this.specificListItem,
  });

  @override
  State<FundSpecificListDetailPage> createState() => _FundSpecificListDetailPageState();
}

class _FundSpecificListDetailPageState extends State<FundSpecificListDetailPage> {
  late QuickPortfolioBloc _quickPortfolioBloc;
  @override
  void initState() {
    _quickPortfolioBloc = getIt<QuickPortfolioBloc>();

    _quickPortfolioBloc.add(
      GetFundInfoFromSpecialListByIdEvent(
        specialListId: widget.specificListItem.id.toString(),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<QuickPortfolioBloc, QuickPortfolioState>(
      bloc: _quickPortfolioBloc,
      builder: (context, state) {
        return Scaffold(
          appBar: PInnerAppBar(
            title: L10n.tr(widget.specificListItem.listName),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.specificListItem.description,
                  style: context.pAppStyle.labelReg14textPrimary,
                ),
                const SizedBox(
                  height: Grid.xs + Grid.s,
                ),
                TableTitleWidget(
                  primaryColumnTitle: '${L10n.tr('fund')} (${widget.specificListItem.symbolNames.length})',
                  secondaryColumnTitle: L10n.tr('1M'),
                  tertiaryColumnTitle: L10n.tr('price'),
                ),
                const SizedBox(
                  height: Grid.xs,
                ),
                state.isLoading || state.specificList.isEmpty
                    ? const Expanded(child: PLoading())
                    : Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: state.fundSpecialList.length,
                          separatorBuilder: (context, index) => const PDivider(),
                          itemBuilder: (context, index) {
                            FundSpecialListModel specialTile = state.fundSpecialList[index];

                            return SymbolListTile(
                              symbolName: specialTile.institutionCode,
                              symbolType: SymbolTypes.fund,
                              leadingText: specialTile.code,
                              subLeadingText: specialTile.title,
                              infoText: '%${MoneyUtils().readableMoney(specialTile.performance1M * 100)}',
                              profit: specialTile.performance1M * 100,
                              trailingText: '₺${MoneyUtils().readableMoney(
                                specialTile.price,
                              )}',
                              onTap: () {
                                router.push(
                                  FundDetailRoute(
                                    fundCode: specialTile.code,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
