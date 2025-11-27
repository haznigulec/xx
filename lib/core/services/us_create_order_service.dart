import 'package:piapiri_v2/app/orders/model/american_order_type_enum.dart';
import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class UsCreateOrderService {
  final ApiClient api;

  UsCreateOrderService(this.api);

  static const String _postCapraCollateralInfo = '/Capra/GetCollateralInfo';
  static const String _postCapraNewOrder = '/Capra/NewOrder';
  static const String _getCapraPortfolioSummary = '/Capra/GetPortfolioSummary';

  Future<ApiResponse> postTradeLimit() async {
    return api.post(
      _postCapraCollateralInfo,
      tokenized: true,
      body: {
        'CustomerExtId': UserModel.instance.customerId,
      },
    );
  }

  Future<ApiResponse> postNewOrder({
    required String symbolName,
    required String? quantity,
    required double? amount,
    required double? price,
    required double? stopPrice,
    required double? equityPrice,
    required OrderActionTypeEnum orderActionType,
    required AmericanOrderTypeEnum orderType,
    required bool extendedHours,
  }) async {
    Map<String, dynamic> body = {
      'CustomerExtId': UserModel.instance.customerId,
      'symbol': symbolName,
      if (quantity != null) 'qty': quantity,
      if (stopPrice != null) 'stop_price': stopPrice.toString(),
      if (price != null) 'limit_price': price.toString(),
      if (amount != null) 'notional': amount.toString(),
      'side': orderActionType.name,
      'type': orderType.value,
      'time_in_force': 'day',
      if (orderType == AmericanOrderTypeEnum.limit || orderType == AmericanOrderTypeEnum.stopLimit)
        'limit_price': price.toString(),
      if (extendedHours) 'extended_hours': extendedHours,
      if (equityPrice != null) 'equity_price': equityPrice.toString(),
    };
    return api.post(
      _postCapraNewOrder,
      tokenized: true,
      body: body,
    );
  }

  Future<ApiResponse> getPositionList({
    String accountId = '',
  }) async {
    return api.post(
      _getCapraPortfolioSummary,
      tokenized: true,
      body: {
        'CustomerExtId': UserModel.instance.customerId,
      },
    );
  }
}
