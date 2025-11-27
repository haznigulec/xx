import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';

class ShowCaseUtils {
  static bool onCheckShowCaseEvent(ShowCaseEnum showCase) {
    return getIt<LocalStorage>().read(showCase.value) == null ? true : false;
  }

  static onAddShowCaseEvent(ShowCaseEnum showCase) {
    getIt<LocalStorage>().write(showCase.value, showCase.value);
  }
}

enum ShowCaseEnum {
  marketsCase('marketsCase'),
  bistCase('bistCase'),
  portfolioCase('portfolioCase'),
  quickBuySellCase('quickBuySellCase');

  const ShowCaseEnum(this.value);
  final String value;
}
