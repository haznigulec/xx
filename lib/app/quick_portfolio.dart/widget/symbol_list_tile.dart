import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/symbol_types.dart';

class SymbolListTile extends StatelessWidget {
  final Widget? trailingWidget;
  final String symbolName;
  final SymbolTypes symbolType;
  final String leadingText;
  final String? subLeadingText;
  final String? infoText;

  final String? trailingText;
  final String? subTrailingText;
  final double? profit;
  final Function()? onTap;
  const SymbolListTile({
    super.key,
    this.trailingWidget,
    required this.symbolName,
    required this.symbolType,
    required this.leadingText,
    this.subLeadingText,
    this.infoText,
    this.trailingText,
    this.subTrailingText,
    this.profit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: context.pColorScheme.transparent,
      highlightColor: context.pColorScheme.transparent,
      focusColor: context.pColorScheme.transparent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Grid.m,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SymbolIcon(
                    key: ValueKey('SYMBOL_ICON_$symbolName'),
                    symbolName: symbolName,
                    symbolType: symbolType,
                    size: 28,
                  ),
                  const SizedBox(
                    width: Grid.s,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          leadingText,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: context.pAppStyle.labelReg14textPrimary,
                        ),
                        const SizedBox(height: Grid.xxs / 2),
                        if (subLeadingText != null && subLeadingText!.isNotEmpty) ...[
                          Text(
                            subLeadingText!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.pAppStyle.labelMed12textSecondary,
                          ),
                        ]
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (infoText != null) ...[
              Expanded(
                flex: 3,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    profit == null
                        ? const SizedBox()
                        : SvgPicture.asset(
                            profit! > 0
                                ? ImagesPath.trending_up
                                : profit! < 0
                                    ? ImagesPath.trending_down
                                    : ImagesPath.trending_notr,
                            width: Grid.m,
                            colorFilter: ColorFilter.mode(
                              profit! > 0
                                  ? context.pColorScheme.success
                                  : profit! < 0
                                      ? context.pColorScheme.critical
                                      : context.pColorScheme.iconPrimary,
                              BlendMode.srcIn,
                            ),
                          ),
                    Text(
                      textAlign: TextAlign.center,
                      profit == null ? infoText! : infoText!.replaceAll('-', ''),
                      style: context.pAppStyle.labelMed14textPrimary.copyWith(
                        color: profit == null
                            ? context.pColorScheme.textPrimary
                            : profit! > 0
                                ? context.pColorScheme.success
                                : profit! < 0
                                    ? context.pColorScheme.critical
                                    : context.pColorScheme.iconPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (trailingWidget != null) ...[
                    trailingWidget!,
                  ],
                  if (trailingWidget == null) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          trailingText ?? '',
                          style: context.pAppStyle.labelMed14textPrimary.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (subTrailingText != null) ...[
                          const SizedBox(height: Grid.xxs / 2),
                          Text(
                            subTrailingText ?? '',
                            style: context.pAppStyle.labelMed12textSecondary,
                          ),
                        ]
                      ],
                    ),
                  ],
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
