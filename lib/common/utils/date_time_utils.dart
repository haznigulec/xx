import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/bloc/language/bloc/language_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class DateTimeUtils {
  static String formatHHMM(String date) {
    final List<String> components = date.split(':');
    if (components.length >= 2) {
      return '${components[0]}:${components[1]}';
    }
    return date;
  }

  static String? strDateEpoc(int? date) =>
      date == null ? null : DateTime.fromMillisecondsSinceEpoch(date * 1000).formatDayMonthYear(); //14 Sep 1989

  static String? strTime(TimeOfDay? tod) {
    if (tod == null) {
      return null;
    }
    final DateTime now = clock.now();
    final DateTime dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    return dt.formatTime(); //'6:00 AM'
  }

  static int combineDateTimeAndTimeOfDay(DateTime date, TimeOfDay timeOfDay) {
    final DateTime dateStripped = DateTime(date.year, date.month, date.day, timeOfDay.hour, timeOfDay.minute);
    return dateStripped.millisecondsSinceEpoch ~/ 1000;
  }

  /// REGION DATE TIME HELPER METHODS
  static List<String> prepareHoursList([DateTime? start, DateTime? end]) {
    start ??= DateTime(1);
    end ??= DateTime(1, 1, 1, 23, 59, 59);
    final List<String> hours = [];
    for (var i = start.hour; i <= end.hour; i++) {
      final String suffix = i > 11 ? 'PM' : 'AM';
      int mod = i % 12;
      if (mod == 0) {
        mod = 12;
      }
      hours.add('$mod:00 $suffix');
      hours.add('$mod:30 $suffix');
    }
    return hours;
  }

  static TimeOfDay? timeFromString(String? time, [bool checkPeriod = false]) {
    if (time == null) {
      return null;
    }
    final bool isAM = time.contains('AM');
    final List<String> timeList = time.replaceAll(' AM', '').replaceAll(' PM', '').split(':');
    int? hour = int.tryParse(timeList[0]);
    if (hour == null || timeList.length < 2) {
      throw ArgumentError('Please provide a time in the following formats: "12:45", "03:30 AM"', 'time');
    }
    final int minute = int.parse(timeList[1]);
    if (checkPeriod) {
      if (isAM) {
        hour = hour == 12 ? 0 : hour;
      } else {
        hour = hour != 12 ? hour + 12 : hour;
      }
    }
    return TimeOfDay(hour: hour, minute: minute);
  }

  static String? mapMonth(int? m) {
    return m == null ? null : DateTime(1, m).format('MMM');
  }

  static bool areDatesInSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  ///
  /// This method returns Date of day specified with dayOrdinal in the week of given date
  ///
  /// Lets say given date is 6.10.2022 16:54 (Thursday)
  /// dayOrdinal = DateTime.tuesday
  ///
  /// Method should return 4.10.2022 00:00:00 (Tuesday)
  ///
  static DateTime findSpecifiedDayDateInWeekOfGivenDate(
    DateTime givenDate,
    int dayOrdinal,
  ) {
    assert(dayOrdinal >= DateTime.monday && dayOrdinal <= DateTime.sunday);
    final DateTime dayOfWeek = givenDate.add(Duration(days: dayOrdinal - givenDate.weekday));
    return DateTime(dayOfWeek.year, dayOfWeek.month, dayOfWeek.day);
  }

  static DateTime getLocalizedStartOfWeek(DateTime date, {bool isSundayStartOfWeek = false}) {
    // Lets say date = 6.10.2022 16:44, isSundayStartOfWeek = false
    final startOfWeekAsMonday =
        findSpecifiedDayDateInWeekOfGivenDate(date, DateTime.monday); // startOfWeekAsMonday = 3.10.2022 00:00:00
    if (isSundayStartOfWeek) {
      return startOfWeekAsMonday.subtract(const Duration(days: 1)); // return 2.10.2022 00:00:00 (sunday)
    }
    return startOfWeekAsMonday; // return 3.10.2022 00:00:00 (monday)
  }

  static DateTime getLocalizedEndOfWeek(DateTime date, {bool isSundayStartOfWeek = false}) {
    final endOfWeekAsSunday = findSpecifiedDayDateInWeekOfGivenDate(date, DateTime.sunday);
    if (isSundayStartOfWeek) {
      return endOfWeekAsSunday.subtract(const Duration(days: 1));
    }
    return endOfWeekAsSunday;
  }

  static bool dateInCurrentWeek(DateTime date, {required bool isSundayStartOfWeek}) {
    final now = clock.now(); // Lets say now = 6.10.2022 16:44, isSundayStartOfWeek = false
    final DateTime startOfWeek = getLocalizedStartOfWeek(
      now,
      isSundayStartOfWeek: isSundayStartOfWeek,
    ); // startOfWeek = 3.10.2022 00:00:00 (monday)

    final DateTime endOfWeek = getLocalizedEndOfWeek(
      now,
      isSundayStartOfWeek: isSundayStartOfWeek,
    ); // endOfWeek = 9.10.2022 00:00:00 (sunday)

    final dayAfterTheEndOfWeek = endOfWeek.add(
      const Duration(days: 1),
    ); // dayAfterTheEndOfWeek = 10.10.2022 00:00:00 (monday)

    // Check                  startOfWeek <= date < dayAfterTheEndOfWeek
    // Check  3.10.2022 00:00:00 (monday) <= date < 10.10.2022 00:00:00 (monday)
    return date.isAfterOrEqualTo(startOfWeek) && date.isBefore(dayAfterTheEndOfWeek);
  }

  static int calculateDifferenceInDays(DateTime startDate, DateTime endDate) {
    return DateTime(endDate.year, endDate.month, endDate.day)
            .difference(DateTime(startDate.year, startDate.month, startDate.day))
            .inDays +
        1;
  }

  static DateTime? dateFromTimestamp(int? timestamp, {bool isNanoTimestamp = false}) {
    if (timestamp == null) {
      return null;
    }

    return DateTime.fromMillisecondsSinceEpoch((isNanoTimestamp ? timestamp ~/ 1000000 : timestamp) * 1000);
  }

  static DateTime getDayDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime getDateOfTomorrow() {
    final DateTime currentTime = clock.now();
    return currentTime.add(const Duration(days: 1));
  }

  static DateTime getYearsAgoFromNow(int yearsCount) {
    final DateTime now = clock.now();
    return DateTime(now.year - yearsCount, now.month, now.day);
  }

  static String strTimeFromDate({DateTime? date}) {
    final DateTime unformattedDate = date ?? clock.now();
    return unformattedDate.format('HH:mm');
  }

  static DateTime getYearsAfterFromNow(int yearsCount) {
    final DateTime now = clock.now();
    return DateTime(now.year + yearsCount, now.month, now.day);
  }

  static DateTime getFirstDayOfWeek(DateTime day) {
    /// Handle Daylight Savings by setting hour to 12:00 Noon
    /// rather than the default of Midnight
    day = DateTime.utc(day.year, day.month, day.day, 12);

    /// Weekday is on a 1-7 scale Monday - Sunday,
    /// This Calendar works from Sunday - Monday
    final decreaseNum = day.weekday % 7;
    return day.subtract(Duration(days: decreaseNum));
  }

  static DateTime getLastDayOfWeek(DateTime day) {
    /// Handle Daylight Savings by setting hour to 12:00 Noon
    /// rather than the default of Midnight
    day = DateTime.utc(day.year, day.month, day.day, 12);

    /// Weekday is on a 1-7 scale Monday - Sunday,
    /// This Calendar's Week starts on Sunday
    final increaseNum = day.weekday % 7;
    return day.add(Duration(days: 7 - increaseNum));
  }

  static DateTime getLastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  static Iterable<DateTime> daysInRange(DateTime start, DateTime end) sync* {
    var i = start;
    var offset = start.timeZoneOffset;
    while (i.isBefore(end)) {
      yield i;
      i = i.add(const Duration(days: 1));
      final timeZoneDiff = i.timeZoneOffset - offset;
      if (timeZoneDiff.inSeconds != 0) {
        offset = i.timeZoneOffset;
        i = i.subtract(Duration(seconds: timeZoneDiff.inSeconds));
      }
    }
  }

  static String dateFormat(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy').format(dateTime);
  }

  static String dateFormatAndTime(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy, HH:mm').format(dateTime);
  }

  static String timeFormat(DateTime dateTime, {bool showSeconds = false}) {
    if (showSeconds) {
      return DateFormat('HH:mm:ss').format(dateTime);
    }
    return DateFormat('HH:mm').format(dateTime);
  }

  static String monthAndYear(String date, String locale) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('MMMM yyyy', locale).format(dateTime);
  }

  static DateTime fromMonthAndYearToDate(String date, String locale) {
    DateFormat format = DateFormat('MMMM yyyy', locale);
    return format.parse(date);
  }

  static String dayMonthAndYear(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd MMMM yyyy', Intl.defaultLocale).format(dateTime);
  }

  static String daySortMonthAndYear(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd.MM.yyyy', Intl.defaultLocale).format(dateTime);
  }

  static String serverDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static DateTime strToDate(String date) {
    return DateFormat('dd.MM.yyyy').parse(date);
  }

  static DateTime strToTime(String date) {
    return DateFormat('HH:mm').parse(date);
  }

  static String nanoSecondTimestampToTime(int? nanosecondTimestamp) {
    if (nanosecondTimestamp == null) {
      return '-';
    }
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
      nanosecondTimestamp ~/ 1000000, // nano -> millis
    ).add(const Duration(hours: 3));
    final formatter = DateFormat('HH:mm:ss');
    return formatter.format(dateTime);
  }

  static DateTime strToNowAndTime(String timeString) {
    DateTime now = DateTime.now();
    DateTime parsed = DateFormat('HH:mm').parse(timeString);

    return DateTime(
      now.year,
      now.month,
      now.day,
      parsed.hour,
      parsed.minute,
      parsed.second,
    );
  }

  static String serverDateAndTime(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }

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

  static DateTime fromString2(String dateTime) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss').parse(dateTime);
  }

  static String dateAndTimeFromDate(DateTime dateTime, {bool showSeconds = false, String splitter = ''}) {
    if (showSeconds) {
      return DateFormat('dd.MM.yyyy$splitter HH:mm:ss').format(dateTime);
    }
    return DateFormat('dd.MM.yyyy$splitter HH:mm').format(dateTime);
  }

  static int toMilliseconds(DateTime date) {
    return date.millisecondsSinceEpoch;
  }

  static String serverDateAndTimeWithZone(DateTime date) {
    return DateFormat('yyyy-MM-ddTHH:mm:ss').format(date);
  }

  static DateTime fromServerDate(String dateTime) {
    return DateFormat('yyyy-MM-dd').parse(dateTime);
  }

  static String pairedDeviceConvert(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy, HH:mm').format(dateTime);
  }

  static DateTime? parseMultiLangDate(String date) {
    final Map<String, String> monthMap = {
      // Türkçe
      'Ocak': '01',
      'Şubat': '02',
      'Mart': '03',
      'Nisan': '04',
      'Mayıs': '05',
      'Haziran': '06',
      'Temmuz': '07',
      'Ağustos': '08',
      'Eylül': '09',
      'Ekim': '10',
      'Kasım': '11',
      'Aralık': '12',
      // İngilizce
      'January': '01',
      'February': '02',
      'March': '03',
      'April': '04',
      'May': '05',
      'June': '06',
      'July': '07',
      'August': '08',
      'September': '09',
      'October': '10',
      'November': '11',
      'December': '12',
    };

    final List<String> dateTimeParts = date.split(' ');
    if (dateTimeParts.length < 3 || dateTimeParts.length > 4) {
      return null;
    }

    final String day = dateTimeParts[0];
    final String month = monthMap[dateTimeParts[1]]!;
    final String year = dateTimeParts[2];
    String time = '00:00:00';

    if (dateTimeParts.length == 4) {
      final String hourMinute = dateTimeParts[3];
      time = '$hourMinute:00';
    }

    final String formattedDateTime = '$year-$month-$day $time';
    try {
      return DateTime.parse(formattedDateTime);
    } catch (e) {
      return DateTime.now();
    }
  }

  static DateTime moveDateToWeekday(DateTime date) {
    int dayOfWeek = date.weekday;
    if (dayOfWeek != DateTime.saturday && dayOfWeek != DateTime.sunday) {
      return date;
    } else if (dayOfWeek == DateTime.saturday) {
      return date.add(
        const Duration(days: 2),
      );
    } else {
      return date.add(
        const Duration(days: 1),
      );
    }
  }

  DateTime checkStopLossDate(DateTime periodEndDate) {
    DateTime newPeriodEndDate = periodEndDate;
    DateTime sessionCloseTime = DateTime(newPeriodEndDate.year, newPeriodEndDate.month, newPeriodEndDate.day, 18, 10);
    if (newPeriodEndDate.isAfter(sessionCloseTime)) {
      newPeriodEndDate = newPeriodEndDate.add(const Duration(days: 1));
    }
    newPeriodEndDate = moveToSessionDate(newPeriodEndDate);
    return newPeriodEndDate;
  }

  static String monthToPeriodLocalization(String month) {
    if (int.parse(month) <= 3) {
      return 'first_quarter';
    }
    if (int.parse(month) <= 6) {
      return 'second_quarter';
    }
    if (int.parse(month) <= 9) {
      return 'third_quarter';
    }
    return 'fourth_quarter';
  }

  static List<String> getViopMaturity(List<String> viopMaturityList) {
    // Tarihleri parse edip Set olarak toplama (tekrarı önlemek için)
    Set<DateTime> uniqueDates = viopMaturityList.map((date) => DateTime.parse(date)).toSet();

    // Tarihleri sıralama
    List<DateTime> sortedDates = uniqueDates.toList()..sort((a, b) => a.compareTo(b));

    // Tarihleri formatlı hale getirme
    List<String> result = sortedDates
        .map((date) {
          return DateFormat(
                  'MMMM yyyy', '${getIt<LanguageBloc>().state.languageCode}_${getIt<LanguageBloc>().state.countryCode}')
              .format(date);
        })
        .toSet()
        .toList();

    return result;
  }

  static String stringTommmmyy(String date) {
    return DateFormat(
            'MMMM yyyy', '${getIt<LanguageBloc>().state.languageCode}_${getIt<LanguageBloc>().state.countryCode}')
        .format(DateTime.parse(date));
  }

  static DateTime mmmmyyToDateTime(String mmmmyy) {
    return DateFormat(
            'MMMM yyyy', '${getIt<LanguageBloc>().state.languageCode}_${getIt<LanguageBloc>().state.countryCode}')
        .parse(mmmmyy);
  }

  bool isWeekend({DateTime? date}) {
    DateTime now = date ?? DateTime.now();
    return now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;
  }

  bool isHoliday({DateTime? date}) {
    return getIt<AppInfoBloc>().state.holidays.contains(
          DateTimeUtils.serverDate(
            date ?? DateTime.now(),
          ),
        );
  }

  DateTime moveToSessionDate(DateTime date) {
    DateTime selectedDate = date;
    while (DateTimeUtils().isWeekend(date: selectedDate) || DateTimeUtils().isHoliday(date: selectedDate)) {
      selectedDate = selectedDate.add(const Duration(days: 1));
    }

    return selectedDate;
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
