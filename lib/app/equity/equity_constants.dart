import 'package:piapiri_v2/core/model/filter_category_model.dart';

class EquityConstants {
  List<FilterCategoryItemModel> indexShares = const [
    FilterCategoryItemModel(
      localization: 'BIST 30',
      value: 'XU030',
      type: '1',
    ),
    FilterCategoryItemModel(
      localization: 'BIST 50',
      value: 'XU050',
      type: '1',
    ),
    FilterCategoryItemModel(
      localization: 'BIST 100',
      value: 'XU100',
      type: '1',
    ),
    FilterCategoryItemModel(
      localization: 'all',
      value: 'XUTUM',
      type: '1',
    ),
  ];

  List<FilterCategoryItemModel> highlights = const [
    FilterCategoryItemModel(
      localization: 'BIST_Increasing',
      value: 'high',
      type: '20',
    ),
    FilterCategoryItemModel(
      localization: 'BIST_Decreasing',
      value: 'low',
      type: '20',
    ),
    FilterCategoryItemModel(
      localization: 'Volume_Leaders',
      value: 'volume',
      type: '20',
    ),
  ];

  List<FilterCategoryItemModel> markets = const [
    FilterCategoryItemModel(
      localization: 'BIST_Stars',
      value: 'Yıldız Pazar',
      type: '3',
    ),
    FilterCategoryItemModel(
      localization: 'BIST_Main',
      value: 'Ana Pazar',
      type: '3',
    ),
    FilterCategoryItemModel(
      localization: 'BIST_SubMarket',
      value: 'Alt Pazar',
      type: '3',
    ),
    FilterCategoryItemModel(
      localization: 'Watchlist_Platform',
      value: 'Yakin İzleme Pazarı',
      type: '3',
    ),
    FilterCategoryItemModel(
      localization: 'Structured_Products_Fund_Market',
      value: 'Kollektif&Yapılandırılmış Ürünler Pazarı',
      type: '4',
    ),
    FilterCategoryItemModel(
      localization: 'PreMarket_Trading_Platform',
      value: 'Piyasa Öncesi İşlem Platformu',
      type: '3',
    ),
  ];

  List<FilterCategoryItemModel> indices = const [
    FilterCategoryItemModel(
      localization: 'equity_indices',
      value: 'BISTEX',
      type: '2',
    ),
    FilterCategoryItemModel(
      localization: 'viop_indices',
      value: 'BISTVIOP',
      type: '2',
    ),
    FilterCategoryItemModel(
      localization: 'etf_indices',
      value: 'YFONLARI',
      type: '2',
    ),
  ];

  List<FilterCategoryItemModel> indexSubDownItemLists = const [
    FilterCategoryItemModel(
      localization: 'index.sublist.BISTEX',
      value: 'BISTEX',
      type: '2',
    ),
    FilterCategoryItemModel(
      localization: 'index.sublist.BISTVIOP',
      value: 'BISTVIOP',
      type: '2',
    ),
    FilterCategoryItemModel(
      localization: 'index.sublist.YFONLARI',
      value: 'YFONLARI',
      type: '2',
    ),
    FilterCategoryItemModel(
      localization: 'index.sublist.DUNYAEX',
      value: 'DUNYAEX',
      type: '2',
    ),
    FilterCategoryItemModel(
      localization: 'index.sublist.CRYPTOCURRENCY',
      value: 'CRYPTOCURRENCY',
      type: '2',
    ),
    FilterCategoryItemModel(
      localization: 'index.sublist.FOREX',
      value: 'FOREX',
      type: '2',
    ),
    FilterCategoryItemModel(
      localization: 'index.sublist.TURIB',
      value: 'TURIB',
      type: '2',
    ),
    FilterCategoryItemModel(
      localization: 'index.sublist.MATRIKS',
      value: 'MATRIKS',
      type: '2',
    ),
  ];

  Map<String, int> equityColumnValues = {
    'equity_column_symbol': 0,
    'equity_bist_buy': 2,
    'equity_bist_sell': 3,
    'equity_bist_last_price_and_difference': 12,
    'equity_column_difference': 10,
    'equity_bist_low': 4,
    'equity_bist_high': 5,
    'equity_column_last_price': 6,
    'equity_bist_difference2': 11,
    'equity_bist_closing': 7,
    'equity_bist_transaction_count': 8,
    'equity_bist_transaction_volume': 9,
    'equity_bist_time': 1,
    'equity_bist_balance': 5,
    'equity_bist_balance2': 5,
  };
}
