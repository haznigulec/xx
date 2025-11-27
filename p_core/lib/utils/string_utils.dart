import 'dart:math';

import 'package:recase/recase.dart';
import 'package:uuid/uuid.dart';

class StringUtils {
  static String? lowercase(String? text) => text?.toLowerCase();

  static String? paramCase(String? text) => text?.paramCase;

  static String? sentenceCase(String? text) => text?.sentenceCase;

  static String? titleCase(String? text) => text?.titleCase;

  static String titleCaseForPartiallyUppercaseText(String? text) {
    if (text == null) {
      return '';
    }

    return text
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => word.toLowerCase())
        .map((word) => capitalize(word))
        .join(' ');
  }

  static String? uppercase(String? text) => text?.toUpperCase();

  static String randomNumberString(int length) {
    assert(length > 0);

    final Random random = Random();
    String output = '';
    for (int i = 0; i < length; i++) {
      output += random.nextInt(9).toString();
    }

    return output;
  }

  static String capitalize(String text) {
    if (text.isEmpty) {
      return text;
    }
    
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  String capitalizeEachWord(String input) {
    return input
        .toLowerCase()
        .split(' ')
        .map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '')
        .join(' ');
  }

  static String initials({String fullName = '', String firstName = '', String lastName = ''}) {
    if (fullName.trim().isNotEmpty) {
      final List<String> split = fullName.trim().split(' ');
      final String left = split[0][0];
      final String right = split.length > 1 ? split.last[0] : '';
      return '$left$right'.toUpperCase();
    }

    return '${firstName.trim()[0]}${lastName.trim()[0]}'.toUpperCase();
  }

  static String generateUuid() {
    const Uuid uuid = Uuid();
    return uuid.v4();
  }
}
