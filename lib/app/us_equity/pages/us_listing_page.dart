import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/us_equity/pages/us_listing_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/model/sort_enum.dart';
import 'package:piapiri_v2/core/model/us_market_movers_enum.dart';

@RoutePage()
class UsListingPage extends StatelessWidget {
  final String title;
  final UsMarketMovers? usMarketMovers;
  final List<String>? symbolNames;
  final List<String> ignoreUnsubscribeSymbols;
  final SortEnum sortenum;
  const UsListingPage({
    super.key,
    required this.title,
    this.usMarketMovers,
    this.symbolNames,
    this.ignoreUnsubscribeSymbols = const [],
    this.sortenum = SortEnum.none,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: title,
      ),
      body: SingleChildScrollView(
        child: USListingWidget(
          usMarketMovers: usMarketMovers,
          symbolNames: symbolNames,
          ignoreUnsubscribeSymbols: ignoreUnsubscribeSymbols,
        ),
      ),
    );
  }
}
