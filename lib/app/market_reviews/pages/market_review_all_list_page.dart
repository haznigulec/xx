import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/market_reviews/bloc/reports_bloc.dart';
import 'package:piapiri_v2/app/market_reviews/bloc/reports_event.dart';
import 'package:piapiri_v2/app/market_reviews/bloc/reports_state.dart';
import 'package:piapiri_v2/app/market_reviews/widgets/market_review_filter_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/common/widgets/list/reports_tile.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/model/report_model.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class MarketReviewAllListPage extends StatefulWidget {
  final List<ReportModel> reportList;
  final String mainGroup;
  final String? symbol;
  const MarketReviewAllListPage({
    super.key,
    required this.reportList,
    required this.mainGroup,
    this.symbol,
  });

  @override
  State<MarketReviewAllListPage> createState() => _MarketReviewAllListPageState();
}

class _MarketReviewAllListPageState extends State<MarketReviewAllListPage> {
  late ReportsBloc _reportsBloc;
  List<ReportModel> _reportList = [];

  @override
  void initState() {
    if (widget.mainGroup == MarketTypeEnum.marketBist.value) {
      getIt<Analytics>().track(
        AnalyticsEvents.raporlarVideoPodcastTabClick,
        taxonomy: [
          InsiderEventEnum.controlPanel.value,
          InsiderEventEnum.marketsPage.value,
          InsiderEventEnum.istanbulStockExchangeTab.value,
          InsiderEventEnum.analysisTab.value,
          InsiderEventEnum.marketReviews.value,
          InsiderEventEnum.seeAll.value,
        ],
      );
    }
    _reportsBloc = getIt<ReportsBloc>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('market_reviews'),
        onPressed: () {
          _reportsBloc.add(
            SetReportFilterEvent(
              deviceId: getIt<AppInfo>().deviceId,
              customerId: UserModel.instance.customerId,
              mainGroup: widget.mainGroup,
              reportFilter: _reportsBloc.state.reportFilter.copyWith(
                showAnalysis: true,
                showPodcasts: true,
                showReports: true,
                showVideoComments: true,
                startDate: null,
                endDate: null,
              ),
            ),
          );

          router.maybePop();
        },
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Grid.m,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: Grid.l - Grid.xs,
            ),
            SizedBox(
              height: 23,
              child: PCustomOutlinedButtonWithIcon(
                text: L10n.tr('filtrele'),
                iconSource: ImagesPath.chevron_down,
                iconAlignment: IconAlignment.end,
                onPressed: () {
                  PBottomSheet.show(
                    context,
                    title: L10n.tr('filtrele'),
                    titlePadding: const EdgeInsets.only(
                      top: Grid.m,
                    ),
                    child: MarketReviewFilterWidget(
                      mainGroup: widget.mainGroup,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: Grid.m,
            ),
            PBlocBuilder<ReportsBloc, ReportsState>(
              bloc: _reportsBloc,
              builder: (context, state) {
                if (state.reportList.isEmpty) {
                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        NoDataWidget(
                          iconName: ImagesPath.search,
                          message: L10n.tr('no_market_reviews_filter_found'),
                        ),
                      ],
                    ),
                  );
                }

                state.reportList.sort(
                  (a, b) => b.dateTime.compareTo(a.dateTime),
                );

                _reportList = state.reportList;

                if (widget.symbol != null) {
                  _reportList = state.reportList
                      .where(
                        (e) => e.symbols.contains(widget.symbol),
                      )
                      .toList();
                }

                return Expanded(
                  child: ListView.separated(
                    itemCount: _reportList.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(
                      bottom: Grid.m,
                    ),
                    physics: const BouncingScrollPhysics(),
                    separatorBuilder: (context, index) => const PDivider(),
                    itemBuilder: (context, index) => ReportsTile(
                      report: _reportList[index],
                      mainGroup: widget.mainGroup,
                      removeTopPadding: index == 0,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      )),
    );
  }
}
