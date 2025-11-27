import 'dart:io';

import 'package:flutter/foundation.dart';

class PlatformUtils {
  static bool _showCupertinoWidgets = false;

  static bool get isIos => (!kIsWeb && Platform.isIOS) || _showCupertinoWidgets;

  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  static bool get isMobile => (isIos || isAndroid) && !kIsWeb;

  static void setShowCupertinoWidgetsValue(bool value) {
    if (kIsWeb) {
      _showCupertinoWidgets = value;
    }
  }
}
