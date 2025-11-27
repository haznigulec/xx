import 'package:collection/collection.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_bloc.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_event.dart';
import 'package:piapiri_v2/app/currency_buy_sell/bloc/currency_buy_sell_bloc.dart';
import 'package:piapiri_v2/app/currency_buy_sell/bloc/currency_buy_sell_event.dart';
import 'package:piapiri_v2/app/currency_buy_sell/bloc/currency_buy_sell_state.dart';
import 'package:piapiri_v2/app/currency_buy_sell/widgets/currency_buy_sell_confirmation_widget.dart';
import 'package:piapiri_v2/app/currency_buy_sell/widgets/currency_limit_alert_widget.dart';
import 'package:piapiri_v2/app/currency_buy_sell/widgets/currency_rate_widget.dart';
import 'package:piapiri_v2/app/currency_buy_sell/widgets/curreny_working_hours_info_widget.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_bloc.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_event.dart';
import 'package:piapiri_v2/app/info/model/info_variant.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/pvalue_textfield_widget.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/text_input_formatters.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_bloc.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_event.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/account_model.dart';
import 'package:piapiri_v2/core/model/alpaca_account_status_enum.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class CurrencySellPage extends StatefulWidget {
  final CurrencyEnum currencyType;
  final List<AccountModel> accountsByCurrency;
  const CurrencySellPage({
    super.key,
    required this.currencyType,
    required this.accountsByCurrency,
  });

  @override
  State<CurrencySellPage> createState() => _CurrencySellPageState();
}

class _CurrencySellPageState extends State<CurrencySellPage> {
  late CurrencyBuySellBloc _currencyBuySellBloc;
  final TextEditingController _receivedAmount = TextEditingController(text: MoneyUtils().readableMoney(0));
  final TextEditingController _soldAmount = TextEditingController(text: MoneyUtils().readableMoney(0));
  String? _errorText;
  String _selectedCurrencyAccount = '';
  List<AccountModel> _tlAccountList = [];
  String _selectedTlAccount = '';
  double _lowerLimit = 0;
  double _upperLimit = 0;
  bool _showLowerAlert = false;
  bool _showUpperAlert = false;
  late GlobalAccountOnboardingBloc _globalOnboardingBloc;
  late AssetsBloc _assetsBloc;

  @override
  void initState() {
    _globalOnboardingBloc = getIt<GlobalAccountOnboardingBloc>();
    _assetsBloc = getIt<AssetsBloc>();
    _selectedCurrencyAccount = widget.accountsByCurrency[0].accountId;

    _currencyBuySellBloc = getIt<CurrencyBuySellBloc>();

    if (UserModel.instance.accounts.isNotEmpty) {
      _tlAccountList =
          UserModel.instance.accounts.where((element) => element.currency == CurrencyEnum.turkishLira).toList();
      _selectedTlAccount = _tlAccountList[0].accountId;
    }

    _currencyBuySellBloc.add(
      GetCurrencyRatiosEvent(
        currency: widget.currencyType.shortName.toUpperCase(),
      ),
    );
    _currencyBuySellBloc.add(
      GetInstantCashAmountEvent(
        accountId: _selectedCurrencyAccount.split('-')[1],
        finInstName: widget.currencyType.shortName.toUpperCase(),
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<CurrencyBuySellBloc, CurrencyBuySellState>(
      bloc: _currencyBuySellBloc,
      builder: (context, state) {
        double currencyRate = 0;
        if (state.currencyRatioList != null &&
            state.currencyRatioList!.isNotEmpty &&
            state.currencyRatioList![0].creditPrice != 0) {
          currencyRate = state.currencyRatioList![0].creditPrice ?? 0;
        }

        if (widget.currencyType == CurrencyEnum.dollar) {
          _lowerLimit = state.systemParametersModel?.fcUsdSellOnceMinLimit ?? 0;
          _upperLimit = state.systemParametersModel?.fcUsdSellOnceMaxLimit ?? 0;
        } else if (widget.currencyType == CurrencyEnum.euro) {
          _lowerLimit = state.systemParametersModel?.fcEurSellOnceMinLimit ?? 0;
          _upperLimit = state.systemParametersModel?.fcEurSellOnceMaxLimit ?? 0;
        } else if (widget.currencyType == CurrencyEnum.pound) {
          _lowerLimit = state.systemParametersModel?.fcGbpSellOnceMinLimit ?? 0;
          _upperLimit = state.systemParametersModel?.fcGbpSellOnceMaxLimit ?? 0;
        }

        return Shimmerize(
          enabled: state.isLoading,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CurrencyRateWidget(
                        currencyType: widget.currencyType,
                        currencyRate: currencyRate,
                      ),
                      const SizedBox(
                        height: Grid.s,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Grid.m,
                          vertical: Grid.s + Grid.xs,
                        ),
                        decoration: BoxDecoration(
                          color: context.pColorScheme.card,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(Grid.m),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  L10n.tr(
                                    'by_account',
                                    args: [
                                      widget.currencyType.shortName.toUpperCase(),
                                    ],
                                  ),
                                  style: context.pAppStyle.labelReg14textPrimary,
                                ),
                                const SizedBox(
                                  height: Grid.s,
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${L10n.tr('cash_balance')}: ',
                                        style: context.pAppStyle.labelReg12textSecondary,
                                      ),
                                      TextSpan(
                                        text: '${widget.currencyType.symbol}${MoneyUtils().readableMoney(
                                          state.tradeLimitByCurrency ?? 0,
                                        )}',
                                        style: context.pAppStyle.labelMed12textSecondary,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            widget.accountsByCurrency.length == 1
                                ? Text(
                                    _selectedCurrencyAccount,
                                    style: context.pAppStyle.labelMed14textPrimary,
                                  )
                                : InkWell(
                                    onTap: () {
                                      PBottomSheet.show(
                                        context,
                                        title: L10n.tr(
                                          'by_account',
                                          args: [
                                            widget.currencyType.shortName.toUpperCase(),
                                          ],
                                        ),
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          itemCount: widget.accountsByCurrency.length,
                                          separatorBuilder: (context, index) => const PDivider(),
                                          itemBuilder: (context, index) {
                                            final account = widget.accountsByCurrency[index];
                                            return BottomsheetSelectTile(
                                              title: account.accountId,
                                              isSelected: _selectedCurrencyAccount == account.accountId,
                                              value: account,
                                              onTap: (title, value) {
                                                setState(() {
                                                  _selectedCurrencyAccount = title;

                                                  _currencyBuySellBloc.add(
                                                    GetInstantCashAmountEvent(
                                                      accountId: _selectedCurrencyAccount.split('-')[1],
                                                      finInstName: widget.currencyType.shortName.toUpperCase(),
                                                    ),
                                                  );

                                                  router.maybePop();
                                                });
                                              },
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          _selectedCurrencyAccount,
                                          style: context.pAppStyle.labelMed14primary,
                                        ),
                                        const SizedBox(
                                          width: Grid.xs,
                                        ),
                                        SvgPicture.asset(
                                          ImagesPath.chevron_down,
                                          width: 15,
                                          height: 15,
                                          colorFilter: ColorFilter.mode(
                                            context.pColorScheme.primary,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: Grid.s,
                      ),
                      Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(
                          horizontal: Grid.m,
                          vertical: Grid.s + Grid.xs,
                        ),
                        decoration: BoxDecoration(
                          color: context.pColorScheme.card,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(Grid.m),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              L10n.tr(
                                'by_account',
                                args: [
                                  'TL',
                                ],
                              ),
                              style: context.pAppStyle.labelReg14textPrimary,
                            ),
                            _tlAccountList.length == 1
                                ? Text(
                                    _selectedTlAccount,
                                    style: context.pAppStyle.labelMed14textPrimary,
                                  )
                                : InkWell(
                                    onTap: () {
                                      PBottomSheet.show(
                                        context,
                                        title: L10n.tr(
                                          'by_account',
                                          args: [
                                            widget.currencyType.shortName.toUpperCase(),
                                          ],
                                        ),
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          itemCount: _tlAccountList.length,
                                          separatorBuilder: (context, index) => const PDivider(),
                                          itemBuilder: (context, index) {
                                            final account = _tlAccountList[index];
                                            return BottomsheetSelectTile(
                                              title: account.accountId,
                                              isSelected: _selectedTlAccount == account.accountId,
                                              value: account,
                                              onTap: (title, value) {
                                                setState(() {
                                                  _selectedTlAccount = title;

                                                  router.maybePop();
                                                });
                                              },
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          _selectedTlAccount,
                                          style: context.pAppStyle.labelMed14primary,
                                        ),
                                        const SizedBox(
                                          width: Grid.xs,
                                        ),
                                        SvgPicture.asset(
                                          ImagesPath.chevron_down,
                                          width: 15,
                                          height: 15,
                                          colorFilter: ColorFilter.mode(
                                            context.pColorScheme.primary,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: Grid.s,
                      ),
                      IgnorePointer(
                        ignoring: (state.tradeLimitByCurrency ?? 0) <= 0,
                        child: PValueTextfieldWidget(
                          controller: _soldAmount,
                          title: L10n.tr(
                            'to_be_sold',
                            args: [
                              widget.currencyType.shortName.toUpperCase(),
                            ],
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: false,
                          ),
                          inputFormatters: [
                            AppInputFormatters.decimalFormatter(
                              maxDigitAfterSeparator: 2,
                            ),
                          ],
                          valueTextStyle:
                              (state.tradeLimitByCurrency ?? 0) <= 0 ? context.pAppStyle.labelMed18textTeritary : null,
                          suffixText: widget.currencyType.symbol,
                          suffixStyle:
                              (state.tradeLimitByCurrency ?? 0) <= 0 ? context.pAppStyle.labelMed18textTeritary : null,
                          errorText: _errorText,
                          onFocusChange: (hasFocus) {
                            if (!hasFocus) {
                              double amount =
                                  _soldAmount.text.isEmpty ? 0 : MoneyUtils().fromReadableMoney(_soldAmount.text);
                              _soldAmount.text = MoneyUtils().readableMoney(amount);
                            }
                          },
                          onTapPrice: () {
                            if (MoneyUtils().fromReadableMoney(_soldAmount.text) == 0) {
                              _soldAmount.text = '';
                            }
                          },
                          onSubmitted: (value) {
                            setState(() {
                              _soldAmount.text = value;
                              double soldAmount = MoneyUtils().fromReadableMoney(_soldAmount.text);

                              if (soldAmount < _lowerLimit) {
                                _showLowerAlert = true;
                              } else {
                                _showLowerAlert = false;
                              }

                              if (soldAmount > _upperLimit) {
                                _showUpperAlert = true;
                              } else {
                                _showUpperAlert = false;
                              }

                              _receivedAmount.text = MoneyUtils().readableMoney(soldAmount * currencyRate);

                              if (soldAmount > (state.tradeLimitByCurrency ?? 0)) {
                                _errorText = L10n.tr('insufficient_cash_balance');
                              } else {
                                _errorText = null;
                              }
                              FocusScope.of(context).unfocus();
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: Grid.s,
                      ),
                      IgnorePointer(
                        ignoring: (state.tradeLimitByCurrency ?? 0) <= 0,
                        child: PValueTextfieldWidget(
                          controller: _receivedAmount,
                          title: L10n.tr(
                            'to_be_received',
                            args: [
                              'TL',
                            ],
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: false,
                          ),
                          inputFormatters: [
                            AppInputFormatters.decimalFormatter(
                              maxDigitAfterSeparator: 2,
                            ),
                          ],
                          valueTextStyle:
                              (state.tradeLimitByCurrency ?? 0) <= 0 ? context.pAppStyle.labelMed18textTeritary : null,
                          suffixText: '₺',
                          suffixStyle:
                              (state.tradeLimitByCurrency ?? 0) <= 0 ? context.pAppStyle.labelMed18textTeritary : null,
                          onFocusChange: (hasFocus) {
                            if (!hasFocus) {
                              double amount = _receivedAmount.text.isEmpty
                                  ? 0
                                  : MoneyUtils().fromReadableMoney(_receivedAmount.text);
                              _receivedAmount.text = MoneyUtils().readableMoney(amount);
                            }
                          },
                          onTapPrice: () {
                            if (MoneyUtils().fromReadableMoney(_receivedAmount.text) == 0) {
                              _receivedAmount.text = '';
                            }
                          },
                          onSubmitted: (value) {
                            setState(() {
                              _receivedAmount.text = value;

                              double receivedAmount = MoneyUtils().fromReadableMoney(
                                _receivedAmount.text,
                              );

                              _soldAmount.text = MoneyUtils().readableMoney(
                                (receivedAmount) / currencyRate,
                              );

                              double soldAmount = (receivedAmount) / currencyRate;

                              if (soldAmount < _lowerLimit) {
                                _showLowerAlert = true;
                              } else {
                                _showLowerAlert = false;
                              }

                              if (soldAmount > _upperLimit) {
                                _showUpperAlert = true;
                              } else {
                                _showUpperAlert = false;
                              }

                              if (soldAmount > (state.tradeLimitByCurrency ?? 0)) {
                                _errorText = L10n.tr('insufficient_cash_balance');
                              } else {
                                _errorText = null;
                              }

                              FocusScope.of(context).unfocus();
                            });
                          },
                        ),
                      ),
                      if (_showLowerAlert || _showUpperAlert)
                        CurrencyLimitAlertWidget(
                          showLowerAlert: _showLowerAlert,
                          upperLimit: _upperLimit,
                          lowerLimit: _lowerLimit,
                          currencySymbol: widget.currencyType.symbol,
                        ),
                      const SizedBox(
                        height: Grid.l,
                      ),
                      CurrencyWorkingHoursInfoWidget(
                        startDate: state.systemParametersModel?.fcStartTime ?? DateTime.now(),
                        endDate: state.systemParametersModel?.fcEndTime ?? DateTime.now(),
                      ),
                      const SizedBox(
                        height: Grid.s,
                      ),
                    ],
                  ),
                ),
              ),
              generalButtonPadding(
                context: context,
                leftPadding: EdgeInsets.zero.left,
                rightPadding: EdgeInsets.zero.right,
                child: PButton(
                  text: L10n.tr(
                    'currency_sell',
                    args: [
                      L10n.tr(widget.currencyType.name),
                    ],
                  ),
                  fillParentWidth: true,
                  onPressed: _errorText != null ||
                          (state.tradeLimitByCurrency ?? 0) <= 0 ||
                          _soldAmount.text == '0' ||
                          _showLowerAlert ||
                          _showUpperAlert
                      ? null
                      : () {
                          PBottomSheet.show(
                            context,
                            child: CurrencyBuySellConfirmationWidget(
                              currencyType: widget.currencyType,
                              currencyRate: currencyRate,
                              currencyAmount: '${widget.currencyType.symbol}${_soldAmount.text}',
                              tlAmount: '₺${_receivedAmount.text}',
                              isBuy: false,
                              onApprove: () {
                                _currencyBuySellBloc.add(
                                  FcBuySellEvent(
                                    debitCredit: 'DEBIT',
                                    tlAccountId: _selectedTlAccount.split('-')[1],
                                    accountId: _selectedCurrencyAccount.split('-')[1],
                                    finInstName: widget.currencyType.shortName.toUpperCase(),
                                    amount: MoneyUtils().fromReadableMoney(
                                      _soldAmount.text,
                                    ),
                                    exchangeRate: currencyRate,
                                    onSuccess: () async {
                                      _assetsBloc.add(
                                        GetOverallSummaryEvent(
                                          accountId: '',
                                          allAccounts: true,
                                          includeCashFlow: true,
                                          getInstant: true,
                                          includeCreditDetail: true,
                                          calculateTradeLimit: true,
                                          isConsolidated: true,
                                        ),
                                      );
                                      _checkCapraAccount();

                                      router.push(
                                        InfoRoute(
                                          variant: InfoVariant.success,
                                          message: L10n.tr('currency_buy_sell_success'),
                                          buttonText: L10n.tr('return_to_portfolio'),
                                          onTapButton: () async {
                                            if (getIt.get<TabBloc>().state.selectedTabIndex != 3) {
                                              router.popUntilRoot();
                                              getIt.get<TabBloc>().add(
                                                    const TabChangedEvent(
                                                      tabIndex: 3,
                                                      portfolioTabIndex: 0,
                                                    ),
                                                  );
                                            } else {
                                              router.pushAndPopUntil(
                                                PortfolioRoute(
                                                  initialIndex: 0,
                                                ),
                                                predicate: (route) => route.settings.name == PortfolioRoute.name,
                                              );
                                              getIt.get<TabBloc>().add(
                                                    const TabChangedEvent(
                                                      tabIndex: 3,
                                                      portfolioTabIndex: 0,
                                                    ),
                                                  );
                                            }
                                          },
                                        ),
                                      );

                                      await router.maybePop();
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                        },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _checkCapraAccount() {
    _globalOnboardingBloc.add(
      AccountSettingStatusEvent(
        succesCallback: (accountSettingStatus) {
          AlpacaAccountStatusEnum? alpacaAccountStatus = AlpacaAccountStatusEnum.values.firstWhereOrNull(
            (e) => e.value == accountSettingStatus.accountStatus,
          );

          if (alpacaAccountStatus == AlpacaAccountStatusEnum.active) {
            _assetsBloc.add(
              GetCapraPortfolioSummaryEvent(),
            );
          }
        },
      ),
    );
  }
}
