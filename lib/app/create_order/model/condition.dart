import 'package:piapiri_v2/core/model/condition_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';

class Condition {
  MarketListModel symbol;
  double price;
  ConditionEnum condition;

  Condition({
    required this.symbol,
    required this.price,
    required this.condition,
  });
}
