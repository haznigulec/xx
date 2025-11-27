import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/fund/widgets/fund_portfolio_detail_tile.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_bloc.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_event.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_state.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/quick_portfolio_asset_model.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/table_title_widget.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

//Fon -> Analiz -> Sepetler
@RoutePage()
class FundPortfolioPage extends StatefulWidget {
  final List<QuickPortfolioAssetModel> funds;
  final String title;
  final String description;
  final String suitable;
  final String basketKey;
  const FundPortfolioPage({
    super.key,
    required this.funds,
    required this.title,
    required this.description,
    required this.suitable,
    required this.basketKey,
  });

  @override
  State<FundPortfolioPage> createState() => _FundPortfolioPageState();
}

class _FundPortfolioPageState extends State<FundPortfolioPage> {
  late QuickPortfolioBloc _quickPortfolioBloc;
  late SymbolBloc _symbolBloc;
  @override
  void initState() {
    super.initState();
    _quickPortfolioBloc = getIt<QuickPortfolioBloc>();
    _symbolBloc = getIt<SymbolBloc>();
    _quickPortfolioBloc.add(
      GetModelPortfolioEvent(
        callback: (modelPortfolio) {
          _symbolBloc.add(
            SymbolSubTopicsEvent(
              symbols: modelPortfolio[0]
                  .items
                  .map(
                    (e) => MarketListModel(
                      symbolCode: e.code,
                      updateDate: '',
                      type: stringToSymbolType(e.type).name,
                    ),
                  )
                  .toList(),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<QuickPortfolioBloc, QuickPortfolioState>(
      bloc: _quickPortfolioBloc,
      builder: (context, state) {
        return Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            dividerTheme: const DividerThemeData(
              color: Colors.transparent,
            ),
          ),
          child: Scaffold(
            appBar: PInnerAppBar(
              title: widget.title,
            ),
            body: Padding(
              padding: const EdgeInsets.all(Grid.m),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.description,
                      style: context.pAppStyle.labelReg14textPrimary,
                    ),
                    const SizedBox(height: Grid.m),
                    Text(
                      L10n.tr('whoIsItSuitableFor'),
                      style: context.pAppStyle.labelMed14textPrimary,
                    ),
                    const SizedBox(
                      height: Grid.s,
                    ),
                    Text(
                      widget.suitable,
                      style: context.pAppStyle.labelReg14textPrimary,
                    ),
                    const SizedBox(height: Grid.s + Grid.xs),
                    TableTitleWidget(
                      primaryColumnTitle: L10n.tr('fund'),
                      secondaryColumnTitle: '%${L10n.tr('yuzde')}',
                      tertiaryColumnTitle: L10n.tr('monthly_profit'),
                    ),
                    state.fundPortfolios.isEmpty
                        ? const Expanded(
                            child: Center(
                              child: PLoading(),
                            ),
                          )
                        : ListView.separated(
                            scrollDirection: Axis.vertical,
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.funds.length,
                            separatorBuilder: (context, index) => const PDivider(),
                            itemBuilder: (context, index) => FundPortfolioDetailTile(
                              item: QuickPortfolioAssetModel(
                                id: 0,
                                amount: 0.0,
                                type: SymbolTypes.fund.name,
                                targetPrice: 0.0,
                                code: widget.funds[index].code,
                                name: widget.funds[index].code,
                                founderCode: widget.funds[index].founderCode,
                                ratio: double.parse(widget.funds[index].ratio.toString()),
                                subType: widget.funds[index].subType,
                                founderName: widget.funds[index].founderName,
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: Grid.xxl,
                    )
                  ],
                ),
              ),
            ),
            bottomNavigationBar: state.fundPortfolios.isEmpty
                ? const SizedBox()
                : generalButtonPadding(
                    context: context,
                    child: PButton(
                      text: L10n.tr('satin_al'),
                      fillParentWidth: true,
                      sizeType: PButtonSize.medium,
                      onPressed: () {
                        _eventDecider(widget.basketKey);
                        router.push(
                          FundPortfolioOrderRoute(
                            title: widget.title,
                            portfolioList: widget.funds,
                            basketKey: widget.basketKey,
                          ),
                        );
                      },
                    ),
                  ),
          ),
        );
      },
    );
  }

  void _eventDecider(String key) {
    switch (key) {
      case 'dinamik_fon_dagilimi':
        getIt<Analytics>().track(
          AnalyticsEvents.dinamikFonDagilimSatinAlClick,
          taxonomy: [
            InsiderEventEnum.controlPanel.value,
            InsiderEventEnum.marketsPage.value,
            InsiderEventEnum.investmentFundTab.value,
            InsiderEventEnum.analysisTab.value,
          ],
        );
        break;
      case 'dengeli_fon_dagilimi':
        getIt<Analytics>().track(
          AnalyticsEvents.dengeliFonDagilimSatinAlClick,
          taxonomy: [
            InsiderEventEnum.controlPanel.value,
            InsiderEventEnum.marketsPage.value,
            InsiderEventEnum.investmentFundTab.value,
            InsiderEventEnum.analysisTab.value,
          ],
        );
        break;
      case 'atak_fon_dagilimi':
        getIt<Analytics>().track(
          AnalyticsEvents.atakFonDagilimiSatinAlClick,
          taxonomy: [
            InsiderEventEnum.controlPanel.value,
            InsiderEventEnum.marketsPage.value,
            InsiderEventEnum.investmentFundTab.value,
            InsiderEventEnum.analysisTab.value,
          ],
        );
        break;
      default:
        getIt<Analytics>().track(
          AnalyticsEvents.dinamikFonDagilimSatinAlClick,
          taxonomy: [
            InsiderEventEnum.controlPanel.value,
            InsiderEventEnum.marketsPage.value,
            InsiderEventEnum.investmentFundTab.value,
            InsiderEventEnum.analysisTab.value,
          ],
        );
    }
  }
}
