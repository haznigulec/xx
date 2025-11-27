import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

enum PSymbolVariant {
  equityDetail,
  equityTab,
  fundPortfolio,
  modelPortfolio,
  ipoActive,
  eurobond,
  fundDetail,
  portfolioBuy,
  searchFollowList,
  search,
  fundTab,
  fundTabRisk,
  warrantDetail,
  warrantTab,
  viopDetail,
  marketMakers,
  listDelete,
}

class PSymbolTile extends StatelessWidget {
  final PSymbolVariant variant;
  final bool? isProfit;
  final Widget? titleWidget;
  // final String? titleIcon;
  final String? title;
  final String? subTitle;
  final String? info;
  final String? trailingTitle;
  final String? trailingSubTitle;
  final Widget? trailingWidget;
  final VoidCallback? onTap;
  final bool isPassive;
  final TextStyle? titleStyle;
  final TextStyle? subTitleStyle;
  final String? symbolName;
  final SymbolTypes? symbolType;
  final double? percentage;

  const PSymbolTile({
    super.key,
    required this.variant,
    this.isProfit,
    this.titleWidget,
    // this.titleIcon,
    this.title,
    this.subTitle,
    this.info,
    this.trailingTitle,
    this.trailingSubTitle,
    this.trailingWidget,
    this.onTap,
    this.isPassive = false,
    this.titleStyle,
    this.subTitleStyle,
    this.symbolName,
    this.symbolType,
    this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = isProfit != null
        ? isProfit!
            ? context.pColorScheme.success
            : context.pColorScheme.primary
        : context.pColorScheme.iconPrimary;
    final String trendingIcon = isProfit != null
        ? isProfit!
            ? ImagesPath.trending_up
            : ImagesPath.trending_down
        : ImagesPath.trending_notr;

    return InkWell(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.zero,
        color: context.pColorScheme.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (titleWidget != null) ...[
              titleWidget!,
              const SizedBox(
                width: Grid.s,
              ),
            ] else ...[
              if (symbolName != null) ...[
                SymbolIcon(
                  size: 30,
                  symbolName: symbolName!,
                  symbolType: symbolType ?? SymbolTypes.equity,
                ),
                const SizedBox(
                  width: Grid.s,
                ),
              ],
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (title != null) ...[
                    Text(
                      title!,
                      style: context.pAppStyle.labelReg14textPrimary.copyWith(
                        fontSize: variant == PSymbolVariant.fundPortfolio ||
                                variant == PSymbolVariant.fundDetail ||
                                variant == PSymbolVariant.fundTab ||
                                variant == PSymbolVariant.fundTabRisk
                            ? Grid.s + Grid.xs
                            : Grid.m - Grid.xxs,
                      ),
                    ),
                    const SizedBox(
                      height: Grid.xxs,
                    ),
                  ],
                  if (subTitle != null)
                    Text(subTitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.pAppStyle.labelMed12textPrimary.copyWith(
                          color: variant == PSymbolVariant.fundPortfolio ||
                                  variant == PSymbolVariant.fundTab ||
                                  variant == PSymbolVariant.fundTabRisk
                              ? context.pColorScheme.textPrimary
                              : context.pColorScheme.textSecondary,
                        )),
                ],
              ),
            ),
            const SizedBox(
              width: Grid.s,
            ),
            if (info != null) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (variant == PSymbolVariant.equityDetail ||
                      variant == PSymbolVariant.warrantDetail ||
                      variant == PSymbolVariant.viopDetail ||
                      variant == PSymbolVariant.fundTab ||
                      variant == PSymbolVariant.listDelete) ...[
                    SvgPicture.asset(
                      trendingIcon,
                      width: Grid.m - Grid.xxs,
                      colorFilter: ColorFilter.mode(
                        bgColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(
                      width: Grid.xxs,
                    ),
                  ],
                  Text(
                    info!,
                    textAlign: TextAlign.right,
                    style: context.pAppStyle.labelMed14textPrimary.copyWith(
                      color: variant == PSymbolVariant.fundPortfolio
                          ? context.pColorScheme.textSecondary
                          : variant == PSymbolVariant.modelPortfolio || variant == PSymbolVariant.portfolioBuy
                              ? context.pColorScheme.textPrimary
                              : bgColor,
                    ),
                  ),
                ],
              ),
            ],
            if (trailingWidget != null) ...[
              trailingWidget!,
            ] else ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (trailingTitle != null) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (variant == PSymbolVariant.fundPortfolio ||
                            variant == PSymbolVariant.fundTab ||
                            variant == PSymbolVariant.warrantTab) ...[
                          SvgPicture.asset(
                            trendingIcon,
                            width: Grid.m - Grid.xxs,
                            colorFilter: ColorFilter.mode(
                              bgColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(
                            width: Grid.xxs,
                          ),
                        ],
                        Text(
                          trailingTitle!,
                          textAlign: TextAlign.end,
                          style: variant == PSymbolVariant.warrantDetail || variant == PSymbolVariant.viopDetail
                              ? context.pAppStyle.labelReg14textPrimary
                              : context.pAppStyle.labelMed14textPrimary.copyWith(
                                  color: variant == PSymbolVariant.fundPortfolio ||
                                          variant == PSymbolVariant.fundTab ||
                                          variant == PSymbolVariant.warrantTab
                                      ? bgColor
                                      : context.pColorScheme.textPrimary,
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: Grid.xxs,
                    ),
                  ],
                  if (trailingSubTitle != null) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (variant == PSymbolVariant.equityTab) ...[
                          SvgPicture.asset(
                            trendingIcon,
                            width: Grid.l / 2,
                            colorFilter: ColorFilter.mode(
                              bgColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(
                            width: Grid.xxs,
                          ),
                        ],
                        Text(
                          trailingSubTitle!,
                          textAlign: TextAlign.right,
                          style: variant == PSymbolVariant.warrantDetail || variant == PSymbolVariant.warrantTab
                              ? context.pAppStyle.labelReg14textPrimary
                              : context.pAppStyle.labelMed14textPrimary.copyWith(
                                  color: variant == PSymbolVariant.fundPortfolio ||
                                          variant == PSymbolVariant.fundTab ||
                                          variant == PSymbolVariant.warrantTab
                                      ? bgColor
                                      : context.pColorScheme.textPrimary,
                                ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}
