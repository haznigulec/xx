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

class WithDrawalCollateralPage extends StatefulWidget {
  final Function(bool)? onFocusChanged;
  final bool isTapAllSelectLimit;

  const WithDrawalCollateralPage({
    super.key,
    this.onFocusChanged,
    required this.isTapAllSelectLimit,
  });

  @override
  State<WithDrawalCollateralPage> createState() => _WithDrawalCollateralPageState();
}

class _WithDrawalCollateralPageState extends State<WithDrawalCollateralPage> {
  final TextEditingController _tcAmount = TextEditingController();
  String _selectedAccount = '';
  late MoneyTransferBloc _moneyTransferBloc;
  String? _errorText;
  List<AccountModel> _accountList = [];

  @override
  void initState() {
    _moneyTransferBloc = getIt<MoneyTransferBloc>();
    _tcAmount.text = MoneyUtils().readableMoney(0);

    _accountList = UserModel.instance.accounts
        .where(
          (element) => element.currency == CurrencyEnum.turkishLira,
        )
        .toList();

    if (_accountList.isNotEmpty) {
      _selectedAccount = _accountList[0].accountId;
    }

    super.initState();
  }

  @override
  void didUpdateWidget(covariant WithDrawalCollateralPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isTapAllSelectLimit && !oldWidget.isTapAllSelectLimit) {
      setState(() {
        _tcAmount.text = MoneyUtils().readableMoney(_moneyTransferBloc.state.collateralInfo?.usableColl ?? 0);
        _errorText = null;
      });
      FocusScope.of(context).unfocus();
    }
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
                                  text: '${L10n.tr('FreeCashColl')}: ',
                                  style: context.pAppStyle.labelReg12textSecondary,
                                ),
                                TextSpan(
                                  text: '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                                    state.collateralInfo?.usableColl ?? 0,
                                  )}',
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
                                PBottomSheet.show(context,
                                    title: L10n.tr('viop_collateral_accounts'),
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
                                              _tcAmount.text = '0';
                                              _errorText = null;

                                              _moneyTransferBloc.add(
                                                GetCollateralInfoEvent(
                                                  accountId: _selectedAccount.split('-')[1],
                                                ),
                                              );

                                              router.maybePop();
                                            });
                                          },
                                        );
                                      },
                                      separatorBuilder: (context, index) => const Divider(),
                                    ));
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
                  title: L10n.tr('cekilecek_tutar'),
                  suffixText: CurrencyEnum.turkishLira.symbol,
                  suffixStyle: context.pAppStyle.interMediumBase.copyWith(
                    fontSize: 18,
                    color: _errorText != null ? context.pColorScheme.critical : context.pColorScheme.primary,
                  ),
                  errorText: _errorText,
                  valueTextStyle: context.pAppStyle.interMediumBase.copyWith(
                    fontSize: 18,
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
                    widget.onFocusChanged?.call(hasFocus);
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
                  onChanged: (value) {
                    _tcAmount.text = value.toString();

                    double amount = MoneyUtils().fromReadableMoney(_tcAmount.text);

                    if (amount > (_moneyTransferBloc.state.collateralInfo?.usableColl ?? 1)) {
                      _errorText = L10n.tr('insufficient_viop_collateral');
                    } else {
                      _errorText = null;
                    }
                    setState(() {});
                  },
                  onSubmitted: (value) {
                    setState(() {
                      _tcAmount.text = value;
                      if (MoneyUtils().fromReadableMoney(_tcAmount.text) >
                          (_moneyTransferBloc.state.collateralInfo?.usableColl ?? 1)) {
                        _errorText = L10n.tr('insufficient_viop_collateral');
                      } else {
                        _errorText = null;
                      }
                      FocusScope.of(context).unfocus();
                    });
                  },
                ),
                const SizedBox(
                  height: Grid.l,
                ),
                PInfoWidget(
                  infoText: L10n.tr('collateral_withdrawal_info'),
                ),
                const Spacer(),
                PButton(
                  text: L10n.tr('devam'),
                  fillParentWidth: true,
                  onPressed: _moneyTransferBloc.state.collateralInfo?.usableColl == 0 ||
                          _errorText != null ||
                          _tcAmount.text.isEmpty ||
                          _tcAmount.text == '0' ||
                          _tcAmount.text == '0,00'
                      ? null
                      : () {
                          _showApproval(context);
                        },
                ),
                SizedBox(
                  height: MediaQuery.paddingOf(context).bottom + Grid.m,
                ),
              ],
            ),
          );
        });
  }

  void _showApproval(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime startDate = DateTime(now.year, now.month, now.day, 09, 00);
    DateTime endDate = DateTime(now.year, now.month, now.day, 15, 40);

    if (now.isBefore(startDate) || now.isAfter(endDate)) {
      PBottomSheet.showError(
        context,
        content: L10n.tr('collateral_withdrawal_date_error'),
      );
      return;
    }

    if (_tcAmount.text.isEmpty || _tcAmount.text == '0') {
      PBottomSheet.showError(
        context,
        content: L10n.tr('lutfen_tutar_giriniz'),
      );
      return;
    }

    PBottomSheet.show(
      context,
      title: L10n.tr('transaction_confirmation'),
      child: Column(
        children: [
          StyledText(
            text: L10n.tr(
              'viop_transaction_deposit_confirmation_message',
              namedArgs: {
                'amount': '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                  MoneyUtils().fromReadableMoney(
                    _tcAmount.text,
                  ),
                )}',
                'viopDeposit': '<medium>${L10n.tr('viop')} ${L10n.tr('teminat_cekme')}</medium>',
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
                      value: L10n.tr('viop_collateral_withdrawal'),
                    ),
                    DemandDetailRow(
                      title: L10n.tr('hesap'),
                      value: _selectedAccount,
                    ),
                    DemandDetailRow(
                      title: L10n.tr('tutar'),
                      value: '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                        MoneyUtils().fromReadableMoney(
                          _tcAmount.text,
                        ),
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
  }

  void _doContinue() {
    _moneyTransferBloc.add(
      CollateralAdministrationDataEvent(
        customerExtId: _selectedAccount.split('-')[0],
        accountExtId: _selectedAccount.split('-')[1],
        amount: MoneyUtils().fromReadableMoney(_tcAmount.text),
        source: CollateralTypeEnum.collateralWithdrawal.value,
        target: CollateralTypeEnum.depositingCollateral.value,
        onSuccess: () {
          router.push(
            InfoRoute(
              variant: InfoVariant.success,
              message: L10n.tr('viop_collateral_success'),
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
