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

  final List<Map<String, dynamic>> validityList = [
    {
      'value': OrderValidityEnum.daily,
      'title': 'daily',
      'visibleOnly': [
        OrderTypeEnum.limit,
        OrderTypeEnum.marketToLimit,
        OrderTypeEnum.reserve,
      ],
    },
    {
      'value': OrderValidityEnum.cancelRest,
      'title': 'kalanini_iptal_et',
      'visibleOnly': [
        OrderTypeEnum.market,
        OrderTypeEnum.limit,
        OrderTypeEnum.marketToLimit,
        OrderTypeEnum.reserve,
      ],
    },
    {
      'value': OrderValidityEnum.balancer,
      'title': 'dengeleyici',
      'visibleOnly': [
        OrderTypeEnum.market,
      ],
    },
  ];
}
