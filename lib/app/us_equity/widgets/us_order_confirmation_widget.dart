import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/create_us_order/bloc/create_us_orders_bloc.dart';
import 'package:piapiri_v2/app/create_us_order/bloc/create_us_orders_event.dart';
import 'package:piapiri_v2/app/create_us_order/bloc/create_us_orders_state.dart';
import 'package:piapiri_v2/app/info/model/info_variant.dart';
import 'package:piapiri_v2/app/orders/model/american_order_type_enum.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/quick_portfolio_asset_model.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_bloc.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_event.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';

import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/us_symbol_snapshot.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class UsOrderConfirmationWidget extends StatelessWidget {
  final double amount;
  final bool extendedHours;
  final List<QuickPortfolioAssetModel> selectedAssets;

  final String title;
  const UsOrderConfirmationWidget({
    super.key,
    required this.extendedHours,
    required this.amount,
    required this.selectedAssets,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    List<bool> responseStatusList = [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: L10n.tr('order_send_span_1',
                    args: [CurrencyEnum.dollar.symbol + MoneyUtils().readableMoney(amount)]),
                style: context.pAppStyle.labelReg16textPrimary,
              ),
              TextSpan(
                text: title,
                style: context.pAppStyle.labelReg16textPrimary,
              ),
              TextSpan(
                text: ' ${L10n.tr('alis')} ',
                style: context.pAppStyle.interRegularBase.copyWith(
                  fontSize: Grid.m,
                  color: context.pColorScheme.success,
                ),
              ),
              TextSpan(
                text: L10n.tr('order_send_span_2'),
                style: context.pAppStyle.labelReg16textPrimary,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: Grid.s,
        ),
        Center(
          child: PTextButton(
            text: L10n.tr('show_order_detail'),
            onPressed: () async {
              await router.maybePop();
              if (context.mounted) {
                _orderDetail(context, _listData(amount), responseStatusList);
              }
            },
          ),
        ),
        const SizedBox(
          height: Grid.l,
        ),
        _actionButtons(_listData(amount), responseStatusList),
      ],
    );
  }

  _orderDetail(context, List<Map<String, dynamic>> listData, List<bool> responseStatusList) {
    List<Map<String, dynamic>> filteredSymbols =
        listData.where((symbol) => symbol['symbolAmount'] != 0 || symbol['count'] != 0).toList();

    PBottomSheet.show(
      context,
      title: L10n.tr('emirler'),
      showBackButton: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: filteredSymbols.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    _orderTile(context, filteredSymbols[index]),
                    if (index != filteredSymbols.length - 1) const PDivider(),
                  ],
                );
              }),
          _actionButtons(listData, responseStatusList),
        ],
      ),
    );
  }

  Widget _orderTile(
    BuildContext context,
    Map<String, dynamic> selectedAsset,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Grid.m),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Text(
                  textAlign: TextAlign.start,
                  selectedAsset['symbolCode'],
                  style: context.pAppStyle.interRegularBase.copyWith(
                    fontSize: Grid.m - Grid.xxs,
                  ),
                ),
                const SizedBox(
                  width: Grid.xs,
                ),
                Text(
                  textAlign: TextAlign.start,
                  L10n.tr('al'),
                  style: context.pAppStyle.interRegularBase.copyWith(
                    fontSize: Grid.m - Grid.xxs,
                    color: context.pColorScheme.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              textAlign: TextAlign.end,
              '${selectedAsset['count']} ${L10n.tr('adet')}',
              style: context.pAppStyle.labelReg14textSecondary,
            ),
          ),
          const SizedBox(
            width: Grid.l,
          ),
          Expanded(
            child: Text(
              textAlign: TextAlign.end,
              '\$${MoneyUtils().readableMoney(selectedAsset['symbolPrice'] * selectedAsset['count'])}',
              style: context.pAppStyle.labelReg14textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButtons(List<Map<String, dynamic>> listData, List<bool> responseStatusList) {
    return PBlocBuilder<CreateUsOrdersBloc, CreateUsOrdersState>(
      bloc: getIt<CreateUsOrdersBloc>(),
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: POutlinedButton(
                text: L10n.tr('vazgec'),
                fillParentWidth: true,
                sizeType: PButtonSize.medium,
                onPressed: () {
                  router.maybePop();
                },
              ),
            ),
            const SizedBox(
              width: Grid.s,
            ),
            Expanded(
              child: PButton(
                text: L10n.tr('onayla'),
                loading: state.isLoading,
                fillParentWidth: true,
                onPressed: state.isLoading
                    ? null
                    : () {
                        List<Map<String, dynamic>> filteredSymbols =
                            listData.where((symbol) => symbol['count'] != 0).toList();

                        for (Map<String, dynamic> symbol in filteredSymbols) {
                          getIt<CreateUsOrdersBloc>().add(
                            CreateOrderEvent(
                              symbolName: symbol['symbolCode'],
                              extendedHours: extendedHours,
                              quantity: symbol['count'].toString(),
                              amount: null,
                              limitPrice: symbol['symbolPrice'],
                              stopPrice: null,
                              equityPrice: null,
                              orderActionType: OrderActionTypeEnum.buy,
                              orderType: AmericanOrderTypeEnum.limit,
                              callback: (isSuccess, message) {
                                if (isSuccess) {
                                  responseStatusList.add(isSuccess);
                                } else {
                                  responseStatusList.add(isSuccess);
                                }

                                if (responseStatusList.length == filteredSymbols.length) {
                                  String successCount =
                                      responseStatusList.where((status) => status == true).length.toString();
                                  String failureCount =
                                      responseStatusList.where((status) => status == false).length.toString();
                                  router.push(
                                    InfoRoute(
                                      variant: responseStatusList.any((e) => e == true)
                                          ? InfoVariant.success
                                          : InfoVariant.failed,
                                      message: L10n.tr('us_bulk_order_submission',
                                          args: [responseStatusList.length.toString(), successCount, failureCount]),
                                      buttonText: L10n.tr('emirlerime_don'),
                                      onTapButton: () {
                                        router.popUntilRoot();
                                        getIt<TabBloc>().add(
                                          const TabChangedEvent(
                                            tabIndex: 1,
                                          ),
                                        );
                                      },
                                      onPressedCloseIcon: () {
                                        router.popUntilRoot();
                                        getIt<TabBloc>().add(
                                          const TabChangedEvent(
                                            tabIndex: 1,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        }
                      },
              ),
            ),
          ],
        );
      },
    );
  }

  List<Map<String, dynamic>> _listData(double amount) {
    List<String> selectedAssetsNames = selectedAssets.map((e) => e.code).toList();
    List<UsSymbolSnapshot> subscribedSymbols = getIt<UsEquityBloc>()
        .state
        .polygonWatchingItems
        .where((element) => selectedAssetsNames.contains(element.ticker))
        .toList();
    return selectedAssets.where((data) => data.ratio != 0).map((data) {
      UsSymbolSnapshot? symbolData = subscribedSymbols.firstWhere(
        (element) => element.ticker == data.code,
      );
      double symbolAmount = amount * data.ratio / 100;
      double symbolPrice = MoneyUtils().fromReadableMoney(MoneyUtils().getUsPrice(symbolData));
      int count = (symbolAmount / symbolPrice).floor();
      return {
        'symbolCode': data.code,
        'symbolAmount': symbolAmount.toString(),
        'symbolPrice': symbolPrice,
        'count': count,
      };
    }).toList();
  }
}
