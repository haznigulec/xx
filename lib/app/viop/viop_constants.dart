import 'package:piapiri_v2/core/model/symbol_types.dart';

class ViopConstants {
  final Map<String, int> viopColumnValues = {
    'viop_bist_symbol': 0,
    'viop_bist_buy': 2,
    'viop_bist_sell': 3,
    'viop_bist_last_price_and_difference': 12,
    'viop_bist_difference': 10,
    'viop_bist_low': 4,
    'viop_bist_high': 5,
    'viop_bist_last_price': 6,
    'viop_bist_difference2': 11,
    'viop_bist_closing': 7,
    'viop_bist_transaction_count': 8,
    'viop_bist_transaction_volume': 9,
    'viop_bist_time': 1,
    'viop_bist_balance': 6,
    'viop_bist_balance2': 6,
  };

  Map<String, String> viopDefaultOrderTypeValueToOrder = {
    '1': '2',
    '2': 'K',
  };

  List<SymbolTypes> contractTypes = [
    SymbolTypes.future,
    SymbolTypes.option,
  ];
  
}
