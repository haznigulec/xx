import 'package:intl/intl.dart';
import 'package:piapiri_v2/core/model/chart_model.dart';

class SymbolChartUtils {
  DateTime calculateMinimumXAxisForSFCartesianChart(
    ChartFilter filter,
  ) {
    switch (filter) {
      case ChartFilter.oneMinute:
        return DateTime.now().subtract(const Duration(minutes: 20));

      case ChartFilter.oneHour:
        return DateTime.now().subtract(const Duration(hours: 24));

      case ChartFilter.oneDay:
        return DateTime.now().subtract(const Duration(days: 30));

      case ChartFilter.oneWeek:
        return DateTime.now().subtract(const Duration(days: 92));

      case ChartFilter.oneMonth:
      case ChartFilter.threeMonth:
      case ChartFilter.sixMonth:
        return DateTime.now().subtract(const Duration(days: 310));

      case ChartFilter.oneYear:
      case ChartFilter.threeYear:
      case ChartFilter.fiveYear:
        return DateTime(DateTime.now().year - 5, 1, 1);
    }
  }

  DateFormat handleXAxisTypeForSFCartesianChart(
    ChartFilter filter,
  ) {
    if (filter == ChartFilter.oneMinute || filter == ChartFilter.oneHour) {
      return DateFormat('d MMM HH:mm');
    } else if (filter == ChartFilter.oneDay || filter == ChartFilter.oneWeek) {
      return DateFormat('dd.MM');
    } else if (filter == ChartFilter.oneMonth || filter == ChartFilter.threeMonth) {
      return DateFormat('MM.yy');
    } else if (filter == ChartFilter.oneYear || filter == ChartFilter.threeYear) {
      return DateFormat('yyyy');
    } else {
      return DateFormat('dd.MM.yy');
    }
  }

  String performanceChartDuration(
    ChartFilter filter,
  ) {
    switch (filter) {
      case ChartFilter.oneWeek:
        return '1W_diff';
      case ChartFilter.oneMonth:
        return '1M_diff';
      case ChartFilter.sixMonth:
        return '6M_diff';
      case ChartFilter.oneYear:
        return '1Y_diff';
      case ChartFilter.fiveYear:
        return '5Y_diff';
      default:
        return '';
    }
  }
}
