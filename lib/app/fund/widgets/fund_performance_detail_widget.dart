import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/detail_performance_gauge.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class FundPerformanceDetailWidget extends StatefulWidget {
  final String symbolName;
  final double price;
  final Map<String, double> performanceData;

  const FundPerformanceDetailWidget({
    super.key,
    required this.symbolName,
    required this.price,
    required this.performanceData,
  });

  @override
  FundPerformanceDetailWidgetState createState() => FundPerformanceDetailWidgetState();
}

class FundPerformanceDetailWidgetState extends State<FundPerformanceDetailWidget> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final entries = widget.performanceData.entries.where((entry) => entry.value != 0).toList();
    final int totalItems = entries.length;

    final displayedEntries = _showAll || totalItems <= 3 ? entries : entries.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L10n.tr('fund_profit_informations'),
          style: context.pAppStyle.labelMed18textPrimary,
        ),
        const SizedBox(height: Grid.s + Grid.xs),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayedEntries.length,
          itemBuilder: (context, index) {
            final entry = displayedEntries[index];
            final String title = entry.key;
            final double performance = entry.value;
            if (performance == -1) return const SizedBox.shrink();
            final lowPrice = performance > 0 ? widget.price / (1 + performance) : widget.price;
            final highPrice = performance > 0 ? widget.price : widget.price / (1 + performance);

            return DetailPerformanceGauge(
              key: ValueKey('$title::'),
              symbolName: widget.symbolName,
              title: title,
              lowPrice: lowPrice,
              highPrice: highPrice,
              price: widget.price,
              showMinMaxLabel: true,
              type: SymbolTypes.fund.matriks,
              isFund: true,
              fundPerformance: performance * 100,
            );
          },
        ),
        if (totalItems > 3)
          PCustomPrimaryTextButton(
            margin: EdgeInsets.zero,
            text: _showAll ? L10n.tr('daha_az_göster') : L10n.tr('daha_fazla_goster'),
            onPressed: () {
              setState(() {
                _showAll = !_showAll;
              });
            },
          ),
      ],
    );
  }
}
