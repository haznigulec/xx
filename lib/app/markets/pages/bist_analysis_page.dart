import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/home/widgets/create_account_info_card.dart';
import 'package:piapiri_v2/app/market_reviews/pages/market_reviews_page.dart';
import 'package:piapiri_v2/app/markets/model/market_menu.dart';
import 'package:piapiri_v2/app/markets/widgets/bist_analysis_advices_widget.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_bloc.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_state.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/model_porfolio_card.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/quick_portfolio_fund_card.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class BistAnalysisPage extends StatefulWidget {
  const BistAnalysisPage({super.key});

  @override
  State<BistAnalysisPage> createState() => _BistAnalysisPageState();
}

class _BistAnalysisPageState extends State<BistAnalysisPage> with AutomaticKeepAliveClientMixin {
  late AuthBloc _authBloc;
  late QuickPortfolioBloc _quickPortfolioBloc;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _authBloc = getIt<AuthBloc>();
    _quickPortfolioBloc = getIt<QuickPortfolioBloc>();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return PBlocBuilder<QuickPortfolioBloc, QuickPortfolioState>(
      bloc: _quickPortfolioBloc,
      builder: (context, state) {
        // if (_authBloc.state.isLoggedIn) {
        //   if (state.isLoading) {
        //     return const PLoading();
        //   }
        // }

        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Grid.s,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Grid.m,
                  ),
                  child: _authBloc.state.isLoggedIn
                      ? BistAnalysisAdvicesWidget(
                          mainGroup: MarketTypeEnum.marketBist.value,
                        )
                      : CreateAccountInfoCard(
                          title: 'advices',
                          description: 'advice_create_account_alert',
                          onLogin: () => router.push(
                            AuthRoute(
                              activeIndex: 2,
                              marketMenu: MarketMenu.istanbulStockExchange,
                              marketIndex: 3,
                            ),
                          ),
                        ),
                ),
                ...!getIt<AuthBloc>().state.isLoggedIn
                    ? [
                        const SizedBox(
                          height: Grid.l,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Grid.m,
                          ),
                          child: CreateAccountInfoCard(
                            title: 'quick_portfolios',
                            description: 'quick_portfolio_create_account_alert',
                            onLogin: () => router.push(
                              AuthRoute(
                                activeIndex: 2,
                                marketMenu: MarketMenu.istanbulStockExchange,
                                marketIndex: 3,
                              ),
                            ),
                          ),
                        ),
                      ]
                    : [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Grid.m,
                          ),
                          child: Text(
                            L10n.tr(
                              'quick_portfolios',
                            ),
                            style: context.pAppStyle.interMediumBase.copyWith(
                              fontSize: Grid.m + Grid.xxs,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: Grid.m,
                        ),
                        if (state.modelPortfolios.isNotEmpty) ...[
                          ModelPortfolioCard(
                            // padding koy
                            item: state.modelPortfolios[0],
                            portfolioKey: 'model_portfoy',
                          ),
                        ],
                        if (state.modelPortfolios.isNotEmpty && state.fundPortfolios['robotik_sepet'] != null) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: Grid.m,
                              horizontal: Grid.m,
                            ),
                            child: PDivider(),
                          ),
                        ],
                        if (state.fundPortfolios['robotik_sepet'] != null) ...[
                          ListView.builder(
                            // // padding koy
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: state.fundPortfolios['robotik_sepet']!.length,
                            itemBuilder: (context, index) => Column(
                              children: [
                                QuickPortfolioFundCard(
                                  item: state.fundPortfolios['robotik_sepet']![index],
                                  portfolioKey: 'robotik_sepet',
                                ),
                                if (index != state.fundPortfolios['robotik_sepet']!.length - 1)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: Grid.m,
                                      horizontal: Grid.m,
                                    ),
                                    child: PDivider(),
                                  ),
                              ],
                            ),
                          ),
                        ]
                      ],
                if (_authBloc.state.isLoggedIn)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Grid.m,
                    ),
                    child: BistAnalysisAdvicesWidget(
                      mainGroup: MarketTypeEnum.marketBist.value,
                      showEmptyWidget: true,
                    ),
                  ),
                const SizedBox(
                  height: Grid.l,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Grid.m,
                  ),
                  child: MarketReviewsPage(
                    mainGroup: MarketTypeEnum.marketBist.value,
                    insideFetchData: false,
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
