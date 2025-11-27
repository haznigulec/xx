import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';
import 'package:piapiri_v2/common/utils/local_keys.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/us_market_status_enum.dart';
import 'package:piapiri_v2/core/model/us_symbol_snapshot.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';

//Todo: Bu sınıfı kullanmadan önce locale'yi belirlemek gerekiyor.

class MoneyUtils {
  String handleValueByLocation(String value) {
    // Gelen double değeri langCode'ye göre ayırır. (Örneğin;türkçede 27,37 - ingilizcede 27.37)
    String languageCode = "tr";
    if (getIt<LocalStorage>().read(LocalKeys.languageCode) == null) {
      languageCode = "tr";
    } else {
      languageCode = getIt<LocalStorage>().read(LocalKeys.languageCode).toString();
    }

    if (value.contains("NaN") || value.contains("null") || value.contains("Infinity")) {
      return "0.0";
    } else {
      return NumberFormat.currency(locale: languageCode, symbol: '').format(double.parse(value));
    }
  }

  final _compactFormatter = NumberFormat.compactCurrency(
    decimalDigits: 2,
    locale: 'tr', //getIt<AppInfoBloc>().state.language,
    symbol: '',
  );

  final _compactLongFormatter = NumberFormat.compactLong(
    locale: 'tr', //getIt<AppInfoBloc>().state.language,
  );

  String compactMoney(double money) {
    return _compactFormatter.format(money);
  }

  int convertStringToNumber(String input) {
    input = input.trim().toUpperCase();
    num multiplier = 1;

    if (input.endsWith('M') || input.endsWith('Mn')) {
      multiplier = 1000000;
      input = input.substring(0, input.length - 1);
    } else if (input.endsWith('B') || input.endsWith('Mr')) {
      multiplier = 1000000000;
      input = input.substring(0, input.length - 1);
    } else if (input.endsWith('T') || input.endsWith('Tr')) {
      multiplier = 1000000000000;
      input = input.substring(0, input.length - 1);
    }

    input = input.replaceAll(',', '.');
    double number = double.parse(input);

    return (number * multiplier).toInt();
  }

  String compactLong(double money) {
    return _compactLongFormatter.format(money);
  }

  String readableMoney(
    num money, {
    String pattern = '#,##0.00',
  }) {
    NumberFormat numberFormat = NumberFormat(pattern, Intl.defaultLocale);
    String formattedMoney = numberFormat.format(money);
    return formattedMoney == 'NaN' ? '0,00' : formattedMoney;
  }

  String editableMoney(
    double money, {
    String pattern = '###0.00',
  }) {
    NumberFormat numberFormat = NumberFormat(pattern, Intl.defaultLocale);
    String formattedMoney = numberFormat.format(money);
    return formattedMoney == 'NaN' ? '0,00' : formattedMoney;
  }

  String ratioFormat(
    double number, {
    String pattern = '#,##0.00',
  }) {
    String lang = Intl.defaultLocale ?? 'tr';

    NumberFormat numberFormat = NumberFormat(pattern, lang);
    String formattedNum = numberFormat.format(number);
    formattedNum = formattedNum == 'NaN' ? '0,00' : formattedNum;
    return lang != 'en' ? '%$formattedNum' : '$formattedNum%';
  }

  double fromReadableMoney(String money) {
    if (money.isEmpty) {
      return 0;
    }
    String lang = Intl.defaultLocale ?? 'tr';
    if (lang == 'tr') {
      money = money.replaceAll('.', '');
      money = money.replaceAll(',', '.');
    } else {
      money = money.replaceAll(',', '');
    }
    return double.tryParse(money) ?? 0;
  }

  generalNumberFormat(num number) {
    NumberFormat numberFormat = NumberFormat.compact();
    return numberFormat.format(number);
  }

  String getCurrency(SymbolTypes type) {
    return type == SymbolTypes.foreign
        ? CurrencyEnum.dollar.symbol
        : type != SymbolTypes.crypto && type != SymbolTypes.parity && type != SymbolTypes.indexType
            ? CurrencyEnum.turkishLira.symbol
            : '';
  }

  double getPrice(MarketListModel symbol, OrderActionTypeEnum? actionType) {
    double price = 0;
    if (actionType != null) {
      price = actionType == OrderActionTypeEnum.sell ? symbol.ask : symbol.bid;
    }
    if (price == 0) {
      price = symbol.last != 0
          ? symbol.last
          : symbol.dayClose != 0
              ? symbol.dayClose
              : symbol.weekClose;
    }
    return price;
  }

  List<double> getPriceSteps({
    required double price,
    required double priceStep,
    required double limitUp,
    required double limitDown,
    required String marketCode,
    String? symbolType,
    String? subMarketCode,
    String? pattern,
  }) {
    String defaultPattern = pattern ?? '#,##0.00';

    List<double> steps = [];
    if (priceStep == 0) {
      return steps;
    }
    double limitDown0 = MoneyUtils().fromReadableMoney(MoneyUtils().readableMoney(limitDown, pattern: defaultPattern));
    limitDown0 = (limitDown0 / priceStep).round() * priceStep;
    double limitUp0 = MoneyUtils().fromReadableMoney(MoneyUtils().readableMoney(limitUp, pattern: defaultPattern));
    limitUp0 = (limitUp0 / priceStep).round() * priceStep;
    double selectedValue = MoneyUtils().fromReadableMoney(MoneyUtils().readableMoney(price, pattern: defaultPattern));
    if (price < limitDown0) {
      selectedValue = limitDown0;
    }
    if (selectedValue > limitUp0) {
      selectedValue = limitUp0;
    }
    selectedValue = (selectedValue / priceStep).round() * priceStep;

    double price0 = selectedValue;
    while (price0 <= limitUp0 && steps.length < 250) {
      steps.add(price0);
      double currentPriceStep = Utils().getPriceStep(price0, symbolType, marketCode, subMarketCode, priceStep);
      double newPrice = price0 + currentPriceStep;
      price0 = MoneyUtils().fromReadableMoney(MoneyUtils().readableMoney(newPrice, pattern: defaultPattern));
    }
    price0 = selectedValue;
    while (price0 > limitDown0 && steps.length < 500) {
      double currentPriceStep = Utils().getPriceStep(price0, symbolType, marketCode, subMarketCode, priceStep);
      double newPrice = price0 - currentPriceStep;
      double newPriceStep = Utils().getPriceStep(newPrice, symbolType, marketCode, subMarketCode, priceStep);
      if (currentPriceStep != newPriceStep) {
        newPrice = price0 - newPriceStep;
      }
      price0 = MoneyUtils().fromReadableMoney(MoneyUtils().readableMoney(newPrice, pattern: defaultPattern));
      steps.add(price0);
    }
    if (price0 > limitDown0) {
      steps.add(limitDown0);
    }
    steps.sort((a, b) => b.compareTo(a));
    if (steps.first != limitUp0) {
      steps.insert(0, limitUp0);
    }
    if (steps.last != limitDown0) {
      steps.add(limitDown0);
    }
    return steps;
  }

  double findClosestPrice(double num, List<double> priceStepList) {
    if (priceStepList.isEmpty) {
      return 0;
    }
    double closest = priceStepList[0];
    for (double i in priceStepList) {
      if ((i - num).abs() < (closest - num).abs()) {
        closest = i;
      }
    }
    return closest;
  }

  int countDecimalPlaces(double value) {

    String formatted = Decimal.parse(value.toString()).toString();

    // Sayı 0'dan küçük ve 1'den büyük değilse başa '0' ekleyelim (e.g. ',000000092' -> '0,000000092')
    if (formatted.startsWith('.')) {
      formatted = '0$formatted';
    }

    if (formatted.contains('.')) {
      int unitDecimal = formatted.split('.').last.length;
      if (unitDecimal > 9) {
        unitDecimal = 9;
      }
      return unitDecimal;
    }
    return 0; // Ondalık kısım yoksa 0 döner.
  }

  String getPatternByUnitDecimal(num value) {

    String formatted = Decimal.parse(value.toString()).toString();

    // Sayı 0'dan küçük ve 1'den büyük değilse başa '0' ekleyelim (e.g. ',000000092' -> '0,000000092')
    if (formatted.startsWith('.')) {
      formatted = '0$formatted';
    }
    if (formatted.contains('.')) {
      formatted = formatted.replaceAll(RegExp(r'0+$'), ''); // Sondaki tüm sıfırları kaldır
      formatted = formatted.replaceAll(RegExp(r'\.$'), ''); // Eğer sadece nokta kaldıysa onu da kaldır
    }
    if (formatted.contains('.')) {
      int unitDecimal = formatted.split('.').last.length;

      if (unitDecimal > 9) {
        unitDecimal = 9;
      }

      return '#,##0.${'0' * unitDecimal}';
    }

    return '#,##0';
  }

  String getPricePattern(SymbolTypes type, String? subMarketCode) {
    return type == SymbolTypes.crypto || type == SymbolTypes.parity || subMarketCode == 'CRF' || subMarketCode == 'CRFU'
        ? '#,##0.0000#####'
        : '#,##0.00';
  }

  String getDecimalSeparator() {
    final locale = Intl.defaultLocale;
    final isTurkish = locale == 'tr';
    return isTurkish ? ',' : '.';
  }

  String getUsPrice(UsSymbolSnapshot? symbol) {
    double price = 0;
    if (symbol == null) {
      price = 0;
    }
    if (symbol?.marketStatus == UsMarketStatus.open) {
      price = symbol?.fmv ?? 0.0;
    }
    if (symbol?.marketStatus == UsMarketStatus.closed || symbol?.marketStatus == UsMarketStatus.afterMarket) {
      price = symbol?.session?.close ?? 0.0;
    }
    if (symbol?.marketStatus == UsMarketStatus.preMarket) {
      price = symbol?.session?.close ?? 0.0;
    }
    return MoneyUtils().readableMoney(
      price,
      pattern: price >= 1 ? '#,##0.00' : '#,##0.0000#####',
    );
  }

  double roundPrice({required double price, required double priceStep, bool roundFloor = true}) {
    const double tolerance = 0.02;
    double raw = price / priceStep;
    double fraction = raw - raw.floor();
    double newPrice;
    if (fraction >= 1 - tolerance) {
      newPrice = raw.round() * priceStep;
    } else {
      newPrice = (roundFloor ? raw.floor() : raw.ceil()) * priceStep;
    }

    return double.parse(newPrice.toStringAsFixed(2));
  }
}
