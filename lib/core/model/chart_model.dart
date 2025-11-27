import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  final DateTime? date;
  final double? open;
  final double? high;
  final double? low;
  final double? close;

  ChartData(
    this.date,
    this.open,
    this.high,
    this.low,
    this.close,
  );
}

enum ChartType {
  area('AREA', 'chart.line', ImagesPath.graph_dot),
  candle('CANDLE', 'chart.candle', ImagesPath.candle),
  ohlc('OHLC', 'chart.stick', ImagesPath.graph_cubuk);

  final String value;
  final String localizationKey;
  final String imagePath;

  const ChartType(this.value, this.localizationKey, this.imagePath);
}

enum ChartFilter {
  oneMinute(
    '1min',
    'minute',
    null,
    null,
    null,
    null,
    'symbol.detail.chart_D',
    '',
    Duration(days: 1),
    DateTimeIntervalType.minutes,
  ),
  oneHour(
    '1hour',
    'hour',
    null,
    null,
    null,
    null,
    'symbol.detail.chart_S',
    '',
    Duration(days: 30),
    DateTimeIntervalType.hours,
  ),
  oneDay(
    '1day',
    'day',
    '1D',
    null,
    null,
    null,
    'symbol.detail.chart_G',
    '',
    Duration(days: 365),
    DateTimeIntervalType.days,
  ),
  oneWeek(
    'weekly',
    'week',
    '1W',
    '240min',
    'day',
    '1D',
    'symbol.detail.chart_H',
    'performance.chart_1H',
    Duration(days: 365),
    DateTimeIntervalType.months,
  ),
  oneMonth(
    'monthly',
    'month',
    '1M',
    '240min',
    'day',
    '1D',
    'symbol.detail.chart_A',
    'performance.chart_1A',
    Duration(days: 365 * 5),
    DateTimeIntervalType.months,
  ),
  threeMonth(
    null,
    null,
    null,
    '240min',
    'day',
    '1D',
    '',
    'performance.chart_3A',
    Duration(days: 365 * 5),
    DateTimeIntervalType.months,
  ),
  //Sadece performans karşılaştırmasında olacak
  sixMonth(
    null,
    null,
    null,
    '240min',
    'day',
    '1D',
    '',
    'performance.chart_6A',
    Duration(days: 365 * 5),
    DateTimeIntervalType.months,
  ),
  oneYear(
    'yearly',
    'year',
    '1Y',
    '240min',
    'day',
    '1D',
    'symbol.detail.chart_Y',
    'performance.chart_1Y',
    Duration(days: 365 * 5),
    DateTimeIntervalType.years,
  ),
  threeYear(
    null,
    null,
    null,
    '240min',
    'day',
    '1D',
    '',
    'performance.chart_3Y',
    Duration(days: 365 * 5),
    DateTimeIntervalType.years,
  ),
  //Sadece performans karşılaştırmasında olacak
  fiveYear(
    null,
    null,
    null,
    '240min',
    'day',
    '1D',
    '',
    'performance.chart_5Y',
    Duration.zero,
    DateTimeIntervalType.years,
  );

  final String? period;
  final String? usPeriod;
  final String? fundPeriod;
  final String? performancePeriod;
  final String? performancePeriodUs;
  final String? performancePeriodFund;
  final String localizationKey;
  final String performanceLocalizationKey;
  final Duration duration;
  final DateTimeIntervalType intervalType;

  const ChartFilter(
    this.period,
    this.usPeriod,
    this.fundPeriod,
    this.performancePeriod,
    this.performancePeriodUs,
    this.performancePeriodFund,
    this.localizationKey,
    this.performanceLocalizationKey,
    this.duration,
    this.intervalType,
  );
}
