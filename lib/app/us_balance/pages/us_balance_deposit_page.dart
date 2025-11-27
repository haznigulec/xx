import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_bloc.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_event.dart';
import 'package:piapiri_v2/app/currency_buy_sell/bloc/currency_buy_sell_bloc.dart';
import 'package:piapiri_v2/app/currency_buy_sell/bloc/currency_buy_sell_event.dart';
import 'package:piapiri_v2/app/currency_buy_sell/bloc/currency_buy_sell_state.dart';
import 'package:piapiri_v2/app/info/model/info_variant.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/pvalue_textfield_widget.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
import 'package:piapiri_v2/app/us_balance/bloc/us_balance_bloc.dart';
import 'package:piapiri_v2/app/us_balance/bloc/us_balance_event.dart';
import 'package:piapiri_v2/app/us_balance/bloc/us_balance_state.dart';
import 'package:piapiri_v2/app/us_balance/model/us_collateral_type_enum.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/text_input_formatters.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottom_sheet_approvement_detail_widget.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottom_sheet_approvement_widget.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_bloc.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_event.dart';
import 'package:piapiri_v2/core/bloc/time/time_bloc.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/account_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/widgets/styled_text.dart';

class UsBalanceDepositPage extends StatefulWidget {
  final double totalUsdBalance;
  const UsBalanceDepositPage({
    super.key,
    required this.totalUsdBalance,
  });

  @override
  State<UsBalanceDepositPage> createState() => _UsBalanceDepositPageState();
}

class _UsBalanceDepositPageState extends State<UsBalanceDepositPage> {
  String _selectedAccount = '';
  List<AccountModel> _usdAccountList = [];
  final TextEditingController _tcAmount = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode(); // FocusNode eklendi
  String? _errorText;
  late UsBalanceBloc _usBalanceBloc;
  late AssetsBloc _assetsBloc;
  late CurrencyBuySellBloc _currencyBuySellBloc;
  bool _isLoading = false;
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    _assetsBloc = getIt<AssetsBloc>();
    _usBalanceBloc = getIt<UsBalanceBloc>();
    _currencyBuySellBloc = getIt<CurrencyBuySellBloc>();
    _currencyBuySellBloc.add(
      GetSystemParametersEvent(),
    );
    _usdAccountList = UserModel.instance.accounts.where((element) => element.currency == CurrencyEnum.dollar).toList();

    _tcAmount.text = MoneyUtils().readableMoney(0);
    _amountFocusNode.addListener(_onFocusChange);

    if (_usdAccountList.isNotEmpty) {
      _selectedAccount = _usdAccountList.first.accountId;

      _usBalanceBloc.add(
        GetInstantCashAmountUsBalanceEvent(
          accountId: _selectedAccount.split('-')[1],
        ),
      );
    }

    super.initState();
  }

  void _onFocusChange() {
    setState(() {
      _isKeyboardVisible = _amountFocusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _amountFocusNode.removeListener(_onFocusChange);
    _amountFocusNode.dispose();
    _tcAmount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<UsBalanceBloc, UsBalanceState>(
      bloc: _usBalanceBloc,
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  vertical: Grid.s,
                ),
                child: Column(
                  children: [
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
                                L10n.tr('gonderen_hesap'),
                                style: context.pAppStyle.labelReg14textPrimary,
                              ),
                              const SizedBox(
                                height: Grid.s,
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${L10n.tr('cash_usd_balance')}: ',
                                      style: context.pAppStyle.labelReg12textSecondary,
                                    ),
                                    TextSpan(
                                      text: state.isLoading
                                          ? '...'
                                          : '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(state.cashAmount ?? 0)}',
                                      style: context.pAppStyle.labelMed12textSecondary,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          _usdAccountList.length == 1
                              ? Text(
                                  _selectedAccount,
                                  style: context.pAppStyle.labelMed14textPrimary,
                                )
                              : InkWell(
                                  onTap: () {
                                    PBottomSheet.show(
                                      context,
                                      title: L10n.tr('gonderen_hesap'),
                                      titlePadding: const EdgeInsets.only(
                                        top: Grid.m,
                                      ),
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        itemCount: _usdAccountList.length,
                                        separatorBuilder: (context, index) => const PDivider(),
                                        itemBuilder: (context, index) {
                                          final account = _usdAccountList[index];

                                          return BottomsheetSelectTile(
                                            title: account.accountId,
                                            isSelected: _selectedAccount == account.accountId,
                                            value: account,
                                            onTap: (title, value) {
                                              setState(() {
                                                _selectedAccount = title;

                                                _tcAmount.text = '0';
                                                _errorText = null;

                                                _usBalanceBloc.add(
                                                  GetInstantCashAmountUsBalanceEvent(
                                                    accountId: _selectedAccount.split('-')[1],
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
                                        _selectedAccount,
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
                    PValueTextfieldWidget(
                      controller: _tcAmount,
                      focusNode: _amountFocusNode,
                      title: L10n.tr('yatirilacak_tutar'),
                      suffixText: CurrencyEnum.dollar.symbol,
                      suffixStyle: context.pAppStyle.interMediumBase.copyWith(
                        fontSize: Grid.m + Grid.xxs,
                        color: state.cashAmount == 0
                            ? context.pColorScheme.textTeritary
                            : _errorText != null
                                ? context.pColorScheme.critical
                                : context.pColorScheme.primary,
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
                      errorText: _errorText,
                      valueTextStyle: context.pAppStyle.interMediumBase.copyWith(
                        fontSize: Grid.m + Grid.xxs,
                        color: state.cashAmount == 0
                            ? context.pColorScheme.textTeritary
                            : _errorText != null
                                ? context.pColorScheme.critical
                                : context.pColorScheme.primary,
                      ),
                      onFocusChange: (hasFocus) {
                        if (!hasFocus) {
                          double amount = _tcAmount.text.isEmpty ? 0 : MoneyUtils().fromReadableMoney(_tcAmount.text);
                          _tcAmount.text = MoneyUtils().readableMoney(amount);
                        }
                      },
                      onTapPrice: () {
                        if (_tcAmount.text == '0' || _tcAmount.text == '0,00') {
                          _tcAmount.text = '';
                        }
                      },
                      onChanged: (deger) {
                        setState(() {
                          _tcAmount.text = deger;

                          if (MoneyUtils().fromReadableMoney(_tcAmount.text) > (state.cashAmount ?? 0)) {
                            _errorText = L10n.tr('insufficient_cash_usd');
                          } else {
                            _errorText = null;
                          }
                        });
                      },
                      onSubmitted: (value) {
                        setState(() {
                          _tcAmount.text = value;
                          if (_tcAmount.text.isEmpty) {
                            _tcAmount.text = '0';
                          }
                          if (MoneyUtils().fromReadableMoney(_tcAmount.text) > (state.cashAmount ?? 0)) {
                            _errorText = L10n.tr('insufficient_cash_usd');
                          } else {
                            _errorText = null;
                          }
                          FocusScope.of(context).unfocus();
                        });
                      },
                    ),
                    const SizedBox(
                      height: Grid.s,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Grid.s,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            L10n.tr('total_american_exchange_balance'),
                            style: context.pAppStyle.labelReg14textPrimary,
                          ),
                          const SizedBox(
                            width: Grid.s,
                          ),
                          Text(
                            '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(widget.totalUsdBalance)}',
                            style: context.pAppStyle.labelMed18textPrimary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: Grid.s,
                    ),
                    PBlocBuilder<CurrencyBuySellBloc, CurrencyBuySellState>(
                      bloc: _currencyBuySellBloc,
                      builder: (context, state) {
                        DateTime startDate = state.systemParametersModel?.fcStartTime ??
                            DateTime.now().copyWith(
                              hour: 09,
                              minute: 00,
                            );
                        DateTime endDate = state.systemParametersModel?.fcEndTime ??
                            DateTime.now().copyWith(
                              hour: 18,
                              minute: 00,
                            );

                        DateTime now = getIt<TimeBloc>().state.mxTime != null
                            ? DateTime.fromMicrosecondsSinceEpoch(
                                getIt<TimeBloc>().state.mxTime!.timestamp.toInt(),
                              )
                            : DateTime.fromMicrosecondsSinceEpoch(
                                DateTime.now().microsecondsSinceEpoch,
                              );

                        bool isMarketClosed = now.hour < startDate.hour || now.hour >= endDate.hour;

                        if (DateTimeUtils().isWeekend() || DateTimeUtils().isHoliday()) {
                          isMarketClosed = true;
                        }

                        return InkWell(
                          splashColor: context.pColorScheme.transparent,
                          highlightColor: context.pColorScheme.transparent,
                          onTap: () {
                            if (isMarketClosed) {
                              PBottomSheet.showError(
                                context,
                                content: '${L10n.tr(
                                  'currency_transaction_working_hour_info',
                                  args: [
                                    startDate.formatTimeHourMinute(),
                                    endDate.formatTimeHourMinute(),
                                  ],
                                )} ${L10n.tr('currency_transcation_specified_time_info')}',
                              );
                              return;
                            } else {
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
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                L10n.tr('click_here_to_get_usd_quickly'),
                                style: context.pAppStyle.labelMed14primary,
                              ),
                              const SizedBox(
                                width: Grid.xs,
                              ),
                              SvgPicture.asset(
                                ImagesPath.arrow_up_right,
                                width: 15,
                                height: 15,
                                colorFilter: ColorFilter.mode(
                                  context.pColorScheme.primary,
                                  BlendMode.srcIn,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            AnimatedPadding(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.only(
                bottom: _isKeyboardVisible ? Grid.xxl : Grid.m + Grid.xs,
              ),
              child: PButton(
                text: L10n.tr('devam'),
                fillParentWidth: true,
                onPressed: _tcAmount.text.isEmpty ||
                        _errorText != null ||
                        _tcAmount.text == '0' ||
                        _tcAmount.text == '0,00' ||
                        _isLoading
                    ? null
                    : () async {
                        return PBottomSheet.show(
                          context,
                          child: BottomSheetApprovementWidget(
                            textWidget: StyledText(
                              text: L10n.tr(
                                'us_balance_approvement_message',
                                namedArgs: {
                                  'account': _selectedAccount,
                                  'amount': '${CurrencyEnum.dollar.symbol}${_tcAmount.text}',
                                  'type': '<medium>${L10n.tr('us_balance_deposit')}</medium>',
                                },
                              ),
                              textAlign: TextAlign.center,
                              style: context.pAppStyle.labelReg16textPrimary,
                              tags: {
                                'medium': StyledTextTag(
                                  style: context.pAppStyle.labelMed16textPrimary,
                                ),
                              },
                            ),
                            onTapSeeDetailButton: () {
                              PBottomSheet.show(
                                context,
                                title: L10n.tr('demand_detail'),
                                child: Column(
                                  children: [
                                    BottomSheetApprovementDetailWidget(
                                      data: {
                                        L10n.tr('islem'): L10n.tr('us_balance_deposit'),
                                        L10n.tr('gonderen_hesap'): _selectedAccount,
                                        L10n.tr('tutar'): '${CurrencyEnum.dollar.symbol}${_tcAmount.text}',
                                      },
                                    ),
                                    OrderApprovementButtons(
                                      onPressedApprove: () async {
                                        await router.maybePop();
                                        await router.maybePop();
                                        _doBalanceTransfer();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            onTapApprove: () async {
                              await router.maybePop();
                              _doBalanceTransfer();
                            },
                          ),
                        );
                      },
              ),
            ),
          ],
        );
      },
    );
  }

  void _doBalanceTransfer() {
    setState(() {
      _isLoading = true;
    });
    _usBalanceBloc.add(
      BalanceTransferEvent(
        accountId: _selectedAccount.split('-')[1],
        amount: MoneyUtils().fromReadableMoney(_tcAmount.text).toString(),
        collateralType: UsCollateralTypeEnum.depositingCollateral.value,
        onSuccess: (response) async {
          _assetsBloc.add(
            GetCapraPortfolioSummaryEvent(),
          );
          _assetsBloc.add(
            GetCapraCollateralInfoEvent(),
          );
          setState(() {
            _isLoading = false;
          });
          router.push(
            InfoRoute(
              showCloseIcon: false,
              variant: response.successMessage != null && response.successMessage == 'SingleTransferLimitExceeded'
                  ? InfoVariant.warning
                  : InfoVariant.success,
              message: response.successMessage != null && response.successMessage == 'SingleTransferLimitExceeded'
                  ? L10n.tr('us_balance.SingleTransferLimitExceeded')
                  : L10n.tr('us_balance_deposit_success'),
              buttonText: L10n.tr('portfoye_don'),
              onTapButton: () {
                if (getIt.get<TabBloc>().state.selectedTabIndex != 3) {
                  router.popUntilRoot();
                  getIt.get<TabBloc>().add(
                        const TabChangedEvent(
                          tabIndex: 3,
                          portfolioTabIndex: 1,
                        ),
                      );
                } else {
                  router.pushAndPopUntil(
                    PortfolioRoute(
                      initialIndex: 1,
                    ),
                    predicate: (route) => route.settings.name == PortfolioRoute.name,
                  );
                  getIt.get<TabBloc>().add(
                        const TabChangedEvent(
                          tabIndex: 3,
                          portfolioTabIndex: 1,
                        ),
                      );
                }
              },
            ),
          );
        },
        onFailed: () {
          setState(() {
            _isLoading = false;
          });
        },
      ),
    );
  }
}
