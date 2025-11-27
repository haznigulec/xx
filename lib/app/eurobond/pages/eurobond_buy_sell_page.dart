import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/sliding_segment/model/sliding_segment_model.dart';
import 'package:piapiri_v2/common/widgets/sliding_segment/sliding_segment.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:p_core/keys/navigator_keys.dart';
import 'package:p_core/utils/keyboard_utils.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/eurobond/bloc/eurobond_bloc.dart';
import 'package:piapiri_v2/app/eurobond/bloc/eurobond_event.dart';
import 'package:piapiri_v2/app/eurobond/bloc/eurobond_state.dart';
import 'package:piapiri_v2/app/eurobond/model/eurobond_list_model.dart';
import 'package:piapiri_v2/app/eurobond/widgets/eurobond_order_detail.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_brief_info.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/cashflow_transaction_widget.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/info_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/common/widgets/buttons/text_button_selector.dart';
import 'package:piapiri_v2/common/widgets/textfields/order_text_fields/p_amount_textfield.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/account_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

@RoutePage()
class EuroBondBuySellPage extends StatefulWidget {
  final OrderActionTypeEnum action;
  final Bonds selectedEuroBond;
  const EuroBondBuySellPage({
    super.key,
    required this.action,
    required this.selectedEuroBond,
  });

  @override
  State<EuroBondBuySellPage> createState() => _EuroBondBuySellPageState();
}

class _EuroBondBuySellPageState extends State<EuroBondBuySellPage> {
  final EuroBondBloc _euroBondBloc = getIt<EuroBondBloc>();
  final AuthBloc _authBloc = getIt<AuthBloc>();
  late AccountModel _selectedAccount;
  OrderActionTypeEnum _action = OrderActionTypeEnum.buy;
  final TextEditingController _amountController = TextEditingController();
  List<AccountModel> _accountList = [];
  late FocusNode _focusNode;
  bool _isPriceError = false;
  late GlobalKey _amountKey;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _amountKey = GlobalKey(debugLabel: 'eurobondAmount');
    _action = widget.action;
    _accountList = UserModel.instance.accounts.where((element) => element.currency == CurrencyEnum.dollar).toList();
    _focusNode = FocusNode();
    _amountController.text = MoneyUtils().readableMoney(0);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        int price = MoneyUtils().fromReadableMoney(_amountController.text).toInt();
        _amountController.text = MoneyUtils().readableMoney(price.toDouble());

        if (MoneyUtils().fromReadableMoney(_amountController.text) > (_euroBondBloc.state.eurobondAssets?.qty ?? 0) &&
            _action == OrderActionTypeEnum.sell) {
          _isPriceError = true;
        } else {
          _isPriceError = false;
        }
        setState(() {});
      }
    });
    if (_accountList.isNotEmpty) {
      _selectedAccount = _accountList.first;
      if (_action == OrderActionTypeEnum.sell) {
        _euroBondBloc.add(
          GetBondsAssetsEvent(
            finInstId: widget.selectedEuroBond.finInstId ?? '',
            accountId: _selectedAccount.accountId.split('-')[1],
          ),
        );
      }

      _euroBondBloc.add(
        GetBondLimitEvent(
          accountId: _selectedAccount.accountId,
          finInstName: widget.selectedEuroBond.name ?? '',
          side: _action == OrderActionTypeEnum.buy ? 'B' : 'S',
        ),
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('buy_sell'),
        actions: !_authBloc.state.isLoggedIn
            ? null
            : [
                /// Emir iletim ayarlarina yonelndirir
                GestureDetector(
                  onTap: () async {
                    /// Eurobond emir iletim ayarlari olmadigindan genel emir iletim ayarlarina yonlendirir
                    await router.push(
                      const OrderSettingsRoute(),
                    );
                  },
                  child: SvgPicture.asset(
                    ImagesPath.preference,
                    height: 24,
                    width: 24,
                    colorFilter: ColorFilter.mode(
                      context.pColorScheme.iconPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
      ),
      body: _accountList.isEmpty
          ? Center(
              child: Text(
                L10n.tr('no_currency_account'),
                style: Theme.of(context).textTheme.labelMedium,
              ),
            )
          : PBlocBuilder<EuroBondBloc, EuroBondState>(
              bloc: _euroBondBloc,
              builder: (context, state) {
                if (state.tradeLimitType == PageState.loading) {
                  return const PLoading();
                }
                return Padding(
                  padding: const EdgeInsets.all(Grid.m),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          splashColor: context.pColorScheme.transparent,
                          highlightColor: context.pColorScheme.transparent,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                ImagesPath.yurt_disi,
                                width: 28,
                                height: 28,
                              ),
                              const SizedBox(
                                width: Grid.s,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.selectedEuroBond.name ?? '',
                                    style: context.pAppStyle.labelReg14textPrimary,
                                  ),
                                  Text(
                                    widget.selectedEuroBond.currencyName ?? '',
                                    style: context.pAppStyle.labelReg12textSecondary,
                                  ),
                                ],
                              ),
                              const Spacer(),
                              SvgPicture.asset(
                                ImagesPath.search,
                                height: 24,
                                width: 24,
                                colorFilter: ColorFilter.mode(
                                  context.pColorScheme.iconPrimary,
                                  BlendMode.srcIn,
                                ),
                              )
                            ],
                          ),
                          onTap: () => router.push(
                            const EurobondSearchSelectRoute(),
                          ),
                        ),
                        const SizedBox(
                          height: Grid.s,
                        ),
                        const PDivider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SymbolBriefInfo(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              label: L10n.tr('market_buy_price'),
                              titleStyle: context.pAppStyle.labelMed16textSecondary,
                              value: '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(
                                widget.selectedEuroBond.creditPrice ?? 0,
                                pattern: '#,##0.000',
                              )}',
                            ),
                            SymbolBriefInfo(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              label: L10n.tr('eurobond_sellprice'),
                              titleStyle: context.pAppStyle.labelMed16textSecondary,
                              value: '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(
                                widget.selectedEuroBond.debitPrice ?? 0,
                                pattern: '#,##0.000',
                              )}',
                            ),
                            SymbolBriefInfo(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              label: L10n.tr('maturity'),
                              titleStyle: context.pAppStyle.labelMed16textSecondary,
                              value: DateTime.parse(widget.selectedEuroBond.maturityDate.toString())
                                  .formatDayMonthYearDot(),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: Grid.m,
                        ),
                        SizedBox(
                          height: 35,
                          child: SlidingSegment(
                            initialSelectedSegment: _action == OrderActionTypeEnum.buy ? 0 : 1,
                            onValueChanged: (action) {
                              setState(() {
                                _action = action == 0 ? OrderActionTypeEnum.buy : OrderActionTypeEnum.sell;
                              });
                              if (_action == OrderActionTypeEnum.sell) {
                                _euroBondBloc.add(
                                  GetBondsAssetsEvent(
                                    finInstId: widget.selectedEuroBond.finInstId ?? '',
                                    accountId: _selectedAccount.accountId.split('-')[1],
                                  ),
                                );
                              }
                            },
                            backgroundColor: context.pColorScheme.card,
                            selectedTextColor: context.pColorScheme.card.shade50,
                            unSelectedTextColor: context.pColorScheme.textSecondary,
                            segmentList: [
                              PSlidingSegmentModel(
                                segmentTitle: L10n.tr('al'),
                                segmentColor: context.pColorScheme.success,
                              ),
                              PSlidingSegmentModel(
                                segmentTitle: L10n.tr('sat'),
                                segmentColor: context.pColorScheme.critical,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: Grid.l,
                        ),
                        PAmountTextfield(
                          key: _amountKey,
                          controller: _amountController,
                          focusNode: _focusNode,
                          action: _action,
                          currency: CurrencyEnum.dollar,
                          subTitle: _action == OrderActionTypeEnum.buy ? null : L10n.tr('saleable_amount'),
                          subTitleValue: _action == OrderActionTypeEnum.buy
                              ? null
                              : MoneyUtils().readableMoney(state.eurobondAssets?.qty ?? 0),
                          onTapSubTitle: () {
                            setState(() {
                              _amountController.text = MoneyUtils().readableMoney(
                                state.eurobondAssets?.qty ?? 0,
                              );
                            });
                          },
                          isError: _isPriceError,
                          errorText: _isPriceError && _action == OrderActionTypeEnum.buy
                              ? L10n.tr('TradeLimitInsufficient')
                              : null,
                          onTapAmount: () => KeyboardUtils().scrollOnFocus(
                            context,
                            _amountKey,
                            _scrollController,
                          ),
                          onAmountChanged: (amount) {
                            double newAmount = (amount / 1000).floor() * 1000;
                            _amountController.text = MoneyUtils().readableMoney(newAmount);

                            setState(() {});
                          },
                        ),

                        // PValueTextfieldWidget(
                        //   controller: _amountController,
                        //   suffixText: CurrencyEnum.dollar.symbol,
                        //   title: L10n.tr('tutar'),
                        //   keyboardType: const TextInputType.numberWithOptions(
                        //     decimal: true,
                        //     signed: false,
                        //   ),
                        //   inputFormatters: [
                        //     AppInputFormatters.decimalFormatter(
                        //       maxDigitAfterSeparator: 2,
                        //     ),
                        //   ],
                        //   subTitle: _action == OrderActionTypeEnum.buy
                        //       ? null
                        //       : Text(
                        //           '${L10n.tr('saleable_amount')}: \$${MoneyUtils().readableMoney(state.eurobondAssets?.qty ?? 0)}',
                        //           style: context.pAppStyle.interMediumBase.copyWith(
                        //             fontSize: Grid.s + Grid.xs,
                        //             color: _isPriceError
                        //                 ? context.pColorScheme.critical
                        //                 : context.pColorScheme.textSecondary,
                        //           ),
                        //         ),
                        //   errorText: _isPriceError && _action == OrderActionTypeEnum.buy
                        //       ? L10n.tr('TradeLimitInsufficient')
                        //       : null,
                        //   focusNode: _focusNode,
                        //   isError: _isPriceError,
                        //   onFocusChange: (hasFocus) {
                        //     if (!hasFocus) {
                        //       int price = MoneyUtils().fromReadableMoney(_amountController.text).toInt();
                        //       _amountController.text = MoneyUtils().readableMoney(price.toDouble());
                        //       setState(() {});
                        //     }
                        //   },
                        // ),
                        const SizedBox(
                          height: Grid.l,
                        ),
                        TextButtonSelector(
                          selectedItem:
                              '${UserModel.instance.customerId ?? ''} - ${_selectedAccount.accountId.split('-')[1]}',
                          enable: _accountList.length > 1,
                          selectedTextStyle: _accountList.length > 1
                              ? context.pAppStyle.labelMed14primary
                              : context.pAppStyle.labelMed14textPrimary,
                          onSelect: () {
                            PBottomSheet.show(
                              context,
                              title: L10n.tr('hesap'),
                              titlePadding: const EdgeInsets.only(
                                top: Grid.s,
                              ),
                              child: ListView.separated(
                                itemCount: _accountList.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return BottomsheetSelectTile(
                                    title:
                                        '${UserModel.instance.customerId ?? ''} - ${_accountList[index].accountId.split('-')[1]}',
                                    isSelected: _selectedAccount == _accountList[index],
                                    value: _accountList[index],
                                    onTap: (_, value) {
                                      setState(() {
                                        _selectedAccount = value;
                                      });
                                      _euroBondBloc.add(
                                        GetBondLimitEvent(
                                          accountId: _selectedAccount.accountId,
                                          finInstName: widget.selectedEuroBond.name ?? '',
                                          side: _action == OrderActionTypeEnum.buy ? 'B' : 'S',
                                        ),
                                      );

                                      router.maybePop();
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) => const PDivider(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: Grid.s,
                        ),
                        CashflowTransactionWidget(
                          limitText: L10n.tr('islem_limiti'),
                          limitValue: state.transactionLimit ?? 0,
                          isUs: true,
                        ),
                        const SizedBox(
                          height: Grid.l,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              L10n.tr('fund_valor_date'),
                              style: context.pAppStyle.labelReg14textSecondary,
                            ),
                            Text(
                              DateTime.parse(
                                widget.selectedEuroBond.valueDate ?? DateTime.now().toString(),
                              ).formatDayMonthYearDot(),
                              style: context.pAppStyle.labelMed14textPrimary,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: Grid.l,
                        ),
                        PInfoWidget(
                          infoText: L10n.tr('eurobond_info_1'),
                        ),
                        const SizedBox(
                          height: Grid.s + Grid.xs,
                        ),
                        PInfoWidget(
                          infoText: L10n.tr('eurobond_info_2'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: _accountList.isEmpty
          ? const SizedBox.shrink()
          : generalButtonPadding(
              context: context,
              child: PButton(
                text: _action == OrderActionTypeEnum.buy ? L10n.tr('buy_eurobond') : L10n.tr('sell_eurobond'),
                variant: _action == OrderActionTypeEnum.buy ? PButtonVariant.success : PButtonVariant.error,
                onPressed: _getButtonDisability() ? null : () => _buyOrSell(),
              ),
            ),
    );
  }

  bool _getButtonDisability() {
    double amount = MoneyUtils().fromReadableMoney(_amountController.text);

    if (amount <= 0) return true;
    if (_isPriceError) return true;
    return false;
  }

  void _buyOrSell() {
    if (MoneyUtils().fromReadableMoney(_amountController.text) < 1000) {
      PBottomSheet.showError(
        NavigatorKeys.navigatorKey.currentContext!,
        isSuccess: false,
        content: L10n.tr('eurobond_order_alert'),
      );
      return;
    }
    PBottomSheet.show(
      context,
      title: L10n.tr('order_confirmation'),
      titlePadding: const EdgeInsets.only(
        top: Grid.s,
      ),
      child: Column(
        children: [
          const SizedBox(
            height: Grid.l,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: L10n.tr('order_send_span_1', args: ['${CurrencyEnum.dollar.symbol}${_amountController.text}']),
                  style: context.pAppStyle.labelReg16textPrimary,
                ),
                TextSpan(
                  text: widget.selectedEuroBond.name ?? '',
                  style: context.pAppStyle.labelMed16textPrimary,
                ),
                TextSpan(
                  text: ' ${L10n.tr('eurobond')} ${_action.localizationKey2} '.toUpperCase(),
                  style: context.pAppStyle.interMediumBase.copyWith(
                    color: _action.color,
                    fontSize: Grid.m,
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
          TextButton(
            onPressed: () {
              PBottomSheet.show(
                context,
                title: L10n.tr('emir_detay'),
                titlePadding: const EdgeInsets.only(
                  top: Grid.s,
                ),
                child: EurobondOrderDetail(
                  bond: widget.selectedEuroBond,
                  actionType: _action,
                  accountId: _selectedAccount.accountId,
                  amount: '\$${_amountController.text}',
                  onPressedApprove: _sendOrder,
                ),
              );
            },
            child: Text(
              L10n.tr('show_order_detail'),
              style: context.pAppStyle.labelReg16primary,
            ),
          ),
          const SizedBox(
            height: Grid.m,
          ),
          OrderApprovementButtons(
            onPressedApprove: _sendOrder,
          ),
          const SizedBox(
            height: Grid.m,
          ),
        ],
      ),
    );
  }

  _sendOrder() {
    _euroBondBloc.add(
      ValidateOrderEvent(
        accountId: _selectedAccount.accountId.split('-')[1],
        finInstId: widget.selectedEuroBond.finInstId ?? '',
        side: _action == OrderActionTypeEnum.buy ? 'B' : 'S', //B(Alış), S(Satış)
        amount: MoneyUtils().fromReadableMoney(_amountController.text),
        onSuccess: (validateOrderResponse) {
          _euroBondBloc.add(
            AddOrderEvent(
              accountId: _selectedAccount.accountId.split('-')[1],
              finInstName: widget.selectedEuroBond.name ?? '',
              side: _action == OrderActionTypeEnum.buy ? 'B' : 'S', //B(Alış), S(Satış)
              amount: MoneyUtils().fromReadableMoney(_amountController.text),
              rate: _action == OrderActionTypeEnum.buy
                  ? widget.selectedEuroBond.creditRate ?? 0
                  : widget.selectedEuroBond.debitRate ?? 0,
              nominal: validateOrderResponse.nominalUnit ?? 0,
              unitPrice: _action == OrderActionTypeEnum.buy
                  ? widget.selectedEuroBond.creditPrice ?? 0
                  : widget.selectedEuroBond.debitPrice ?? 0,
              onSuccess: (response) async {
                router.replace(
                  OrderResultRoute(
                    isSuccess: true,
                    message: L10n.tr('HISSEOK'),
                  ),
                );
              },
              onError: (String errorMessage) {
                router.replace(
                  OrderResultRoute(
                    isSuccess: false,
                    message: L10n.tr(errorMessage),
                  ),
                );
              },
            ),
          );
        },
        onError: (String errorMessage) {
          router.replace(
            OrderResultRoute(
              isSuccess: false,
              message: L10n.tr(errorMessage),
            ),
          );
        },
      ),
    );
  }
}
