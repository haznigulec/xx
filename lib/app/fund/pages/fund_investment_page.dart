import 'package:piapiri_v2/common/widgets/tab_controller/model/tab_bar_item.dart';
import 'package:piapiri_v2/common/widgets/tab_controller/tab_controllers/p_main_tab_controller.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/fund/pages/fund_analysis_page.dart';
import 'package:piapiri_v2/app/fund/pages/fund_page.dart';
import 'package:piapiri_v2/app/market_reviews/bloc/reports_bloc.dart';
import 'package:piapiri_v2/app/markets/pages/markets_video_page.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class FundInvestmentPage extends StatelessWidget {
  final int? tabIndex;
  const FundInvestmentPage({
    super.key,
    this.tabIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PMainTabController(
                initialIndex: tabIndex ?? 0,
                tabs: [
                  PTabItem(
                    title: L10n.tr('fund'),
                    page: const FundPage(),
                  ),
                  PTabItem(
                    title: L10n.tr('analiz'),
                    page: const FundAnalysisPage(),
                  ),
                  if (getIt<ReportsBloc>().state.fundVideoReportList.isNotEmpty)
                    PTabItem(
                      title: L10n.tr('video'),
                      page: const MarketsVideoPage(
                        marketType: MarketTypeEnum.marketFund,
                      ),
                    ),
                ],
                scrollable: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
