import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_bloc.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_event.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_state.dart';
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

//model portfolio önizleme
@RoutePage()
class ModelPorfolioPage extends StatefulWidget {
  final String portfolioKey;
  final String title;
  final String description;
  final List<String> ignoreUnsubList;
  const ModelPorfolioPage({
    super.key,
    required this.portfolioKey,
    required this.title,
    required this.description,
    this.ignoreUnsubList = const [],
  });

  @override
  State<ModelPorfolioPage> createState() => _ModelPorfolioPageState();
}

class _ModelPorfolioPageState extends State<ModelPorfolioPage> {
  late QuickPortfolioBloc _quickPortfolioBloc;
  late SymbolBloc _symbolBloc;
  @override
  void initState() {
    super.initState();
    _quickPortfolioBloc = getIt<QuickPortfolioBloc>();
    _symbolBloc = getIt<SymbolBloc>();

    _symbolBloc.add(
      SymbolSubTopicsEvent(
        symbols: _quickPortfolioBloc.state.modelPortfolios[0].items
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

    _quickPortfolioBloc.add(
      GetModelPortfolioByIdEvent(
        id: 1,
      ),
    );
  }

  @override
  void dispose() {
    _symbolBloc.add(
      SymbolUnsubsubscribeEvent(
        symbolList: _quickPortfolioBloc.state.modelPortfolios[0].items
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
        if (state.modelPortfolios.isEmpty) {
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
                    if (state.modelPortfolioDetail != null) ...[
                      const SizedBox(height: Grid.s),
                      Text(
                        state.modelPortfolioDetail!.targetGroup,
                        style: context.pAppStyle.labelReg14textPrimary,
                      ),
                    ],
                    const SizedBox(height: Grid.s + Grid.xs),
                    TableTitleWidget(
                      primaryColumnTitle: L10n.tr('equity'),
                      secondaryColumnTitle: '%${L10n.tr('yuzde')}',
                      tertiaryColumnTitle: L10n.tr('last_and_target_price'),
                    ),
                    ListView.separated(
                      scrollDirection: Axis.vertical,
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.modelPortfolios[0].items.length,
                      separatorBuilder: (context, index) => const PDivider(),
                      itemBuilder: (context, index) => ModelPortfolioDetailTile(
                        item: state.modelPortfolios[0].items[index],
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
                  getIt<Analytics>().track(
                    AnalyticsEvents.modelPortfoySatinAlClick,
                    taxonomy: [
                      InsiderEventEnum.controlPanel.value,
                      InsiderEventEnum.marketsPage.value,
                      InsiderEventEnum.istanbulStockExchangeTab.value,
                      InsiderEventEnum.analysisTab.value,
                    ],
                  );
                  router.push(
                    ModelPortfolioOrderRoute(
                      title: state.modelPortfolios[0].title,
                      portfolioList: state.modelPortfolios[0].items,
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
}
