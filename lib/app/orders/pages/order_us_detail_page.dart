import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/info/model/info_variant.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_bloc.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_event.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_state.dart';
import 'package:piapiri_v2/app/orders/model/american_order_type_enum.dart';
import 'package:piapiri_v2/app/orders/pages/order_us_update.dart';
import 'package:piapiri_v2/app/orders/widgets/order_us_detail_row_widget.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/order_status_enum.dart';
import 'package:piapiri_v2/core/model/transaction_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/widgets/styled_text.dart';

@RoutePage()
class OrderUsDetailPage extends StatelessWidget {
  final TransactionModel selectedOrder;
  final OrderStatusEnum orderStatus;
  final AmericanOrderTypeEnum orderType;
  const OrderUsDetailPage({
    super.key,
    required this.selectedOrder,
    required this.orderType,
    required this.orderStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('emir_detay'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Grid.m,
          ),
          child: Column(
            children: [
              OrderUsDetailRowWidget(
                title: L10n.tr('durum'),
                value: selectedOrder.orderStatus == 'null'
                    ? '-'
                    : L10n.tr(
                        'order_us_${selectedOrder.orderStatus ?? ''}',
                      ),
                valueColor: context.pColorScheme.primary,
              ),
              OrderUsDetailRowWidget(
                title: L10n.tr('symbol'),
                value: selectedOrder.symbol ?? '',
                widget: InkWell(
                  splashColor: context.pColorScheme.transparent,
                  highlightColor: context.pColorScheme.transparent,
                  onTap: () {
                    router.push(
                      SymbolUsDetailRoute(
                        symbolName: selectedOrder.symbol ?? '',
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        ImagesPath.arrow_up_right,
                        width: 14,
                        height: 14,
                        colorFilter: ColorFilter.mode(
                          context.pColorScheme.textPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(
                        width: Grid.xs,
                      ),
                      Text(
                        selectedOrder.symbol ?? selectedOrder.asset ?? '',
                        style: context.pAppStyle.labelMed14textPrimary,
                      ),
                    ],
                  ),
                ),
              ),
              OrderUsDetailRowWidget(
                title: L10n.tr('islem_turu'),
                value:
                    selectedOrder.transactionType == 'buy' ? L10n.tr('al').toUpperCase() : L10n.tr('sat').toUpperCase(),
                valueColor: selectedOrder.transactionType == 'buy'
                    ? context.pColorScheme.success
                    : context.pColorScheme.critical,
              ),
              OrderUsDetailRowWidget(
                title: L10n.tr('emir_tipi'),
                value: L10n.tr(orderType.name),
              ),
              if (orderType == AmericanOrderTypeEnum.market) ...[
                if (orderStatus == OrderStatusEnum.filled) ...[
                  OrderUsDetailRowWidget(
                    title: '${L10n.tr('tutar')} (${L10n.tr('excluding_transaction_fee')})',
                    value: '\$${MoneyUtils().readableMoney(
                      (selectedOrder.realizedUnit ?? 0) * (double.parse(selectedOrder.filledAvgPrice ?? '0')),
                    )}',
                  ),
                  OrderUsDetailRowWidget(
                    title: L10n.tr('realization_price'),
                    value: '\$${MoneyUtils().readableMoney(
                      double.parse(selectedOrder.filledAvgPrice ?? '0'),
                    )}',
                  ),
                ] else ...[
                  OrderUsDetailRowWidget(
                    title: L10n.tr('fiyat'),
                    value: L10n.tr('serbest'),
                  ),
                  orderStatus != OrderStatusEnum.filled && selectedOrder.orderAmount != null
                      ? const SizedBox.shrink()
                      : OrderUsDetailRowWidget(
                          title: L10n.tr('quantity_of_entries'),
                          value: orderStatus == OrderStatusEnum.filled
                              ? MoneyUtils().readableMoney(
                                  selectedOrder.realizedUnit ?? 0,
                                  pattern: MoneyUtils().getPatternByUnitDecimal(selectedOrder.realizedUnit ?? 0),
                                )
                              : MoneyUtils().readableMoney(
                                  selectedOrder.orderUnit ?? 0,
                                  pattern: MoneyUtils().getPatternByUnitDecimal(selectedOrder.orderUnit ?? 0),
                                ),
                        ),
                ],
                if (selectedOrder.tpPrice != null)
                  OrderUsDetailRowWidget(
                    title: L10n.tr('take_profit_price'),
                    value: '\$${MoneyUtils().readableMoney(selectedOrder.tpPrice ?? 0)}',
                  ),
                if (selectedOrder.slPrice != null)
                  OrderUsDetailRowWidget(
                    title: L10n.tr('stop_loss_price'),
                    value: '\$${MoneyUtils().readableMoney(selectedOrder.slPrice ?? 0)}',
                  ),
              ],
              if (orderType == AmericanOrderTypeEnum.limit) ...[
                if (orderStatus == OrderStatusEnum.filled) ...[
                  OrderUsDetailRowWidget(
                    title: L10n.tr('limit_price'),
                    value: MoneyUtils().readableMoney(
                      selectedOrder.orderPrice ?? 0,
                      pattern: MoneyUtils().countDecimalPlaces(selectedOrder.orderPrice ?? 0) > 2
                          ? MoneyUtils().getPatternByUnitDecimal(selectedOrder.orderPrice ?? 0)
                          : '#,##0.00',
                    ),
                  ),
                  if (selectedOrder.orderAmount == null)
                    OrderUsDetailRowWidget(
                      title: L10n.tr('quantity_of_entries'),
                      value: MoneyUtils().readableMoney(
                        selectedOrder.orderUnit ?? 0,
                      ),
                    ),
                  OrderUsDetailRowWidget(
                    title: L10n.tr('gerceklesen_adet'),
                    value: MoneyUtils().readableMoney(
                      selectedOrder.realizedUnit ?? 0,
                      pattern: MoneyUtils().getPatternByUnitDecimal(selectedOrder.realizedUnit ?? 0),
                    ),
                  ),
                  OrderUsDetailRowWidget(
                    title: L10n.tr('realization_price'),
                    value: '\$${MoneyUtils().readableMoney(
                      double.parse(selectedOrder.filledAvgPrice ?? '0'),
                    )}',
                  ),
                  OrderUsDetailRowWidget(
                    title: '${L10n.tr('tutar')} (${L10n.tr('excluding_transaction_fee')})',
                    value: '\$${MoneyUtils().readableMoney(
                      selectedOrder.orderAmount == null || selectedOrder.orderAmount == 0
                          ? (selectedOrder.realizedUnit ?? 0) * (double.parse(selectedOrder.filledAvgPrice ?? '0'))
                          : selectedOrder.orderAmount!,
                    )}',
                  ),
                ] else ...[
                  OrderUsDetailRowWidget(
                    title: L10n.tr('limit_price'),
                    value: '\$${MoneyUtils().readableMoney(
                      selectedOrder.orderPrice ?? 0,
                      pattern: MoneyUtils().countDecimalPlaces(selectedOrder.orderPrice ?? 0) > 2
                          ? MoneyUtils().getPatternByUnitDecimal(selectedOrder.orderPrice ?? 0)
                          : '#,##0.00',
                    )}',
                  ),
                  orderStatus != OrderStatusEnum.filled && selectedOrder.orderAmount != null
                      ? OrderUsDetailRowWidget(
                          title: L10n.tr('quantity_of_entries'),
                          value: MoneyUtils().readableMoney(
                            (selectedOrder.orderAmount ?? 0) / (selectedOrder.orderPrice ?? 1),
                            pattern: MoneyUtils().getPatternByUnitDecimal(
                              (selectedOrder.orderAmount ?? 0) / (selectedOrder.orderPrice ?? 1),
                            ),
                          ),
                        )
                      : OrderUsDetailRowWidget(
                          title: '${L10n.tr('quantity_of_entries')} ${selectedOrder.orderAmount ?? ''}',
                          value: orderStatus == OrderStatusEnum.filled
                              ? MoneyUtils().readableMoney(
                                  selectedOrder.realizedUnit ?? 0,
                                  pattern: MoneyUtils().getPatternByUnitDecimal(selectedOrder.realizedUnit ?? 0),
                                )
                              : MoneyUtils().readableMoney(
                                  selectedOrder.orderUnit ?? 0,
                                  pattern: MoneyUtils().getPatternByUnitDecimal(selectedOrder.orderUnit ?? 0),
                                ),
                        ),
                  OrderUsDetailRowWidget(
                    title: '${L10n.tr('tutar')} (${L10n.tr('excluding_transaction_fee')})',
                    value: '\$${MoneyUtils().readableMoney(
                      selectedOrder.orderAmount == null || selectedOrder.orderAmount == 0
                          ? (selectedOrder.orderUnit ?? 0) * (selectedOrder.orderPrice ?? 0)
                          : selectedOrder.orderAmount!,
                    )}',
                  ),
                ],
                if (selectedOrder.extendedHours != null && selectedOrder.extendedHours!)
                  OrderUsDetailRowWidget(
                    title: L10n.tr('time_range'),
                    value: L10n.tr('extended_trading_hours'),
                  ),
                if (selectedOrder.tpPrice != null)
                  OrderUsDetailRowWidget(
                    title: L10n.tr('take_profit_price'),
                    value: '\$${MoneyUtils().readableMoney(selectedOrder.tpPrice ?? 0)}',
                  ),
                if (selectedOrder.slPrice != null)
                  OrderUsDetailRowWidget(
                    title: L10n.tr('stop_loss_price'),
                    value: '\$${MoneyUtils().readableMoney(selectedOrder.slPrice ?? 0)}',
                  ),
              ],
              if (orderType == AmericanOrderTypeEnum.stop) ...[
                if (orderStatus == OrderStatusEnum.filled) ...[
                  OrderUsDetailRowWidget(
                    title: L10n.tr('gerceklesen_adet'),
                    value: MoneyUtils().readableMoney(
                      selectedOrder.realizedUnit ?? 0,
                      pattern: MoneyUtils().getPatternByUnitDecimal(selectedOrder.realizedUnit ?? 0),
                    ),
                  ),
                  OrderUsDetailRowWidget(
                    title: L10n.tr('realization_price'),
                    value: '\$${MoneyUtils().readableMoney(
                      double.parse(selectedOrder.filledAvgPrice ?? '0'),
                    )}',
                  ),
                  OrderUsDetailRowWidget(
                    title: '${L10n.tr('tutar')} (${L10n.tr('excluding_transaction_fee')})',
                    value: '\$${MoneyUtils().readableMoney(
                      (selectedOrder.realizedUnit ?? 0) * (double.parse(selectedOrder.filledAvgPrice ?? '0')),
                    )}',
                  ),
                ] else ...[
                  OrderUsDetailRowWidget(
                    title: L10n.tr('price'),
                    value: L10n.tr('serbest'),
                  ),
                  orderStatus != OrderStatusEnum.filled && selectedOrder.orderAmount != null
                      ? const SizedBox.shrink()
                      : OrderUsDetailRowWidget(
                          title: L10n.tr('quantity_of_entries'),
                          value: orderStatus == OrderStatusEnum.filled
                              ? MoneyUtils().readableMoney(
                                  selectedOrder.realizedUnit ?? 0,
                                  pattern: MoneyUtils().getPatternByUnitDecimal(selectedOrder.realizedUnit ?? 0),
                                )
                              : MoneyUtils().readableMoney(
                                  selectedOrder.orderUnit ?? 0,
                                  pattern: MoneyUtils().getPatternByUnitDecimal(selectedOrder.orderUnit ?? 0),
                                ),
                        ),
                ],
                OrderUsDetailRowWidget(
                  title: L10n.tr('stop_price'),
                  value: '\$${MoneyUtils().readableMoney(selectedOrder.stopPrice ?? 0)}',
                ),
              ],
              if (orderType == AmericanOrderTypeEnum.stopLimit) ...[
                if (orderStatus == OrderStatusEnum.filled) ...[
                  OrderUsDetailRowWidget(
                    title: L10n.tr('gerceklesen_adet'),
                    value: MoneyUtils().readableMoney(
                      selectedOrder.realizedUnit ?? 0,
                      pattern: MoneyUtils().getPatternByUnitDecimal(selectedOrder.realizedUnit ?? 0),
                    ),
                  ),
                  OrderUsDetailRowWidget(
                    title: L10n.tr('realization_price'),
                    value: '\$${MoneyUtils().readableMoney(
                      double.parse(selectedOrder.filledAvgPrice ?? '0'),
                    )}',
                  ),
                  OrderUsDetailRowWidget(
                    title: '${L10n.tr('tutar')} (${L10n.tr('excluding_transaction_fee')})',
                    value: '\$${MoneyUtils().readableMoney(
                      (selectedOrder.realizedUnit ?? 0) * (double.parse(selectedOrder.filledAvgPrice ?? '0')),
                    )}',
                  ),
                ] else ...[
                  OrderUsDetailRowWidget(
                    title: L10n.tr('limit_price'),
                    value: '\$${MoneyUtils().readableMoney(
                      selectedOrder.orderPrice ?? 0,
                      pattern: MoneyUtils().countDecimalPlaces(selectedOrder.orderPrice ?? 0) > 2
                          ? MoneyUtils().getPatternByUnitDecimal(selectedOrder.orderPrice ?? 0)
                          : '#,##0.00',
                    )}',
                  ),
                  orderStatus != OrderStatusEnum.filled && selectedOrder.orderAmount != null
                      ? OrderUsDetailRowWidget(
                          title: L10n.tr('quantity_of_entries'),
                          value: MoneyUtils().readableMoney(
                            (selectedOrder.orderAmount ?? 0) / (selectedOrder.orderPrice ?? 1),
                            pattern: MoneyUtils().getPatternByUnitDecimal(
                              (selectedOrder.orderAmount ?? 0) / (selectedOrder.orderPrice ?? 1),
                            ),
                          ),
                        )
                      : OrderUsDetailRowWidget(
                          title: L10n.tr('quantity_of_entries'),
                          value: orderStatus == OrderStatusEnum.filled
                              ? MoneyUtils().readableMoney(
                                  selectedOrder.realizedUnit ?? 0,
                                  pattern: MoneyUtils().getPatternByUnitDecimal(selectedOrder.realizedUnit ?? 0),
                                )
                              : MoneyUtils().readableMoney(
                                  selectedOrder.orderUnit ?? 0,
                                  pattern: MoneyUtils().getPatternByUnitDecimal(selectedOrder.orderUnit ?? 0),
                                ),
                        ),
                  OrderUsDetailRowWidget(
                    title: '${L10n.tr('tutar')} (${L10n.tr('excluding_transaction_fee')})',
                    value: '\$${MoneyUtils().readableMoney(
                      selectedOrder.orderAmount == null || selectedOrder.orderAmount == 0
                          ? (selectedOrder.orderUnit ?? 0) * (selectedOrder.orderPrice ?? 0)
                          : selectedOrder.orderAmount!,
                    )}',
                  ),
                ],
                OrderUsDetailRowWidget(
                  title: L10n.tr('stop_price'),
                  value: '\$${MoneyUtils().readableMoney(selectedOrder.stopPrice ?? 0)}',
                ),
              ],
              if (orderType == AmericanOrderTypeEnum.trailStop) ...[
                if (selectedOrder.transactionType == 'buy') ...[
                  if (orderStatus == OrderStatusEnum.filled) ...[
                    OrderUsDetailRowWidget(
                      title: L10n.tr('gerceklesen_adet'),
                      value: MoneyUtils().readableMoney(
                        selectedOrder.realizedUnit ?? 0,
                        pattern: MoneyUtils().getPatternByUnitDecimal(selectedOrder.realizedUnit ?? 0),
                      ),
                    ),
                    OrderUsDetailRowWidget(
                      title: L10n.tr('realization_price'),
                      value: '\$${MoneyUtils().readableMoney(
                        double.parse(selectedOrder.filledAvgPrice ?? '0'),
                      )}',
                    ),
                    OrderUsDetailRowWidget(
                      title: L10n.tr('stop_price'),
                      value: '\$${MoneyUtils().readableMoney(selectedOrder.stopPrice ?? 0)}',
                    ),
                  ] else ...[
                    orderStatus != OrderStatusEnum.filled && selectedOrder.orderAmount != null
                        ? const SizedBox.shrink()
                        : OrderUsDetailRowWidget(
                            title: orderStatus == OrderStatusEnum.filled
                                ? L10n.tr('adet')
                                : L10n.tr('quantity_of_entries'),
                            value: orderStatus == OrderStatusEnum.filled
                                ? MoneyUtils().readableMoney(
                                    selectedOrder.realizedUnit ?? 0,
                                    pattern: MoneyUtils().getPatternByUnitDecimal(selectedOrder.realizedUnit ?? 0),
                                  )
                                : MoneyUtils().readableMoney(
                                    selectedOrder.orderUnit ?? 0,
                                    pattern: MoneyUtils().getPatternByUnitDecimal(selectedOrder.orderUnit ?? 0),
                                  ),
                          ),
                  ],
                  OrderUsDetailRowWidget(
                    title: L10n.tr('profit_rate'),
                    value: '%${selectedOrder.trailPercent ?? ''}',
                  ),
                  OrderUsDetailRowWidget(
                    title: L10n.tr('profit_amount'),
                    value: '\$${MoneyUtils().readableMoney(double.parse(selectedOrder.trailPrice ?? '0'))}',
                  ),
                ] else ...[
                  if (orderStatus == OrderStatusEnum.filled) ...[
                    OrderUsDetailRowWidget(
                      title: L10n.tr('realization_price'),
                      value: '\$${MoneyUtils().readableMoney(
                        double.parse(selectedOrder.filledAvgPrice ?? '0'),
                      )}',
                    ),
                    OrderUsDetailRowWidget(
                      title: '${L10n.tr('tutar')} (${L10n.tr('excluding_transaction_fee')})',
                      value: '\$${MoneyUtils().readableMoney(
                        (selectedOrder.realizedUnit ?? 0) * (double.parse(selectedOrder.filledAvgPrice ?? '0')),
                      )}',
                    ),
                  ] else ...[
                    orderStatus != OrderStatusEnum.filled && selectedOrder.orderAmount != null
                        ? const SizedBox.shrink()
                        : OrderUsDetailRowWidget(
                            title: orderStatus == OrderStatusEnum.filled
                                ? L10n.tr('adet')
                                : L10n.tr('quantity_of_entries'),
                            value: orderStatus == OrderStatusEnum.filled
                                ? MoneyUtils().readableMoney(
                                    selectedOrder.realizedUnit ?? 0,
                                    pattern: MoneyUtils().getPatternByUnitDecimal(selectedOrder.realizedUnit ?? 0),
                                  )
                                : MoneyUtils().readableMoney(
                                    selectedOrder.orderUnit ?? 0,
                                    pattern: MoneyUtils().getPatternByUnitDecimal(selectedOrder.orderUnit ?? 0),
                                  ),
                          ),
                  ],
                  OrderUsDetailRowWidget(
                    title: L10n.tr('stop_loss_rate'),
                    value: '%${selectedOrder.trailPercent ?? ''}',
                  ),
                  OrderUsDetailRowWidget(
                    title: L10n.tr('stop_loss_amount'),
                    value: '\$${MoneyUtils().readableMoney(double.parse(selectedOrder.trailPrice ?? '0'))}',
                  ),
                ],
              ],
              if (orderStatus == OrderStatusEnum.filled) ...[
                OrderUsDetailRowWidget(
                  title: L10n.tr('date_of_realization'),
                  value: selectedOrder.filledAt != null
                      ?

                      /// gelen tarih utc formatına uygun geldiği için,
                      /// gelen string'i direkt kabul ettik ve substring ile istenilen format şeklinde gösterildi.
                      '${selectedOrder.filledAt!.split('T')[0].replaceAll('-', '.')}, ${selectedOrder.filledAt!.split('T')[1].substring(0, 5)}'
                      : '',
                ),
              ] else ...[
                OrderUsDetailRowWidget(
                  title: L10n.tr('validity_period'),
                  value: L10n.tr('us_detail_${L10n.tr(selectedOrder.validity ?? '')}'),
                ),
                OrderUsDetailRowWidget(
                  title: L10n.tr('order_date'),
                  value: DateTime.parse(selectedOrder.orderDate ?? '').toLocal().formatDayMonthYearTimeWithComma(),
                ),
              ],
              OrderUsDetailRowWidget(
                title: L10n.tr('transaction_fee'),
                value: '\$${MoneyUtils().readableMoney(double.parse(selectedOrder.commission ?? '0'))}',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: orderStatus == OrderStatusEnum.pending ? _bottomWidget(context) : const SizedBox.shrink(),
    );
  }

  Widget _bottomWidget(BuildContext context) {
    return generalButtonPadding(
      context: context,
      child: PBlocBuilder<OrdersBloc, OrdersState>(
        bloc: getIt<OrdersBloc>(),
        builder: (context, state) {
          return state.isDeleting
              ? const CupertinoActivityIndicator()
              : OrderApprovementButtons(
                  cancelButtonText: L10n.tr('sil'),
                  onPressedCancel: () => _deleteOrder(context),
                  //showApproveButton: _canUpdate(),
                  approveButtonText: L10n.tr('guncelle'),
                  onPressedApprove: () => _updateOrder(context),
                );
        },
      ),
    );
  }

  Future _deleteOrder(BuildContext context) async {
    bool isMarketOrStopOrder = orderType == AmericanOrderTypeEnum.market || orderType == AmericanOrderTypeEnum.stop;
    OrderActionTypeEnum action = OrderActionTypeEnum.values.firstWhere(
      (element) => element.name == selectedOrder.transactionType,
    );
    PBottomSheet.show(
      context,
      title: L10n.tr('order_edit'),
      child: Column(
        children: [
          SvgPicture.asset(
            ImagesPath.alert_circle,
            width: 52,
            height: 52,
            colorFilter: ColorFilter.mode(
              context.pColorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(
            height: Grid.m,
          ),
          StyledText(
            text: L10n.tr(
              'delete_order_alert',
              namedArgs: {
                'symbol': '<bold>${selectedOrder.symbol}</bold>',
                'price': isMarketOrStopOrder
                    ? L10n.tr('serbest')
                    : '\$${MoneyUtils().readableMoney(selectedOrder.orderPrice ?? 0)}',
                'action': action == OrderActionTypeEnum.buy
                    ? '<green>${L10n.tr('alis').toUpperCase()}</green>'
                    : '<red>${L10n.tr('satis').toUpperCase()}</red>',
                'unit': selectedOrder.orderUnit != null ? '${selectedOrder.orderUnit}' : '${selectedOrder.orderAmount}',
              },
            ),
            textAlign: TextAlign.center,
            style: context.pAppStyle.labelReg16textPrimary,
            tags: {
              'bold': StyledTextTag(
                style: context.pAppStyle.labelMed16textPrimary,
              ),
              'green': StyledTextTag(
                  style: context.pAppStyle.interMediumBase.copyWith(
                fontSize: Grid.m,
                color: context.pColorScheme.success,
              )),
              'red': StyledTextTag(
                  style: context.pAppStyle.interMediumBase.copyWith(
                fontSize: Grid.m,
                color: context.pColorScheme.critical,
              )),
            },
          ),
          const SizedBox(
            height: Grid.l,
          ),
          OrderApprovementButtons(
            onPressedApprove: () {
              Navigator.of(context).pop();
              getIt<OrdersBloc>().add(
                DeleteUsOrderEvent(
                  id: selectedOrder.id ?? '',
                  callback: (isSuccess, message) async {
                    if (isSuccess) {
                      await router.replace(
                        InfoRoute(
                            variant: InfoVariant.success,
                            message: L10n.tr('emir_silme_talebiniz_iletilmistir'),
                            buttonText: L10n.tr('emirlerime_don'),
                            onTapButton: () => router.maybePop()),
                      );
                    } else {
                      await router.push(
                        InfoRoute(
                            variant: InfoVariant.failed,
                            message: L10n.tr(message ?? ''),
                            buttonText: L10n.tr('emirlerime_don'),
                            onTapButton: () => router.popUntilRoot(),
                            onPressedCloseIcon: () => router.maybePop()),
                      );
                    }
                  },
                ),
              );
            },
          ),
          const SizedBox(
            height: Grid.m,
          ),
        ],
      ),
    );
  }

  void _updateOrder(BuildContext context) async {
    PBottomSheet.show(
      context,
      title: L10n.tr('order_edit'),
      child: OrderUsUpdate(
        selectedOrder: selectedOrder,
        orderStatus: orderStatus,
      ),
    );
  }

  // bool _canUpdate() {
  //   if (selectedOrder.orderStatus == 'accepted' ||
  //       selectedOrder.orderStatus == 'pending_new' ||
  //       selectedOrder.orderStatus == 'pending_cancel' ||
  //       selectedOrder.orderStatus == 'pending_replace') {
  //     return false;
  //   }
  //   return true;
  // }
}
