import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/market_reviews/bloc/reports_bloc.dart';
import 'package:piapiri_v2/app/market_reviews/bloc/reports_event.dart';
import 'package:piapiri_v2/app/market_reviews/bloc/reports_state.dart';
import 'package:piapiri_v2/app/market_reviews/widgets/shimmer_market_review_widget.dart';
import 'package:piapiri_v2/common/widgets/list/reports_tile.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/report_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class MarketReviewsPage extends StatefulWidget {
  final String mainGroup;
  final bool insideFetchData;

  const MarketReviewsPage({
    super.key,
    required this.mainGroup,
    this.insideFetchData = true,
  });

  @override
  State<MarketReviewsPage> createState() => _MarketReviewsPageState();
}

class _MarketReviewsPageState extends State<MarketReviewsPage> {
  late ReportsBloc _bloc;
  List<ReportModel> reportList = [];

  @override
  void initState() {
    _bloc = getIt<ReportsBloc>();

    if (widget.insideFetchData) {
      _bloc.add(
        GetReportsEvent(
          deviceId: getIt<AppInfo>().deviceId,
          mainGroup: widget.mainGroup,
        ),
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<ReportsBloc, ReportsState>(
      bloc: _bloc,
      builder: (context, state) {
        reportList = state.reportList.toList();
        if (reportList.isNotEmpty) {
          reportList.sort((a, b) => b.dateTime.compareTo(a.dateTime));
        }

        return state.reportsState == PageState.loading
            ? const ShimmerMarketReviewWidget()
            : reportList.isEmpty
                ? const SizedBox.shrink()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: Grid.m,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            L10n.tr('market_reviews'),
                            style: context.pAppStyle.labelMed18textPrimary,
                          ),
                          if (reportList.isNotEmpty)
                            InkWell(
                              onTap: () => router.push(
                                MarketReviewAllListRoute(
                                  reportList: reportList.isNotEmpty ? reportList : [],
                                  mainGroup: widget.mainGroup,
                                ),
                              ),
                              child: Text(
                                L10n.tr('see_all'),
                                style: context.pAppStyle.labelReg16primary,
                              ),
                            ),
                        ],
                      ),
                      reportList.isEmpty
                          ? const SizedBox.shrink()
                          : ListView.separated(
                              itemCount: reportList.length >= 2 ? reportList.take(2).length : reportList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, index) => const PDivider(),
                              itemBuilder: (context, index) => ReportsTile(
                                report: reportList[index],
                                mainGroup: widget.mainGroup,
                                removeTopPadding: index == 0,
                              ),
                            ),
                    ],
                  );
      },
    );
  }
}
