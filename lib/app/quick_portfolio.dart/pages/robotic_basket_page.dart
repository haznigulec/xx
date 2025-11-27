import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_bloc.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_state.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/quick_portfolio_asset_model.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/model_portfolio_detail_tile.dart';
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

//robotik sepetler önizleme
@RoutePage()
class RoboticBasketPage extends StatefulWidget {
  final String portfolioKey;
  final String title;
  final int portfolioId;
  final String description;
  final String suitable;
  final List<String> ignoreUnsubList;
  final String? basketKey;
  const RoboticBasketPage({
    super.key,
    required this.portfolioKey,
    required this.title,
    required this.portfolioId,
    required this.description,
    required this.suitable,
    this.ignoreUnsubList = const [],
    this.basketKey,
  });

  @override
  State<RoboticBasketPage> createState() => _ModelPorfolioPageState();
}

class _ModelPorfolioPageState extends State<RoboticBasketPage> {
  late QuickPortfolioBloc _quickPortfolioBloc;
  List<QuickPortfolioAssetModel> _selectedAssets = [];
  late SymbolBloc _symbolBloc;
  @override
  void initState() {
    super.initState();
    _quickPortfolioBloc = getIt<QuickPortfolioBloc>();
    _symbolBloc = getIt<SymbolBloc>();
    _selectedAssets = List.from(
      _quickPortfolioBloc.state.roboticPortfolios.where((e) => e.portfolioId == widget.portfolioId).toList(),
    );
    _symbolBloc.add(
      SymbolSubTopicsEvent(
        symbols: _selectedAssets
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
  }

  @override
  void dispose() {
    _symbolBloc.add(
      SymbolUnsubsubscribeEvent(
        symbolList: _selectedAssets
            .where((e) => !widget.ignoreUnsubList.contains(e.code))
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<QuickPortfolioBloc, QuickPortfolioState>(
      bloc: _quickPortfolioBloc,
      builder: (context, state) {
        if (state.roboticPortfolios.isEmpty || _selectedAssets.isEmpty) {
          return const PLoading();
        }

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
                  mainAxisSize: MainAxisSize.max,
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
                    const SizedBox(height: Grid.s),
                    Text(
                      widget.suitable,
                      style: context.pAppStyle.labelReg14textPrimary,
                    ),
                    const SizedBox(height: Grid.s),
                    TableTitleWidget(
                      primaryColumnTitle: L10n.tr('equity'),
                      secondaryColumnTitle: '%${L10n.tr('yuzde')}',
                      tertiaryColumnTitle: L10n.tr('son_fiyat'),
                    ),
                    ListView.separated(
                      scrollDirection: Axis.vertical,
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _selectedAssets.length,
                      separatorBuilder: (context, index) => const PDivider(),
                      itemBuilder: (context, index) => ModelPortfolioDetailTile(
                        item: _selectedAssets[index],
                        portfolioKey: widget.portfolioKey,
                      ),
                    ),
                    const SizedBox(
                      height: Grid.xxl,
                    ),
                  ],
                ),
              ),
            ),
            bottomSheet: generalButtonPadding(
              context: context,
              child: PButton(
                text: L10n.tr('satin_al'),
                fillParentWidth: true,
                sizeType: PButtonSize.medium,
                onPressed: () {
                  if (widget.basketKey != null) {
                    _eventDecider(widget.basketKey!);
                  }

                  router.push(
                    RoboticBasketOrderRoute(
                      title: widget.title,
                      portfolioList: _selectedAssets,
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
      case 'teknoloji_hisseleri_sepeti':
        getIt<Analytics>().track(
          AnalyticsEvents.teknolojiHisseleriSatinAlClick,
          taxonomy: [
            InsiderEventEnum.controlPanel.value,
            InsiderEventEnum.marketsPage.value,
            InsiderEventEnum.istanbulStockExchangeTab.value,
            InsiderEventEnum.analysisTab.value,
          ],
        );
        break;
      case 'temettu_hisseleri_sepeti':
        getIt<Analytics>().track(
          AnalyticsEvents.temettuHisseleriSatinAlClick,
          taxonomy: [
            InsiderEventEnum.controlPanel.value,
            InsiderEventEnum.marketsPage.value,
            InsiderEventEnum.istanbulStockExchangeTab.value,
            InsiderEventEnum.analysisTab.value,
          ],
        );
        break;
      case 'doviz_pozitif_hisseleri_sepeti':
        getIt<Analytics>().track(
          AnalyticsEvents.dovizPozitifHisseleriSatinAlClick,
          taxonomy: [
            InsiderEventEnum.controlPanel.value,
            InsiderEventEnum.marketsPage.value,
            InsiderEventEnum.istanbulStockExchangeTab.value,
            InsiderEventEnum.analysisTab.value,
          ],
        );
        break;
      default:
        getIt<Analytics>().track(
          AnalyticsEvents.teknolojiHisseleriSatinAlClick,
          taxonomy: [
            InsiderEventEnum.controlPanel.value,
            InsiderEventEnum.marketsPage.value,
            InsiderEventEnum.istanbulStockExchangeTab.value,
            InsiderEventEnum.analysisTab.value,
          ],
        );
    }
  }
}
