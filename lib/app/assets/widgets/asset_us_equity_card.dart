import 'package:cached_network_image/cached_network_image.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/assets/model/us_capra_summary_model.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/capital_fallback.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/us_market_status_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AssetUsEquityCard extends StatelessWidget {
  final UsOverallSubItem asset;
  final num totalQuantity;
  final bool isUsd;
  final double tlExchangeRate;
  final UsMarketStatus usMarketStatus;
  final bool isVisible;

  const AssetUsEquityCard({
    super.key,
    required this.asset,
    required this.totalQuantity,
    required this.isUsd,
    required this.tlExchangeRate,
    required this.usMarketStatus,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    // final double changeToday = double.tryParse(asset.changeToday ?? '0') ?? 0;
    return InkWell(
      splashColor: context.pColorScheme.transparent,
      highlightColor: context.pColorScheme.transparent,
      onTap: () {
        router.push(
          SymbolUsDetailRoute(
            symbolName: asset.symbol ?? '',
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Grid.s,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
            child: CachedNetworkImage(
              imageUrl: 'https://piapiri-test.b-cdn.net/icons/symbols/us/${asset.symbol ?? ''}.png',
              width: 28,
              height: 28,
              placeholder: (_, __) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, _, __) {
                return CapitalFallback(
                  symbolName: asset.symbol ?? '',
                  size: 28,
                );
              },
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      asset.symbol ?? '',
                      textAlign: TextAlign.left,
                      style: context.pAppStyle.labelReg14textPrimary,
                    ),
                    const SizedBox(
                      width: Grid.xs,
                    ),
                    Text(
                      !isVisible
                          ? '(%**)'
                          : '(%${MoneyUtils().readableMoney(((asset.qty ?? 0) / totalQuantity) * 100)})',
                      textAlign: TextAlign.left,
                      style: context.pAppStyle.labelReg12textSecondary,
                    )
                  ],
                ),
                const SizedBox(
                  height: Grid.xxs,
                ),
                Row(
                  spacing: Grid.xxs,
                  children: [
                    Text(
                      _formatCurrentPrice(
                        isUsd: isUsd,
                        currentPrice: asset.currentPrice,
                        tlExchangeRate: tlExchangeRate,
                      ),
                      style: context.pAppStyle.labelMed12textSecondary,
                    ),
                    // SvgPicture.asset(
                    //   changeToday > 0
                    //       ? ImagesPath.trending_up
                    //       : changeToday < 0
                    //           ? ImagesPath.trending_down
                    //           : ImagesPath.trending_notr,
                    //   height: Grid.m - Grid.xxs,
                    //   colorFilter: ColorFilter.mode(
                    //     changeToday > 0
                    //         ? context.pColorScheme.success
                    //         : changeToday < 0
                    //             ? context.pColorScheme.critical
                    //             : context.pColorScheme.iconPrimary,
                    //     BlendMode.srcIn,
                    //   ),
                    // ),
                    // Text(
                    //   !isVisible
                    //       ? '%**'
                    //       : '%${MoneyUtils().readableMoney(
                    //           changeToday.abs(),
                    //         )}',
                    //   style: context.pAppStyle.interMediumBase.copyWith(
                    //     fontSize: Grid.s + Grid.xs,
                    //     color: changeToday == 0
                    //         ? context.pColorScheme.textPrimary
                    //         : changeToday > 0
                    //             ? context.pColorScheme.success
                    //             : context.pColorScheme.critical,
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(
                  height: Grid.xxs,
                ),
                Text(
                  isUsd
                      ? !isVisible
                          ? '${L10n.tr('maliyet')}: ${CurrencyEnum.dollar.symbol}**'
                          : '${L10n.tr('maliyet')}: ${CurrencyEnum.dollar.symbol}${double.parse(asset.avgEntryPrice ?? '0') >= 1 ? MoneyUtils().readableMoney(
                              double.parse(asset.avgEntryPrice ?? '0'),
                            ) : MoneyUtils().readableMoney(
                              double.parse(
                                asset.avgEntryPrice ?? '0',
                              ),
                              pattern: '#,##0.0000#####',
                            )}'
                      : !isVisible
                          ? '${L10n.tr('maliyet')}: ${CurrencyEnum.turkishLira.symbol}**'
                          : '${L10n.tr('maliyet')}: ${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(double.parse(asset.avgEntryPrice ?? '0') * tlExchangeRate)}',
                  style: context.pAppStyle.labelReg12textSecondary,
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  isVisible
                      ? '${MoneyUtils().readableMoney((asset.qty ?? 0), pattern: MoneyUtils().getPatternByUnitDecimal(asset.qty ?? 0))} ${L10n.tr('adet')}'
                      : '** ${L10n.tr('adet')}',
                  textAlign: TextAlign.right,
                  style: context.pAppStyle.labelReg12textPrimary,
                ),
                const SizedBox(
                  height: Grid.xs,
                ),
                Text(
                  isUsd
                      ? !isVisible
                          ? '${L10n.tr('toplam')}: ${CurrencyEnum.dollar.symbol}**'
                          : '${L10n.tr('toplam')}: ${CurrencyEnum.dollar.symbol}${double.parse(asset.currentPrice ?? '0') >= 1 ? MoneyUtils().readableMoney(double.parse(asset.marketValue ?? '0')) : MoneyUtils().readableMoney(
                              double.parse(
                                asset.marketValue ?? '0',
                              ),
                              pattern: '#,##0.0000#####',
                            )}'
                      : !isVisible
                          ? '${L10n.tr('toplam')}: ${CurrencyEnum.turkishLira.symbol}**'
                          : '${L10n.tr('toplam')}: ${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                              (double.parse(asset.marketValue ?? '0') * tlExchangeRate),
                            )}',
                  textAlign: TextAlign.right,
                  style: context.pAppStyle.labelMed12textPrimary,
                ),
                const SizedBox(
                  height: Grid.xs,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SvgPicture.asset(
                      double.parse(asset.unrealizedPlpc ?? '0') > 0
                          ? ImagesPath.trending_up
                          : double.parse(asset.unrealizedPlpc ?? '0') < 0
                              ? ImagesPath.trending_down
                              : ImagesPath.trending_notr,
                      height: Grid.m,
                      width: Grid.m,
                      colorFilter: ColorFilter.mode(
                        double.parse(asset.unrealizedPlpc ?? '0') > 0
                            ? context.pColorScheme.success
                            : double.parse(asset.unrealizedPlpc ?? '0') < 0
                                ? context.pColorScheme.critical
                                : context.pColorScheme.iconPrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(
                      width: Grid.xxs,
                    ),
                    Text(
                      !isVisible
                          ? '%**'
                          : '%${MoneyUtils().readableMoney(double.parse(asset.unrealizedPlpc ?? '0').abs() * 100)}',
                      textAlign: TextAlign.right,
                      style: context.pAppStyle.interMediumBase.copyWith(
                        fontSize: Grid.m - Grid.xs,
                        color: double.parse(asset.unrealizedPlpc ?? '0') > 0
                            ? context.pColorScheme.success
                            : context.pColorScheme.critical,
                      ),
                    ),
                    const SizedBox(
                      width: Grid.xxs,
                    ),
                    Text(
                      _formatUnrealizedPl(
                        currentPrice: asset.currentPrice,
                        unrealizedPl: asset.unrealizedPl,
                        isUsd: isUsd,
                        tlExchangeRate: tlExchangeRate,
                      ),
                      style: context.pAppStyle.interMediumBase.copyWith(
                        fontSize: Grid.m - Grid.xs,
                        color: isUsd
                            ? double.parse(asset.unrealizedPl ?? '0') > 0
                                ? context.pColorScheme.success
                                : context.pColorScheme.critical
                            : double.parse(asset.unrealizedPl ?? '0') * tlExchangeRate > 0
                                ? context.pColorScheme.success
                                : context.pColorScheme.critical,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrentPrice({
    required bool isUsd,
    required String? currentPrice,
    required double tlExchangeRate,
  }) {
    final double price = double.tryParse(currentPrice ?? '0') ?? 0.0;

    if (isUsd) {
      String formatted = !isVisible
          ? '**'
          : price >= 1
              ? MoneyUtils().readableMoney(price.abs())
              : MoneyUtils().readableMoney(price.abs(), pattern: '#,##0.0000#####');

      return '${CurrencyEnum.dollar.symbol}$formatted';
    }

    double unrealizedTl = price * tlExchangeRate;
    String formattedTl = !isVisible ? '**' : MoneyUtils().readableMoney(unrealizedTl.abs());
    return '${CurrencyEnum.turkishLira.symbol}$formattedTl';
  }

  String _formatUnrealizedPl({
    required String? currentPrice,
    required String? unrealizedPl,
    required bool isUsd,
    required double tlExchangeRate,
  }) {
    final double price = double.tryParse(currentPrice ?? '0') ?? 0.0;
    final double unrealized = double.tryParse(unrealizedPl ?? '0') ?? 0.0;

    if (isUsd) {
      String formatted = !isVisible
          ? '**'
          : price >= 1
              ? MoneyUtils().readableMoney(unrealized.abs())
              : MoneyUtils().readableMoney(unrealized.abs(), pattern: '#,##0.0000#####');

      return unrealized < 0
          ? '(-${CurrencyEnum.dollar.symbol}$formatted)'
          : '(${CurrencyEnum.dollar.symbol}$formatted)';
    }

    double unrealizedTl = unrealized * tlExchangeRate;
    String formattedTl = !isVisible ? '**' : MoneyUtils().readableMoney(unrealizedTl.abs());
    return unrealizedTl < 0
        ? '(-${CurrencyEnum.turkishLira.symbol}$formattedTl)'
        : '(${CurrencyEnum.turkishLira.symbol}$formattedTl)';
  }

  int getUnitDecimal(double rawUnit) {
    int unitDecimal = MoneyUtils().countDecimalPlaces(rawUnit);
    return int.parse('1${'0' * unitDecimal}');
  }
}
