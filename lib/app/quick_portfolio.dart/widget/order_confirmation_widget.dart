import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_bloc.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_event.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_state.dart';
import 'package:piapiri_v2/app/info/model/info_variant.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_bloc.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_event.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_state.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/quick_portfolio_asset_model.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_bloc.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_event.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class OrderConfirmationWidget extends StatelessWidget {
  final double amount;
  final List<QuickPortfolioAssetModel> selectedAssets;
  final String accountExtId;
  final String portfolioKey;
  final String title;
  final String? basketKey;
  const OrderConfirmationWidget({
    super.key,
    required this.amount,
    required this.selectedAssets,
    required this.accountExtId,
    required this.portfolioKey,
    required this.title,
    this.basketKey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: L10n.tr(
                  'order_send_span_1',
                  args: [
                    CurrencyEnum.turkishLira.symbol + MoneyUtils().readableMoney(amount),
                  ],
                ),
                style: context.pAppStyle.labelReg16textPrimary,
              ),
              TextSpan(
                text: title,
                style: context.pAppStyle.labelMed16textPrimary,
              ),
              TextSpan(
                text: ' ${L10n.tr('alis')} '.toUpperCase(),
                style: context.pAppStyle.interMediumBase.copyWith(
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
                _orderDetail(
                  context,
                  portfolioKey == 'fon_sepeti' ? _fundListData() : _listData(amount),
                );
              }
            },
          ),
        ),
        const SizedBox(
          height: Grid.l,
        ),
        actionButtons(),
      ],
    );
  }

  _orderDetail(context, List<Map<String, dynamic>> listData) {
    List<Map<String, dynamic>> filteredSymbols =
        listData.where((symbol) => symbol['symbolAmount'] != 0 || symbol['count'] != 0).toList();
    PBottomSheet.show(
      titlePadding: const EdgeInsets.only(
        top: Grid.m,
      ),
      showBackButton: true,
      context,
      title: L10n.tr('emirler'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.separated(
              shrinkWrap: true,
              itemCount: filteredSymbols.length,
              separatorBuilder: (context, index) => const PDivider(),
              itemBuilder: (context, index) {
                return _orderTile(context, filteredSymbols[index]);
              }),
          const SizedBox(
            height: Grid.m,
          ),
          actionButtons(),
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  textAlign: TextAlign.start,
                  selectedAsset['symbolCode'],
                  style: context.pAppStyle.labelReg14textPrimary,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: Grid.xs),
                  child: Text(
                    textAlign: TextAlign.start,
                    L10n.tr('al'),
                    style: context.pAppStyle.labelMed14textPrimary.copyWith(
                      color: context.pColorScheme.success,
                    ),
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
              '₺${MoneyUtils().readableMoney(selectedAsset['symbolPrice'] * selectedAsset['count'])}',
              style: context.pAppStyle.labelReg14textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget actionButtons() {
    return PBlocBuilder<OrdersBloc, OrdersState>(
      bloc: getIt<OrdersBloc>(),
      builder: (context, orderState) {
        return PBlocBuilder<FundBloc, FundState>(
          bloc: getIt<FundBloc>(),
          builder: (context, fundState) {
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
                    loading: orderState.isLoading || fundState.isLoading,
                    text: L10n.tr('onayla'),
                    fillParentWidth: true,
                    onPressed: orderState.isLoading || fundState.isLoading
                        ? null
                        : () {
                            if (basketKey != null) {
                              _eventDecider(basketKey!);
                            }

                            if (portfolioKey == 'model_portfoy' || portfolioKey == 'robotik_sepet') {
                              getIt<OrdersBloc>().add(
                                CreateBulkOrderEvent(
                                  account: accountExtId,
                                  list: _listData(amount),
                                  trackEvent: () => getIt<Analytics>().track(AnalyticsEvents.modelPortfoyOnaylaClick),
                                  callback: (int successCount, int failureCount) {
                                    String message = L10n.tr('bulk_order_all_success');
                                    bool isError = false;

                                    if (successCount == 0) {
                                      message = L10n.tr('bulk_order_all_failed');
                                      isError = true;
                                    } else if (failureCount > 0) {
                                      message = L10n.tr(
                                        'bulk_order_success_with_failure',
                                        args: [
                                          successCount.toString(),
                                          failureCount.toString(),
                                        ],
                                      );
                                      isError = true;
                                    }
                                    router.push(
                                      InfoRoute(
                                        variant: isError ? InfoVariant.failed : InfoVariant.success,
                                        message: message,
                                        buttonText: L10n.tr('emirlerime_don'),
                                        onTapButton: () {
                                          router.popUntilRoot();
                                          getIt<TabBloc>().add(
                                            const TabChangedEvent(
                                              tabIndex: 1,
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                            if (portfolioKey == 'fon_sepeti') {
                              getIt<FundBloc>().add(
                                NewBulkOrderEvent(
                                  account: accountExtId,
                                  list: _fundListData(),
                                  callback: (int successCount, int failureCount) {
                                    String message = L10n.tr('bulk_order_all_success');
                                    bool isError = false;

                                    if (successCount == 0) {
                                      message = L10n.tr('bulk_order_all_failed');
                                      isError = true;
                                    } else if (failureCount > 0) {
                                      message = L10n.tr(
                                        'bulk_order_success_with_failure',
                                        args: [
                                          successCount.toString(),
                                          failureCount.toString(),
                                        ],
                                      );
                                      isError = true;
                                    }
                                    router.push(
                                      InfoRoute(
                                        variant: isError ? InfoVariant.failed : InfoVariant.success,
                                        message: message,
                                        buttonText: L10n.tr('emirlerime_don'),
                                        onTapButton: () {
                                          router.popUntilRoot();
                                          getIt<TabBloc>().add(
                                            const TabChangedEvent(
                                              tabIndex: 1,
                                            ),
                                          );
                                        },
                                      ),
                                    );
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
      },
    );
  }

  void _eventDecider(String key) {
    switch (key) {
      case 'teknoloji_hisseleri_sepeti':
        getIt<Analytics>().track(
          AnalyticsEvents.teknolojiHisseleriOnaylaClick,
          taxonomy: [
            InsiderEventEnum.controlPanel.value,
            InsiderEventEnum.marketsPage.value,
            InsiderEventEnum.istanbulStockExchangeTab.value,
            InsiderEventEnum.analysisTab.value,
          ],
        );
        break;
      case 'temettu_hisseleri_sepeti':
        getIt<Analytics>().track(
          AnalyticsEvents.temettuHisseleriOnaylaClick,
          taxonomy: [
            InsiderEventEnum.controlPanel.value,
            InsiderEventEnum.marketsPage.value,
            InsiderEventEnum.istanbulStockExchangeTab.value,
            InsiderEventEnum.analysisTab.value,
          ],
        );
        break;
      case 'doviz_pozitif_hisseleri_sepeti':
        getIt<Analytics>().track(
          AnalyticsEvents.dovizPozitifHisseleriOnaylaClick,
          taxonomy: [
            InsiderEventEnum.controlPanel.value,
            InsiderEventEnum.marketsPage.value,
            InsiderEventEnum.istanbulStockExchangeTab.value,
            InsiderEventEnum.analysisTab.value,
          ],
        );
        break;
      case 'model_portfolio':
        getIt<Analytics>().track(
          AnalyticsEvents.modelPortfoyOnaylaClick,
          taxonomy: [
            InsiderEventEnum.controlPanel.value,
            InsiderEventEnum.marketsPage.value,
            InsiderEventEnum.istanbulStockExchangeTab.value,
            InsiderEventEnum.analysisTab.value,
          ],
        );
        break;
      case 'dinamik_fon_dagilimi':
        getIt<Analytics>().track(
          AnalyticsEvents.dinamikFonDagilimOnaylaClick,
          taxonomy: [
            InsiderEventEnum.controlPanel.value,
            InsiderEventEnum.marketsPage.value,
            InsiderEventEnum.investmentFundTab.value,
            InsiderEventEnum.analysisTab.value,
          ],
        );
        break;
      case 'dengeli_fon_dagilimi':
        getIt<Analytics>().track(
          AnalyticsEvents.dengeliFonDagilimOnaylaClick,
          taxonomy: [
            InsiderEventEnum.controlPanel.value,
            InsiderEventEnum.marketsPage.value,
            InsiderEventEnum.investmentFundTab.value,
            InsiderEventEnum.analysisTab.value,
          ],
        );
        break;
      case 'atak_fon_dagilimi':
        getIt<Analytics>().track(
          AnalyticsEvents.atakFonDagilimiOnaylaClick,
          taxonomy: [
            InsiderEventEnum.controlPanel.value,
            InsiderEventEnum.marketsPage.value,
            InsiderEventEnum.investmentFundTab.value,
            InsiderEventEnum.analysisTab.value,
          ],
        );
        break;
      default:
        getIt<Analytics>().track(
          AnalyticsEvents.teknolojiHisseleriOnaylaClick,
          taxonomy: [
            InsiderEventEnum.controlPanel.value,
            InsiderEventEnum.marketsPage.value,
            InsiderEventEnum.istanbulStockExchangeTab.value,
            InsiderEventEnum.analysisTab.value,
          ],
        );
    }
  }

  List<Map<String, dynamic>> _listData(double amount) {
    List<String> selectedAssetsNames = selectedAssets.map((e) => e.code).toList();
    List<MarketListModel> subscribedSymbols = getIt<SymbolBloc>()
        .state
        .watchingItems
        .where((element) => selectedAssetsNames.contains(element.symbolCode))
        .toList();

    return selectedAssets.where((data) => data.ratio != 0).map((data) {
      MarketListModel? symbolData = subscribedSymbols.firstWhere(
        (element) => element.symbolCode == data.code,
      );
      double symbolAmount = amount * data.ratio / 100;
      double symbolPrice = symbolData.last == 0 ? symbolData.dayClose : symbolData.last;
      int count = (symbolAmount / symbolPrice).floor();
      return {
        'symbolCode': data.code,
        'symbolAmount': symbolAmount,
        'symbolPrice': symbolPrice,
        'count': count,
      };
    }).toList();
  }

  List<Map<String, dynamic>> _fundListData() {
    return selectedAssets.where((data) {
      double symbolAmount = amount * data.ratio / 100;
      double symbolPrice = data.amount;
      int count = (symbolAmount / symbolPrice).floor();
      return count >= 1;
    }).map((data) {
      double symbolAmount = amount * data.ratio / 100;
      double symbolPrice = data.amount;
      int count = (symbolAmount / symbolPrice).floor();
      String name = data.name;
      String fundValorDate = data.fundValorDate!;
      return {
        'symbolCode': data.code,
        'symbolAmount': symbolAmount,
        'symbolPrice': symbolPrice,
        'count': count,
        'name': name,
        'fundValorDate': fundValorDate,
      };
    }).toList();
  }
}
