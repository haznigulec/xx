import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/info/model/info_variant.dart';
import 'package:piapiri_v2/app/money_transfer/bloc/money_transfer_bloc.dart';
import 'package:piapiri_v2/app/money_transfer/bloc/money_transfer_event.dart';
import 'package:piapiri_v2/app/money_transfer/bloc/money_transfer_state.dart';
import 'package:piapiri_v2/app/money_transfer/model/money_transfer_enum.dart';
import 'package:piapiri_v2/app/money_transfer/widgets/p_selector_field.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/pvalue_letter_textfield_widget.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/pvalue_textfield_widget.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/text_input_formatters.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/demand_detail_row.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/account_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/dropdown_model.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/widgets/styled_text.dart';

@RoutePage()
class MoneyTransferBetweenAccountPage extends StatefulWidget {
  const MoneyTransferBetweenAccountPage({super.key});

  @override
  State<MoneyTransferBetweenAccountPage> createState() => _MoneyTransferBetweenAccountPageState();
}

class _MoneyTransferBetweenAccountPageState extends State<MoneyTransferBetweenAccountPage> {
  List<AccountModel> _sendingAccountList = [];
  List<AccountModel> _recipientAccountList = [];
  late AccountModel _selectedSendingAccount;
  AccountModel? _selectedRecipientAccount;
  final TextEditingController _tcAmount = TextEditingController(
    text: MoneyUtils().readableMoney(0),
  );
  final TextEditingController _tcDescription = TextEditingController();
  late MoneyTransferBloc _moneyTransferBloc;
  double _transactionLimit = 1;
  String? _errorText;
  bool _keyboardIsOpen = false;

  @override
  void initState() {
    _moneyTransferBloc = getIt<MoneyTransferBloc>();

    _sendingAccountList = UserModel.instance.accounts;
    _recipientAccountList = UserModel.instance.accounts
        .where(
          (element) =>
              element.accountId != _sendingAccountList[0].accountId &&
              element.currency == _sendingAccountList[0].currency,
        )
        .toList();

    _selectedSendingAccount = _sendingAccountList[0];

    if (_selectedSendingAccount.currency.shortName == 'tl') {
      _moneyTransferBloc.add(
        GetTradeLimitBySenderRecipientEvent(
          accountId: _selectedSendingAccount.accountId.split('-')[1],
          typeName: 'CASH-T2',
          isSender: true,
        ),
      );
    } else {
      /// Döviz (usd, gbp, eur, jpy) için işlem limitinin alındığı event.
      _moneyTransferBloc.add(
        GetInstantCashAmountEvent(
          accountId: _selectedSendingAccount.accountId.split('-')[1],
          finInstName: _selectedSendingAccount.currency.shortName.toUpperCase(),
          isSender: true,
        ),
      );
    }

    if (_recipientAccountList.isNotEmpty) {
      _selectedRecipientAccount = _recipientAccountList[0];

      if (_selectedRecipientAccount!.currency.shortName == 'tl') {
        _moneyTransferBloc.add(
          GetTradeLimitBySenderRecipientEvent(
            accountId: _selectedRecipientAccount!.accountId.split('-')[1],
            typeName: 'CASH-T2',
            isSender: false,
          ),
        );
      } else {
        /// Döviz (usd, gbp, eur, jpy) için işlem limitinin alındığı event.
        _moneyTransferBloc.add(
          GetInstantCashAmountEvent(
            accountId: _selectedRecipientAccount!.accountId.split('-')[1],
            finInstName: _selectedRecipientAccount!.currency.shortName.toUpperCase(),
            isSender: false,
          ),
        );
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr(
          MoneyTransferEnum.transferMoneyBetweenAccounts.name,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: Grid.l - Grid.xs,
            left: Grid.m,
            right: Grid.m,
          ),
          child: Column(
            children: [
              _sendingAccountWidget(),
              const SizedBox(
                height: Grid.s,
              ),
              _recipiendAccountWidget(),
              if (_selectedRecipientAccount != null) ...[
                const SizedBox(
                  height: Grid.s,
                ),
                PValueTextfieldWidget(
                  controller: _tcAmount,
                  title: L10n.tr('tutar'),
                  suffixText: _selectedSendingAccount.currency.symbol,
                  suffixStyle: context.pAppStyle.interMediumBase.copyWith(
                    fontSize: Grid.m + Grid.xxs,
                    color: _errorText != null ? context.pColorScheme.critical : context.pColorScheme.primary,
                  ),
                  errorText: _errorText,
                  valueTextStyle: context.pAppStyle.interMediumBase.copyWith(
                    fontSize: Grid.m + Grid.xxs,
                    color: _errorText != null ? context.pColorScheme.critical : context.pColorScheme.primary,
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
                  onFocusChange: (hasFocus) {
                    if (!hasFocus) {
                      double amount = _tcAmount.text.isEmpty ? 0 : MoneyUtils().fromReadableMoney(_tcAmount.text);
                      _tcAmount.text = MoneyUtils().readableMoney(amount);
                      _keyboardIsOpen = false;
                    } else {
                      _keyboardIsOpen = true;
                    }
                  },
                  onTapPrice: () {
                    if (_tcAmount.text == '0' || _tcAmount.text == '0,00') {
                      _tcAmount.text = '';
                    }
                  },
                  onSubmitted: (value) {
                    setState(() {
                      if (value.isEmpty) {
                        value = '0';
                      }

                      if (MoneyUtils().fromReadableMoney(_tcAmount.text.toString()) > (_transactionLimit)) {
                        _errorText = L10n.tr('insufficient_transaction_limit');
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
                PValueLetterTextfieldWidget(
                  controller: _tcDescription,
                  title: L10n.tr('aciklama'),
                  hintText: L10n.tr('optional'),
                  valueTextStyle: context.pAppStyle.labelReg14textPrimary,
                  onChanged: (deger) {
                    setState(() {
                      _tcDescription.text = deger.toString();
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
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: PBlocBuilder<MoneyTransferBloc, MoneyTransferState>(
          bloc: _moneyTransferBloc,
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: _keyboardIsOpen ? MediaQuery.of(context).viewInsets.bottom + Grid.xxl + Grid.m : 0,
              ),
              child: generalButtonPadding(
                context: context,
                child: PButton(
                  text: L10n.tr('devam'),
                  fillParentWidth: true,
                  onPressed: _selectedRecipientAccount == null ||
                          _errorText != null ||
                          _tcAmount.text.isEmpty ||
                          _tcAmount.text == '0' ||
                          MoneyUtils().fromReadableMoney(_tcAmount.text) == 0
                      ? null
                      : () {
                          PBottomSheet.show(
                            context,
                            title: L10n.tr('transaction_confirmation'),
                            child: Column(
                              children: [
                                StyledText(
                                  text: L10n.tr(
                                    'money_transfer_between_account_info',
                                    namedArgs: {
                                      'fromAccount': '"${_selectedSendingAccount.accountId}"',
                                      'toAccount': '"${_selectedRecipientAccount?.accountId ?? ''}"',
                                      'amount': '${_selectedSendingAccount.currency.symbol}${_tcAmount.text}',
                                      'moneyTransferBetweenAccount':
                                          '<medium>${L10n.tr('transferMoneyBetweenAccounts')}</medium>',
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
                                const SizedBox(
                                  height: Grid.m,
                                ),
                                InkWell(
                                  onTap: () {
                                    PBottomSheet.show(
                                      context,
                                      title: L10n.tr('demand_detail'),
                                      child: Column(
                                        children: [
                                          DemandDetailRow(
                                            title: L10n.tr('islem'),
                                            value: L10n.tr(
                                              MoneyTransferEnum.transferMoneyBetweenAccounts.name,
                                            ),
                                          ),
                                          DemandDetailRow(
                                            title: L10n.tr('gonderen_hesap'),
                                            value: _selectedSendingAccount.accountId,
                                          ),
                                          DemandDetailRow(
                                            title: L10n.tr('alici_hesap'),
                                            value: _selectedRecipientAccount?.accountId ?? '',
                                          ),
                                          DemandDetailRow(
                                            title: L10n.tr('tutar'),
                                            value: '${_selectedSendingAccount.currency.symbol}${_tcAmount.text}',
                                            hasDivider: false,
                                          ),
                                          const SizedBox(
                                            height: Grid.s,
                                          ),
                                          OrderApprovementButtons(
                                            onPressedApprove: () {
                                              _moneyTransferBloc.add(
                                                AddVirmanOrderEvent(
                                                  accountId: _selectedSendingAccount.accountId.split('-')[1],
                                                  toAccountId: _selectedRecipientAccount?.accountId.split('-')[1] ?? '',
                                                  amount: MoneyUtils().fromReadableMoney(
                                                    _tcAmount.text,
                                                  ),
                                                  onSuccess: () {
                                                    router.push(
                                                      InfoRoute(
                                                        variant: InfoVariant.success,
                                                        message: L10n.tr('money_transfer_between_account_success'),
                                                      ),
                                                    );
                                                    router.popUntilRoot();
                                                    return;
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Text(
                                    L10n.tr('see_request_detail'),
                                    style: context.pAppStyle.labelReg16primary,
                                  ),
                                ),
                                const SizedBox(
                                  height: Grid.l + Grid.s,
                                ),
                                OrderApprovementButtons(
                                  onPressedApprove: () async {
                                    _moneyTransferBloc.add(
                                      AddVirmanOrderEvent(
                                        accountId: _selectedSendingAccount.accountId.split('-')[1],
                                        toAccountId: _selectedRecipientAccount?.accountId.split('-')[1] ?? '',
                                        amount: MoneyUtils().fromReadableMoney(
                                          _tcAmount.text,
                                        ),
                                        onSuccess: () {
                                          router.push(
                                            InfoRoute(
                                              variant: InfoVariant.success,
                                              message: L10n.tr('money_transfer_between_account_success'),
                                            ),
                                          );
                                          router.popUntilRoot();
                                          return;
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );

                          return;
                        },
                ),
              ),
            );
          }),
    );
  }

  Widget _sendingAccountWidget() {
    _sendingAccountList.sort((a, b) {
      int suffixA = int.parse(a.accountId.split('-').last);
      int suffixB = int.parse(b.accountId.split('-').last);

      // Önce 100-199 arası (örneğin -100'lü hesaplar), sonra 900-999 arası sıralansın
      bool isAIn100s = suffixA >= 100 && suffixA < 200;
      bool isBIn100s = suffixB >= 100 && suffixB < 200;

      if (isAIn100s && !isBIn100s) return -1;
      if (!isAIn100s && isBIn100s) return 1;

      // Her ikisi de aynı gruptaysa kendi arasında sırala
      return suffixA.compareTo(suffixB);
    });

    return PSelectorField(
      title: L10n.tr('gonderen_hesap'),
      initializeValue: DropdownModel(
        name: _selectedSendingAccount.accountId,
        value: _selectedSendingAccount,
      ),
      selectedAccount: _selectedSendingAccount,
      subTitle: Row(
        children: [
          Text(
            '${L10n.tr('islem_limiti')}: ',
            style: context.pAppStyle.labelReg12textSecondary,
          ),
          PBlocBuilder<MoneyTransferBloc, MoneyTransferState>(
              bloc: _moneyTransferBloc,
              builder: (context, state) {
                _transactionLimit = state.senderTradeLimit ?? 0;

                String tradeLimit = MoneyUtils().readableMoney(_transactionLimit);

                if (tradeLimit.contains('-')) {
                  tradeLimit = tradeLimit.replaceAll('-', '-${_selectedSendingAccount.currency.symbol}');
                } else {
                  tradeLimit = '${_selectedSendingAccount.currency.symbol}$tradeLimit';
                }

                return Shimmerize(
                  enabled: state.isLoading,
                  child: Text(
                    tradeLimit,
                    style: context.pAppStyle.labelMed12textSecondary,
                  ),
                );
              }),
        ],
      ),
      items: _sendingAccountList
          .map((e) => DropdownModel(
                name: e.accountId,
                value: e,
              ))
          .toList(),
      onChanged: (selectedItem) {
        setState(() {
          _selectedSendingAccount = selectedItem.value;
          _tcAmount.text = '0';
          _errorText = null;

          if (_selectedSendingAccount.currency.shortName == 'tl') {
            _moneyTransferBloc.add(
              GetTradeLimitBySenderRecipientEvent(
                accountId: _selectedSendingAccount.accountId.split('-')[1],
                typeName: 'CASH-T2',
                isSender: true,
              ),
            );
          } else {
            /// Döviz (usd, gbp, eur, jpy) için işlem limitinin alındığı event.
            _moneyTransferBloc.add(
              GetInstantCashAmountEvent(
                accountId: _selectedSendingAccount.accountId.split('-')[1],
                finInstName: _selectedSendingAccount.currency.shortName.toUpperCase(),
                isSender: true,
              ),
            );
          }

          _recipientAccountList = UserModel.instance.accounts
              .where(
                (element) => element.accountId != selectedItem.name && element.currency == selectedItem.value.currency,
              )
              .toList();

          if (_recipientAccountList.isNotEmpty) {
            _selectedRecipientAccount = _recipientAccountList[0];

            if (_selectedRecipientAccount!.currency.shortName == 'tl') {
              _moneyTransferBloc.add(
                GetTradeLimitBySenderRecipientEvent(
                  accountId: _selectedRecipientAccount!.accountId.split('-')[1],
                  typeName: 'CASH-T2',
                  isSender: false,
                ),
              );
            } else {
              /// Döviz (usd, gbp, eur, jpy) için işlem limitinin alındığı event.
              _moneyTransferBloc.add(
                GetInstantCashAmountEvent(
                  accountId: _selectedRecipientAccount!.accountId.split('-')[1],
                  finInstName: _selectedRecipientAccount!.currency.shortName.toUpperCase(),
                  isSender: false,
                ),
              );
            }
          } else {
            // Seçilen hesabın aynı döviz kurundan başka hesap yoksa yapılacak işlemler.

            _selectedRecipientAccount = null;
          }
        });
      },
    );
  }

  Widget _recipiendAccountWidget() {
    if (_recipientAccountList.isNotEmpty) {
      _recipientAccountList.sort((a, b) {
        int suffixA = int.parse(a.accountId.split('-').last);
        int suffixB = int.parse(b.accountId.split('-').last);

        // Önce 100-199 arası (örneğin -100'lü hesaplar), sonra 900-999 arası sıralansın
        bool isAIn100s = suffixA >= 100 && suffixA < 200;
        bool isBIn100s = suffixB >= 100 && suffixB < 200;

        if (isAIn100s && !isBIn100s) return -1;
        if (!isAIn100s && isBIn100s) return 1;

        // Her ikisi de aynı gruptaysa kendi arasında sırala
        return suffixA.compareTo(suffixB);
      });
    }

    return PSelectorField(
      title: L10n.tr('alici_hesap'),
      initializeValue: DropdownModel(
        name: _selectedRecipientAccount?.accountId ?? '',
        value: _selectedRecipientAccount ?? '',
      ),
      selectedAccount: _selectedRecipientAccount ??
          AccountModel(
            accountId: '',
            currency: CurrencyEnum.turkishLira,
          ),
      subTitle: _selectedRecipientAccount == null
          ? null
          : Row(
              children: [
                Text(
                  '${L10n.tr('cash_balance')}: ',
                  style: context.pAppStyle.labelReg12textSecondary,
                ),
                PBlocBuilder<MoneyTransferBloc, MoneyTransferState>(
                  bloc: _moneyTransferBloc,
                  builder: (context, state) {
                    String tradeLimit = MoneyUtils().readableMoney(
                      state.recipientTradeLimit ?? 0,
                    );

                    if (tradeLimit.contains('-')) {
                      tradeLimit = tradeLimit.replaceAll('-', '-${_selectedSendingAccount.currency.symbol}');
                    } else {
                      tradeLimit = '${_selectedSendingAccount.currency.symbol}$tradeLimit';
                    }

                    return Shimmerize(
                      enabled: state.isLoading,
                      child: Text(
                        tradeLimit,
                        style: context.pAppStyle.labelMed12textSecondary,
                      ),
                    );
                  },
                ),
              ],
            ),
      itemWidget: _selectedRecipientAccount == null ? _addAccountWidget() : null,
      items: _recipientAccountList
          .map((e) => DropdownModel(
                name: e.accountId,
                value: e,
              ))
          .toList(),
      onChanged: (selectedItem) {
        setState(() {
          _selectedRecipientAccount = selectedItem.value;
          _tcAmount.text = '0';
          _errorText = null;

          if (_selectedRecipientAccount!.currency.shortName == 'tl') {
            _moneyTransferBloc.add(
              GetTradeLimitBySenderRecipientEvent(
                accountId: _selectedRecipientAccount!.accountId.split('-')[1],
                typeName: 'CASH-T2',
                isSender: false,
              ),
            );
          } else {
            /// Döviz (usd, gbp, eur, jpy) için işlem limitinin alındığı event.
            _moneyTransferBloc.add(
              GetInstantCashAmountEvent(
                accountId: _selectedRecipientAccount!.accountId.split('-')[1],
                finInstName: _selectedRecipientAccount!.currency.shortName.toUpperCase(),
                isSender: false,
              ),
            );
          }

          router.maybePop();
        });
      },
    );
  }

  Widget _addAccountWidget() {
    return InkWell(
      onTap: () => Utils().showCustomerServiceCallAlert(
        context,
        L10n.tr('contact_the_call_center'),
      ),
      child: Row(
        children: [
          Text(
            L10n.tr('hesap_ekle'),
            style: context.pAppStyle.labelMed14primary,
          ),
          const SizedBox(
            width: Grid.xs,
          ),
          SvgPicture.asset(
            ImagesPath.plus,
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
}
