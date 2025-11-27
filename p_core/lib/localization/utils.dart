import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:p_core/localization/language_type.dart';

class LocalizationUtils {
  static String getStrLocale(BuildContext context) => Localizations.localeOf(context).languageCode;

  static LanguageType getLanguage(BuildContext context, {String? savedLocaleString}) {
    final String localeString = savedLocaleString ?? Localizations.localeOf(context).languageCode;
    return Locale(localeString) == const Locale('tr') ? LanguageType.tr : LanguageType.en;
  }

  static String getStrLanguage(BuildContext context) => getLanguage(context) == LanguageType.tr ? 'tr' : 'en';

  static LanguageType getNextLanguage(LanguageType language) =>
      language == LanguageType.en ? LanguageType.tr : LanguageType.en;

  static Future<void> setLocale(String locale) async {
    Intl.defaultLocale = locale;
  }
}
