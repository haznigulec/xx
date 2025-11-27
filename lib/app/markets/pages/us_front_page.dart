import 'package:piapiri_v2/common/widgets/tab_controller/model/tab_bar_item.dart';
import 'package:piapiri_v2/common/widgets/tab_controller/tab_controllers/p_main_tab_controller.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/market_reviews/bloc/reports_bloc.dart';
import 'package:piapiri_v2/app/markets/pages/markets_video_page.dart';
import 'package:piapiri_v2/app/markets/pages/us_analysis_page.dart';
import 'package:piapiri_v2/app/markets/pages/us_equity_front_page.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class UsFrontPage extends StatelessWidget {
  final int? tabIndex;
  const UsFrontPage({
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
                scrollable: false,
                initialIndex: tabIndex ?? 0,
                tabs: [
                  PTabItem(
                    title: L10n.tr('equity'),
                    page: const UsEquityFrontPage(),
                  ),
                  PTabItem(
                    title: L10n.tr('analysis'),
                    page: const UsAnalysisPage(),
                  ),
                  if (getIt<ReportsBloc>().state.usVideoReportList.isNotEmpty)
                    PTabItem(
                      title: L10n.tr('video'),
                      page: const MarketsVideoPage(
                        marketType: MarketTypeEnum.marketUs,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
