import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class ProfitLossRow extends StatelessWidget {
  final String title;
  final double value;
  final bool hasIcon;
  final VoidCallback? onTap;
  final String? iconName;
  final String? symbolName;
  final String? symbolType;
  final EdgeInsetsGeometry padding;
  final String fromMainTitle;
  const ProfitLossRow({
    super.key,
    required this.title,
    required this.value,
    this.hasIcon = true,
    this.onTap,
    this.iconName,
    this.symbolName,
    this.symbolType,
    this.padding = const EdgeInsets.symmetric(
      vertical: Grid.m,
    ),
    this.fromMainTitle = '',
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (symbolName != null) ...[
              SymbolIcon(
                symbolName: symbolName!,
                symbolType: stringToSymbolType(symbolType!),
                size: 15,
              ),
              const SizedBox(
                width: Grid.s,
              ),
            ],
            Expanded(
              child: Text(
                title + fromMainTitle,
                textAlign: TextAlign.left,
                style: context.pAppStyle.labelReg14textPrimary,
              ),
            ),
            hasIcon
                ? Row(
                    children: [
                      Text(
                        '${value == 0 ? '' : value > 0 ? '+' : '-'}₺${MoneyUtils().readableMoney(value < 0 ? double.parse(
                            value.toString().replaceAll('-', ''),
                          ) : value)}',
                        style: context.pAppStyle.interMediumBase.copyWith(
                          fontSize: Grid.m - Grid.xxs,
                          color: value == 0
                              ? context.pColorScheme.iconPrimary
                              : value > 0
                                  ? context.pColorScheme.success
                                  : context.pColorScheme.critical,
                        ),
                      ),
                      const SizedBox(
                        width: Grid.xs,
                      ),
                      SvgPicture.asset(
                        iconName ?? ImagesPath.chevron_down,
                        height: 12,
                        width: 12,
                        colorFilter: ColorFilter.mode(
                          context.pColorScheme.textPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.only(
                      right: Grid.m,
                    ),
                    child: Text(
                      '${value == 0 ? '' : value > 0 ? '+' : '-'}₺${MoneyUtils().readableMoney(value < 0 ? double.parse(
                          value.toString().replaceAll('-', ''),
                        ) : value)}',
                      style: context.pAppStyle.interMediumBase.copyWith(
                        fontSize: Grid.m - Grid.xxs,
                        color: value == 0
                            ? context.pColorScheme.iconPrimary
                            : value > 0
                                ? context.pColorScheme.success
                                : context.pColorScheme.critical,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
