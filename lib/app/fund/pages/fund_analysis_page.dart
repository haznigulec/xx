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
import 'package:piapiri_v2/app/quick_portfolio.dart/model/specific_list_bist_type_enum.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/quick_portfolio_fund_card.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/shimmer_specific_list_widget.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/specific_list_widget.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class FundAnalysisPage extends StatefulWidget {
  const FundAnalysisPage({super.key});

  @override
  State<FundAnalysisPage> createState() => _FundAnalysisPageState();
}

class _FundAnalysisPageState extends State<FundAnalysisPage> {
  late QuickPortfolioBloc _quickPortfolioBloc;
  late AuthBloc _authBloc;
  @override
  void initState() {
    _quickPortfolioBloc = getIt<QuickPortfolioBloc>();
    _authBloc = getIt<AuthBloc>();

    if (_authBloc.state.isLoggedIn) {
      _quickPortfolioBloc.add(
        GetPreparedPortfolioEvent(
          portfolioKey: 'fon_sepet',
        ),
      );
    }
    _quickPortfolioBloc.add(
      GetSpecificListEvent(
        mainGroup: BistType.fundBist.type,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<QuickPortfolioBloc, QuickPortfolioState>(
      bloc: _quickPortfolioBloc,
      builder: (context, state) {
        if (state.isLoading) {
          return const Padding(
            padding: EdgeInsets.only(
              top: Grid.m,
            ),
            child: Shimmerize(
              enabled: true,
              child: ShimmerSpecificListWidget(),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Grid.s,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!getIt<AuthBloc>().state.isLoggedIn)
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
                          marketMenu: MarketMenu.investmentFund,
                          marketIndex: 1,
                        ),
                      ),
                    ),
                  )
                else if (state.fundPortfolios['fon_sepet'] != null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Grid.m),
                    child: Text(
                      L10n.tr('quick_portfolios'),
                      style: context.pAppStyle.labelMed18textPrimary,
                    ),
                  ),
                  const SizedBox(height: Grid.m),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.fundPortfolios['fon_sepet']!.length,
                    separatorBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.symmetric(vertical: Grid.m, horizontal: Grid.m),
                      child: PDivider(),
                    ),
                    itemBuilder: (context, index) => Column(
                      children: [
                        QuickPortfolioFundCard(
                          item: state.fundPortfolios['fon_sepet']![index],
                          portfolioKey: 'fon_sepeti',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: Grid.l,
                  ),
                ],
                const SpecificListWidget(
                  leftPadding: Grid.m,
                  rightPadding: Grid.m,
                ),
                const SizedBox(
                  height: Grid.s,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Grid.m,
                  ),
                  child: MarketReviewsPage(
                    mainGroup: MarketTypeEnum.marketFund.value,
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
