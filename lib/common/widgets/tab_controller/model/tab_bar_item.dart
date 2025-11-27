import 'package:piapiri_v2/common/widgets/exchange_overlay/widgets/show_case_view.dart';
import 'package:flutter/widgets.dart';

class PTabItem {
  final String title;
  final Widget page;
  final ShowCaseViewModel? showCase;
  PTabItem({
    required this.title,
    required this.page,
    this.showCase,
  });
}
