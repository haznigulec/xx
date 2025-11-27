import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_bloc.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_event.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_state.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/diff_percentage.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/extension/double_extension.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DetailPerformanceGauge extends StatefulWidget {
  final String title;
  final String symbolName;
  final double lowPrice;
  final double highPrice;
  final double price;
  final bool showMinMaxLabel;
  final String? type;
  final String? subMarketCode;
  final bool? isFund;
  final double? fundPerformance;

  const DetailPerformanceGauge({
    super.key,
    required this.title,
    required this.symbolName,
    required this.lowPrice,
    required this.highPrice,
    required this.price,
    this.showMinMaxLabel = false,
    this.type,
    this.subMarketCode,
    this.isFund = false,
    this.fundPerformance,
  });

  @override
  State<DetailPerformanceGauge> createState() => _DetailPerformanceGaugeState();
}

class _DetailPerformanceGaugeState extends State<DetailPerformanceGauge> {
  late String title;
  late double lowPrice;
  late double highPrice;
  late double price;
  late bool showMinMaxLabel;
  late DateTime startDate;
  late DateTime endDate;
  double performance = 0.00;

  @override
  initState() {
    super.initState();
    title = widget.title;
    lowPrice = widget.lowPrice;
    highPrice = widget.highPrice;
    price = widget.price;
    showMinMaxLabel = widget.showMinMaxLabel;
    calculateDate();
    if (widget.isFund!) {
      performance = widget.fundPerformance ?? 0;
    } else {
      getIt<SymbolChartBloc>().add(
        GetDataByDateRangeEvent(
          symbolName: widget.symbolName,
          startDate: startDate,
          endDate: endDate,
          callback: (List<SymbolChartModel>? data) {
            if (mounted) {
              if (data != null && data.isNotEmpty) {
                final sortedData = List<SymbolChartModel>.from(data)..sort((a, b) => a.date.compareTo(b.date));
                setState(() {
                  if (widget.price == 0 || sortedData.last.close == 0) {
                    performance = 0;
                  } else {
                    performance = ((widget.price - sortedData.last.close) / sortedData.last.close) * 100;
                  }
                });
              }
            }
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Grid.s),
      margin: const EdgeInsets.only(bottom: Grid.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            L10n.tr(title),
            style: context.pAppStyle.labelMed14textPrimary,
          ),
          const SizedBox(height: Grid.s),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${MoneyUtils().getCurrency(stringToSymbolType(widget.type ?? ''))}${stringToSymbolType(widget.type ?? '') == SymbolTypes.crypto || widget.isFund! || stringToSymbolType(widget.type ?? '') == SymbolTypes.parity || widget.subMarketCode == 'CRF' ? MoneyUtils().readableMoney(
                    lowPrice.isNaN || lowPrice.isInfinite ? 0 : lowPrice,
                    pattern: '#,##0.000000',
                  ) : MoneyUtils().readableMoney(lowPrice.isNaN || lowPrice.isInfinite ? 0 : lowPrice)}',
                style: context.pAppStyle.labelMed12textSecondary,
              ),
              DiffPercentage(
                percentage: performance,
                fontSize: Grid.l / 2,
              ),
              Text(
                '${MoneyUtils().getCurrency(stringToSymbolType(widget.type ?? ''))}${stringToSymbolType(widget.type ?? '') == SymbolTypes.crypto || widget.isFund! || stringToSymbolType(widget.type ?? '') == SymbolTypes.parity || widget.subMarketCode == 'CRF' ? MoneyUtils().readableMoney(
                    highPrice.isNaN || highPrice.isInfinite ? 0 : highPrice,
                    pattern: '#,##0.000000',
                  ) : MoneyUtils().readableMoney(highPrice.isNaN || highPrice.isInfinite ? 0 : highPrice)}',
                style: context.pAppStyle.labelMed12textSecondary,
              ),
            ],
          ),
          SfLinearGauge(
            minimum: lowPrice >= highPrice ? highPrice - .001 : lowPrice,
            maximum: highPrice.isNaN || highPrice.isInfinite ? 1 : highPrice,
            showLabels: false,
            animateAxis: false,
            showTicks: false,
            axisTrackStyle: LinearAxisTrackStyle(
              color: context.pColorScheme.line,
            ),
            markerPointers: [
              LinearShapePointer(
                value: price.isNullOrZero ? lowPrice : price,
                color: performance > 0
                    ? context.pColorScheme.success.shade100
                    : performance < 0
                        ? context.pColorScheme.critical.shade100
                        : context.pColorScheme.iconPrimary.shade100,
                width: 18,
                position: LinearElementPosition.cross,
                shapeType: LinearShapePointerType.circle,
                height: 18,
                borderColor: performance > 0
                    ? context.pColorScheme.success
                    : performance < 0
                        ? context.pColorScheme.critical
                        : context.pColorScheme.iconPrimary,
                borderWidth: 5,
              ),
            ],
          ),
        ],
      ),
    );
  }

  calculateDate() {
    switch (title) {
      case '7g':
        endDate = DateTime.now().subtract(const Duration(days: 7));
      case '30g':
        endDate = DateTime.now().subtract(const Duration(days: 30));
      case '3M':
        endDate = DateTime.now().subtract(const Duration(days: 90));
      case '6M':
        endDate = DateTime.now().subtract(const Duration(days: 180));
      case 'NEWYEAR':
        endDate = DateTime.now()
            .subtract(Duration(days: DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays));
      case '52h':
        endDate = DateTime.now().subtract(const Duration(days: 365));
      case '3Y':
        endDate = DateTime.now().subtract(const Duration(days: 365 * 3));

      case '5Y':
        endDate = DateTime.now().subtract(const Duration(days: 365 * 5));

      default:
    }
    startDate = endDate.subtract(const Duration(days: 15));
  }
}
