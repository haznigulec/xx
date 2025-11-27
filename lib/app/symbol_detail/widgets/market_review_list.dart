import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/market_reviews/bloc/reports_bloc.dart';
import 'package:piapiri_v2/app/market_reviews/bloc/reports_event.dart';
import 'package:piapiri_v2/app/market_reviews/bloc/reports_state.dart';
import 'package:piapiri_v2/common/widgets/list/reports_tile.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/report_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class MarketReviewList extends StatefulWidget {
  final String symbolName;
  final String mainGroup;
  const MarketReviewList({
    super.key,
    required this.symbolName,
    required this.mainGroup,
  });

  @override
  State<MarketReviewList> createState() => _MarketReviewListState();
}

class _MarketReviewListState extends State<MarketReviewList> {
  final ReportsBloc _reportsBloc = getIt<ReportsBloc>();
  List<ReportModel> _reportList = [];

  @override
  void initState() {
    _reportsBloc.add(
      GetReportsEvent(
        deviceId: getIt<AppInfo>().deviceId,
        mainGroup: widget.mainGroup,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<ReportsBloc, ReportsState>(
      bloc: _reportsBloc,
      builder: (context, state) {
        if (state.reportsState == PageState.loading) {
          return const SizedBox.shrink();
        }

        if (state.reportList.isNotEmpty) {
          state.reportList.sort((a, b) => b.dateTime.compareTo(a.dateTime));

          _reportList = state.reportList.where((e) => e.symbols.contains(widget.symbolName)).toList();
        }

        return _reportList.isEmpty
            ? const SizedBox.shrink()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Grid.s,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        L10n.tr('market_reviews'),
                        style: context.pAppStyle.labelMed18textPrimary,
                      ),
                      InkWell(
                        onTap: () => router.push(
                          MarketReviewAllListRoute(
                            reportList: _reportList.isNotEmpty ? _reportList : [],
                            mainGroup: widget.mainGroup,
                            symbol: widget.symbolName,
                          ),
                        ),
                        child: Text(
                          L10n.tr('see_all'),
                          style: context.pAppStyle.labelReg16primary,
                        ),
                      ),
                    ],
                  ),
                  ListView.separated(
                    itemCount: _reportList.length >= 2 ? _reportList.take(2).length : _reportList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => const PDivider(),
                    itemBuilder: (context, index) => ReportsTile(
                      report: _reportList[index],
                      mainGroup: widget.mainGroup,
                    ),
                  ),
                  const SizedBox(
                    height: Grid.l,
                  ),
                ],
              );
      },
    );
  }
}
