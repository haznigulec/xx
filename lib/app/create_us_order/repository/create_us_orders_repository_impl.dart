import 'package:piapiri_v2/app/create_us_order/repository/create_us_orders_repository.dart';
import 'package:piapiri_v2/app/orders/model/american_order_type_enum.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';

class CreateUsOrdersRepositoryImpl implements CreateUsOrdersRepository {

  @override
  Future<ApiResponse> getTradeLimit() {
    return getIt<PPApi>().usCreateOrderService.postTradeLimit();
  }

  @override
  Future<ApiResponse> createOrder({
    required String symbolName,
    required String? quantity,
    required double? amount,
    required double? limitPrice,
    required double? stopPrice,
    required double? equityPrice,
    required OrderActionTypeEnum orderActionType,
    required AmericanOrderTypeEnum orderType,
    required bool extendedHours,

  }) {
    return getIt<PPApi>().usCreateOrderService.postNewOrder(
          symbolName: symbolName,
          quantity: quantity,
          amount: amount,
          price: limitPrice,
          stopPrice: stopPrice,
          equityPrice: equityPrice,
          orderActionType: orderActionType,
          orderType: orderType,
          extendedHours: extendedHours,
        );
  }


  @override
  Future<ApiResponse> deleteUsOrder({
    required String id,
  }) {
    return getIt<PPApi>().ordersService.deleteUsOrder(
          id: id,
        );
  }

  @override
  Future<ApiResponse> getPositionList() {
    return getIt<PPApi>().usCreateOrderService.getPositionList();
  }

}
