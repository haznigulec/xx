import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/quick_portfolio_asset_model.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/model_portfolio_tile.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/order_confirmation_widget.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/pvalue_textfield_widget.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/table_title_widget.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/text_input_formatters.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/select_account_widget.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

//robotik sepetler hisse seçim
@RoutePage()
class RoboticBasketOrderPage extends StatefulWidget {
  final String title;
  final List<QuickPortfolioAssetModel> portfolioList;
  final String? basketKey;

  const RoboticBasketOrderPage({
    super.key,
    required this.title,
    required this.portfolioList,
    this.basketKey,
  });

  @override
  State<RoboticBasketOrderPage> createState() => _RoboticBasketOrderPageState();
}

class _RoboticBasketOrderPageState extends State<RoboticBasketOrderPage> {
  final TextEditingController _amountController = TextEditingController(text: MoneyUtils().readableMoney(10000));
  double _amount = 10000;
  List<QuickPortfolioAssetModel> _selectedAssets = [];
  bool _showDefault = true;
  bool _isFocus = false;
  String _selectedAccount = '';
  late SymbolBloc _symbolBloc;
  double _cashBalance = 10000;
  @override
  void initState() {
    _selectedAssets = List.from(widget.portfolioList);
    _symbolBloc = getIt<SymbolBloc>();
    _symbolBloc.add(
      SymbolSubTopicsEvent(
        symbols: widget.portfolioList
            .map(
              (e) => MarketListModel(
                symbolCode: e.name,
                updateDate: '',
                type: SymbolTypes.equity.name,
              ),
            )
            .toList(),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
        ),
      ),
      child: Scaffold(
        appBar: PInnerAppBar(
          title: widget.title,
        ),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.s,
            ),
            child: PButton(
              text: L10n.tr('devam'),
              fillParentWidth: true,
              onPressed: _cashBalance < _amount || _amount == 0 ? null : () => _doContinue(),
            ),
          ),
        ],
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Grid.m,
                    ),
                    child: Text(
                      L10n.tr(
                        'analysis_buy_robotic_basket_page_info',
                        args: [
                          MoneyUtils().readableMoney(10000),
                        ],
                      ),
                      style: context.pAppStyle.labelReg14textPrimary,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: Grid.s + Grid.xxs,
                      horizontal: Grid.m,
                    ),
                    child: PValueTextfieldWidget(
                      isError: _cashBalance < _amount,
                      errorText: _cashBalance < _amount ? L10n.tr('insufficient_transaction_limit') : null,
                      valueTextStyle: context.pAppStyle.labelMed16primary.copyWith(
                        color: _cashBalance < _amount ? context.pColorScheme.critical : context.pColorScheme.primary,
                      ),
                      title: L10n.tr('tutar'),
                      controller: _amountController,
                      suffixText: CurrencyEnum.turkishLira.symbol,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: false,
                      ),
                      inputFormatters: [
                        AppInputFormatters.decimalFormatter(
                          maxDigitAfterSeparator: 2,
                        ),
                      ],
                      onFocusChange: (value) {
                        if (!value) {
                          _amountController.text = MoneyUtils().readableMoney(_amount);
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          _amount = MoneyUtils().fromReadableMoney(value);
                        });
                      },
                      onSubmitted: (value) {
                        _amountController.text = MoneyUtils().readableMoney(_amount);
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Grid.m,
                      ),
                      child: Column(
                        children: [
                          TableTitleWidget(
                            primaryColumnTitle: L10n.tr('equity'),
                            secondaryColumnTitle: L10n.tr('tutar'),
                            tertiaryColumnTitle: '${L10n.tr('yuzde')} %',
                          ),
                          Expanded(
                            child: ListView.separated(
                              itemCount: widget.portfolioList.length,
                              separatorBuilder: (context, index) => const PDivider(),
                              itemBuilder: (context, index) {
                                return ModelPortfolioTile(
                                  modelPortfolio: _selectedAssets[index],
                                  totalAmount: _amount,
                                  numberOfSelectedAssets: _selectedAssets.where((element) => element.isChecked).length,
                                  showDefault: _showDefault,
                                  isChecked: _selectedAssets[index].isChecked,
                                  onChecked: (value) {
                                    setState(() {
                                      _showDefault = false;
                                      _selectedAssets[index] = _selectedAssets[index].copyWith(
                                        isChecked: value,
                                        ratio: 0,
                                        isChanged: false,
                                      );
                                      Iterable<QuickPortfolioAssetModel> checkedAssets = _selectedAssets.where(
                                        (element) => element.isChecked && !element.isChanged,
                                      );
                                      Iterable<QuickPortfolioAssetModel> changedAndCheckedAssets =
                                          _selectedAssets.where(
                                        (element) => element.isChecked && element.isChanged,
                                      );

                                      double totalRatio = calculateTotalRatio(changedAndCheckedAssets.toList());

                                      for (int i = 0; i < _selectedAssets.length; i++) {
                                        if (!_selectedAssets[i].isChanged && _selectedAssets[i].isChecked) {
                                          _selectedAssets[i] = _selectedAssets[i].copyWith(
                                            ratio: (100 - totalRatio) / checkedAssets.length,
                                          );
                                        }
                                      }
                                    });
                                  },
                                  onChangedRatio: (double ratio) {
                                    setState(() {
                                      double oldRatio = _selectedAssets[index].ratio;
                                      Iterable<QuickPortfolioAssetModel> checkedAssets = _selectedAssets.where(
                                        (element) => element.isChecked,
                                      );
                                      _selectedAssets[index] =
                                          _selectedAssets[index].copyWith(ratio: ratio, isChanged: true);
                                      double totalRatio = calculateTotalRatio(checkedAssets.toList());
                                      if (totalRatio > 100) {
                                        _selectedAssets[index] = _selectedAssets[index].copyWith(ratio: oldRatio);
                                        totalRatio = totalRatio - ratio + oldRatio;
                                      }
                                      double remainingRatio = 100 - totalRatio;
                                      Iterable<QuickPortfolioAssetModel> selectedUnchangedAssets =
                                          _selectedAssets.where(
                                        (element) => element.isChecked && !element.isChanged,
                                      );
                                      double equalRatio = remainingRatio / selectedUnchangedAssets.length;
                                      for (int i = 0; i < _selectedAssets.length; i++) {
                                        if (!_selectedAssets[i].isChanged && _selectedAssets[i].isChecked) {
                                          _selectedAssets[i] = _selectedAssets[i].copyWith(ratio: equalRatio);
                                        }
                                      }
                                    });
                                  },
                                  isFocus: (value) {
                                    setState(() {
                                      _isFocus = value;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                          SelectAccountWidget(
                            onAmount: (amount) {
                              setState(() {
                                _cashBalance = amount;
                              });
                            },
                            onSelectedAccount: (account) {
                              setState(() {
                                _selectedAccount = account.split('-')[1];
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _isFocus ? Grid.xxl : 0,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: _isFocus ? keyboardCloseButton(context) : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  double calculateTotalRatio(List<QuickPortfolioAssetModel> list) {
    double total = 0.0;

    for (QuickPortfolioAssetModel model in list) {
      if (model.isChanged) {
        total += model.ratio;
      }
    }
    return total;
  }

  _doContinue() {
    if (widget.basketKey != null) {
      _eventDecider(widget.basketKey!);
    }

    if (_selectedAssets.every((element) => !element.isChecked)) {
      return PBottomSheet.showError(
        context,
        content: L10n.tr('lutfen_en_az_bir_adet_sembol_seciniz'),
      );
    }

    String price = '';

    if (MoneyUtils().readableMoney(_amount) == '0,00') {
      price = '0';
    } else {
      price = _amount.toString();
    }
    if (MoneyUtils().fromReadableMoney(price) < 10000) {
      return PBottomSheet.showError(
        context,
        content: L10n.tr('girilen_tutar_islem_yapmak_icin_yetersizdir'),
      );
    } else {
      getIt<Analytics>().track(AnalyticsEvents.modelPortfoyDevamClick);
      PBottomSheet.show(
        context,
        title: L10n.tr('order_confirmation'),
        child: OrderConfirmationWidget(
          amount: _amount,
          selectedAssets: _selectedAssets,
          accountExtId: _selectedAccount.isNotEmpty ? _selectedAccount : UserModel.instance.accountId,
          portfolioKey: 'robotik_sepet',
          title: widget.title,
          basketKey: widget.basketKey,
        ),
      );
    }
  }

  void _eventDecider(String key) {
    switch (key) {
      case 'teknoloji_hisseleri_sepeti':
        getIt<Analytics>().track(
          AnalyticsEvents.teknolojiHisseleriDevamClick,
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
          AnalyticsEvents.temettuHisseleriDevamClick,
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
          AnalyticsEvents.dovizPozitifHisseleriDevamClick,
          taxonomy: [
            InsiderEventEnum.controlPanel.value,
            InsiderEventEnum.marketsPage.value,
            InsiderEventEnum.istanbulStockExchangeTab.value,
            InsiderEventEnum.analysisTab.value,
          ],
        );
        break;
      default:
        getIt<Analytics>().track(
          AnalyticsEvents.teknolojiHisseleriDevamClick,
          taxonomy: [
            InsiderEventEnum.controlPanel.value,
            InsiderEventEnum.marketsPage.value,
            InsiderEventEnum.istanbulStockExchangeTab.value,
            InsiderEventEnum.analysisTab.value,
          ],
        );
    }
  }

  Widget keyboardCloseButton(BuildContext context) {
    return Container(
      height: Grid.xl,
      width: MediaQuery.of(context).size.width,
      color: context.pColorScheme.transparent,
      child: TextButton(
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            L10n.tr('tamam'),
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.right,
          ),
        ),
        onPressed: () {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}
