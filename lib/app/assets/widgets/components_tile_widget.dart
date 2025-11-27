import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/extensions/string_extensions.dart';
import 'package:p_core/utils/string_utils.dart';
import 'package:piapiri_v2/app/assets/widgets/viop_instant_profit_loss_widget.dart';
import 'package:piapiri_v2/app/assets/widgets/viop_settlement_price_widet.dart';
import 'package:piapiri_v2/app/eurobond/bloc/eurobond_bloc.dart';
import 'package:piapiri_v2/app/eurobond/bloc/eurobond_event.dart';
import 'package:piapiri_v2/app/eurobond/model/eurobond_list_model.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/assets_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ComponentsTileWidget extends StatelessWidget {
  final String instrumentCategory;
  final OverallSubItemModel overallSubItems;
  final bool isDefaultParity;
  final double totalUsdOverall;
  final double totalAmount;
  final int index;
  final int lastIndex;
  final bool isVisible;
  final double scrollPadding;
  const ComponentsTileWidget({
    super.key,
    required this.instrumentCategory,
    required this.overallSubItems,
    required this.isDefaultParity,
    required this.totalUsdOverall,
    required this.totalAmount,
    required this.index,
    required this.lastIndex,
    required this.isVisible,
    required this.scrollPadding,
  });

  String _getSymbolNameForSymbolIcon() {
    if (instrumentCategory == 'currency') {
      return '${overallSubItems.symbol}TRY';
    }

    if (stringToSymbolType(instrumentCategory) == SymbolTypes.fund ||
        stringToSymbolType(instrumentCategory) == SymbolTypes.option ||
        stringToSymbolType(instrumentCategory) == SymbolTypes.future ||
        stringToSymbolType(instrumentCategory) == SymbolTypes.warrant) {
      return overallSubItems.underlying;
    }

    return overallSubItems.symbol;
  }

  String _getSymbolNameForDetail() {
    SymbolTypes symbolType = stringToSymbolType(instrumentCategory);
    if (symbolType == SymbolTypes.option || symbolType == SymbolTypes.future) {
      return overallSubItems.symbol.split(' ').first;
    }
    return overallSubItems.symbol;
  }

  @override
  Widget build(BuildContext context) {
    bool isEurobond = stringToSymbolType(instrumentCategory) == SymbolTypes.bond;

    return InkWell(
      onTap:
          (instrumentCategory == 'currency' && overallSubItems.symbol != CurrencyEnum.dollar.shortName.toUpperCase())
              ? null
              : () {
                  if (isEurobond) {
                    // Eurobond detay sayfasına yönlendirir
                    getIt<EuroBondBloc>().add(
                      GetBondListEvent(
                        finInstId: overallSubItems.financialInstrumentId ?? '',
                        onSuccess: (EuroBondListModel bond) => router.push(
                          EuroBondDetailRoute(
                            selectedEuroBond: bond.bonds!.first,
                            transactionStartTime: bond.transactionStartTime!,
                            transactionEndTime: bond.transactionEndTime!,
                          ),
                        ),
                      ),
                    );
                  } else if (stringToSymbolType(instrumentCategory) == SymbolTypes.fund) {
                    router.push(
                      FundDetailRoute(
                        fundCode: overallSubItems.financialInstrumentCode ?? '',
                      ),
                    );
                  } else if (instrumentCategory == 'currency' && overallSubItems.symbol == 'USD') {
                    router.push(
                      CurrencyBuySellRoute(
                        currencyType: CurrencyEnum.dollar,
                        accountsByCurrency: UserModel.instance.accounts
                            .where(
                              (element) => element.currency == CurrencyEnum.dollar,
                            )
                            .toList(),
                      ),
                    );
                  } else {
                    _goDetailPage(
                      symbol: _getSymbolNameForDetail(),
                      type: instrumentCategory,
                    );
                  }
                },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Grid.m,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (instrumentCategory != 'Mevduat') ...[
              Padding(
                padding: const EdgeInsets.only(
                  top: Grid.xxs,
                ),
                child: isEurobond
                    ? SvgPicture.asset(
                        ImagesPath.yurt_disi,
                        width: 30,
                        height: 30,
                      )
                    : SymbolIcon(
                        key: Key('Portfolio_Category:${instrumentCategory}_Symbol:${overallSubItems.symbol}'),
                        symbolName: _getSymbolNameForSymbolIcon(),
                        symbolType: instrumentCategory == 'currency'
                            ? SymbolTypes.parity
                            : stringToSymbolType(instrumentCategory),
                        size: 30,
                      ),
              ),
              const SizedBox(width: Grid.s),
            ],
            SizedBox(
              //ekran widthi - padding , iconsize,
              width: MediaQuery.sizeOf(context).width - Grid.m * 2 - 30 - Grid.s - scrollPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //1.satır
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: instrumentCategory != 'Mevduat'
                              ? MediaQuery.sizeOf(context).width / 2
                              : MediaQuery.sizeOf(context).width - Grid.m * 2 - 30 - Grid.s - scrollPadding,
                        ),
                        child: Text(
                          textAlign: TextAlign.start,
                          instrumentCategory == SymbolTypes.fund.name
                              ? overallSubItems.financialInstrumentCode!
                              : stringToSymbolType(instrumentCategory) == SymbolTypes.future
                                  ? '${splitAndCleanString(overallSubItems.symbol)['beforeSpace'] ?? overallSubItems.symbol} •'
                                  : overallSubItems.symbol,
                          maxLines: instrumentCategory != 'Mevduat' ? 1 : 3,
                          overflow: TextOverflow.ellipsis,
                          style: context.pAppStyle.labelReg14textPrimary,
                        ),
                      ),
                      if (instrumentCategory != 'Mevduat') ...[
                        const SizedBox(
                          width: Grid.xs,
                        ),
                        if (stringToSymbolType(instrumentCategory) == SymbolTypes.future) ...[
                          Text(
                            StringUtils.capitalize(splitAndCleanString(overallSubItems.symbol)['afterSpace'] ?? ''),
                            style: context.pAppStyle.interMediumBase.copyWith(
                              fontSize: Grid.s + Grid.xs,
                              color: splitAndCleanString(overallSubItems.symbol)['afterSpace'] == 'LONG'
                                  ? context.pColorScheme.success
                                  : context.pColorScheme.critical,
                            ),
                          ),
                          const SizedBox(
                            width: Grid.xs,
                          ),
                        ],
                        if (instrumentCategory != 'viop' && instrumentCategory != 'sgmk') ...[
                          Text(
                            '${'(%${MoneyUtils().readableMoney(
                              (overallSubItems.price * overallSubItems.qty * 100) / totalAmount,
                            )}'})',
                            style: context.pAppStyle.labelReg12textSecondary,
                          ),
                        ],
                        const Spacer(),
                        Text(
                          isVisible
                              ? instrumentCategory == 'sgmk'
                                  ? overallSubItems.amount == 0
                                      ? '-'
                                      : '${MoneyUtils().readableMoney(overallSubItems.amount)} ${CurrencyEnum.turkishLira.symbol}'
                                  : overallSubItems.qty == 0
                                      ? '-'
                                      : '${MoneyUtils().readableMoney(overallSubItems.qty)} ${L10n.tr('adet')}'
                              : '**',
                          style: context.pAppStyle.labelReg12textPrimary,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(
                    height: Grid.xxs,
                  ),

                  //2.satır
                  if (instrumentCategory != 'sgmk' && instrumentCategory != 'Mevduat') ...[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        instrumentCategory == 'viop'
                            ? ViopSettlementPriceWidget(
                                symbol: overallSubItems.symbol,
                                isDefaultParity: isDefaultParity,
                                isVisible: isVisible,
                                price: overallSubItems.price,
                                totalUsdOverall: totalUsdOverall,
                              )
                            : Row(
                                children: [
                                  Text(
                                    isDefaultParity
                                        ? isVisible
                                            ? '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                                                overallSubItems.price,
                                              )}'
                                                .formatNegativePriceAndPercentage()
                                            : '${CurrencyEnum.turkishLira.symbol}**'
                                        : isVisible
                                            ? '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(
                                                overallSubItems.price / totalUsdOverall,
                                              )}'
                                                .formatNegativePriceAndPercentage()
                                            : '${CurrencyEnum.dollar.symbol}**',
                                    style: context.pAppStyle.labelMed12textSecondary,
                                  ),
                                  const SizedBox(
                                    width: Grid.s,
                                  ),
                                  if (instrumentCategory != 'currency') ...[
                                    SvgPicture.asset(
                                      overallSubItems.profitLossPercent > 0
                                          ? ImagesPath.trending_up
                                          : overallSubItems.profitLossPercent < 0
                                              ? ImagesPath.trending_down
                                              : ImagesPath.trending_notr,
                                      height: Grid.m - Grid.xxs,
                                      colorFilter: ColorFilter.mode(
                                        overallSubItems.profitLossPercent > 0
                                            ? context.pColorScheme.success
                                            : overallSubItems.profitLossPercent < 0
                                                ? context.pColorScheme.critical
                                                : context.pColorScheme.iconPrimary,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    Text(
                                      isVisible
                                          ? '%${MoneyUtils().readableMoney(
                                              overallSubItems.profitLossPercent,
                                            )}'
                                              .formatNegativePriceAndPercentage()
                                          : '%**',
                                      style: context.pAppStyle.labelMed12textPrimary.copyWith(
                                        color: overallSubItems.profitLossPercent == 0
                                            ? context.pColorScheme.textPrimary
                                            : overallSubItems.profitLossPercent > 0
                                                ? context.pColorScheme.success
                                                : context.pColorScheme.critical,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (instrumentCategory != 'viop') ...[
                              Text(
                                '${L10n.tr('toplam')}: ',
                                style: context.pAppStyle.labelMed12textPrimary,
                              ),
                            ],
                            Text(
                              isDefaultParity
                                  ? isVisible
                                      ? '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                                          instrumentCategory == 'viop'
                                              ? overallSubItems.price * overallSubItems.qty * overallSubItems.multiplier
                                              : overallSubItems.amount,
                                          pattern: instrumentCategory == 'viop' ? '#,##0.00##' : '#,##0.00',
                                        )} '
                                      : '${CurrencyEnum.turkishLira.symbol}**'
                                  : isVisible
                                      ? '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(
                                          instrumentCategory == 'viop'
                                              ? (overallSubItems.price *
                                                      overallSubItems.qty *
                                                      overallSubItems.multiplier) /
                                                  totalUsdOverall
                                              : overallSubItems.amount / totalUsdOverall,
                                          pattern: instrumentCategory == 'viop' ? '#,##0.00##' : '#,##0.00',
                                        )} '
                                      : '${CurrencyEnum.dollar.symbol}**',
                              style: context.pAppStyle.labelMed12textPrimary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(
                    height: Grid.xxs,
                  ),

                  //3.satır
                  if (instrumentCategory != 'Mevduat' && instrumentCategory != 'currency') ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          isDefaultParity
                              ? '${L10n.tr('maliyet')}: ${isVisible ? '₺${MoneyUtils().readableMoney(
                                  overallSubItems.cost,
                                  pattern: instrumentCategory == 'viop' ? '#,##0.####' : '#,##0.00',
                                )}' : '${CurrencyEnum.turkishLira.symbol}**'}'
                              : '${L10n.tr('maliyet')}: ${isVisible ? '\$${MoneyUtils().readableMoney(
                                  overallSubItems.cost / totalUsdOverall,
                                  pattern: instrumentCategory == 'viop' ? '#,##0.####' : '#,##0.00',
                                )}' : '${CurrencyEnum.dollar.symbol}**'}',
                          style: context.pAppStyle.labelReg12textSecondary,
                        ),
                        const Spacer(),
                        if (instrumentCategory == 'viop') ...[
                          Text(
                            '${L10n.tr('profitLossSymbol')}:',
                            style: context.pAppStyle.labelMed12textSecondary.copyWith(
                              fontSize: Grid.l / 2 - Grid.xxs / 2,
                              color: overallSubItems.profitLossPercent == 0
                                  ? context.pColorScheme.iconPrimary
                                  : overallSubItems.profitLossPercent > 0
                                      ? context.pColorScheme.success
                                      : context.pColorScheme.critical,
                            ),
                          ),
                          const SizedBox(
                            width: Grid.xxs,
                          ),
                        ],
                        if (instrumentCategory != 'viop') ...[
                          Utils().profitLossPercentWidget(
                            context: context,
                            performance: overallSubItems.profitLossPercent,
                            fontSize: Grid.l / 2 - Grid.xxs / 2,
                            isVisible: isVisible,
                          ),
                        ],
                        Text(
                          isDefaultParity
                              ? isVisible
                                  ? overallSubItems.potentialProfitLoss == 0
                                      ? '- '
                                      : ' (${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                                          overallSubItems.potentialProfitLoss,
                                          // pattern: instrumentCategory == 'viop' ? '#,##0.####' : '#,##0.00',
                                        )})'
                                          .formatNegativePriceAndPercentage()
                                  : ' (${CurrencyEnum.turkishLira.symbol}**)'
                              : isVisible
                                  ? overallSubItems.potentialProfitLoss == 0
                                      ? '- '
                                      : ' (${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(
                                          overallSubItems.potentialProfitLoss / totalUsdOverall,
                                          pattern: instrumentCategory == 'viop' ? '#,##0.####' : '#,##0.00',
                                        )})'
                                          .formatNegativePriceAndPercentage()
                                  : ' (${CurrencyEnum.dollar.symbol}**)',
                          style: context.pAppStyle.labelMed12primary.copyWith(
                            color: overallSubItems.potentialProfitLoss == 0
                                ? context.pColorScheme.textPrimary
                                : overallSubItems.potentialProfitLoss > 0
                                    ? context.pColorScheme.success
                                    : context.pColorScheme.critical,
                            fontSize: Grid.l / 2 - Grid.xxs / 2,
                          ),
                        ),
                      ],
                    ),
                    //4.satır
                    if (instrumentCategory == 'viop') ...[
                      ViopInstantProfitLossWidget(
                        totalUsdOverall: totalUsdOverall,
                        isDefaultParity: isDefaultParity,
                        isVisible: isVisible,
                        cost: overallSubItems.cost,
                        symbol: overallSubItems.symbol,
                        multiplier: overallSubItems.multiplier,
                        quantity: overallSubItems.qty,
                        price: overallSubItems.price,
                      )
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Map<String, String> splitAndCleanString(String input) {
  List<String> parts = input.split(' ');
  String beforeSpace = parts[0];
  String afterSpace = parts[1].replaceAll('(', '').replaceAll(')', '');
  return {
    'beforeSpace': beforeSpace,
    'afterSpace': afterSpace,
  };
}

void _goDetailPage({
  required String symbol,
  required String type,
}) {
  getIt<SymbolBloc>().add(
    SymbolIsExistInDBEvent(
      symbol: symbol,
      symbolTypes: stringToSymbolType(type),
      hasInDB: (isExist, symbolName) {
        if (isExist && symbolName != 'Cari') {
          //db'de yoksa sembol detaya göndermiyorum
          router.push(
            SymbolDetailRoute(
              symbol: MarketListModel(
                symbolCode: symbolName,
                updateDate: '',
                type: type,
              ),
              ignoreDispose: true,
            ),
          );
        }
      },
    ),
  );
}
