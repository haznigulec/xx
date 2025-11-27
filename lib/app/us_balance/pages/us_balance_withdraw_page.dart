import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_bloc.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_event.dart';
import 'package:piapiri_v2/app/info/model/info_variant.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/pvalue_textfield_widget.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
import 'package:piapiri_v2/app/us_balance/bloc/us_balance_bloc.dart';
import 'package:piapiri_v2/app/us_balance/bloc/us_balance_event.dart';
import 'package:piapiri_v2/app/us_balance/bloc/us_balance_state.dart';
import 'package:piapiri_v2/app/us_balance/model/us_collateral_type_enum.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/text_input_formatters.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottom_sheet_approvement_detail_widget.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottom_sheet_approvement_widget.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_bloc.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_event.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/account_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/widgets/styled_text.dart';

class UsBalanceWithdrawPage extends StatefulWidget {
  final double totalUsdBalance;
  final Function(bool)? onFocusChanged;
  final bool isTapAllSelectLimit;

  const UsBalanceWithdrawPage({
    super.key,
    required this.totalUsdBalance,
    this.onFocusChanged,
    required this.isTapAllSelectLimit,
  });

  @override
  State<UsBalanceWithdrawPage> createState() => _UsBalanceWithdrawPageState();
}

class _UsBalanceWithdrawPageState extends State<UsBalanceWithdrawPage> {
  final TextEditingController _tcAmount = TextEditingController();
  String? _errorText;
  AccountModel? _selectedRecipientAccount;
  List<AccountModel> _recipientAccountList = [];
  late UsBalanceBloc _usBalanceBloc;
  late AssetsBloc _assetsBloc;
  bool _isLoading = false;

  @override
  void initState() {
    _assetsBloc = getIt<AssetsBloc>();
    _usBalanceBloc = getIt<UsBalanceBloc>();

    _tcAmount.text = MoneyUtils().readableMoney(0);

    _recipientAccountList =
        UserModel.instance.accounts.where((element) => element.currency == CurrencyEnum.dollar).toList();

    _selectedRecipientAccount = _recipientAccountList.first;

    super.initState();
  }

  @override
  void didUpdateWidget(covariant UsBalanceWithdrawPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isTapAllSelectLimit && !oldWidget.isTapAllSelectLimit) {
      setState(() {
        _tcAmount.text = MoneyUtils().readableMoney(widget.totalUsdBalance);
        _errorText = null;
      });
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<UsBalanceBloc, UsBalanceState>(
        bloc: _usBalanceBloc,
        builder: (context, state) {
          return Column(
            children: [
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(
                  horizontal: Grid.m,
                  vertical: Grid.s + Grid.xs,
                ),
                decoration: BoxDecoration(
                  color: context.pColorScheme.card,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      Grid.m,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      L10n.tr('alici_hesap'),
                      textAlign: TextAlign.left,
                      style: context.pAppStyle.labelReg14textPrimary,
                    ),
                    const SizedBox(
                      width: Grid.xs,
                    ),
                    _recipientAccountList.length == 1
                        ? Text(
                            _selectedRecipientAccount?.accountId ?? '',
                            style: context.pAppStyle.labelMed14textPrimary,
                          )
                        : InkWell(
                            onTap: () {
                              PBottomSheet.show(
                                context,
                                title: L10n.tr('hesap'),
                                titlePadding: const EdgeInsets.only(
                                  top: Grid.m,
                                ),
                                child: ListView.separated(
                                  itemCount: _recipientAccountList.length,
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) => const PDivider(),
                                  itemBuilder: (context, index) {
                                    return BottomsheetSelectTile(
                                      title:
                                          '${UserModel.instance.customerId ?? ''} - ${_recipientAccountList[index].accountId.split('-')[1]}',
                                      isSelected: _selectedRecipientAccount == _recipientAccountList[index],
                                      value: _recipientAccountList[index],
                                      onTap: (_, value) {
                                        setState(() {
                                          _selectedRecipientAccount = value;
                                        });

                                        router.maybePop();
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  _selectedRecipientAccount?.accountId ?? '',
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
                          )
                  ],
                ),
              ),
              const SizedBox(
                height: Grid.s,
              ),
              PValueTextfieldWidget(
                controller: _tcAmount,
                title: L10n.tr('cekilecek_tutar'),
                suffixText: CurrencyEnum.dollar.symbol,
                suffixStyle: context.pAppStyle.interMediumBase.copyWith(
                  fontSize: Grid.m + Grid.xxs,
                  color: widget.totalUsdBalance == 0
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
                  color: widget.totalUsdBalance == 0
                      ? context.pColorScheme.textTeritary
                      : _errorText != null
                          ? context.pColorScheme.critical
                          : context.pColorScheme.primary,
                ),
                onTapPrice: () {
                  if (_tcAmount.text == '0' || _tcAmount.text == '0,00') {
                    _tcAmount.text = '';
                  }
                },
                onFocusChange: (hasFocus) {
                  widget.onFocusChanged?.call(hasFocus);
                  if (!hasFocus) {
                    double amount = _tcAmount.text.isEmpty ? 0 : MoneyUtils().fromReadableMoney(_tcAmount.text);
                    _tcAmount.text = MoneyUtils().readableMoney(amount);
                  }
                },
                onChanged: (value) {
                  setState(() {
                    _tcAmount.text = value.toString();
                  });
                },
                subTitleTopPadding: Grid.s,
                subTitle: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${L10n.tr('usd_withdrawable_balance')} ',
                          style: context.pAppStyle.labelReg12textSecondary,
                        ),
                        TextSpan(
                          text: '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(widget.totalUsdBalance)}',
                          style: context.pAppStyle.labelMed12textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
                onSubmitted: (value) {
                  setState(() {
                    _tcAmount.text = value;
                    if (MoneyUtils().fromReadableMoney(_tcAmount.text) > (widget.totalUsdBalance)) {
                      _errorText = L10n.tr('insufficient_usd_balance');
                    } else {
                      _errorText = null;
                    }
                    FocusScope.of(context).unfocus();
                  });
                },
              ),
              const Spacer(),
              generalButtonPadding(
                context: context,
                leftPadding: 0,
                rightPadding: 0,
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
                          PBottomSheet.show(
                            context,
                            child: BottomSheetApprovementWidget(
                              textWidget: StyledText(
                                text: L10n.tr(
                                  'us_balance_approvement_message',
                                  namedArgs: {
                                    'account': _selectedRecipientAccount?.accountId ?? '',
                                    'amount': '${CurrencyEnum.dollar.symbol}${_tcAmount.text}',
                                    'type': '<medium>${L10n.tr('us_balance_withdrawal')}</medium>',
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
                                          L10n.tr('islem'): L10n.tr('us_balance_withdrawal'),
                                          L10n.tr('alici_hesap'): _selectedRecipientAccount!.accountId,
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
        });
  }

  void _doBalanceTransfer() {
    setState(() {
      _isLoading = true;
    });

    _usBalanceBloc.add(
      BalanceTransferEvent(
        accountId: _selectedRecipientAccount!.accountId.split('-')[1],
        amount: MoneyUtils().fromReadableMoney(_tcAmount.text).toString(),
        collateralType: UsCollateralTypeEnum.collateralWithdrawal.value,
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
                  : L10n.tr('us_balance_withdrawal_success'),
              buttonText: L10n.tr('return_to_portfolio'),
              onTapButton: () async {
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
