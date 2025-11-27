import 'package:flutter/widgets.dart';
import 'package:piapiri_v2/core/database/db_helper.dart';
import 'package:talker_flutter/talker_flutter.dart';

class AppRouterObserver extends TalkerRouteObserver {
  final Talker talkerInstance;

  AppRouterObserver(this.talkerInstance) : super(talkerInstance);

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name == null) {
      return;
    }
    if (previousRoute != null) {
      DatabaseHelper dbHelper = DatabaseHelper();
      dbHelper.dbLog(
        LogLevel.info,
        TalkerRouteLog(route: route),
      );
      return;
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (route.settings.name == null) {
      return;
    }
    DatabaseHelper dbHelper = DatabaseHelper();
    dbHelper.dbLog(
      LogLevel.info,
      TalkerRouteLog(route: route, isPush: false),
    );
  }
}
