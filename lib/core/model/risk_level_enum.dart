import 'dart:ui';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:p_core/keys/navigator_keys.dart';

enum RiskLevelEnum {
  lowRisk('GRE', 'low_risk', 'low_risk_desc'),
  balanced('BLU', 'balanced', 'balanced_desc'),
  risky('YEL', 'risky', 'risky_desc'),
  highRisk('RED', 'high_risk', 'high_risk_desc');

  const RiskLevelEnum(this.value, this.text, this.desc);
  final String value;
  final String text;
  final String desc;

  Color get color => _getColor();

  Color _getColor() {
    final context = NavigatorKeys.navigatorKey.currentContext!;
    switch (this) {
      case RiskLevelEnum.lowRisk:
        return context.pColorScheme.iconSecondary;
      case RiskLevelEnum.balanced:
        return context.pColorScheme.success;
      case RiskLevelEnum.risky:
        return context.pColorScheme.risky;
      case RiskLevelEnum.highRisk:
        return context.pColorScheme.critical;
    }
  }
}

RiskLevelEnum stringToRiskLevel(String risk) {
  switch (risk) {
    case 'GRE':
      return RiskLevelEnum.lowRisk;
    case 'BLU':
      return RiskLevelEnum.balanced;
    case 'YEL':
      return RiskLevelEnum.risky;
    case 'RED':
      return RiskLevelEnum.highRisk;
    default:
      return RiskLevelEnum.balanced;
  }
}
