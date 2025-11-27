import 'package:piapiri_v2/core/utils/localization_utils.dart';

class BrokerageConstants {
  static final List<Map<String, dynamic>> institutionCountList = [
    {
      'name': L10n.tr(
        'top_institution',
        args: ['5'],
      ),
      'value': 5,
    },
    {
      'name': L10n.tr(
        'top_institution',
        args: ['10'],
      ),
      'value': 10,
    },
    {
      'name': L10n.tr(
        'top_institution',
        args: ['15'],
      ),
      'value': 15,
    },
  ];

  static const double chartTitleHeight = 22;
  static const double chartHeight = 32;
  static const double chartListTitleHeight = 14;
  static const double institutionHeaderHeight = 38;
  static const double institutionContentHeight = 116;
}
