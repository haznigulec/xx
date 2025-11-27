import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/news/pages/news_tab_page.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class NewsPage extends StatelessWidget {
  final String symbolName;
  final bool? fromSymbolDetail;

  const NewsPage({
    super.key,
    required this.symbolName,
    this.fromSymbolDetail = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr(
          'by_news',
          args: [
            symbolName,
          ],
        ),
      ),
      body: NewsTabPage(
        symbolName: symbolName,
        fromSymbolDetail: fromSymbolDetail,
      ),
    );
  }
}
