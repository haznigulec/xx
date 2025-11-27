import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/home/widgets/create_account_info_card.dart';
import 'package:piapiri_v2/app/market_reviews/pages/market_reviews_page.dart';
import 'package:piapiri_v2/app/markets/model/market_menu.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_bloc.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_event.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_state.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/quick_portfolio_fund_card.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/specific_list_widget.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class UsAnalysisPage extends StatefulWidget {
  const UsAnalysisPage({super.key});

  @override
  State<UsAnalysisPage> createState() => _UsAnalysisPageState();
}

class _UsAnalysisPageState extends State<UsAnalysisPage> {
  late QuickPortfolioBloc _quickPortfolioBloc;
  late AuthBloc _authBloc;
  // Amerikan Borsasında öneriler olmadığı için bu kısımda yoruma alınmıştır.
  // late AdvicesBloc _advicesBloc;

  @override
  void initState() {
    _quickPortfolioBloc = getIt<QuickPortfolioBloc>();
    _authBloc = getIt<AuthBloc>();
    // Amerikan Borsasında öneriler olmadığı için bu kısımda yoruma alınmıştır.
    // _advicesBloc = getIt<AdvicesBloc>();

    if (_authBloc.state.isLoggedIn) {
      // Amerikan Borsasında öneriler olmadığı için bu kısımda yoruma alınmıştır.
      // _advicesBloc.add(
      //   GetAdvicesEvent(
      //     fetchRoboSignals: false,
      //     mainGroup: MarketTypeEnum.marketUs.value,
      //   ),
      // );

      _quickPortfolioBloc.add(
        GetPreparedPortfolioEvent(
          portfolioKey: 'us_sepet',
        ),
      );
    }

    _quickPortfolioBloc.add(
      GetSpecificListEvent(
        mainGroup: MarketTypeEnum.marketUs.value,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Grid.m,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amerikan Borsasında öneriler olmadığı için bu kısımda yoruma alınmıştır.
            // Padding(
            //   padding: const EdgeInsets.symmetric(
            //     horizontal: Grid.m,
            //   ),
            //   child: _authBloc.state.isLoggedIn
            //       ? BistAnalysisAdvicesWidget(
            //           mainGroup: MarketTypeEnum.marketUs.value,
            //         )
            //       : CreateAccountInfoCard(
            //           title: 'advices',
            //           description: 'advice_create_account_alert',
            //           onLogin: () => router.push(
            //             AuthRoute(
            //               activeIndex: 2,
            //               marketMenu: MarketMenu.americanStockExchanges,
            //               marketIndex: 1,
            //             ),
            //           ),
            //         ),
            // ),
            ...!getIt<AuthBloc>().state.isLoggedIn
                ? [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Grid.l,
                        horizontal: Grid.m,
                      ),
                      child: CreateAccountInfoCard(
                        title: 'quick_portfolios',
                        description: 'quick_portfolio_create_account_alert',
                        onLogin: () => router.push(
                          AuthRoute(
                            activeIndex: 2,
                            marketMenu: MarketMenu.americanStockExchanges,
                            marketIndex: 1,
                          ),
                        ),
                      ),
                    )
                  ]
                : [
                    PBlocBuilder<QuickPortfolioBloc, QuickPortfolioState>(
                      bloc: _quickPortfolioBloc,
                      builder: (context, state) {
                        if (state.fundPortfolios['us_sepet'] == null) {
                          return const SizedBox.shrink();
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: Grid.s,
                          ),
                          child: Shimmerize(
                            enabled: state.isLoading,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Grid.m,
                                  ),
                                  child: Text(
                                    L10n.tr('quick_portfolios'),
                                    style: context.pAppStyle.labelMed18textPrimary,
                                  ),
                                ),
                                const SizedBox(
                                  height: Grid.m,
                                ),
                                ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: state.fundPortfolios['us_sepet']!.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  separatorBuilder: (context, index) => const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: Grid.m,
                                      horizontal: Grid.m,
                                    ),
                                    child: PDivider(),
                                  ),
                                  itemBuilder: (context, index) => QuickPortfolioFundCard(
                                    item: state.fundPortfolios['us_sepet']![index],
                                    portfolioKey: 'us_sepet',
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(
                                //     horizontal: Grid.m,
                                //   ),
                                //   child: BistAnalysisAdvicesWidget(
                                //     mainGroup: MarketTypeEnum.marketUs.value,
                                //     showEmptyWidget: true,
                                //   ),
                                // ),
                                const SizedBox(
                                  height: Grid.m,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
            const SpecificListWidget(
              leftPadding: Grid.m,
              rightPadding: Grid.m,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Grid.m,
              ),
              child: MarketReviewsPage(
                mainGroup: MarketTypeEnum.marketUs.value,
              ),
            ),
            const SizedBox(
              height: Grid.l,
            ),
          ],
        ),
      ),
    );
  }
}
