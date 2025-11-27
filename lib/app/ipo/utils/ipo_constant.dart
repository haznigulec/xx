import 'package:piapiri_v2/core/utils/localization_utils.dart';

class IpoConstant {
  static int ipoPaginationListLength = 10;

  final List<Map<String, dynamic>> ipoApplicationTypeDropdownList = [
    {'title': L10n.tr('tutarsal'), 'value': 0},
    {'title': L10n.tr('miktarsal'), 'value': 1},
  ];

  final List<Map<String, dynamic>> ipoKktcCitizenDropdownList = [
    {
      'title': L10n.tr('no'),
      'value': 0,
      'customFields': 'KKTC=H',
    },
    {
      'title': L10n.tr('yes'),
      'value': 1,
      'customFields': 'KKTC=E',
    },
  ];
}
