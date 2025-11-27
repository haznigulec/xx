import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/chip/chip.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_bloc.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_event.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_state.dart';
import 'package:piapiri_v2/app/fund/model/fund_performance_model.dart';
import 'package:piapiri_v2/app/fund/widgets/fund_founders_widget.dart';
import 'package:piapiri_v2/app/fund/widgets/fund_groups_widget.dart';
import 'package:piapiri_v2/app/fund/widgets/shimmer_fund_founder_widget.dart';
import 'package:piapiri_v2/app/fund/widgets/shimmer_fund_group_widget.dart';
import 'package:piapiri_v2/app/fund/widgets/shimmer_fund_list.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/symbol_list_tile.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/table_title_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/diff_percentage.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/extension/string_extension.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

import '../../../core/config/router/app_router.gr.dart';

class FundPage extends StatefulWidget {
  const FundPage({super.key});

  @override
  State<FundPage> createState() => _FundPageState();
}

class _FundPageState extends State<FundPage> {
  String _selectedCategory = L10n.tr('topByPerformance');
  late final FundBloc _fundBloc;
  @override
  void initState() {
    _fundBloc = getIt<FundBloc>();
    _fundBloc.add(
      GetInstitutionsEvent(callback: (_) {}),
    );
    if (_fundBloc.state.performanceRanking == null) {
      _fundBloc.add(
        GetFundPerformanceRankingEvent(),
      );
    }
    if (_fundBloc.state.founderInfoList == null) {
      _fundBloc.add(
        GetFinancialFounderListEvent(''),
      );
    }

    if (_fundBloc.state.applicationCategories == null) {
      _fundBloc.add(
        GetFundApplicationCategoriesListEvent(),
      );
    }

    _fundBloc.add(
      GetAllFundThemesEvent(),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<FundBloc, FundState>(
      bloc: _fundBloc,
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: Grid.s,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Grid.m,
                ),
                child: Text(
                  L10n.tr('highlights'),
                  style: context.pAppStyle.interMediumBase.copyWith(
                    fontSize: Grid.m + Grid.xxs,
                  ),
                ),
              ),
              const SizedBox(
                height: Grid.s,
              ),
              SizedBox(
                height: 36,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    const SizedBox(
                      width: Grid.m,
                    ),
                    PChoiceChip(
                      label: L10n.tr('topByPerformance'),
                      selected: _selectedCategory == L10n.tr('topByPerformance'),
                      chipSize: ChipSize.medium,
                      enabled: true,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = L10n.tr('topByPerformance');
                        });
                      },
                    ),
                    const SizedBox(
                      width: Grid.xs,
                    ),
                    PChoiceChip(
                      label: L10n.tr('lowestByPerformance'),
                      selected: _selectedCategory == L10n.tr('lowestByPerformance'),
                      chipSize: ChipSize.medium,
                      enabled: true,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = L10n.tr('lowestByPerformance');
                        });
                      },
                    ),
                    const SizedBox(
                      width: Grid.xs,
                    ),
                    PChoiceChip(
                      label: L10n.tr('popular'),
                      selected: _selectedCategory == L10n.tr('withMostPeople'),
                      chipSize: ChipSize.medium,
                      enabled: true,
                      onSelected: (selected) {
                        setState(
                          () {
                            _selectedCategory = L10n.tr('withMostPeople');
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      width: Grid.xs,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: Grid.s,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Grid.m,
                ),
                child: TableTitleWidget(
                  primaryColumnTitle: L10n.tr('fund'),
                  tertiaryColumnTitle: _categoryTableTitle(_selectedCategory),
                  showTopDivider: false,
                ),
              ),
              state.performanceRanking == null
                  ? const Padding(
                      padding: EdgeInsets.all(
                        Grid.m,
                      ),
                      child: Shimmerize(
                        enabled: true,
                        child: ShimmerFundList(),
                      ),
                    )
                  : _performansTile(
                      _getPerformanceListByCategory(
                        state.performanceRanking!,
                        _selectedCategory,
                      ),
                      _selectedCategory,
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Grid.m,
                ),
                child: Text(
                  L10n.tr('show_all_funds_message'),
                  style: context.pAppStyle.labelReg14textSecondary,
                ),
              ),
              const SizedBox(
                height: Grid.s + Grid.xs,
              ),
              Padding(
                padding: const EdgeInsets.only(left: Grid.m),
                child: PCustomOutlinedButtonWithIcon(
                  text: L10n.tr('show_all_funds'),
                  iconSource: ImagesPath.arrow_up_right,
                  buttonType: PCustomOutlinedButtonTypes.mediumSecondary,
                  onPressed: () {
                    router.push(
                      FundsListRoute(
                        title: L10n.tr('all_funds'),
                      ),
                    );
                  },
                ),
              ),
              state.fundThemeList == null
                  ? const ShimmerFundGroupWidget()
                  : state.fundThemeList != null && state.fundThemeList!.isEmpty
                      ? const SizedBox.shrink()
                      : const FundGroupsWidget(),
              state.founderInfoList == null
                  ? const ShimmerFundFounderWidget()
                  : state.founderInfoList != null && state.founderInfoList!.isEmpty
                      ? const SizedBox.shrink()
                      : FundFoundersWidget(
                          institutionList: state.founderInfoList ?? [],
                        ),
              const SizedBox(
                height: Grid.s + Grid.xs,
              ),
            ],
          ),
        );
      },
    );
  }

  List<PerformanceDetail> _getPerformanceListByCategory(FundPerformanceModel model, String category) {
    if (category == L10n.tr('topByPerformance')) {
      return model.topByPerformance;
    } else if (category == L10n.tr('lowestByPerformance')) {
      return model.lowestByPerformance;
    } else if (category == L10n.tr('withMostPeople')) {
      return model.withMostPeople;
    } else {
      return model.topByPerformance;
    }
  }

  String _categoryTableTitle(String category) {
    if (category == L10n.tr('topByPerformance')) {
      return L10n.tr('monthly_profit');
    } else if (category == L10n.tr('lowestByPerformance')) {
      return L10n.tr('monthly_profit');
    } else if (category == L10n.tr('withMostPeople')) {
      return L10n.tr('withMostPeople');
    } else {
      return L10n.tr('monthly_profit');
    }
  }

  Widget _performansTile(List<PerformanceDetail> performanceRankingList, String filterCategory) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Grid.m,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: performanceRankingList.length,
        itemBuilder: (context, index) => Column(
          children: [
            SymbolListTile(
              symbolName: performanceRankingList[index].instutionCode.toString(),
              symbolType: SymbolTypes.fund,
              leadingText: '${performanceRankingList[index].subType}',
              subLeadingText:
                  '${performanceRankingList[index].fundCode} • ${performanceRankingList[index].instutionName.toCapitalizeCaseTr}',
              trailingWidget: filterCategory == L10n.tr('withMostPeople')
                  ? Text(MoneyUtils().compactMoney(performanceRankingList[index].numberOfPeople ?? 0),
                      style: context.pAppStyle.labelMed14textPrimary)
                  : DiffPercentage(percentage: performanceRankingList[index].performance1M! * 100),
              onTap: () => {
                router.push(
                  FundDetailRoute(
                    fundCode: performanceRankingList[index].fundCode.toString(),
                  ),
                ),
              },
            ),
            if (index != performanceRankingList.length - 1) const PDivider(),
          ],
        ),
      ),
    );
  }
}
