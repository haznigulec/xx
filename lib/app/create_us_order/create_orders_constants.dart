import 'package:piapiri_v2/core/model/order_type_enum.dart';
import 'package:piapiri_v2/core/model/order_validity_enum.dart';

class OrdersConstants {
  final List<Map<String, dynamic>> orderTypes = [
    {
      'value': OrderTypeEnum.market,
      'title': 'piyasa',
      'description': 'piyasa_aciklama',
    },
    {
      'value': OrderTypeEnum.limit,
      'title': 'limit',
      'description': 'limit_aciklama',
    },
    {
      'value': OrderTypeEnum.marketToLimit,
      'title': 'piyasadanlimite',
      'description': 'piyasadanlimite_aciklama',
    },
    {
      'value': OrderTypeEnum.reserve,
      'title': 'rezerve',
      'description': 'rezerve_aciklama',
    },
  ];

  final Map<OrderTypeEnum, List<OrderValidityEnum>> validityList = 
    {
    OrderTypeEnum.market: [
      OrderValidityEnum.cancelRest,
      OrderValidityEnum.balancer,
      ],
    OrderTypeEnum.limit: [
      OrderValidityEnum.daily,
      OrderValidityEnum.cancelRest,
      ],
    OrderTypeEnum.marketToLimit: [
      OrderValidityEnum.daily,
      OrderValidityEnum.cancelRest,
      ],
    OrderTypeEnum.reserve: [
      OrderValidityEnum.daily,
      OrderValidityEnum.cancelRest,
    ],
  };
  
}
