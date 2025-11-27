import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/market_reviews/widgets/share_icon.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/symbol_chips_widget.dart';
import 'package:piapiri_v2/core/model/report_model.dart';

class PdfContentWidget extends StatelessWidget {
  final ReportModel reportModel;
  final Widget bodyWidget;
  final String title;
  final String mainGroup;
  const PdfContentWidget({
    super.key,
    required this.reportModel,
    required this.bodyWidget,
    required this.title,
    required this.mainGroup,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: title,
        actions: [
          ShareIcon(
            reportModel: reportModel,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Grid.s,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: Text(
              reportModel.title,
              textAlign: TextAlign.left,
              style: context.pAppStyle.labelMed16textPrimary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: Text(
              DateTimeUtils.dateFormat(
                DateTime.parse(reportModel.dateTime),
              ),
              style: context.pAppStyle.labelMed14textSecondary,
            ),
          ),
          SymbolChipsWidget(
            symbolList: List<String>.from(reportModel.symbols),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Grid.m,
              ),
              child: bodyWidget,
            ),
          ),
        ],
      ),
    );
  }
}
