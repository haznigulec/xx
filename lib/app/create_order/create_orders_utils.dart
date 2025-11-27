import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_bloc.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_bloc.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_event.dart';
import 'package:piapiri_v2/app/create_order/bloc/create_orders_bloc.dart';
import 'package:piapiri_v2/app/create_order/bloc/create_orders_event.dart';
import 'package:piapiri_v2/app/create_order/create_orders_constants.dart';
import 'package:piapiri_v2/app/create_order/widgets/real_estate_certificate_pdf.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/order_type_enum.dart';
import 'package:piapiri_v2/core/model/order_validity_enum.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class CreateOrdersUtils {
  final CreateOrdersBloc _createOrdersBloc = getIt<CreateOrdersBloc>();
  final AppSettingsBloc _appSettingsBloc = getIt<AppSettingsBloc>();
  final ContractsBloc _contractsBloc = getIt<ContractsBloc>();
  final AppInfoBloc _appInfoBloc = getIt<AppInfoBloc>();

  /// Returns the subtitle for the quantity input based on the action type and available units.
  String? getQtySubtitle({
    required OrderActionTypeEnum action,
    required int buyableUnit,
    required int sellableUnit,
  }) {
    if (action == OrderActionTypeEnum.buy) {
      return '${L10n.tr('alinabilir_adet')}: ${MoneyUtils().readableMoney(buyableUnit, pattern: '#,##0')}';
    }
    if (action == OrderActionTypeEnum.sell) {
      return '${L10n.tr('satilabilir_adet')}: ${MoneyUtils().readableMoney(sellableUnit, pattern: '#,##0')}';
    }
    return null;
  }

  /// Validates the quantity input based on the action type and available units.
  bool isQtyError({
    required OrderActionTypeEnum action,
    required int? sellableUnit,
    required int unit,
  }) {
    if (action == OrderActionTypeEnum.sell && sellableUnit != null && unit > sellableUnit) {
      return true;
    }
    return false;
  }

  /// Checks if the input amount is valid based on the action type and available limits.
  String? getConsistentEquivalenceError({
    required OrderActionTypeEnum action,
    required double amount,
    required int unit,
    required double tradeLimit,
    required int? sellableUnit,
    required bool isQuantitative,
  }) {
    if (action == OrderActionTypeEnum.buy && amount > tradeLimit && isQuantitative) {
      return L10n.tr('insufficient_transaction_limit');
    }
    if (action == OrderActionTypeEnum.sell && sellableUnit != null && unit > sellableUnit && !isQuantitative) {
      return L10n.tr('insufficient_transaction_unit');
    }
    return null;
  }

  /// Sets the default order type and validity based on the provided order types and the app settings.
  void setDefaultOrderType({
    required List<OrderTypeEnum> orderTypes,
    required Function(OrderTypeEnum orderType, OrderValidityEnum orderValidity) onChanged,
  }) {
    if (orderTypes.any((e) => e == _appSettingsBloc.state.orderSettings.equityDefaultOrderType)) {
      onChanged(
        _appSettingsBloc.state.orderSettings.equityDefaultOrderType,
        _appSettingsBloc.state.orderSettings.equityDefaultValidity,
      );
      return;
    }

    OrderTypeEnum orderType = orderTypes.first;
    OrderValidityEnum orderValidity;
    List<OrderValidityEnum>? selectableValidities = OrdersConstants().validityList[orderType];
    if (selectableValidities?.any((e) => e == _appSettingsBloc.state.orderSettings.equityDefaultValidity) == true) {
      orderValidity = _appSettingsBloc.state.orderSettings.equityDefaultValidity;
    } else {
      orderValidity = selectableValidities?.first ?? OrderValidityEnum.values.first;
    }
    onChanged(orderType, orderValidity);
  }

  /// Calculates the number of buyable units based on the action type, trade limit, and price input.
  int getBuyableUnit({
    required MarketListModel? symbol,
    required OrderActionTypeEnum action,
    required String priceControllerText,
    required bool isMarketOrMarketToLimit,
    required double tradeLimit,
  }) {
    if (symbol == null) {
      return 0;
    }
    if (isMarketOrMarketToLimit) {
      if (MoneyUtils().getPrice(symbol, action) != 0) {
        double price = MoneyUtils().getPrice(symbol, action);
        return (tradeLimit / price).floor();
      } else {
        return 0;
      }
    } else {
      if (priceControllerText.isNotEmpty && MoneyUtils().fromReadableMoney(priceControllerText) != 0) {
        double price = MoneyUtils().fromReadableMoney(priceControllerText);
        return (tradeLimit / price).floor();
      } else {
        return 0;
      }
    }
  }

  /// Calculates the number of sellable units based on the action type, trade limit, and price input.
  void createOrderCallback(
    BuildContext context, {
    required String successMessage,
    required bool isError,
    required OrderActionTypeEnum action,
    required MarketListModel symbol,
    required double price,
    required double amount,
    required String accountId,
    required Function() onSuccessSubMarketContractCallback,
  }) {
    getIt<Analytics>().track(
      action == OrderActionTypeEnum.buy ? AnalyticsEvents.actionBuy : AnalyticsEvents.actionSell,
      taxonomy: [
        InsiderEventEnum.controlPanel.value,
        InsiderEventEnum.marketsPage.value,
        InsiderEventEnum.buySellPage.value,
      ],
      properties: {
        'product_id': symbol.symbolCode,
        'name': symbol.symbolCode,
        'price': price,
        'amount': amount,
        'currency': 'TRY',
        'account_no': '${UserModel.instance.customerId}-$accountId',
      },
    );
    if (successMessage == 'Yakın İzleme Pazarı Risk Bildirim Formu onayın bulunmuyor.') {
      PBottomSheet.showError(
        context,
        content: L10n.tr('close_monitoring_market_contract_content'),
        showFilledButton: true,
        showOutlinedButton: true,
        outlinedButtonText: L10n.tr('vazgec'),
        onOutlinedButtonPressed: () => Navigator.pop(context),
        filledButtonText: L10n.tr('tamam'),
        onFilledButtonPressed: () {
          router.maybePop();
          _createOrdersBloc.add(
            AddSubMarketContractEvent(
              equityName: symbol.symbolCode,
              accountId: accountId,
              callback: (success) {
                if (success) {
                  onSuccessSubMarketContractCallback();
                }
              },
            ),
          );
        },
      );
      return;
    }
    if (successMessage == 'Serbest İşlem Platformu onayın bulunmuyor.') {
      PBottomSheet.showError(
        context,
        content: L10n.tr('premarket_trading_contract_content'),
        showFilledButton: true,
        showOutlinedButton: true,
        outlinedButtonText: L10n.tr('vazgec'),
        onOutlinedButtonPressed: () => Navigator.pop(context),
        filledButtonText: L10n.tr('tamam'),
        onFilledButtonPressed: () {
          router.maybePop();
          _createOrdersBloc.add(
            AddSubMarketContractEvent(
              equityName: symbol.symbolCode,
              accountId: accountId,
              callback: (success) {
                if (success) {
                  onSuccessSubMarketContractCallback();
                }
              },
            ),
          );
        },
      );
      return;
    }

    if (successMessage == 'ContractForSubMarketOrderNotFound' ||
        successMessage == 'Alt Pazar sözleşme onayınız bulunmamaktadır.' ||
        successMessage == 'Alt hesap sözleşme onayın bulunmuyor.') {
      PBottomSheet.showError(
        context,
        content: L10n.tr('submarket_contract_content'),
        showFilledButton: true,
        showOutlinedButton: true,
        onOutlinedButtonPressed: () => Navigator.pop(context),
        outlinedButtonText: L10n.tr('vazgec'),
        filledButtonText: L10n.tr('tamam'),
        onFilledButtonPressed: () {
          router.maybePop();
          _createOrdersBloc.add(
            AddSubMarketContractEvent(
              equityName: symbol.symbolCode,
              accountId: accountId,
              callback: (success) {
                if (success) {
                  onSuccessSubMarketContractCallback();
                }
              },
            ),
          );
        },
      );
      return;
    }

    if (successMessage == 'CustomerAccounthavenotaGMSRBFContract') {
      /// Gayrimenkul Sertifikalarına İlişkin Risk Bildirim Formu uyarısı.

      if (UserModel.instance.innerType == 'INSTITUTION') {
        // Kurumsal Hesap kontrolü.
        PBottomSheet.showError(
          context,
          content: L10n.tr(
            'contract_institution_control_gmsrbf',
          ),
          showFilledButton: true,
          filledButtonText: L10n.tr('tamam'),
          onFilledButtonPressed: () {
            router.maybePop();
          },
        );

        return;
      }

      PBottomSheet.showError(
        context,
        content: L10n.tr('CustomerAccounthavenotaGMSRBFContract'),
        showFilledButton: true,
        showOutlinedButton: true,
        outlinedButtonText: L10n.tr('vazgec'),
        filledButtonText: L10n.tr('approve_contract'),
        onOutlinedButtonPressed: () => router.maybePop(),
        onFilledButtonPressed: () {
          router.maybePop();

          _contractsBloc.add(
            GetContractPdfEvent(
              contractCode: _appInfoBloc.state.realEstateCertificateContractCode,
              onContractCode: (refCode) {
                return PBottomSheet.show(
                  context,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.sizeOf(context).height * 0.7,
                    ),
                    child: RealEstateCertificatePdf(
                      refCode: refCode,
                      onApproved: () {
                        _contractsBloc.add(
                          ApproveGptConractEvent(
                            contractCode: _appInfoBloc.state.realEstateCertificateContractCode,
                            accountExtId: accountId,
                            contractRefCode: refCode,
                            successCallback: () {
                              onSuccessSubMarketContractCallback();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
      return;
    }

    router.popUntilRouteWithName(CreateOrderRoute.name);
    if (successMessage == 'ShortfallOrderDeniedOfInvestorBasedPrecaution' ||
        successMessage == 'CanNotEnterShortFallSellOrderInsufficientEquityCharacteristic') {
      successMessage = 'order.conditional_order_error.$successMessage';
    }

    router.replace(
      OrderResultRoute(
        isSuccess: !isError,
        message: L10n.tr(successMessage),
        buttonKey: successMessage == 'order.conditional_order_error.ContractForSubMarketOrderNotFound'
            ? 'submarket_contract_button_text'
            : null,
      ),
    );
  }
}
