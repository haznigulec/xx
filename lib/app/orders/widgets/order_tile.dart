import 'package:collection/collection.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/orders/widgets/black_dot_widget.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/order_status_enum.dart';
import 'package:piapiri_v2/core/model/order_type_enum.dart';
import 'package:piapiri_v2/core/model/symbol_type_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/transaction_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class OrderTile extends StatelessWidget {
  final TransactionModel order;
  final OrderStatusEnum orderStatus;
  final int index;

  const OrderTile({
    super.key,
    required this.index,
    required this.order,
    required this.orderStatus,
  });

  @override
  Widget build(BuildContext context) {
    bool isEurobond = order.symbolType == SymbolTypeEnum.fincList;
    final String symbolName = order.symbolType == SymbolTypeEnum.mfList ||
            order.symbolType == SymbolTypeEnum.wrList ||
            order.symbolType == SymbolTypeEnum.viopList
        ? order.underlying
        : order.symbol ?? '';
    final String valueKey = 'SYMBOL_ICON_${orderStatus.value}_${index}_$symbolName';

    return InkWell(
      onTap: () {
        router.push(
          OrderDetailRoute(
            selectedOrder: order,
            orderStatus: orderStatus,
          ),
        );
      },
      child: Row(
        children: [
          if (order.chainNo != 0 && order.chainNo != null) ...[
            SvgPicture.asset(
              ImagesPath.link,
              width: 15,
              height: 15,
              colorFilter: ColorFilter.mode(
                context.pColorScheme.textPrimary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(
              width: Grid.xs,
            ),
          ],
          isEurobond // eurobond iconu kontrolü
              ? SvgPicture.asset(
                  ImagesPath.yurt_disi,
                  width: 28,
                  height: 28,
                )
              : SymbolIcon(
                  key: ValueKey(
                    valueKey,
                  ),
                  symbolName: symbolName,
                  symbolType: order.symbolType == SymbolTypeEnum.americanStockExchangeList
                      ? SymbolTypes.foreign
                      : order.symbolType == SymbolTypeEnum.mfList
                          ? SymbolTypes.fund
                          : SymbolTypes.equity,
                  size: 28,
                ),
          const SizedBox(
            width: Grid.s + Grid.xs,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: isEurobond ? order.asset ?? '' : order.symbol ?? '',
                          style: context.pAppStyle.labelReg14textPrimary,
                          children: [
                            WidgetSpan(
                              child: Baseline(
                                baselineType: TextBaseline.alphabetic,
                                baseline: -5, // Text'i ortalaması için verilen değer
                                child: Text(
                                  ' • ',
                                  style: context.pAppStyle.labelReg14textPrimary.copyWith(
                                    fontSize: Grid.s + Grid.xxs,
                                  ),
                                ),
                              ),
                            ),
                            TextSpan(
                              text: order.shortFall
                                  ? L10n.tr('short_selling')
                                  : order.sideType == 1
                                      ? order.conditionSymbol == null
                                          ? L10n.tr(order.equityGroupCode == 'HE' ? 'Talep' : 'alis').toUpperCase()
                                          : L10n.tr('condition_buying').toUpperCase()
                                      : order.conditionSymbol == null
                                          ? L10n.tr('satis').toUpperCase()
                                          : L10n.tr('condition_selling').toUpperCase(),
                              style: context.pAppStyle.labelReg14textPrimary.copyWith(
                                color: order.shortFall || order.equityGroupCode == 'HE'
                                    ? context.pColorScheme.primary
                                    : order.sideType == 1
                                        ? context.pColorScheme.success
                                        : context.pColorScheme.critical,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: Grid.xxs / 2,
                      ),
                      Text(
                        L10n.tr(
                          order.equityGroupCode == 'HE' ? 'ipo' : order.symbolType?.name ?? '',
                        ),
                        style: context.pAppStyle.labelReg12textSecondary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: Grid.s,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (orderStatus == OrderStatusEnum.filled || orderStatus == OrderStatusEnum.canceled)
                      Text(
                        L10n.tr(
                          OrderTypeEnum.values
                                  .firstWhereOrNull(
                                    (element) => element.value == order.transactionType,
                                  )
                                  ?.localizationKey ??
                              '-',
                        ),
                        style: context.pAppStyle.labelMed12textSecondary,
                      ),
                    _trailingTitle(
                      context,
                      isEurobond,
                    ),
                    _trailingSubTitle(
                      context,
                      isEurobond,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            width: Grid.s,
          ),
          SvgPicture.asset(
            ImagesPath.chevron_right,
            width: 15,
            height: 15,
            colorFilter: ColorFilter.mode(
              context.pColorScheme.textPrimary,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }

  Widget _trailingTitle(
    BuildContext context,
    bool isEurobond,
  ) {
    String title = '';
    Color titleColor = context.pColorScheme.textSecondary;

    if (orderStatus == OrderStatusEnum.pending) {
      if (isEurobond) {
        title = '${L10n.tr('tutar')}: ${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(
          order.units ?? 0,
        )}';
      } else if (order.symbolType == SymbolTypeEnum.mfList) {
        title =
            '${L10n.tr('tutar')} ${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(order.orderAmount ?? 0)}';
      } else {
        if (order.orderStatus == 'PARTIALLYFILLED') {
          title = '${L10n.tr(
            OrderTypeEnum.values.firstWhere((element) => element.value == order.transactionType).localizationKey,
          )} \n ${L10n.tr('gerceklesen_adet')}: ${order.realizedUnit?.toInt() ?? 0}';
        } else {
          title = L10n.tr(
            OrderTypeEnum.values.firstWhere((element) => element.value == order.transactionType).localizationKey,
          );
        }
      }
    } else if (orderStatus == OrderStatusEnum.filled) {
      if (isEurobond) {
        title = '${L10n.tr('tutar')}: ${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(
          order.units ?? 0,
        )}';
      } else {
        title = '${L10n.tr('tutar')}: ${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
          order.conditionSymbol != null
              ? (order.orderPrice ?? 0) * (order.orderUnit ?? 0)
              : (order.transactionPrice ?? 0) * (order.realizedUnit ?? 0),
        )}';
      }
    } else {
      title = L10n.tr('canceled');
      titleColor = context.pColorScheme.critical;
    }

    return Text(
      title,
      textAlign: TextAlign.end,
      style: context.pAppStyle.interMediumBase.copyWith(
        fontSize: Grid.s + Grid.xs,
        color: titleColor,
      ),
    );
  }

  Widget _trailingSubTitle(BuildContext context, bool isEurobond) {
    String subTitle1 = '';
    String subTitle2 = '';

    String digit = '0';

    digit = digit * (order.decimalCount ?? 2);

    if (orderStatus == OrderStatusEnum.pending) {
      if (order.symbolType == SymbolTypeEnum.mfList) {
        subTitle1 =
            '${L10n.tr('fiyat')} ${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
          order.transactionPrice ?? order.price ?? 0,
          pattern: order.symbolType == SymbolTypeEnum.mfList ? '#,##0.######' : '#,##0.##',
        )}';
      } else {
        if (orderStatus != OrderStatusEnum.filled &&
                OrderTypeEnum.values.firstWhere((element) => element.value == order.transactionType).name ==
                    OrderTypeEnum.market.name ||
            OrderTypeEnum.values.firstWhere((element) => element.value == order.transactionType).name ==
                OrderTypeEnum.marketToLimit.name) {
          subTitle1 = L10n.tr('serbest');
        } else {
          subTitle1 =
              '${order.equityGroupCode == 'HE' ? '' : L10n.tr('fiyat')} ${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
            order.orderPrice ?? order.price ?? 0,
            pattern: order.symbolType == SymbolTypeEnum.mfList
                ? '#,##0.######'
                : order.decimalCount == 0
                    ? '#,##0'
                    : '#,##0.$digit',
          )}';
        }
      }

      subTitle2 = '${order.orderUnit?.toInt() ?? order.units?.toInt() ?? 0} ${L10n.tr('adet')}';
    } else if (orderStatus == OrderStatusEnum.filled) {
      if (isEurobond) {
        subTitle1 = '${L10n.tr('fiyat')} ${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(
          order.price ?? 0,
          pattern: order.decimalCount == 0 ? '#,##0' : '#,##0.$digit',
        )}';
        subTitle2 = '${order.orderUnit?.toInt() ?? order.units?.toInt() ?? 0} ${L10n.tr('adet')}';
      } else {
        subTitle1 = '${L10n.tr('fiyat')} ${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
          order.conditionSymbol != null ? order.orderPrice ?? 0 : order.transactionPrice ?? 0,
          pattern: order.symbolType == SymbolTypeEnum.mfList
              ? '#,##0.######'
              : order.decimalCount == 0
                  ? '#,##0'
                  : '#,##0.$digit',
        )}';
        subTitle2 = '${order.orderUnit?.toInt() ?? order.units?.toInt() ?? 0} ${L10n.tr('adet')}';
      }
    } else {
      subTitle1 = '${L10n.tr('fiyat')} ${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
        order.orderPrice ?? order.price ?? 0,
        pattern: order.symbolType == SymbolTypeEnum.mfList
            ? '#,##0.######'
            : order.decimalCount == 0
                ? '#,##0'
                : '#,##0.$digit',
      )}';
      subTitle2 = '${order.orderUnit?.toInt() ?? order.units?.toInt() ?? 0} ${L10n.tr('adet')}';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          subTitle1,
          style: context.pAppStyle.labelMed12textPrimary,
        ),
        const BlackDotWidget(),
        Text(
          subTitle2,
          style: context.pAppStyle.labelMed12textPrimary,
        ),
      ],
    );
  }
}
