import 'package:piapiri_v2/app/orders/model/american_order_type_enum.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';

abstract class CreateUsOrdersRepository {

  Future<ApiResponse> getTradeLimit();

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
  });


  Future<ApiResponse> deleteUsOrder({
    required String id,
  });

  Future<ApiResponse> getPositionList();


}
