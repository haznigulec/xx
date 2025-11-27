import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  int get daysFromNow => difference(DateTime.now()).inDays;

  int get monthsFromNow => daysFromNow ~/ 30;

  int get yearsFromNow => daysFromNow ~/ 365;

  bool get isPast {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    return isBefore(today);
  }

  bool get isPresentOrFuture => !isPast;

  bool isToday() {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    return difference(today).inDays == 0;
  }

  bool isYesterday() {
    final DateTime now = DateTime.now().subtract(const Duration(days: 1));
    final DateTime yesterday = DateTime(now.year, now.month, now.day);
    return difference(yesterday).inDays == 0;
  }

  int toTimestamp() => millisecondsSinceEpoch ~/ 1000;

  bool isAfterOrEqualTo(DateTime dateTime) {
    final date = this;
    final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
    return isAtSameMomentAs || date.isAfter(dateTime);
  }

  bool isBeforeOrEqualTo(DateTime dateTime) {
    final date = this;
    final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
    return isAtSameMomentAs || date.isBefore(dateTime);
  }

  bool isSameDayAs(DateTime dateTime) {
    return day == dateTime.day && month == dateTime.month && year == dateTime.year;
  }

  bool isSameDayOrAfter(DateTime other) => isAfter(other) || isSameDayAs(other);

  bool isSameDayOrBefore(DateTime other) => isBefore(other) || isSameDayAs(other);

  bool? isBetween(
    DateTime? fromDateTime,
    DateTime? toDateTime,
  ) {
    if (fromDateTime == null || toDateTime == null) {
      return false;
    }
    final date = this;
    final isAfter = date.isAfterOrEqualTo(fromDateTime);
    final isBefore = date.isBeforeOrEqualTo(toDateTime);
    return isAfter && isBefore;
  }

  DateTime addMonths(int monthCount) {
    return DateTime(year, month + monthCount, day);
  }

  DateTime subtractMonths(int monthCount) {
    return DateTime(year, month - monthCount, day);
  }

  DateTime removeTime() => DateTime(year, month, day);

  /// REGION DATE TIME FORMAT

  /// Accepted formats in Bayzat here. Do not change these formats. If you want to change the format, please create a new method.
  /// All previous format usages replaced with these method.
  /// Only these formats should be used across codebase.
  /// https://bayzat.atlassian.net/wiki/spaces/DES/pages/1537671200/Data+formats
  ///

  String format(String pattern) {
    try {
      final DateFormat dateFormat = DateFormat(
        pattern,
      );
      dateFormat.dateSymbols.ZERODIGIT = '0';
      return dateFormat.format(this);
    } on ArgumentError {
      return DateFormat(
        pattern,
        'en',
      ).format(this);
    }
  }

  /// 04 Sep 1989
  String formatDayMonthYear({String? locale}) => format('dd MMM yyyy');

  /// 04 Sep
  String formatDayMonth({String? locale}) => format('dd MMM');

  /// Sep 1989
  String formatMonthYear({String? locale}) => format('MMM yyyy');

  /// Thu 04 Sep 1989
  String formatDayNameDayMonthYear({String? locale}) => format('EEE dd MMM yyyy');

  /// 04 Sep 1989 12:00 AM
  String formatDayMonthYearTime({String? locale}) => format('dd.MM.yyyy HH:mm');

  /// 04 Sep 1989, 12:00 AM
  String formatDayMonthYearTimeWithComma({String? locale}) => format('dd.MM.yyyy, HH:mm');

  /// 04.05.1989
  String formatDayMonthYearDot({String? locale}) => format('dd.MM.yyyy');

  /// 04.05
  String formatDayMonthDot({String? locale}) => format('dd.MM');

  /// Thu 04 Sep 1989 12:00 AM
  String formatDayNameDayMonthYearTime({String? locale}) => format('EEE dd MMM yyyy hh:mm a');

  /// September
  String formatMonth({String? locale}) => format('MMMM');

  /// 12:00:00 AM
  String formatTime({String? locale}) => format('HH:mm:ss');

  /// 12:00
  String formatTimeHourMinute({String? locale}) => format('HH:mm');

  /// 1989-09-04
  String formatToJson() => format('yyyy-MM-dd');

  /// 1989-09-04T12:00:00
  String formatToJsonWithHours() => format('yyyy-MM-ddTHH:mm:ss');

  static DateTime fromString(String dateTime) {
    if (dateTime.isEmpty || dateTime == 'null') {
      return DateTime.now();
    }
    try {
      return DateFormat('dd-MM-yyyy HH:mm:ss').parse(dateTime);
    } catch (e) {
      return DateFormat('yyyy-MM-ddTHH:mm:ss').parse(dateTime);
    }
  }

  // İçinde bulunan haftanın ilk gününü verir
  DateTime getStartOfWeek(DateTime date) {
    final int difference = date.weekday - DateTime.monday;
    return date.subtract(Duration(days: difference));
  }

  // İçinde bulunan haftanın son gününü verir
  DateTime getEndOfWeek(DateTime date) {
    final int difference = DateTime.sunday - date.weekday;
    return date.add(Duration(days: difference));
  }

  // 1 sene öncesini verir
  DateTime getOneYearAgo(DateTime date) {
    return DateTime(date.year - 1, date.month, date.day);
  }

  // 2 sene öncesini verir
  DateTime getTwoYearAgo(DateTime date) {
    return DateTime(date.year - 2, date.month, date.day);
  }
}
