import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/eurobond/bloc/eurobond_bloc.dart';
import 'package:piapiri_v2/app/eurobond/bloc/eurobond_event.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_bloc.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_event.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_state.dart';
import 'package:piapiri_v2/app/orders/pages/order_update_page.dart';
import 'package:piapiri_v2/app/orders/widgets/order_detail_card.dart';
import 'package:piapiri_v2/app/orders/widgets/order_update_ipo_widget.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/order_status_enum.dart';
import 'package:piapiri_v2/core/model/order_type_enum.dart';
import 'package:piapiri_v2/core/model/symbol_type_enum.dart';
import 'package:piapiri_v2/core/model/transaction_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/widgets/styled_text.dart';

@RoutePage()
class OrderDetailPage extends StatelessWidget {
  final TransactionModel selectedOrder;
  final OrderStatusEnum orderStatus;
  const OrderDetailPage({
    super.key,
    required this.selectedOrder,
    required this.orderStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('emir_detay'),
      ),
      body: SafeArea(
        child: OrderDetailCard(
          selectedOrder: selectedOrder,
          isInUpdate: false,
          orderStatus: orderStatus,
        ),
      ),
      bottomNavigationBar: orderStatus == OrderStatusEnum.pending ? _bottomWidget(context) : const SizedBox.shrink(),
    );
  }

  Widget _bottomWidget(BuildContext context) {
    if (selectedOrder.symbolType == SymbolTypeEnum.mfList && selectedOrder.fundCanBeCancelled == false) {
      return const SizedBox.shrink();
    }
    return generalButtonPadding(
      context: context,
      child: PBlocBuilder<OrdersBloc, OrdersState>(
        bloc: getIt<OrdersBloc>(),
        builder: (context, state) {
          return state.isDeleting
              ? const CupertinoActivityIndicator()
              : Row(
                  children: [
                    Expanded(
                      child: POutlinedButton(
                        text: L10n.tr('sil'),
                        variant: PButtonVariant.brand,
                        fillParentWidth: false,
                        sizeType: PButtonSize.small,
                        onPressed: () => _deleteOrder(context),
                      ),
                    ),
                    if (selectedOrder.symbolType != SymbolTypeEnum.fincList &&
                        selectedOrder.symbolType != SymbolTypeEnum.mfList) ...[
                      const SizedBox(
                        width: Grid.s,
                      ),
                      Expanded(
                        child: PButton(
                          text: L10n.tr('guncelle'),
                          onPressed: () => _goUpdateOrderPage(context),
                        ),
                      ),
                    ],
                  ],
                );
        },
      ),
    );
  }

  Future _deleteOrder(BuildContext context) async {
    bool isMarketOrder = selectedOrder.transactionType == OrderTypeEnum.market.value ||
        selectedOrder.transactionType == OrderTypeEnum.marketToLimit.value;

    return PBottomSheet.show(
      context,
      title: L10n.tr('delete_order_title'),
      titleStyle: context.pAppStyle.labelReg14textPrimary,
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
              'order_delete_message',
              namedArgs: {
                'symbol': '<bold>${(selectedOrder.symbol ?? selectedOrder.asset ?? '').toUpperCase()}</bold>',
                'transactionType':
                    '<transaction_type>${selectedOrder.sideType == 1 ? L10n.tr('alim').toUpperCase() : L10n.tr('satim').toUpperCase()}</transaction_type>',
                'unit': '${(selectedOrder.orderUnit ?? 0).toInt()}',
                'price': isMarketOrder
                    ? L10n.tr('serbest')
                    : '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                        selectedOrder.orderPrice ?? 0,
                        pattern: selectedOrder.symbolType == SymbolTypeEnum.mfList ? '#,##0.######' : '#,##0.00',
                      )}',
              },
            ),
            textAlign: TextAlign.center,
            style: context.pAppStyle.labelReg16textPrimary,
            tags: {
              'bold': StyledTextTag(
                style: context.pAppStyle.labelMed16textPrimary.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              'transaction_type': StyledTextTag(
                  style: context.pAppStyle.interRegularBase.copyWith(
                fontSize: Grid.m,
                color: selectedOrder.sideType == 1 ? context.pColorScheme.success : context.pColorScheme.critical,
              )),
            },
          ),
          const SizedBox(
            height: Grid.m,
          ),
          OrderApprovementButtons(
            onPressedApprove: () async {
              if (selectedOrder.parentTransactionId != null && selectedOrder.chainNo != 0) {
                await router.maybePop();
                router.popAndPush(
                  FutureInfoRoute(
                    buttonText: L10n.tr('emirlerime_don'),
                    buttonClick: () => router.popUntilRoot(),
                    initialFuture: Future<(bool, String)>(
                      () async {
                        bool isSuccessResult = false;
                        String messageResult = '';
                        Completer<void> cancelChainOrderCompleter = Completer<void>();
                        getIt<OrdersBloc>().add(
                          CancelChainOrderEvent(
                            chainNo: selectedOrder.chainNo ?? 0,
                            accountExtId: selectedOrder.accountExtId ?? '',
                            transactionId: selectedOrder.transactionId ?? '',
                            accountId: selectedOrder.accountExtId ?? '',
                            completedCallBack: (isSuccess, message) {
                              isSuccessResult = isSuccess;
                              messageResult = message;
                              cancelChainOrderCompleter.complete();
                            },
                          ),
                        );
                        await cancelChainOrderCompleter.future;
                        return Future.value((isSuccessResult, messageResult));
                      },
                    ),
                  ),
                );
              } else if (selectedOrder.conditionSymbol != null && selectedOrder.conditionSymbol!.isNotEmpty) {
                await router.maybePop();
                router.popAndPush(
                  FutureInfoRoute(
                    buttonText: L10n.tr('emirlerime_don'),
                    buttonClick: () => router.popUntilRoot(),
                    initialFuture: Future<(bool, String)>(
                      () async {
                        bool isSuccessResult = false;
                        String messageResult = '';
                        Completer<void> cancelConditionOrderCompleter = Completer<void>();
                        getIt<OrdersBloc>().add(
                          CancelConditionalOrderEvent(
                            transactionId: selectedOrder.transactionId ?? '',
                            accountExtId: selectedOrder.accountExtId ?? '',
                            completedCallBack: (isSuccess, message) {
                              isSuccessResult = isSuccess;
                              messageResult = message;
                              cancelConditionOrderCompleter.complete();
                            },
                          ),
                        );
                        await cancelConditionOrderCompleter.future;
                        return Future.value((isSuccessResult, messageResult));
                      },
                    ),
                  ),
                );
              } else if (selectedOrder.symbolType == SymbolTypeEnum.fincList) {
                await router.maybePop();
                router.popAndPush(
                  FutureInfoRoute(
                    buttonText: L10n.tr('emirlerime_don'),
                    buttonClick: () => router.popUntilRoot(),
                    initialFuture: Future<(bool, String)>(
                      () async {
                        bool isSuccessResult = false;
                        String messageResult = '';
                        Completer<void> cancelDeleteOrderCompleter = Completer<void>();
                        getIt<EuroBondBloc>().add(
                          DeleteOrderEvent(
                            transactionId: selectedOrder.transactionId ?? '',
                            accountId: selectedOrder.accountExtId ?? '',
                            completedCallBack: (isSuccess, message) {
                              isSuccessResult = isSuccess;
                              messageResult = message;
                              cancelDeleteOrderCompleter.complete();
                            },
                          ),
                        );
                        await cancelDeleteOrderCompleter.future;
                        return Future.value((isSuccessResult, messageResult));
                      },
                    ),
                  ),
                );
              } else if (selectedOrder.symbolType == SymbolTypeEnum.viopList) {
                await router.maybePop();
                router.popAndPush(
                  FutureInfoRoute(
                    buttonText: L10n.tr('emirlerime_don'),
                    buttonClick: () => router.popUntilRoot(),
                    initialFuture: Future<(bool, String)>(
                      () async {
                        bool isSuccessResult = false;
                        String messageResult = '';
                        Completer<void> cancelViopOrderCompleter = Completer<void>();
                        getIt<OrdersBloc>().add(
                          CancelViopOrderEvent(
                            transactionId: selectedOrder.transactionId ?? '',
                            accountId: selectedOrder.accountExtId ?? '',
                            completedCallBack: (isSuccess, message) {
                              isSuccessResult = isSuccess;
                              messageResult = message;
                              cancelViopOrderCompleter.complete();
                            },
                          ),
                        );
                        await cancelViopOrderCompleter.future;
                        return Future.value((isSuccessResult, messageResult));
                      },
                    ),
                  ),
                );
              } else if (selectedOrder.symbolType == SymbolTypeEnum.mfList) {
                await router.maybePop();
                router.popAndPush(
                  FutureInfoRoute(
                    buttonText: L10n.tr('emirlerime_don'),
                    buttonClick: () => router.popUntilRoot(),
                    initialFuture: Future<(bool, String)>(
                      () async {
                        bool isSuccessResult = false;
                        String messageResult = '';
                        Completer<void> cancelViopOrderCompleter = Completer<void>();
                        getIt<OrdersBloc>().add(
                          CancelFundOrderEvent(
                            transactionId: selectedOrder.transactionId ?? '',
                            accountId: selectedOrder.accountExtId ?? '',
                            completedCallBack: (isSuccess, message) {
                              isSuccessResult = isSuccess;
                              messageResult = message;
                              cancelViopOrderCompleter.complete();
                            },
                          ),
                        );
                        await cancelViopOrderCompleter.future;
                        return Future.value((isSuccessResult, messageResult));
                      },
                    ),
                  ),
                );
              } else {
                await router.maybePop();
                router.popAndPush(
                  FutureInfoRoute(
                    buttonText: L10n.tr('emirlerime_don'),
                    buttonClick: () => router.popUntilRoot(),
                    initialFuture: Future<(bool, String)>(
                      () async {
                        bool isSuccessResult = false;
                        String messageResult = '';
                        Completer<void> cancelOrderCompleter = Completer<void>();
                        getIt<OrdersBloc>().add(
                          CancelOrderEvent(
                            transactionId: selectedOrder.transactionId ?? '',
                            accountId: selectedOrder.accountExtId ?? '',
                            periodicTransactionId: selectedOrder.periodicTransactionId ?? '',
                            succesCallBack: () {
                              getIt<OrdersBloc>().add(
                                RefreshOrdersEvent(
                                  account: getIt<OrdersBloc>().state.selectedAccount,
                                  symbolType: getIt<OrdersBloc>().state.selectedSymbolType,
                                  orderStatus: OrderStatusEnum.pending,
                                  refreshData: true,
                                  isLoading: true,
                                ),
                              );
                            },
                            completedCallBack: (isSuccess, message) {
                              isSuccessResult = isSuccess;
                              messageResult = message;
                              cancelOrderCompleter.complete();
                            },
                          ),
                        );
                        await cancelOrderCompleter.future;
                        return Future.value((isSuccessResult, messageResult));
                      },
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  _goUpdateOrderPage(BuildContext context) async {
    if (selectedOrder.symbol != null && selectedOrder.equityGroupCode == 'HE') {
      return PBottomSheet.show(
        context,
        title: L10n.tr('order_edit'),
        child: OrderUpdateIpoWidget(
          selectedOrder: selectedOrder,
        ),
      );
    }

    return PBottomSheet.show(
      context,
      child: OrderUpdatePage(
        selectedOrder: selectedOrder,
      ),
    );
  }
}
