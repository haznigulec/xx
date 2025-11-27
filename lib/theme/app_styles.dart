import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:piapiri_v2/theme/color_scheme.dart';
import 'package:flutter/material.dart';

class PAppStyles extends ThemeExtension<PAppStyles> {
  final PColorScheme _pColorScheme;
  PAppStyles(this._pColorScheme);

  late TextStyle interLightBase = const TextStyle(
    fontFamily: 'Inter-Light',
    fontWeight: FontWeight.w300,
  );
  late TextStyle interRegularBase = const TextStyle(
    fontFamily: 'Inter-Regular',
    fontWeight: FontWeight.w400,
  );
  late TextStyle interMediumBase = const TextStyle(
    fontFamily: 'Inter-Medium',
    fontWeight: FontWeight.w500,
  );
  late TextStyle interSemiBoldBase = const TextStyle(
    fontFamily: 'Inter-SemiBold',
    fontWeight: FontWeight.w600,
  );

  late TextStyle labelLig12textTeritary = interLightBase.copyWith(
    fontSize: 12,
    color: _pColorScheme.textTeritary,
  );
  late TextStyle labelLig14textPrimary = interRegularBase.copyWith(
    fontSize: 14,
    color: _pColorScheme.textPrimary,
  );
  late TextStyle labelReg10textPrimary = interRegularBase.copyWith(
    fontSize: 10,
    color: _pColorScheme.textPrimary,
  );
  late TextStyle labelReg12textPrimary = interRegularBase.copyWith(
    fontSize: 12,
    color: _pColorScheme.textPrimary,
  );
  late TextStyle labelReg12textSecondary = interRegularBase.copyWith(
    fontSize: 12,
    color: _pColorScheme.textSecondary,
  );
  late TextStyle labelReg12textTeritary = interRegularBase.copyWith(
    fontSize: 12,
    color: _pColorScheme.textTeritary,
  );
  late TextStyle labelReg14iconPrimary = interRegularBase.copyWith(
    fontSize: 14,
    color: _pColorScheme.iconPrimary,
  );
  late TextStyle labelReg14textPrimary = interRegularBase.copyWith(
    fontSize: 14,
    color: _pColorScheme.textPrimary,
  );
  late TextStyle labelReg14primary = interRegularBase.copyWith(
    fontSize: 14,
    color: _pColorScheme.primary,
  );
  late TextStyle labelReg14textSecondary = interRegularBase.copyWith(
    fontSize: 14,
    color: _pColorScheme.textSecondary,
  );
  late TextStyle labelReg14textTeritary = interRegularBase.copyWith(
    fontSize: 14,
    color: _pColorScheme.textTeritary,
  );

  late TextStyle labelReg16darkMedium = interRegularBase.copyWith(
    fontSize: 16,
    color: _pColorScheme.darkMedium,
  );
  late TextStyle labelReg16textPrimary = interRegularBase.copyWith(
    fontSize: 16,
    color: _pColorScheme.textPrimary,
  );
  late TextStyle labelReg16textSecondary = interRegularBase.copyWith(
    fontSize: 16,
    color: _pColorScheme.textSecondary,
  );
  late TextStyle labelReg16primary = interRegularBase.copyWith(
    fontSize: 16,
    color: _pColorScheme.primary,
  );
  late TextStyle labelReg18textPrimary = interRegularBase.copyWith(
    fontSize: 18,
    color: _pColorScheme.textPrimary,
  );
  late TextStyle labelReg18textSecondary = interRegularBase.copyWith(
    fontSize: 18,
    color: _pColorScheme.textSecondary,
  );
  late TextStyle labelReg18primary = interRegularBase.copyWith(
    fontSize: 18,
    color: _pColorScheme.primary,
  );
  late TextStyle labelReg20primary = interRegularBase.copyWith(
    fontSize: 20,
    color: _pColorScheme.primary,
  );
  late TextStyle labelReg20textPrimary = interRegularBase.copyWith(
    fontSize: 20,
    color: _pColorScheme.textPrimary,
  );
  late TextStyle labelReg20textQuaternary = interRegularBase.copyWith(
    fontSize: 20,
    color: _pColorScheme.textQuaternary,
  );
  late TextStyle labelReg26textPrimary = interRegularBase.copyWith(
    fontSize: 26,
    color: _pColorScheme.textPrimary,
  );
  late TextStyle labelReg30iconPrimary = interRegularBase.copyWith(
    fontSize: 30,
    color: _pColorScheme.iconPrimary,
  );

  late TextStyle labelMed10textPrimary = interMediumBase.copyWith(
    fontSize: 10,
    color: _pColorScheme.textPrimary,
  );
  late TextStyle labelMed12primary = interMediumBase.copyWith(
    fontSize: 12,
    color: _pColorScheme.primary,
  );
  late TextStyle labelMed12textPrimary = interMediumBase.copyWith(
    fontSize: 12,
    color: _pColorScheme.textPrimary,
  );
  late TextStyle labelMed12textSecondary = interMediumBase.copyWith(
    fontSize: 12,
    color: _pColorScheme.textSecondary,
  );
  late TextStyle labelMed12textTeritary = interMediumBase.copyWith(
    fontSize: 12,
    color: _pColorScheme.textTeritary,
  );
  late TextStyle labelMed12lightHigh = interMediumBase.copyWith(
    fontSize: 12,
    color: _pColorScheme.lightHigh,
  );
  late TextStyle labelMed14primary = interMediumBase.copyWith(
    fontSize: 14,
    color: _pColorScheme.primary,
  );
  late TextStyle labelMed14textPrimary = interMediumBase.copyWith(
    fontSize: 14,
    color: _pColorScheme.textPrimary,
  );
  late TextStyle labelMed14textSecondary = interMediumBase.copyWith(
    fontSize: 14,
    color: _pColorScheme.textSecondary,
  );
  late TextStyle labelMed14textTeritary = interMediumBase.copyWith(
    fontSize: 14,
    color: _pColorScheme.textTeritary,
  );

  late TextStyle labelMed16primary = interMediumBase.copyWith(
    fontSize: 16,
    color: _pColorScheme.primary,
  );
  late TextStyle labelMed16textPrimary = interMediumBase.copyWith(
    fontSize: 16,
    color: _pColorScheme.textPrimary,
  );
  late TextStyle labelMed16textSecondary = interMediumBase.copyWith(
    fontSize: 16,
    color: _pColorScheme.textSecondary,
  );
  late TextStyle labelMed16lightHigh = interMediumBase.copyWith(
    fontSize: 16,
    color: _pColorScheme.lightHigh,
  );

  late TextStyle labelMed18darkHigh = interMediumBase.copyWith(
    fontSize: 18,
    color: _pColorScheme.darkHigh,
  );
  late TextStyle labelMed18primary = interMediumBase.copyWith(
    fontSize: 18,
    color: _pColorScheme.primary,
  );
  late TextStyle labelMed18textPrimary = interMediumBase.copyWith(
    fontSize: 18,
    color: _pColorScheme.textPrimary,
  );
  late TextStyle labelMed1textSecondary = interMediumBase.copyWith(
    fontSize: 18,
    color: _pColorScheme.textSecondary,
  );
  late TextStyle labelMed18textTeritary = interMediumBase.copyWith(
    fontSize: 18,
    color: _pColorScheme.textTeritary,
  );
  late TextStyle labelMed20textPrimary = interMediumBase.copyWith(
    fontSize: 20,
    color: _pColorScheme.textPrimary,
  );
  late TextStyle labelMed20backgroundColor = interMediumBase.copyWith(
    fontSize: 20,
    color: _pColorScheme.backgroundColor,
  );
  late TextStyle labelMed20primary = interMediumBase.copyWith(
    fontSize: 20,
    color: _pColorScheme.primary,
  );
  late TextStyle labelMed22textPrimary = interMediumBase.copyWith(
    fontSize: 22,
    color: _pColorScheme.textPrimary,
  );
  late TextStyle labelMed24textPrimary = interMediumBase.copyWith(
    fontSize: 24,
    color: _pColorScheme.textPrimary,
  );
  late TextStyle labelMed26textPrimary = interMediumBase.copyWith(
    fontSize: 26,
    color: _pColorScheme.textPrimary,
  );
  late TextStyle labelMed34textPrimary = interMediumBase.copyWith(
    fontSize: 34,
    color: _pColorScheme.textPrimary,
  );

  late TextStyle labelSemiBold14textPrimary = interSemiBoldBase.copyWith(
    fontSize: 14,
    color: _pColorScheme.textPrimary,
  );
  late TextStyle labelSemiBold16textSecondary = interSemiBoldBase.copyWith(
    fontSize: 16,
    color: _pColorScheme.textSecondary,
  );
  late TextStyle labelSemiBold18textPrimary = interSemiBoldBase.copyWith(
    fontSize: 18,
    color: _pColorScheme.textPrimary,
  );

  late ButtonStyle oulinedLargePrimaryStyle = OutlinedButton.styleFrom(
    fixedSize: const Size.fromHeight(Grid.xxl + Grid.xs),
    minimumSize: Size.zero,
    foregroundColor: _pColorScheme.primary,
    backgroundColor: _pColorScheme.backgroundColor,
    textStyle: interMediumBase.copyWith(fontSize: Grid.m + Grid.xs),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Grid.l + Grid.xs),
    ),
    side: BorderSide(color: _pColorScheme.primary),
  );

  late ButtonStyle oulinedMediumPrimaryStyle = OutlinedButton.styleFrom(
    fixedSize: const Size.fromHeight(Grid.l + Grid.s + Grid.xxs),
    minimumSize: Size.zero,
    padding: const EdgeInsets.symmetric(horizontal: Grid.m),
    foregroundColor: _pColorScheme.textPrimary,
    backgroundColor: _pColorScheme.backgroundColor,
    disabledForegroundColor: _pColorScheme.textPrimary,
    disabledBackgroundColor: _pColorScheme.backgroundColor,
    textStyle: interRegularBase.copyWith(fontSize: Grid.m),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Grid.m),
    ),
    side: BorderSide(color: _pColorScheme.stroke),
  );

  late ButtonStyle oulinedMediumSecondaryStyle = oulinedMediumPrimaryStyle.copyWith(
    foregroundColor: WidgetStatePropertyAll(_pColorScheme.primary),
    textStyle: WidgetStatePropertyAll(interMediumBase.copyWith(fontSize: Grid.m)),
    side: WidgetStatePropertyAll(
      BorderSide(
        color: _pColorScheme.primary,
      ),
    ),
  );

  late ButtonStyle oulinedSmallPrimaryStyle = OutlinedButton.styleFrom(
    fixedSize: const Size.fromHeight(Grid.l),
    minimumSize: Size.zero,
    padding: const EdgeInsets.symmetric(horizontal: Grid.s + Grid.xs),
    foregroundColor: _pColorScheme.textSecondary,
    backgroundColor: _pColorScheme.backgroundColor,
    disabledForegroundColor: _pColorScheme.textPrimary,
    disabledBackgroundColor: _pColorScheme.backgroundColor,
    textStyle: interMediumBase.copyWith(
      fontSize: Grid.s + Grid.xs + Grid.xxs,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Grid.m),
    ),
    side: BorderSide(color: _pColorScheme.stroke),
  );

  late ButtonStyle oulinedSmallSecondaryStyle = oulinedSmallPrimaryStyle.copyWith(
    foregroundColor: WidgetStatePropertyAll(_pColorScheme.textPrimary),
    textStyle: WidgetStatePropertyAll(
      interRegularBase.copyWith(fontSize: Grid.s + Grid.xs + Grid.xxs),
    ),
  );

  late ButtonStyle elevatedMediumPrimaryStyle = OutlinedButton.styleFrom(
    fixedSize: const Size.fromHeight(Grid.xxl + Grid.xs),
    minimumSize: Size.zero,
    foregroundColor: _pColorScheme.primary,
    backgroundColor: _pColorScheme.backgroundColor,
    textStyle: interMediumBase.copyWith(
      fontSize: Grid.m,
    ),
    disabledForegroundColor: _pColorScheme.secondary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Grid.l + Grid.xxs),
    ),
    side: BorderSide(color: _pColorScheme.primary),
  );

  late InputDecoration formFieldDecoration = InputDecoration(
    prefixStyle: interRegularBase.copyWith(
      fontSize: Grid.m,
      height: 1.5,
    ),
    errorStyle: interRegularBase.copyWith(
      fontSize: Grid.s + Grid.xs + Grid.xxs,
    ),
    helperStyle: interRegularBase.copyWith(
      fontSize: Grid.s + Grid.xs + Grid.xxs,
      color: _pColorScheme.darkMedium,
    ),
    helperMaxLines: 2,
    isDense: true,
    floatingLabelBehavior: FloatingLabelBehavior.always,
    filled: true,
  );

  late InputDecoration quickCashTextfieldDecoration = InputDecoration(
    contentPadding: EdgeInsets.zero,
    isCollapsed: true,
    filled: false,
    fillColor: Colors.transparent,
    border: InputBorder.none,
    hintStyle: labelReg14textTeritary,
  );

  @override
  ThemeExtension<PAppStyles> copyWith() {
    return this;
  }

  @override
  ThemeExtension<PAppStyles> lerp(
    covariant ThemeExtension<PAppStyles>? other,
    double t,
  ) {
    return this;
  }
}
