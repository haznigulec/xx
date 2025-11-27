import 'package:intl/intl.dart';

class NumberUtils {
  // 1100 => 1.1k
  static String getPrettyCount(int? number) {
    if (number == null || number == 0) {
      return '';
    }
    return NumberFormat.compact(locale: 'en_US').format(number).toLowerCase();
  }

  static String doubleToString(double? number) {
    if (number == null) {
      return '';
    }
    final NumberFormat formatter = NumberFormat('###.##');
    return formatter.format(number);
  }

  static String removeExtraDecimalPoints(String val) {
    final List<String> components = val.split('.');

    if (components.length == 2 && (components[1] == '00' || components[1] == '0')) {
      return components[0];
    }

    return val;
  }

  static String removeExtraDecimalZeros(double val) {
    final strVal = doubleToString(val);
    final List<String> components = strVal.split('.');

    if (components.length == 2 && (components[1] == '00' || components[1] == '0')) {
      return components[0];
    }

    return strVal;
  }

  // 123 => 123
  // 1234 => 1,234
  // 1234.0 => 1,234
  // 1234.15 => 1,234.15
  // 16987 => 16,987
  // 13876 => 13,876
  // 456786 => 456,786
  // 4456786 => 4,456,786
  // 44456786 => 44,456,786
  // 444156786 => 444,156,786
  static String getFormattedNumberWithThousandsSeparators(double number) {
    return NumberFormat.decimalPattern('en_US').format(number);
  }

  static String ordinal(int number) {
    if (number < 1) {
      throw Exception('Invalid number with value $number');
    }

    final int lastTwoDigits = number % 100;

    if (lastTwoDigits >= 11 && lastTwoDigits <= 13) {
      return 'th';
    }

    switch (number % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  static String toOrdinalString(int number) {
    return '$number${ordinal(number)}';
  }
}
