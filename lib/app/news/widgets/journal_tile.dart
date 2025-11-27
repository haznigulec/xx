import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/news/widgets/journal_instrument_list.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/news_model.dart';

class JournalTile extends StatelessWidget {
  final News news;
  final MarketListModel? symbol;
  final String appBarTitle;
  const JournalTile({
    super.key,
    required this.news,
    this.symbol,
    required this.appBarTitle,
  });

  @override
  Widget build(BuildContext context) {
    String date = news.date ?? '';
    DateTime localtime = DateTime.parse(date).toLocal();

    return InkWell(
      onTap: () {
        router.push(
          JournalDetailRoute(
            news: news,
            symbol: symbol,
            appBarTitle: appBarTitle,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Grid.m,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          spacing: Grid.xs,
          children: [
            Text(
              news.headline ?? '',
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: context.pAppStyle.labelReg14textPrimary,
            ),
            Text(
              DateTime.parse(date)
                  .add(
                    Duration(
                      hours: localtime.timeZoneOffset.inHours,
                    ),
                  )
                  .formatDayMonthYearTimeWithComma(),
              textAlign: TextAlign.left,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.pAppStyle.labelMed12textSecondary,
            ),
            if (news.symbol != null && news.symbol!.isNotEmpty)
              JournalInstrumentList(
                news: news,
                symbol: symbol,
                maxWidth: MediaQuery.sizeOf(context).width,
              ),
          ],
        ),
      ),
    );
  }
}
