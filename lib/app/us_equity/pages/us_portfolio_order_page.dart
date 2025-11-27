import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/switch_tile/switch_tile.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/quick_portfolio_asset_model.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/model_portfolio_tile.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/pvalue_textfield_widget.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/table_title_widget.dart';
import 'package:piapiri_v2/app/us_equity/widgets/us_order_confirmation_widget.dart';
import 'package:piapiri_v2/app/us_symbol_detail/widgets/us_clock.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/us_selected_account.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/model/us_market_status_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

//Amerikan borsası -> portfoy -> hisse seçimleri
@RoutePage()
class UsPortfolioOrderPage extends StatefulWidget {
  final String title;
  final List<QuickPortfolioAssetModel> portfolioList;

  const UsPortfolioOrderPage({
    super.key,
    required this.title,
    required this.portfolioList,
  });

  @override
  State<UsPortfolioOrderPage> createState() => _UsPortfolioOrderPageState();
}

class _UsPortfolioOrderPageState extends State<UsPortfolioOrderPage> {
  double _usMinAmount = 0;
  final TextEditingController _amountController =
      TextEditingController(text: MoneyUtils().readableMoney(double.parse(L10n.tr('us_portfolio_min_amount'))));
  double _amount = double.parse(L10n.tr('us_portfolio_min_amount'));
  List<QuickPortfolioAssetModel> _selectedAssets = [];
  bool _showDefault = true;
  bool _isFocus = false;
  bool _extendedHours = false;
  double _cashBalance = double.parse(L10n.tr('us_portfolio_min_amount'));
  late UsMarketStatus _marketStatus;
  @override
  void initState() {
    _usMinAmount = double.parse(L10n.tr('us_portfolio_min_amount'));
    _marketStatus = getMarketStatus();
    _selectedAssets = List.from(widget.portfolioList);
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Grid.m,
                    ),
                    child: Text(
                      L10n.tr(
                        'analysis_us_portfolio_description',
                        args: [
                          MoneyUtils().readableMoney(_usMinAmount),
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
                      title: L10n.tr('tutar'),
                      suffixText: CurrencyEnum.dollar.symbol,
                      controller: _amountController,
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
                      keyboardType: TextInputType.none,
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
                              shrinkWrap: true,
                              separatorBuilder: (context, index) => const PDivider(),
                              itemBuilder: (context, index) {
                                return ModelPortfolioTile(
                                  fromUs: true,
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

                          UsSelectAccountWidget(
                            onAmount: (amount) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  _cashBalance = amount;
                                });
                              });
                            },
                          ),

                          if (_marketStatus != UsMarketStatus.open) ...[
                            const SizedBox(
                              height: Grid.m,
                            ),
                            PSwitchRow(
                              text: L10n.tr('extended_hours_desc'),
                              textStyle: context.pAppStyle.labelReg14textPrimary,
                              value: _extendedHours,
                              onChanged: (value) {
                                setState(() {
                                  _extendedHours = value;
                                });
                              },
                            ),
                            const SizedBox(
                              height: Grid.m,
                            ),
                          ],
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
    double total = 0;

    for (QuickPortfolioAssetModel model in list) {
      if (model.isChanged) {
        total += model.ratio;
      }
    }
    return total;
  }

  _doContinue() {
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
    if (MoneyUtils().fromReadableMoney(price) < _usMinAmount) {
      return PBottomSheet.showError(
        context,
        content: L10n.tr('girilen_tutar_islem_yapmak_icin_yetersizdir'),
      );
    } else {
      getIt<Analytics>().track(
        AnalyticsEvents.modelPortfoyDevamClick,
        taxonomy: [
          InsiderEventEnum.controlPanel.value,
          InsiderEventEnum.marketsPage.value,
          InsiderEventEnum.americanStockExchanges.value,
          InsiderEventEnum.analysisTab.value,
          InsiderEventEnum.readyPortfoy.value,
        ],
      );
      PBottomSheet.show(
        context,
        title: L10n.tr('order_confirmation'),
        child: UsOrderConfirmationWidget(
          amount: _amount,
          selectedAssets: _selectedAssets,
          title: widget.title,
          extendedHours: _extendedHours,
        ),
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
