import 'package:collection/collection.dart';
import 'package:piapiri_v2/app/create_us_order/bloc/create_us_orders_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/us_symbol_snapshot.dart';

class CreateOrdersUtils {
  final CreateUsOrdersBloc createUsOrdersBloc = getIt<CreateUsOrdersBloc>();

  //Komisyon hesaplamasi yapar
  // Adet basina komisyon * adet  minimum komisyondan buyukse hesaplanan komisyonu doner
  // degilse minimum komisyonu doner
  double calculateCommission(double unit) {
    double calculatedCommision = unit * createUsOrdersBloc.state.commissionPerUnit;
    if (calculatedCommision > createUsOrdersBloc.state.minCommission) {
      return calculatedCommision;
    } else {
      return createUsOrdersBloc.state.minCommission;
    }
  }

  String getUnitPattern(bool fractionable, num rawUnit) {
    if (!fractionable) return '#,##0';
    if (rawUnit == 0) return '#,##0.0';
    return MoneyUtils().getPatternByUnitDecimal(rawUnit);
  }

  bool refreshWhen(UsEquityState previous, UsEquityState current, UsSymbolSnapshot? symbol, bool didPriceGet) {
    if (previous.polygonWatchingItems.firstWhereOrNull((e) => e.ticker == symbol?.ticker)?.marketStatus !=
        current.polygonWatchingItems.firstWhereOrNull((e) => e.ticker == symbol?.ticker)?.marketStatus) {
      return true;
    }
    if (symbol == null) return false;
    if (didPriceGet) return false;
    if (!current.polygonWatchingItems.any((e) => e.ticker == symbol.ticker)) return false;
    return true;
  }

}
