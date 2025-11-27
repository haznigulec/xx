class WarrantConstants {
  final Map<String, int> warrantColumnValues = {
    'warrant_bist_symbol': 0,
    'warrant_bist_buy': 2,
    'warrant_bist_sell': 3,
    'warrant_bist_last_price_and_difference': 12,
    'warrant_bist_difference': 10,
    'warrant_bist_low': 4,
    'warrant_bist_high': 5,
    'warrant_bist_last_price': 6,
    'warrant_bist_difference2': 11,
    'warrant_bist_closing': 7,
    'warrant_bist_transaction_count': 8,
    'warrant_bist_transaction_volume': 9,
    'warrant_bist_time': 1,
    'warrant_bist_balance': 6,
    'warrant_bist_balance2': 6,
  };
  final List<String> warrantChartTypes = [
    'warrant_price',
    'delta',
    'gamma',
    'theta',
    'vega',
  ];

  final Map<String, String> marketMakertoIssuer = {
    'AKM': 'AKM',
    'UNS': 'GSI',
    'IYF': 'IYF',
    'TBY': 'BNP',
    'IYM': 'IYM',
    'GRM': 'TGB',
  };
}
