// main.dart veya uygulama başlatma dosyanız
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:piapiri_v2/app.dart';
import 'package:piapiri_v2/app/keyboard_controller.dart';
import 'package:piapiri_v2/core/config/service_locator_manager.dart';
import 'package:piapiri_v2/core/database/db.dart';
import 'package:piapiri_v2/firebase_starter.dart';

Future<void> initApp(
  FirebaseOptions option,
  Future<void> Function(RemoteMessage) handler,
) async {
  await FirebaseStarter(option, handler).init();
  // Bu satırı buraya eklemek, kontrolcünün uygulama başlarken oluşturulmasını sağlar.
  keyboardController; // Sadece örneğe erişerek başlatılmasını tetikler

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await ServiceLocatorManager.registerObjects();
  await DB.instance.database;
  numberFormatSymbols['tr'] = const NumberSymbols(
    NAME: 'tr_TR',
    DECIMAL_SEP: ',',
    GROUP_SEP: '.',
    ZERO_DIGIT: '0',
    PLUS_SIGN: '+',
    MINUS_SIGN: '-',
    EXP_SYMBOL: 'E',
    PERCENT: '%',
    INFINITY: '∞',
    NAN: 'NaN',
    DECIMAL_PATTERN: '#,##0.###',
    SCIENTIFIC_PATTERN: '#E0',
    PERCENT_PATTERN: '#,##0%',
    CURRENCY_PATTERN: '#,##0.00',
    PERMILL: '\u2030',
    DEF_CURRENCY_CODE: 'TRY',
  );

  numberFormatSymbols['en'] = const NumberSymbols(
    NAME: 'en_US',
    DECIMAL_SEP: '.',
    GROUP_SEP: ',',
    ZERO_DIGIT: '0',
    PLUS_SIGN: '+',
    MINUS_SIGN: '-',
    EXP_SYMBOL: 'E',
    PERCENT: '%',
    INFINITY: '∞',
    NAN: 'NaN',
    DECIMAL_PATTERN: '#,##0.###',
    SCIENTIFIC_PATTERN: '#E0',
    PERCENT_PATTERN: '#,##0%',
    CURRENCY_PATTERN: '#,##0.00',
    PERMILL: '\u2030',
    DEF_CURRENCY_CODE: 'USD',
  );

  Intl.defaultLocale = 'tr';

  runApp(
    const App(),
  );
}
