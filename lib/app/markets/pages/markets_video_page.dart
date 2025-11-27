import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/market_reviews/bloc/reports_bloc.dart';
import 'package:piapiri_v2/app/market_reviews/bloc/reports_state.dart';
import 'package:piapiri_v2/app/markets/widgets/market_video_list_item.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/report_model.dart';

class MarketsVideoPage extends StatefulWidget {
  const MarketsVideoPage({
    super.key,
    required this.marketType,
    this.subSymbol,
  });

  final MarketTypeEnum marketType;
  final String? subSymbol;

  @override
  State<MarketsVideoPage> createState() => _BistVideoPageState();
}

class _BistVideoPageState extends State<MarketsVideoPage> with AutomaticKeepAliveClientMixin {
  late ReportsBloc _reportsBloc;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _reportsBloc = getIt<ReportsBloc>();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: PBlocBuilder<ReportsBloc, ReportsState>(
          bloc: _reportsBloc,
          builder: (context, state) {
            List<ReportModel> reports = widget.marketType == MarketTypeEnum.marketBist
                ? state.bistVideoReportList
                : widget.marketType == MarketTypeEnum.marketFund
                    ? state.fundVideoReportList
                    : widget.marketType == MarketTypeEnum.marketUs
                        ? state.usVideoReportList
                        : [];

            if (widget.subSymbol != null) {
              reports = reports.where((e) => e.symbols.any((e) => e == widget.subSymbol!)).toList();
            }

            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(
                      top: Grid.m,
                      bottom: Grid.xxl,
                    ),
                    shrinkWrap: true,
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
                      final reportItem = reports[index];
                      return MarketVideoListItemWidget(
                        index: index,
                        embedCode: reportItem.youtubeEmbedCode,
                        title: reportItem.title,
                        description: reportItem.description,
                        dateTime: reportItem.dateTime,
                        symbols: reportItem.symbols.map((e) => e.toString()).toList(),
                        marketType: widget.marketType,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) => PDivider(
                      tickness: 1.0,
                      color: context.pColorScheme.line,
                      padding: const EdgeInsets.symmetric(
                        vertical: Grid.m,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
