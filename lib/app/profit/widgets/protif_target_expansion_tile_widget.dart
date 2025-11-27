import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class ProfitTargetExpansionTileWidget extends StatelessWidget {
  final String titleLeft;
  final double titleRight;
  final List<Widget> children;
  const ProfitTargetExpansionTileWidget({
    super.key,
    required this.titleLeft,
    this.titleRight = 0,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: context.pColorScheme.transparent,
      ),
      child: ListTileTheme(
        contentPadding: EdgeInsets.zero,
        child: ExpansionTile(
          collapsedBackgroundColor: context.pColorScheme.transparent,
          backgroundColor: context.pColorScheme.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                titleLeft,
                style: context.pAppStyle.labelReg14textPrimary,
              ),
              Text(
                titleRight > 0 ? '+${MoneyUtils().readableMoney(titleRight)}' : MoneyUtils().readableMoney(titleRight),
                style: context.pAppStyle.interMediumBase.copyWith(
                  fontSize: Grid.m - Grid.xxs,
                  color: titleRight == 0
                      ? context.pColorScheme.iconPrimary
                      : titleRight > 0
                          ? context.pColorScheme.success
                          : context.pColorScheme.critical,
                ),
              ),
            ],
          ),
          children: children,
        ),
      ),
    );
  }
}
