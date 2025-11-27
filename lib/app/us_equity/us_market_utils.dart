import 'package:piapiri_v2/core/model/us_market_status_enum.dart';
import 'package:piapiri_v2/core/model/us_symbol_snapshot.dart';

class UsMarketUtils {
  double getDiffPercent(UsSymbolSnapshot snapshot, {bool isDividend = false}) {
    if (isDividend) {
      return snapshot.session?.regularTradingChangePercent ?? 0;
    }
    if (snapshot.marketStatus == UsMarketStatus.preMarket) {
      return snapshot.session?.earlyTradingChangePercent ?? 0;
    }
    if (snapshot.marketStatus == UsMarketStatus.afterMarket) {
      return snapshot.session?.lateTradingChangePercent ?? 0;
    }
    return snapshot.session?.regularTradingChangePercent ?? 0;
  }
}
