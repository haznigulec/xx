import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/config/app_config.dart';

class FirebaseStarter {
  final FirebaseOptions firebaseOptions;
  final Future<void> Function(RemoteMessage) handler;

  FirebaseStarter(this.firebaseOptions, this.handler);

  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      name: 'Piapiri',
      options: firebaseOptions,
    );

    FirebaseMessaging.onBackgroundMessage(handler);

    final crashlytics = FirebaseCrashlytics.instance;
    await crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);

    FlutterError.onError = (FlutterErrorDetails details) {
      final exceptionString = details.exceptionAsString();

      final bool isIcon404 = exceptionString.isNotEmpty &&
          exceptionString.contains('HttpException: Invalid statusCode: 404') &&
          exceptionString.contains('/icons/');
      if (isIcon404) {
        crashlytics.recordError(
          details.exception,
          details.stack ?? StackTrace.empty,
          fatal: false,
          printDetails: AppConfig.instance.flavor != Flavor.prod,
        );
        return;
      }
      crashlytics.recordFlutterFatalError(details);
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      final errorString = error.toString();
      final bool isIcon404 = errorString.isNotEmpty &&
          errorString.contains('HttpException: Invalid statusCode: 404') &&
          errorString.contains('/icons/');
      crashlytics.recordError(
        error,
        stack,
        fatal: isIcon404 ? false : true,
        printDetails: AppConfig.instance.flavor != Flavor.prod,
      );
      return true;
    };
  }
}
