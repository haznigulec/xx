import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:talker_flutter/talker_flutter.dart';

@RoutePage()
class LogsPage extends StatelessWidget {
  const LogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TalkerScreen(
      talker: talker,
    );
  }
}
