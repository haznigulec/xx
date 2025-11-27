import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/sliding_segment/model/sliding_segment_model.dart';
import 'package:piapiri_v2/common/widgets/sliding_segment/sliding_segment.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_bloc.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_bloc.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_event.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_state.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/create_us_order/widgets/consistent_equivalence.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_bloc.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_event.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_state.dart';
import 'package:piapiri_v2/app/fund/widgets/fund_order_info_widget.dart';
import 'package:piapiri_v2/app/fund/widgets/fund_review_tile_widget.dart';
import 'package:piapiri_v2/app/fund/widgets/fund_trade_limit_enum.dart';
import 'package:piapiri_v2/app/fund/widgets/p_fund_amount_textfield.dart';
import 'package:piapiri_v2/app/fund/widgets/p_fund_quantity_textfield.dart';
import 'package:piapiri_v2/app/info/model/info_variant.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_bloc.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_event.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/create_account_widget.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/info_widget.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/ink_wrapper.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/insufficient_limit_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/select_account_widget.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_bloc.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_event.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/extension/string_extension.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/fund_model.dart';
import 'package:piapiri_v2/core/model/fund_order_action.dart';
import 'package:piapiri_v2/core/model/order_status_enum.dart';
import 'package:piapiri_v2/core/model/symbol_type_enum.dart';
import 'package:piapiri_v2/core/model/transaction_model.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class FundOrderPage extends StatefulWidget {
  final FundDetailModel fund;
  final List<FundOrderActionEnum> allowedActions;
  final FundOrderActionEnum action;

  const FundOrderPage({
    super.key,
    required this.fund,
    required this.action,
    required this.allowedActions,
  });

  @override
  State<FundOrderPage> createState() => _FundOrderPageState();
}

class _FundOrderPageState extends State<FundOrderPage> {
  final FundBloc _fundBloc = getIt<FundBloc>();
  final OrdersBloc _ordersBloc = getIt<OrdersBloc>();
  final TabBloc _tabBloc = getIt<TabBloc>();
  final AssetsBloc _assetsBloc = getIt<AssetsBloc>();
  final AppSettingsBloc _appSettingsBloc = getIt<AppSettingsBloc>();
  final AuthBloc _authBloc = getIt<AuthBloc>();

  String _selectedAccount = '';
  FundOrderActionEnum _action = FundOrderActionEnum.buy;
  FundOrderBaseTypeEnum _baseType = FundOrderBaseTypeEnum.unit;
  final TextEditingController _unitController = TextEditingController(text: '0');
  final TextEditingController _amountController = TextEditingController(text: MoneyUtils().readableMoney(0));
  final FocusNode _amountFocusNode = FocusNode(
    debugLabel: 'tutar',
  );
  final FocusNode _quantitiyFocusNode = FocusNode(
    debugLabel: 'adet',
  );
  // AssetsBloc GetOverallSummaryEvent fundSymbol geçilen yerlerde callbackte setlendi
  String _assetCode = '';
  double? _fundPrice;
  // emirlerimde aktif olarak emri verilmis adet sayisi
  int pendingSellableUnit = 0;
  @override
  void initState() {
    if (_authBloc.state.isLoggedIn) {
      _selectedAccount = _appSettingsBloc.state.orderSettings.fundDefaultAccount;
      _action = widget.action;
      _fundBloc.add(
        GetFundPriceEvent(
            fundCode: widget.fund.code,
            callback: (price) {
              setState(() {
                _fundPrice = price;
              });
            }),
      );
      _fundBloc.add(
        GetFundInfoEvent(
          accountId: _selectedAccount,
          fundCode: widget.fund.code,
          type: _action == FundOrderActionEnum.buy ? 'B' : 'S',
        ),
      );
      _ordersBloc.add(
        GetOrdersEvent(
          account: 'ALL',
          symbolType: SymbolTypeEnum.all,
          orderStatus: OrderStatusEnum.pending,
          refreshData: false,
          isLoading: false,
          callBack: (orderListModel) {
            List<TransactionModel> pendingOrders = orderListModel.fundList
                .where(
                  (e) => e.symbol == widget.fund.code && e.transactionType == 'Sell',
                )
                .toList();

            pendingSellableUnit = pendingOrders.fold(
              0,
              (previousValue, element) => (previousValue + (element.orderUnit ?? 0)).toInt(),
            );

            setState(() {});
          },
        ),
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    _unitController.dispose();
    _amountController.dispose();
    _quantitiyFocusNode.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  double valueFormatter(double value) {
    return (value * 100).ceilToDouble() / 100;
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<FundBloc, FundState>(
        bloc: _fundBloc,
        builder: (context, state) {
          return PBlocBuilder<AssetsBloc, AssetsState>(
            bloc: _assetsBloc,
            builder: (context, assetState) {
              double price;
              if (_fundPrice != null && _fundPrice != 0) {
                price = _fundPrice!;
              } else if (widget.fund.price != null && widget.fund.price != 0) {
                price = widget.fund.price!;
              } else {
                price = 0;
              }
              double tradeLimit = _assetCode != widget.fund.code ? 0 : assetState.limitInfos?['tradeLimit'] ?? 0;

              int minBuyableUnit = widget.fund.minBuyAmount.toInt();
              int minSellableUnit = widget.fund.minSellAmount.toInt();
              int maxBuyableUnit = price == 0 ? 0 : (tradeLimit / price).floor();
              int maxSellableUnit =
                  (_assetCode != widget.fund.code ? 0 : assetState.saleableUnit?.toInt() ?? 0) - pendingSellableUnit;
              if (maxSellableUnit < 0) {
                maxSellableUnit = 0;
              }
              return Stack(
                children: [
                  Scaffold(
                    appBar: PInnerAppBar(
                      title: '${L10n.tr('al')} / ${L10n.tr('sat')}',
                      actions: !_authBloc.state.isLoggedIn
                          ? null
                          : [
                              InkWrapper(
                                child: SvgPicture.asset(
                                  ImagesPath.preference,
                                  height: Grid.l,
                                  width: Grid.l,
                                  colorFilter: ColorFilter.mode(
                                    context.pColorScheme.iconPrimary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                onTap: () => router.push(
                                  const FundSettingsRoute(),
                                ),
                              ),
                            ],
                    ),
                    body: !_authBloc.state.isLoggedIn
                        ? Center(
                            child: CreateAccountWidget(
                              memberMessage: L10n.tr('create_account_orders'),
                              loginMessage: L10n.tr('login_warning_orders'),
                              onLogin: () => router.push(
                                AuthRoute(
                                  afterLoginAction: () async {
                                    router.push(
                                      FundOrderRoute(
                                        fund: widget.fund,
                                        action: widget.action,
                                        allowedActions: widget.allowedActions,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Grid.m,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: Grid.m,
                                  ),
                                  FundOrderInfoWidget(
                                    fund: widget.fund,
                                    fundPrice: _fundPrice,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: Grid.l,
                                    ),
                                    child: SizedBox(
                                      height: 35,
                                      child: SlidingSegment(
                                          initialSelectedSegment: widget.allowedActions.indexOf(_action),
                                          onValueChanged: (action) {
                                            if (widget.allowedActions.length == 1) return;
                                            setState(() {
                                              _action =
                                                  action == 0 ? FundOrderActionEnum.buy : FundOrderActionEnum.sell;
                                              _fundBloc.add(
                                                GetFundInfoEvent(
                                                  accountId: _selectedAccount,
                                                  fundCode: widget.fund.code,
                                                  type: action == FundOrderActionEnum.buy.index ? 'B' : 'S',
                                                ),
                                              );
                                            });
                                          },
                                          backgroundColor: context.pColorScheme.card,
                                          selectedTextColor: context.pColorScheme.card.shade50,
                                          unSelectedTextColor: context.pColorScheme.textSecondary,
                                          segmentList: [
                                            ...widget.allowedActions.map((action) {
                                              return PSlidingSegmentModel(
                                                segmentTitle: L10n.tr(action.localizationKey).toCapitalizeCaseTr,
                                                segmentColor: action == FundOrderActionEnum.buy
                                                    ? context.pColorScheme.success
                                                    : context.pColorScheme.critical,
                                              );
                                            })
                                          ]),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 35,
                                    width: MediaQuery.sizeOf(context).width,
                                    child: SlidingSegment(
                                      initialSelectedSegment: _baseType == FundOrderBaseTypeEnum.unit ? 0 : 1,
                                      backgroundColor: context.pColorScheme.card,
                                      segmentList: [
                                        PSlidingSegmentModel(
                                          segmentTitle: L10n.tr('adet'),
                                          segmentColor: context.pColorScheme.secondary,
                                        ),
                                        PSlidingSegmentModel(
                                          segmentTitle: L10n.tr('tutar'),
                                          segmentColor: context.pColorScheme.secondary,
                                        ),
                                      ],
                                      onValueChanged: (baseType) {
                                        setState(() {
                                          _baseType =
                                              baseType == 0 ? FundOrderBaseTypeEnum.unit : FundOrderBaseTypeEnum.amount;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: Grid.s,
                                  ),
                                  _baseType == FundOrderBaseTypeEnum.amount
                                      ? PFundAmountTextfield(
                                          key: ValueKey('FUND_AMOUNT_${_action.value}'),
                                          action: _action,
                                          controller: _amountController,
                                          focusNode: _amountFocusNode,
                                          errorText: _action == FundOrderActionEnum.buy &&
                                                  MoneyUtils().fromReadableMoney(_amountController.text) > tradeLimit
                                              ? L10n.tr('insufficient_transaction_limit')
                                              : null,
                                          onAmountChanged: (amount) {
                                            int rawUnit = (amount / price).floor();
                                            _unitController.text = MoneyUtils().readableMoney(
                                              rawUnit,
                                              pattern: '#,##0',
                                            );
                                            _setUnitController(rawUnit, price);
                                            setState(() {});
                                          },
                                        )
                                      : PFundQuantityTextfield(
                                          key: ValueKey('FUND_QTY_${_action.value}'),
                                          controller: _unitController,
                                          focusNode: _quantitiyFocusNode,
                                          action: _action,
                                          errorText: isQtyError(
                                              minBuyableUnit: minBuyableUnit,
                                              minSellableUnit: minSellableUnit,
                                              maxSellableUnit: maxSellableUnit),
                                          subTitle:
                                              '${_action == FundOrderActionEnum.buy ? L10n.tr('alinabilir_adet') : L10n.tr('satilabilir_adet')}: ${_action == FundOrderActionEnum.buy ? '$maxBuyableUnit' : '$maxSellableUnit'}',
                                          onTapSubtitle: () {
                                            if (_action == FundOrderActionEnum.buy) {
                                              _setUnitController(maxBuyableUnit, price);
                                            } else {
                                              _setUnitController(maxSellableUnit, price);
                                            }
                                          },
                                          onUnitChanged: (unit) {
                                            _setUnitController(unit, price);
                                            setState(() {});
                                          }),
                                  const SizedBox(
                                    height: Grid.m,
                                  ),

                                  /// Tutar gosterilen alan yetersiz limitte hata verir
                                  ConsistentEquivalence(
                                    title: _baseType == FundOrderBaseTypeEnum.unit
                                        ? L10n.tr('estimated_amount')
                                        : L10n.tr('estimated_number_shares'),
                                    titleValue: _baseType == FundOrderBaseTypeEnum.unit
                                        ? '${CurrencyEnum.turkishLira.symbol}${_amountController.text}'
                                        : _unitController.text,
                                    subTitle: (_action == FundOrderActionEnum.buy && minBuyableUnit > 1) ||
                                            (_action == FundOrderActionEnum.sell && minSellableUnit > 1)
                                        ? '${L10n.tr('fund_minimum_share')}:'
                                        : null,
                                    subTitleValue:
                                        _action == FundOrderActionEnum.buy ? '$minBuyableUnit' : '$minSellableUnit',
                                    onTapSubtitle: (num value) {
                                      _setUnitController(
                                          _action == FundOrderActionEnum.buy ? minBuyableUnit : minSellableUnit, price);
                                    },
                                    subTitle2: _baseType == FundOrderBaseTypeEnum.amount
                                        ? '${_action == FundOrderActionEnum.sell ? L10n.tr('satilabilir_adet') : L10n.tr('alinabilir_adet')}:'
                                        : null,
                                    subTitleValue2: _baseType == FundOrderBaseTypeEnum.amount
                                        ? '${_action == FundOrderActionEnum.sell ? maxSellableUnit : maxBuyableUnit}'
                                        : null,
                                    onTapSubtitle2: (num value) {
                                      if (_baseType == FundOrderBaseTypeEnum.amount) {
                                        _setUnitController(
                                          _action == FundOrderActionEnum.buy ? maxBuyableUnit : maxSellableUnit,
                                          price,
                                        );
                                      }
                                    },
                                    errorMessage: getConsistentEquivalenceError(
                                      tradeLimit: tradeLimit,
                                      minBuyableUnit: minBuyableUnit,
                                      minSellableUnit: minSellableUnit,
                                      maxSellableUnit: maxSellableUnit,
                                    ),
                                  ),
                                  if (MoneyUtils().fromReadableMoney(_amountController.text) != 0 &&
                                      MoneyUtils().fromReadableMoney(_amountController.text) > tradeLimit &&
                                      _action == FundOrderActionEnum.buy) ...[
                                    const SizedBox(
                                      height: Grid.s,
                                    ),

                                    /// yetersiz limitte bakiye yuklemeye godneridgimiz widget
                                    InsufficientLimitWidget(
                                      text: L10n.tr('deposit_tl_continue'),
                                      onTap: () {
                                        router.push(DepositMoneyAccountRoute());
                                      },
                                    ),
                                  ],
                                  if (widget.fund.unitCoefficient > 1) ...[
                                    const SizedBox(
                                      height: Grid.m,
                                    ),
                                    PInfoWidget(
                                      infoText: L10n.tr('fund_unitcoefficient_info', args: [
                                        widget.fund.unitCoefficient.toString(),
                                      ]),
                                      infoTextStyle: context.pAppStyle.labelReg12textPrimary,
                                    ),
                                  ],
                                  const SizedBox(
                                    height: Grid.l,
                                  ),
                                  SelectAccountWidget(
                                      fundCode: widget.fund.code,
                                      tradeLimitType: FundTradeLimitEnum.fromValorDate(state.valorDate).typeName,
                                      setFundCodeToAssetCode: () {
                                        if (_assetCode != widget.fund.code) {
                                          setState(() {
                                            _assetCode = widget.fund.code;
                                          });
                                        }
                                      },
                                      onSelectedAccount: (account) {
                                        setState(() {
                                          _selectedAccount = account.split('-')[1];
                                          _fundBloc.add(
                                            GetFundInfoEvent(
                                              accountId: _selectedAccount,
                                              fundCode: widget.fund.code,
                                              type: _action == FundOrderActionEnum.buy ? 'B' : 'S',
                                            ),
                                          );
                                          if (_action == FundOrderActionEnum.sell) {
                                            _assetsBloc.add(
                                              GetOverallSummaryEvent(
                                                accountId: _selectedAccount,
                                                allAccounts: _selectedAccount == '',
                                                fundSymbol: widget.fund.code,
                                                includeCashFlow: true,
                                                includeCreditDetail: true,
                                                calculateTradeLimit: true,
                                                isConsolidated: true,
                                                getInstant: true,
                                                callback: (assetsModel) {
                                                  if (_assetCode != widget.fund.code) {
                                                    setState(() {
                                                      _assetCode = widget.fund.code;
                                                    });
                                                  }
                                                },
                                              ),
                                            );
                                          }
                                        });
                                      }),
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
                                        state.valorDate.isEmpty
                                            ? DateTimeUtils.dateFormat(DateTime.now())
                                            : DateTimeUtils.dateFormat(
                                                DateTime.parse(state.valorDate),
                                              ),
                                        style: context.pAppStyle.labelMed14textPrimary,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                    bottomNavigationBar: !_authBloc.state.isLoggedIn
                        ? null
                        : generalButtonPadding(
                            context: context,
                            child: PButton(
                              text: '${widget.fund.code} ${L10n.tr(_action.localizationKey)}',
                              sizeType: PButtonSize.medium,
                              loading: state.isLoading,
                              fillParentWidth: true,
                              variant:
                                  _action == FundOrderActionEnum.buy ? PButtonVariant.success : PButtonVariant.error,
                              onPressed: disableOrderButton(tradeLimit, maxSellableUnit)
                                  ? null
                                  : () {
                                      _orderConfirmation(state);
                                    },
                            ),
                          ),
                  ),
                ],
              );
            },
          );
        });
  }

  String? getConsistentEquivalenceError(
      {required double tradeLimit,
      required int minBuyableUnit,
      required int minSellableUnit,
      required int maxSellableUnit}) {
    double amount = MoneyUtils().fromReadableMoney(_amountController.text);
    int unit = MoneyUtils().fromReadableMoney(_unitController.text).toInt();

    if (_action == FundOrderActionEnum.buy && amount > tradeLimit && _baseType == FundOrderBaseTypeEnum.unit) {
      return L10n.tr('insufficient_transaction_limit');
    }
    if (_action == FundOrderActionEnum.sell && unit > maxSellableUnit && _baseType == FundOrderBaseTypeEnum.amount) {
      return L10n.tr('insufficient_transaction_unit');
    }
    if (_action == FundOrderActionEnum.buy &&
        _baseType == FundOrderBaseTypeEnum.amount &&
        unit != 0 &&
        unit < minBuyableUnit &&
        minBuyableUnit > 1) {
      return L10n.tr('insufficient_number_of_shares');
    }
    if (_action == FundOrderActionEnum.sell &&
        _baseType == FundOrderBaseTypeEnum.amount &&
        unit != 0 &&
        unit < minSellableUnit &&
        minSellableUnit > 1) {
      return L10n.tr('insufficient_number_of_shares');
    }
    return null;
  }

  bool disableOrderButton(double tradeLimit, int sellableUnit) {
    int unit = MoneyUtils().fromReadableMoney(_unitController.text).toInt();
    double amount = MoneyUtils().fromReadableMoney(_amountController.text);
    if (_action == FundOrderActionEnum.buy) {
      if (unit < widget.fund.minBuyAmount) return true;
      if (amount > tradeLimit) return true;
      return false;
    } else {
      if (unit < widget.fund.minSellAmount) return true;
      if (unit > sellableUnit) return true;
      return false;
    }
  }

  void _orderDetail(FundState state) {
    int unit = MoneyUtils().fromReadableMoney(_unitController.text).toInt();
    PBottomSheet.show(
      context,
      title: L10n.tr('emir_detay'),
      titlePadding: const EdgeInsets.only(
        top: Grid.m,
      ),
      showBackButton: true,
      negativeAction: PBottomSheetAction(
        text: L10n.tr('vazgec'),
        action: () => router.maybePop(),
      ),
      positiveAction: PBottomSheetAction(
        text: L10n.tr('onayla'),
        action: state.isLoading
            ? null
            : () async {
                await router.maybePop();
                await router.maybePop();
                _fundBloc.add(
                  NewOrderEvent(
                    accountId: _selectedAccount,
                    fundCode: widget.fund.code,
                    orderActionType: _action,
                    price: _fundPrice != null && _fundPrice != widget.fund.price ? _fundPrice! : widget.fund.price ?? 0,
                    unit: MoneyUtils().fromReadableMoney(_unitController.text).toInt(),
                    amount: MoneyUtils().fromReadableMoney(_amountController.text),
                    valorDate: state.valorDate,
                    baseType: _baseType.name,
                    errorCallback: () =>
                        UserModel.instance.innerType != null && UserModel.instance.innerType != 'INSTITUTION'
                            ? PBottomSheet.showError(
                                context,
                                content: L10n.tr('CustomerMustBeQualifiedInvestor'),
                                showFilledButton: true,
                                showOutlinedButton: true,
                                filledButtonText: L10n.tr('confirm_form'),
                                outlinedButtonText: L10n.tr('vazgec'),
                                onFilledButtonPressed: () => router.push(
                                  const FundQualifiedInvestorRoute(),
                                ),
                                onOutlinedButtonPressed: () => router.maybePop(),
                              )
                            : PBottomSheet.showError(
                                context,
                                content: L10n.tr(
                                  'contract_institution_control_nybf',
                                ),
                              ),
                    successCallback: () {
                      router.push(
                        InfoRoute(
                          message: L10n.tr('order_success'),
                          variant: InfoVariant.success,
                          buttonText: L10n.tr('emirlerime_don'),
                          onTapButton: () {
                            router.popUntilRoot();
                            _tabBloc.add(
                              const TabChangedEvent(
                                tabIndex: 1,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          FundReviewTileWidget(leadingText: L10n.tr('symbol'), trailingText: widget.fund.code),
          FundReviewTileWidget(
              leadingText: L10n.tr('transaction_type'),
              trailingText: _action.value == 'B' ? L10n.tr('AL') : L10n.tr('SAT'),
              orderActionType: _action.value),
          FundReviewTileWidget(
              leadingText: L10n.tr('fund_name'), trailingText: '${widget.fund.subType} • ${widget.fund.founder}'),
          FundReviewTileWidget(leadingText: L10n.tr('adet'), trailingText: unit.toString()),
          FundReviewTileWidget(
              leadingText: L10n.tr('estimated_amount'),
              trailingText: '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                widget.fund.price! * unit,
                pattern: '#,##0.######',
              )}'),
          FundReviewTileWidget(
              leadingText: L10n.tr('hesap'), trailingText: '${UserModel.instance.customerId}-$_selectedAccount'),
          FundReviewTileWidget(
            leadingText: L10n.tr('valor_date'),
            trailingText: state.valorDate.isEmpty
                ? DateTimeUtils.dateFormat(DateTime.now())
                : DateTimeUtils.dateFormat(
                    DateTime.parse(state.valorDate),
                  ),
            isLastDivider: true,
          ),
          const SizedBox(
            height: Grid.s + Grid.xxs,
          )
        ],
      ),
    );
  }

  String? isQtyError({
    required int minBuyableUnit,
    required int minSellableUnit,
    required int maxSellableUnit,
  }) {
    int unit = MoneyUtils().fromReadableMoney(_unitController.text).toInt();
    if (unit == 0) return null;
    if (_action == FundOrderActionEnum.buy && unit < minBuyableUnit) return L10n.tr('insufficient_number_of_shares');
    if (_action == FundOrderActionEnum.sell && unit < minSellableUnit) return L10n.tr('insufficient_number_of_shares');
    if (_action == FundOrderActionEnum.sell && unit > maxSellableUnit) return L10n.tr('insufficient_transaction_unit');

    return null;
  }

  void _orderConfirmation(FundState state) {
    int unit = MoneyUtils().fromReadableMoney(_unitController.text).toInt();
    PBottomSheet.show(
      context,
      titlePadding: const EdgeInsets.only(
        top: Grid.m,
      ),
      title: L10n.tr('order_confirmation'),
      negativeAction: PBottomSheetAction(
        text: L10n.tr('vazgec'),
        action: () => router.maybePop(),
      ),
      positiveAction: PBottomSheetAction(
        text: L10n.tr('onayla'),
        action: state.isLoading
            ? null
            : () async {
                await router.maybePop();
                _fundBloc.add(
                  NewOrderEvent(
                    accountId: _selectedAccount,
                    fundCode: widget.fund.code,
                    orderActionType: _action,
                    price: _fundPrice != null && _fundPrice != widget.fund.price ? _fundPrice! : widget.fund.price ?? 0,
                    unit: MoneyUtils().fromReadableMoney(_unitController.text).toInt(),
                    amount: MoneyUtils().fromReadableMoney(_amountController.text),
                    valorDate: state.valorDate,
                    baseType: _baseType.name,
                    errorCallback: () =>
                        UserModel.instance.innerType != null && UserModel.instance.innerType != 'INSTITUTION'
                            ? PBottomSheet.showError(
                                context,
                                content: L10n.tr('CustomerMustBeQualifiedInvestor'),
                                showFilledButton: true,
                                showOutlinedButton: true,
                                filledButtonText: L10n.tr('confirm_form'),
                                outlinedButtonText: L10n.tr('vazgec'),
                                onFilledButtonPressed: () => router.push(
                                  const FundQualifiedInvestorRoute(),
                                ),
                                onOutlinedButtonPressed: () => router.maybePop(),
                              )
                            : PBottomSheet.showError(
                                context,
                                content: L10n.tr(
                                  'contract_institution_control_nybf',
                                ),
                              ),
                    successCallback: () {
                      router.push(
                        InfoRoute(
                          message: L10n.tr('order_success'),
                          variant: InfoVariant.success,
                          buttonText: L10n.tr('emirlerime_don'),
                          onTapButton: () {
                            router.popUntilRoot();
                            _tabBloc.add(
                              const TabChangedEvent(
                                tabIndex: 1,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
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
                    text: _fundPrice != null && _fundPrice != widget.fund.price
                        ? L10n.tr(
                            'order_send_span_3',
                            args: [
                              MoneyUtils().readableMoney(
                                _fundPrice!,
                                pattern: MoneyUtils().getPatternByUnitDecimal(_fundPrice!),
                              ),
                              unit.toString(),
                              widget.fund.code,
                            ],
                          )
                        : L10n.tr(
                            'order_send_span_market',
                            args: [
                              unit.toString(),
                              widget.fund.code,
                            ],
                          ),
                    style: context.pAppStyle.labelReg16textPrimary,
                  ),
                  TextSpan(
                    text: '${L10n.tr(
                      _action.localizationKey,
                    ).toUpperCase()} ',
                    style: context.pAppStyle.interMediumBase.copyWith(
                      color: _action == FundOrderActionEnum.buy
                          ? context.pColorScheme.success
                          : context.pColorScheme.critical,
                      fontSize: Grid.m,
                    ),
                  ),
                  TextSpan(
                    text: L10n.tr('order_send_span_2'),
                    style: context.pAppStyle.labelReg16textPrimary,
                  ),
                ],
              )),
          const SizedBox(
            height: Grid.s,
          ),
          TextButton(
            onPressed: () async {
              _orderDetail(state);
            },
            child: Text(
              L10n.tr('show_order_detail'),
              style: context.pAppStyle.labelReg16primary,
            ),
          ),
          const SizedBox(
            height: Grid.m,
          ),
        ],
      ),
    );
  }

  _setUnitController(int value, double price) {
    // Eger unitCoefficient 1'den buyuk ise unit degeri unitCoefficient in katlari seklinde ayarlanir
    int unitCoefficient = widget.fund.unitCoefficient;

    if (unitCoefficient > 1) {
      value = (value / unitCoefficient).floor() * unitCoefficient;
    }

    _unitController.text = MoneyUtils().readableMoney(
      value,
      pattern: '#,##0',
    );
    _amountController.text = MoneyUtils().readableMoney(
      valueFormatter(price * value),
    );
    setState(() {});
  }
}
