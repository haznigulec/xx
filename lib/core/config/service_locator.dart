import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

final getIt = GetIt.instance;
final remoteConfig = FirebaseRemoteConfig.instance;

final talker = TalkerFlutter.init(
  settings: TalkerSettings(
    enabled: true,
    useHistory: true,
    useConsoleLogs: true,
    maxHistoryItems: 10000,
    colors: {
      TalkerLogType.httpRequest: AnsiPen()..blue(),
      TalkerLogType.httpResponse: AnsiPen()..green(),
      TalkerLogType.httpError: AnsiPen()..red(),
    },
  ),
  logger: TalkerLogger(
    settings: TalkerLoggerSettings(
      colors: {
        LogLevel.info: AnsiPen()..blue(),
      },
    ),
  ),
);
