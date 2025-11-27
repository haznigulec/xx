import 'package:piapiri_v2/core/model/market_list_model.dart';

class SymbolDetailUtils {
  /// subscribe olunanan sembolde aciklama ve underlying gibi alanlar bos geliyor ve bizim databseden
  /// gelen datalari kullanmamiz gerekiyor bu yuzden bu fonksiyon ile subscribe olunan sembolun
  ///  aciklama ve underlying gibi alanlarini databaseden gelen datalar ile dolduruyoruz.
  MarketListModel fetchWithSubscribedSymbol(MarketListModel mainSymbol, MarketListModel? fetchSymbol) {
    if (fetchSymbol == null) {
      return mainSymbol;
    }
    return mainSymbol.copyWith(
      underlying: fetchSymbol.underlying,
      marketCode: fetchSymbol.marketCode,
      exchangeCode: fetchSymbol.exchangeCode,
      swapType: fetchSymbol.swapType,
      actionType: fetchSymbol.actionType,
      description: fetchSymbol.description,
      multiplier: fetchSymbol.multiplier,
      issuer: fetchSymbol.issuer,
      optionType: fetchSymbol.optionType,
      optionClass: fetchSymbol.optionClass,
      maturity: fetchSymbol.maturity,
      sectorCode: fetchSymbol.sectorCode,
      tradeStatus: fetchSymbol.tradeStatus,
    );
  }
}
