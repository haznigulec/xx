import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/assets/model/collateral_type_enum.dart';
import 'package:piapiri_v2/app/info/model/info_variant.dart';
import 'package:piapiri_v2/app/money_transfer/bloc/money_transfer_bloc.dart';
import 'package:piapiri_v2/app/money_transfer/bloc/money_transfer_event.dart';
import 'package:piapiri_v2/app/money_transfer/bloc/money_transfer_state.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/pvalue_textfield_widget.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/text_input_formatters.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/demand_detail_row.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/info_widget.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/account_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/widgets/styled_text.dart';

class DepositCollateralPage extends StatefulWidget {
  const DepositCollateralPage({super.key});

  @override
  State<DepositCollateralPage> createState() => _DepositCollateralPageState();
}

class _DepositCollateralPageState extends State<DepositCollateralPage> {
  final TextEditingController _tcAmount = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();
  String _selectedAccount = '';
  late MoneyTransferBloc _moneyTransferBloc;
  String? _errorText;
  List<AccountModel> _accountList = [];
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    _moneyTransferBloc = getIt<MoneyTransferBloc>();
    _tcAmount.text = MoneyUtils().readableMoney(0);

    _amountFocusNode.addListener(_onFocusChange);

    _accountList = UserModel.instance.accounts
        .where(
          (element) => element.currency == CurrencyEnum.turkishLira,
        )
        .toList();

    if (_accountList.isNotEmpty) {
      _selectedAccount = _accountList[0].accountId;

      _moneyTransferBloc.add(
        GetCollateralInfoEvent(
          accountId: _selectedAccount.split('-')[1],
        ),
      );

      _moneyTransferBloc.add(
        GetCashBalance(
          accountId: _selectedAccount.split('-')[1],
          typeName: 'CASH-T',
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
    return PBlocBuilder<MoneyTransferBloc, MoneyTransferState>(
      bloc: _moneyTransferBloc,
      builder: (context, state) {
        return Shimmerize(
          enabled: state.isLoading,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
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
                                  L10n.tr('collateral_account'),
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
                                        text: '₺${MoneyUtils().readableMoney(state.cashBalance ?? 0)}',
                                        style: context.pAppStyle.labelMed12textSecondary,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            _accountList.length == 1
                                ? Text(
                                    _selectedAccount,
                                    style: context.pAppStyle.labelMed12textPrimary,
                                  )
                                : InkWell(
                                    onTap: () {
                                      PBottomSheet.show(
                                        context,
                                        title: L10n.tr('viop_collateral_accounts'),
                                        titlePadding: const EdgeInsets.only(top: Grid.m),
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          itemCount: _accountList.length,
                                          itemBuilder: (context, index) {
                                            final account = _accountList[index];
                                            return BottomsheetSelectTile(
                                              title: account.accountId,
                                              isSelected: _selectedAccount == account.accountId,
                                              value: account,
                                              onTap: (title, value) {
                                                setState(() {
                                                  _selectedAccount = title;

                                                  _moneyTransferBloc.add(
                                                    GetCollateralInfoEvent(
                                                      accountId: _selectedAccount.split('-')[1],
                                                    ),
                                                  );

                                                  _moneyTransferBloc.add(
                                                    GetCashBalance(
                                                      accountId: _selectedAccount.split('-')[1],
                                                      typeName: 'CASH-T',
                                                    ),
                                                  );

                                                  router.maybePop();
                                                });
                                              },
                                            );
                                          },
                                          separatorBuilder: (context, index) => const PDivider(),
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
                        suffixText: CurrencyEnum.turkishLira.symbol,
                        suffixStyle: context.pAppStyle.interMediumBase.copyWith(
                          fontSize: Grid.m + Grid.xxs,
                          color:
                              state.cashBalance == 0 ? context.pColorScheme.textTeritary : context.pColorScheme.primary,
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
                          color: state.cashBalance == 0
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
                        onSubmitted: (value) {
                          setState(() {
                            _tcAmount.text = value;

                            if (MoneyUtils().fromReadableMoney(_tcAmount.text) > (state.cashBalance ?? 1)) {
                              _errorText = L10n.tr('insufficient_cash_balance');
                            } else {
                              _errorText = null;
                            }
                            FocusScope.of(context).unfocus();
                          });
                        },
                      ),
                      const SizedBox(
                        height: Grid.s + Grid.xs,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            L10n.tr('total_viop_collateral_title'),
                            style: context.pAppStyle.labelReg14textPrimary,
                          ),
                          const SizedBox(
                            width: Grid.s,
                          ),
                          Text(
                            '₺${MoneyUtils().readableMoney(
                              state.collateralInfo?.cashColl ?? 0,
                            )}',
                            style: context.pAppStyle.labelMed18textPrimary,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: Grid.l,
                      ),
                      PInfoWidget(
                        infoText: L10n.tr('deposit_of_collateral_info'),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedPadding(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.only(
                  bottom: _isKeyboardVisible ? Grid.xxl : Grid.m,
                ),
                child: PButton(
                  text: L10n.tr('devam'),
                  fillParentWidth: true,
                  onPressed:
                      _tcAmount.text.isEmpty || _tcAmount.text == '0' || _tcAmount.text == '0,00' || _errorText != null
                          ? null
                          : () {
                              if (_errorText != null) {
                                PBottomSheet.showError(
                                  context,
                                  content: L10n.tr('please_enter_valid_amount'),
                                );
                                return;
                              }

                              PBottomSheet.show(
                                context,
                                title: L10n.tr('transaction_confirmation'),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: Grid.s,
                                    ),
                                    StyledText(
                                      text: L10n.tr(
                                        'viop_transaction_deposit_confirmation_message',
                                        namedArgs: {
                                          'amount': '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                                            MoneyUtils().fromReadableMoney(_tcAmount.text),
                                          )}',
                                          'viopDeposit':
                                              '<medium>${L10n.tr('viop')} ${L10n.tr('teminat_yatirma')}</medium>',
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
                                                value: L10n.tr('WAITINGVIOPWDEM'),
                                              ),
                                              DemandDetailRow(
                                                title: L10n.tr('hesap'),
                                                value: _selectedAccount,
                                              ),
                                              DemandDetailRow(
                                                title: L10n.tr('tutar'),
                                                value: '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                                                  MoneyUtils().fromReadableMoney(_tcAmount.text),
                                                )}',
                                                hasDivider: false,
                                              ),
                                              const SizedBox(
                                                height: Grid.s,
                                              ),
                                              OrderApprovementButtons(
                                                onPressedApprove: () {
                                                  _doContinue();
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
                                        _doContinue();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                ),
              ),
              SizedBox(
                height: _isKeyboardVisible ? 0 : Grid.l,
              ),
            ],
          ),
        );
      },
    );
  }

  void _doContinue() {
    _moneyTransferBloc.add(
      CollateralAdministrationDataEvent(
        customerExtId: _selectedAccount.split('-')[0],
        accountExtId: _selectedAccount.split('-')[1],
        amount: MoneyUtils().fromReadableMoney(_tcAmount.text),
        source: CollateralTypeEnum.depositingCollateral.value,
        target: CollateralTypeEnum.collateralWithdrawal.value,
        onSuccess: () {
          router.push(
            InfoRoute(
              variant: InfoVariant.success,
              message: L10n.tr('viop_deposit_success'),
            ),
          );
          router.popUntilRoot();

          return;
        },
        onFailed: (message) {
          return PBottomSheet.showError(
            context,
            content: message,
          );
        },
      ),
    );
  }
}
