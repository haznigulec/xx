import 'package:auto_route/auto_route.dart';
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
import 'package:piapiri_v2/app/ipo/repository/ipo_repository_impl.dart';
import 'package:piapiri_v2/app/money_transfer/bloc/money_transfer_bloc.dart';
import 'package:piapiri_v2/app/money_transfer/bloc/money_transfer_event.dart';
import 'package:piapiri_v2/app/money_transfer/bloc/money_transfer_state.dart';
import 'package:piapiri_v2/app/money_transfer/widgets/quick_cash_widget.dart';
import 'package:piapiri_v2/app/money_transfer/widgets/title_total_value_widget.dart';
import 'package:piapiri_v2/app/money_transfer/widgets/withdraw_iban_widget.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/pvalue_textfield_widget.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/text_input_formatters.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/info_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/common/widgets/textfields/keyboard_done_action.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/bloc/time/time_bloc.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/assets_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class WithdrawMoneyFromAccountPage extends StatefulWidget {
  final CurrencyEnum currencyType;
  final bool comeFromBanner;

  const WithdrawMoneyFromAccountPage({
    super.key,
    required this.currencyType,
    this.comeFromBanner = false,
  });

  @override
  State<WithdrawMoneyFromAccountPage> createState() => _WithdrawMoneyFromAccountPageState();
}

class _WithdrawMoneyFromAccountPageState extends State<WithdrawMoneyFromAccountPage> {
  final String userKey = 'INSTITUTION';
  late MoneyTransferBloc _moneyTransferBloc;
  late CurrencyBuySellBloc _currencyBuySellBloc;
  late bool _comeFromBanner;
  List<String> _accountList = [];
  List<CustomerBankAccountModel>? _customerBankAccountList;
  String _selectedAccount = '';
  final TextEditingController _tcAmount = TextEditingController();
  final TextEditingController _tcDescription = TextEditingController();
  final FocusNode _focusNodeDescription = FocusNode(
    debugLabel: 'descriptionFocus',
  );
  EftInfoModel? _eftInfo;
  CustomerBankAccountModel? _selectedBankAccount;
  double _lowerLimit = 0;
  double _upperLimit = 0;
  bool _showLowerAlert = false;
  bool _showUpperAlert = false;
  double _amount = 0;
  String? _maxDescriptionCharacter;
  bool _hasFocus = false;

  @override
  void initState() {
    _accountList = _handleAccountList();

    _tcAmount.text = MoneyUtils().readableMoney(0);

    _moneyTransferBloc = getIt<MoneyTransferBloc>();
    _currencyBuySellBloc = getIt<CurrencyBuySellBloc>();
    _comeFromBanner = widget.comeFromBanner;

    if (_accountList.isNotEmpty) {
      _selectedAccount = _accountList[0];

      _moneyTransferBloc.add(
        GetCustomerBankAccountsEvent(
          accountId: _selectedAccount.split('-')[1],
        ),
      );

      _moneyTransferBloc.add(
        GetConvertT0Event(
          callBack: (t1CreditNetLimit, t2CreditNetLimit) {
            if (_comeFromBanner) {
              _comeFromBanner = false;
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => _openQuickCash(t1CreditNetLimit, t2CreditNetLimit),
              );
            }
          },
        ),
      );

      _getTradeLimit();

      _currencyBuySellBloc.add(
        GetSystemParametersEvent(),
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    _focusNodeDescription.removeListener(() {});

    super.dispose();
  }

  Future _openQuickCash(double t1CreditNetLimit, double t2CreditNetLimit) {
    if (t1CreditNetLimit <= 0 && t2CreditNetLimit <= 0) {
      return PBottomSheet.showError(
        context,
        content: L10n.tr('t0_credit_limit_not_exist'),
        showFilledButton: true,
        filledButtonText: L10n.tr('tamam'),
        onFilledButtonPressed: () async {
          Navigator.of(context).pop();
        },
      );
    }

    if (UserModel.instance.innerType?.toLowerCase() == userKey.toLowerCase() ||
        UserModel.instance.innerType?.toUpperCase() == userKey.toUpperCase()) {
      return PBottomSheet.showError(
        context,
        content: L10n.tr('t0_institution_user_alert'),
        showFilledButton: true,
        filledButtonText: L10n.tr('tamam'),
        onFilledButtonPressed: () async {
          Navigator.of(context).pop();
        },
      );
    }

    return PBottomSheet.show(
      context,
      title: L10n.tr(
        'cash_now',
      ),
      child: QuickCashWidget(
        accountExtId: _selectedAccount.split('-')[1],
        currencyType: widget.currencyType,
        typeName: _didEftTimePassed(_eftInfo) ? 'CASH-T1' : 'CASH-T',
      ),
    );
  }

  void _getTradeLimit() {
    _moneyTransferBloc.add(
      GetEftInfoEvent(
        accountExtId: _selectedAccount.split('-')[1],
        callback: (eftInfo) {
          _eftInfo = eftInfo;

          /// Eft saatini kontrol ediyoruz, eğer Eft saatini geçtiyse T1 e bakıyoruz.
          if (_didEftTimePassed(eftInfo)) {
            _moneyTransferBloc.add(
              GetTradeLimitEvent(
                accountId: _selectedAccount.split('-')[1],
                typeName: 'CASH-T1',
              ),
            );
          } else {
            _moneyTransferBloc.add(
              GetTradeLimitEvent(
                accountId: _selectedAccount.split('-')[1],
                typeName: 'CASH-T',
              ),
            );
          }
        },
      ),
    );
  }

  void _getTradeLimitForAllAccounts() {
    /// Hesap seçimi bottom sheet'i açılınca, her hesabın işlem limitini alt satırda göstermek için bu event kullanılıyor.
    _moneyTransferBloc.add(
      GetEftInfoEvent(
        accountExtId: _selectedAccount.split('-')[1],
        callback: (eftInfo) {
          _eftInfo = eftInfo;
          if (_didEftTimePassed(eftInfo)) {
            _moneyTransferBloc.add(
              GetTradeLimitForAllAccountsEvent(
                accountList: _accountList,
                typeName: 'CASH-T1',
              ),
            );
          } else {
            _moneyTransferBloc.add(
              GetTradeLimitForAllAccountsEvent(
                accountList: _accountList,
                typeName: 'CASH-T',
              ),
            );
          }
        },
      ),
    );
  }

  bool _didEftTimePassed(EftInfoModel? eftInfo) {
    double amount = MoneyUtils().fromReadableMoney(_tcAmount.text);
    double fastLimit = double.parse(
      L10n.tr('eft_fast_limit'),
    );

    if (amount <= (fastLimit)) {
      return false;
    }

    DateTime now = getIt<TimeBloc>().state.mxTime?.timestamp != null
        ? DateTime.fromMicrosecondsSinceEpoch(
            getIt<TimeBloc>().state.mxTime!.timestamp.toInt(),
          )
        : DateTime.now();
    DateTime eftEndTime = eftInfo?.eftEndTime != null
        ? DateTime.parse(eftInfo!.eftEndTime.toString())
        : DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            15,
            45,
          );
    return now.isAfter(eftEndTime);
  }

  List<String> _handleAccountList() {
    switch (widget.currencyType) {
      case CurrencyEnum.turkishLira:
        return IpoRepositoryImpl()
            .readAccountList()
            .where((element) => element['currencyType'] == 'TRY')
            .map((e) => e['accountExtId'].toString())
            .toList();
      case CurrencyEnum.dollar:
        return IpoRepositoryImpl()
            .readAccountList()
            .where((element) => element['currencyType'] == 'USD')
            .map((e) => e['accountExtId'].toString())
            .toList();
      case CurrencyEnum.euro:
        return IpoRepositoryImpl()
            .readAccountList()
            .where((element) => element['currencyType'] == 'EUR')
            .map((e) => e['accountExtId'].toString())
            .toList();
      case CurrencyEnum.pound:
        return IpoRepositoryImpl()
            .readAccountList()
            .where((element) => element['currencyType'] == 'GBP')
            .map((e) => e['accountExtId'].toString())
            .toList();
      default:
        return IpoRepositoryImpl()
            .readAccountList()
            .where((element) => element['currencyType'] == 'TRY')
            .map((e) => e['accountExtId'].toString())
            .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<MoneyTransferBloc, MoneyTransferState>(
      bloc: _moneyTransferBloc,
      builder: (context, state) {
        final double tradeLimit = state.tradeLimit ?? 0;
        final double t1CreditNetLimit = state.t1CreditNetLimit ?? 0;
        final double t2CreditNetLimit = state.t2CreditNetLimit ?? 0;

        _customerBankAccountList = state.customerBankAccountList;

        return Scaffold(
          resizeToAvoidBottomInset: _hasFocus,
          appBar: PInnerAppBar(
            title: L10n.tr(
              'withdraw_currency_from_account',
              args: [
                widget.currencyType.shortName.toUpperCase(),
              ],
            ),
          ),
          body: SafeArea(
            child: Shimmerize(
              enabled: state.isLoading,
              child: Padding(
                padding: const EdgeInsets.all(
                  Grid.m,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _accountListWidget(),
                      const SizedBox(
                        height: Grid.s,
                      ),
                      _amountInput(
                        tradeLimit,
                      ),
                      const SizedBox(
                        height: Grid.s,
                      ),
                      WithdrawIbanWidget(
                        bankAccountList: state.customerBankAccountList,
                        selectedAccount: _selectedAccount,
                        onSelectedBankAccount: (selectedBank) {
                          setState(() {
                            _selectedBankAccount = selectedBank;
                          });
                        },
                      ),
                      const SizedBox(
                        height: Grid.s,
                      ),
                      _descriptionInput(),
                      const SizedBox(height: Grid.l),
                      if (_didEftTimePassed(_eftInfo)) ...[
                        TitleTotalValueWidget(
                          title: L10n.tr(
                            'next_business_day_cash_balance',
                          ),
                          totalValue: tradeLimit + t1CreditNetLimit,
                          currency: widget.currencyType.symbol,
                        ),
                        if (t1CreditNetLimit + t2CreditNetLimit > 0) ...[
                          const SizedBox(height: Grid.m),
                          TitleTotalValueWidget(
                            title: L10n.tr(
                              'balance_pending_clearing',
                            ),
                            currency: widget.currencyType.symbol,
                            totalValue: t1CreditNetLimit + t2CreditNetLimit,
                            titleStyle: context.pAppStyle.labelMed12textSecondary,
                            valueStyle: context.pAppStyle.labelMed14textPrimary,
                          ),
                          const SizedBox(height: Grid.m),
                          InkWell(
                            onTap: () => _openQuickCash(t1CreditNetLimit, t2CreditNetLimit),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  L10n.tr(
                                    'convert_your_pending_balance_to_cash_now',
                                  ),
                                  style: context.pAppStyle.labelMed14primary,
                                ),
                                const SizedBox(width: Grid.xs),
                                SvgPicture.asset(
                                  ImagesPath.arrow_up_right,
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
                        ]
                      ] else ...[
                        TitleTotalValueWidget(
                          title: _didEftTimePassed(_eftInfo)
                              ? L10n.tr('t1_islem_limiti')
                              : L10n.tr(
                                  'cash_balance',
                                ),
                          currency: widget.currencyType.symbol,
                          totalValue: tradeLimit,
                        ),
                        if (t1CreditNetLimit + t2CreditNetLimit > 0) ...[
                          const SizedBox(height: Grid.m),
                          TitleTotalValueWidget(
                            title: L10n.tr(
                              'balance_pending_clearing',
                            ),
                            currency: widget.currencyType.symbol,
                            totalValue: t1CreditNetLimit + t2CreditNetLimit,
                            titleStyle: context.pAppStyle.labelMed12textSecondary,
                            valueStyle: context.pAppStyle.labelMed14textPrimary,
                          ),
                          const SizedBox(height: Grid.m),
                          InkWell(
                            onTap: () => _openQuickCash(t1CreditNetLimit, t2CreditNetLimit),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  L10n.tr(
                                    'convert_your_pending_balance_to_cash_now',
                                  ),
                                  style: context.pAppStyle.labelMed14primary,
                                ),
                                const SizedBox(width: Grid.xs),
                                SvgPicture.asset(
                                  ImagesPath.arrow_up_right,
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
                        ]
                      ],
                      const SizedBox(
                        height: Grid.l,
                      ),
                      PInfoWidget(
                        infoText: L10n.tr(
                          'only_transfer_money_yourself',
                        ),
                      ),
                      const SizedBox(
                        height: Grid.s + Grid.xs,
                      ),
                      PInfoWidget(
                        infoText:
                            '${_eftInfo?.eftEndTime != null ? DateTimeUtils.strTimeFromDate(date: DateTime.parse(_eftInfo!.eftEndTime.toString())) : '15:45'} ${L10n.tr('money_transfer_info')}',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomSheet: _hasFocus
              ? ColoredBox(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: Grid.m,
                        right: Grid.m,
                        bottom: Grid.xxl + Grid.s,
                      ),
                      child: POutlinedButton(
                        text: L10n.tr('allSelectLimit'),
                        fillParentWidth: true,
                        onPressed: () {
                          _tcAmount.text = MoneyUtils().readableMoney(tradeLimit);
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                  ),
                )
              : null,
          bottomNavigationBar: PBlocBuilder<MoneyTransferBloc, MoneyTransferState>(
            bloc: _moneyTransferBloc,
            builder: (context, state) {
              return generalButtonPadding(
                context: context,
                child: PButton(
                  text: L10n.tr('devam'),
                  fillParentWidth: true,
                  onPressed: _customerBankAccountList == null ||
                          tradeLimit == 0 ||
                          _tcAmount.text.isEmpty ||
                          _tcAmount.text == '0' ||
                          _tcAmount.text == '0,00' ||
                          state.customerBankAccountList == null ||
                          state.customerBankAccountList!.isEmpty ||
                          _showLowerAlert ||
                          _showUpperAlert
                      ? null
                      : () => _doContinue(),
                ),
              );
            },
          ),
        );
      },
    );
  }

  _doContinue() {
    if (_selectedBankAccount == null) {
      if (_customerBankAccountList != null && _customerBankAccountList!.isNotEmpty) {
        _selectedBankAccount = _customerBankAccountList![0];
      }
    }

    DateTime now = getIt<TimeBloc>().state.mxTime?.timestamp != null
        ? DateTime.fromMicrosecondsSinceEpoch(
            getIt<TimeBloc>().state.mxTime!.timestamp.toInt(),
          )
        : DateTime.now();

    double fastLimit = double.parse(
      L10n.tr('eft_fast_limit'),
    );

    return PBottomSheet.show(
      context,
      title: L10n.tr('demand_detail'),
      child: Column(
        children: [
          _demandDetailRow(
            title: L10n.tr('gonderen_hesap'),
            value: _selectedAccount,
          ),
          _demandDetailRow(
            title: L10n.tr('tutar'),
            value: widget.currencyType.symbol + _tcAmount.text,
          ),
          _demandDetailRow(
            title: L10n.tr('iban'),
            value: _selectedBankAccount != null ? _selectedBankAccount!.ibanNo : '',
          ),
          if (_tcDescription.text.isNotEmpty)
            _demandDetailRow(
              title: L10n.tr('description'),
              value: _tcDescription.text,
            ),
          _demandDetailRow(
            title: L10n.tr('eft_date'),
            value: widget.currencyType == CurrencyEnum.turkishLira
                ? MoneyUtils().fromReadableMoney(_tcAmount.text) <= (fastLimit)
                    ? now.formatDayMonthYearDot()
                    : DateTimeUtils.dateFormat(
                        DateTime.parse(
                          _eftInfo?.eftDate ?? DateTime.now().toString(),
                        ),
                      )
                : now.formatDayMonthYearDot(),
            hasDivider: false,
          ),
          const SizedBox(
            height: Grid.s + Grid.xs,
          ),
          OrderApprovementButtons(
            onPressedApprove: () {
              router.maybePop();
              if (_didEftTimePassed(_eftInfo)) {
                return PBottomSheet.show(
                  context,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: Grid.m,
                      ),
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
                      Text(
                        L10n.tr('eft_time_passed_warning').replaceAll(
                          '{time}',
                          DateTimeUtils.dateFormat(DateTime.parse(
                            _eftInfo?.eftDate ?? DateTime.now().toString(),
                          )).toString(),
                        ),
                        textAlign: TextAlign.center,
                        style: context.pAppStyle.labelReg16textPrimary,
                      ),
                      const SizedBox(
                        height: Grid.m,
                      ),
                      OrderApprovementButtons(
                        onPressedApprove: () => _addMoneyTransferOrder(),
                      ),
                    ],
                  ),
                );
              } else {
                _addMoneyTransferOrder();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _demandDetailRow({
    String title = '',
    String value = '',
    bool hasDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Grid.xs,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: Grid.s,
            children: [
              Text(
                title,
                textAlign: TextAlign.left,
                style: context.pAppStyle.labelReg14textSecondary,
              ),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: context.pAppStyle.labelMed14textPrimary,
                ),
              ),
            ],
          ),
        ),
        if (hasDivider) ...[
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: Grid.s + Grid.xs,
            ),
            child: PDivider(),
          ),
        ] else ...[
          const SizedBox(
            height: Grid.s + Grid.xs,
          )
        ]
      ],
    );
  }

  void _addMoneyTransferOrder() async {
    if (_selectedBankAccount != null) {
      _moneyTransferBloc.add(
        MoneyTransferOrderEvent(
          accountId: _selectedAccount.split('-')[1],
          bankAccId: _selectedBankAccount!.bankAccId,
          amount: MoneyUtils().fromReadableMoney(_tcAmount.text),
          description: _tcDescription.text,
          finInstName:
              widget.currencyType == CurrencyEnum.turkishLira ? 'TRY' : widget.currencyType.shortName.toUpperCase(),
          onSuccess: () {
            getIt<AssetsBloc>().add(
              GetOverallSummaryEvent(
                accountId: '',
                allAccounts: true,
                includeCashFlow: true,
                includeCreditDetail: true,
                calculateTradeLimit: true,
                isConsolidated: true,
                getInstant: true,
              ),
            );
            router.push(
              InfoRoute(
                variant: InfoVariant.success,
                message: L10n.tr('withdrawal_money_success'),
              ),
            );

            router.popUntilRoot();
          },
          onFailed: (errorMessage) {
            return PBottomSheet.showError(
              context,
              content: L10n.tr(errorMessage),
            );
          },
        ),
      );
    }
  }

  Widget _accountListWidget() {
    return InkWell(
      onTap: () {
        _getTradeLimitForAllAccounts();

        PBottomSheet.show(
          context,
          title: L10n.tr('hesap'),
          titlePadding: const EdgeInsets.only(
            top: Grid.m,
          ),
          child: ListView.separated(
            itemCount: _accountList.length,
            shrinkWrap: true,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final account = _accountList[index];

              return BottomsheetSelectTile(
                title: account,
                isSelected: _selectedAccount == account,
                value: account,
                subTitleWidget: PBlocBuilder<MoneyTransferBloc, MoneyTransferState>(
                  bloc: _moneyTransferBloc,
                  builder: (context, state) {
                    return Shimmerize(
                      enabled: state.tradeLimitState == PageState.loading,
                      child: Text(
                        "${L10n.tr('islem_limiti')}: ${widget.currencyType.symbol}${MoneyUtils().readableMoney(
                          state.tradeLimitAllAccounts?[index] ?? 0,
                        )}",
                        style: context.pAppStyle.labelReg12textSecondary,
                      ),
                    );
                  },
                ),
                onTap: (title, value) {
                  setState(() {
                    _selectedAccount = value;

                    _moneyTransferBloc.add(
                      GetCustomerBankAccountsEvent(
                        accountId: _selectedAccount.split('-')[1],
                      ),
                    );

                    _getTradeLimit();

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
          )
        ],
      ),
    );
  }

  Widget _amountInput(
    double tradeLimit,
  ) {
    return PBlocBuilder<CurrencyBuySellBloc, CurrencyBuySellState>(
      bloc: _currencyBuySellBloc,
      builder: (context, state) {
        if (widget.currencyType == CurrencyEnum.turkishLira) {
          _lowerLimit = state.systemParametersModel?.eftLowerLimit ?? 0;
          _upperLimit = state.systemParametersModel?.eftUpperLimit ?? 0;
        } else if (widget.currencyType == CurrencyEnum.dollar) {
          _lowerLimit = state.systemParametersModel?.eftUsdLowerLimit ?? 0;
          _upperLimit = state.systemParametersModel?.eftUsdUpperLimit ?? 0;
        } else if (widget.currencyType == CurrencyEnum.euro) {
          _lowerLimit = state.systemParametersModel?.eftEurLowerLimit ?? 0;
          _upperLimit = state.systemParametersModel?.eftEurUpperLimit ?? 0;
        } else if (widget.currencyType == CurrencyEnum.pound) {
          _lowerLimit = state.systemParametersModel?.eftGbpLowerLimit ?? 0;
          _upperLimit = state.systemParametersModel?.eftGbpUpperLimit ?? 0;
        }

        double amount = MoneyUtils().fromReadableMoney(_tcAmount.text);

        return PValueTextfieldWidget(
          controller: _tcAmount,
          title: L10n.tr('tutar'),
          suffixText: widget.currencyType.symbol,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: false,
          ),
          inputFormatters: [
            AppInputFormatters.decimalFormatter(
              maxDigitAfterSeparator: 2,
            ),
          ],
          onTapPrice: () {
            if (_tcAmount.text == '0' || _tcAmount.text == '0,00') {
              _tcAmount.text = '';
            }
          },
          errorText: amount > tradeLimit
              ? L10n.tr('insufficient_transaction_limit')
              : _showLowerAlert
                  ? L10n.tr(
                      'min_amount_alert',
                      args: [
                        '${widget.currencyType.symbol}${MoneyUtils().readableMoney(_lowerLimit)}',
                      ],
                    )
                  : _showUpperAlert
                      ? L10n.tr(
                          'max_amount_alert',
                          args: [
                            '${widget.currencyType.symbol}${MoneyUtils().readableMoney(_upperLimit)}',
                          ],
                        )
                      : null,
          onTapOutside: (_) => setState(() {
            _hasFocus = false;
          }),
          onFocusChange: (hasFocus) {
            setState(() {
              _hasFocus = hasFocus;
            });
            if (!hasFocus) {
              double amount = _tcAmount.text.isEmpty ? 0 : MoneyUtils().fromReadableMoney(_tcAmount.text);
              _tcAmount.text = MoneyUtils().readableMoney(amount);
            }
          },
          onChanged: (value) {
            setState(() {
              _tcAmount.text = value.toString();
              double amount = MoneyUtils().fromReadableMoney(_tcAmount.text);

              if (amount < _lowerLimit) {
                _showLowerAlert = true;
              } else {
                _showLowerAlert = false;
              }

              if (amount > _upperLimit) {
                _showUpperAlert = true;
              } else {
                _showUpperAlert = false;
              }
            });
          },
          onSubmitted: (value) {
            setState(() {
              if (value.isEmpty) {
                value = '0';
              }

              _tcAmount.text = value;

              _amount = MoneyUtils().fromReadableMoney(value);

              if (_amount < _lowerLimit) {
                _showLowerAlert = true;
              } else {
                _showLowerAlert = false;
              }

              if (_amount > _upperLimit) {
                _showUpperAlert = true;
              } else {
                _showUpperAlert = false;
              }

              FocusScope.of(context).unfocus();
            });
          },
        );
      },
    );
  }

  Widget _descriptionInput() {
    return Container(
      decoration: BoxDecoration(
        color: context.pColorScheme.card,
        borderRadius: BorderRadius.circular(
          Grid.m,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Grid.s,
          horizontal: Grid.m,
        ),
        child: Row(
          spacing: Grid.xs,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    L10n.tr('aciklama'),
                    textAlign: TextAlign.start,
                    style: context.pAppStyle.labelReg14textPrimary,
                  ),
                  if (_maxDescriptionCharacter != null) ...[
                    const SizedBox(
                      height: Grid.s,
                    ),
                    Text(
                      _maxDescriptionCharacter!,
                      style: context.pAppStyle.interRegularBase.copyWith(
                        fontSize: Grid.s + Grid.xs,
                        color: context.pColorScheme.critical,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: KeyboardDoneAction(
                focusNode: _focusNodeDescription,
                child: TextField(
                  focusNode: _focusNodeDescription,
                  controller: _tcDescription,
                  maxLength: 35,
                  maxLines: 2,
                  minLines: 1,
                  textAlign: TextAlign.right, // Metni sağa hizala
                  decoration: InputDecoration(
                    hintText: L10n.tr('optional'),
                    hintStyle: context.pAppStyle.labelReg14textTeritary,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    counterText: '', // Sayaç gizleniyor
                  ),
                  style: _maxDescriptionCharacter != null
                      ? context.pAppStyle.labelReg14textPrimary.copyWith(
                          color: context.pColorScheme.critical,
                          decoration: TextDecoration.none,
                        )
                      : context.pAppStyle.labelReg14textPrimary.copyWith(
                          decoration: TextDecoration.none,
                        ),
                  onChanged: (deger) {
                    setState(() {
                      _tcDescription.text = deger.toString();

                      if (_tcDescription.text.length == 35) {
                        _maxDescriptionCharacter = L10n.tr(
                          'withdraw_money_description_limit',
                          args: ['35'],
                        );
                      } else {
                        _maxDescriptionCharacter = null;
                      }
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      _tcDescription.text = value;
                      FocusScope.of(context).unfocus();
                    });
                  },
                  onTapOutside: (value) {
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
