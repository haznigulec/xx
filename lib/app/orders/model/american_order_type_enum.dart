import 'package:piapiri_v2/core/model/order_action_type_enum.dart';

enum AmericanOrderTypeEnum {
  market('market', 'market_order', 'market_order_description',
      [OrderActionTypeEnum.buy, OrderActionTypeEnum.sell]), // Piyasa Emri
  limit('limit', 'limit_order', 'limit_order_description',
      [OrderActionTypeEnum.buy, OrderActionTypeEnum.sell]), // Limit Emri
  stop('stop', 'stopOrder', 'stop_order_description', [OrderActionTypeEnum.buy]), // Stop Emri
  stopLimit(
      'stop_limit', 'stopLimitOrder', 'stop_limit_order_description', [OrderActionTypeEnum.buy]), // Stop Limit Emri
  trailStop('trailing_stop', 'trail_stop', 'trail_stop_order_description',
      [OrderActionTypeEnum.buy]); // Satışta Hareketli Zarar Durdur / Alışta Hareketli Kar Al

  final String value;
  final String localizationKey;
  final String descLocalizationKey;
  final List<OrderActionTypeEnum> actionList;
  const AmericanOrderTypeEnum(this.value, this.localizationKey, this.descLocalizationKey, this.actionList);
}
