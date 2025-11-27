import 'package:piapiri_v2/core/model/filter_category_model.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';

abstract class EquityRepository {
  Future<List<MarketListModel>> getSymbolInfo({
    required FilterCategoryItemModel selectedList,
  });
}
