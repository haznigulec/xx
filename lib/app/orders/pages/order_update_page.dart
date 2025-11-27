import 'package:collection/collection.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/utils/keyboard_utils.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_bloc.dart';
import 'package:piapiri_v2/app/create_order/create_orders_utils.dart';
import 'package:piapiri_v2/app/create_us_order/widgets/consistent_equivalence.dart';
import 'package:piapiri_v2/app/info/model/info_variant.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_bloc.dart';
import 'package:piapiri_v2/app/orders/widgets/condition_selector.dart';
import 'package:piapiri_v2/app/orders/widgets/order_detail_price_tile.dart';
import 'package:piapiri_v2/app/orders/widgets/order_detail_styled_widget.dart';
import 'package:piapiri_v2/app/orders/widgets/take_profit_stop_loss_selector.dart';
import 'package:piapiri_v2/app/profit/bloc/profit_event.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/pvalue_textfield_widget.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_bloc.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_event.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/text_input_formatters.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/diff_percentage.dart';
import 'package:piapiri_v2/common/widgets/list/p_symbol_tile.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/common/widgets/textfields/order_text_fields/p_price_textfield.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_state.dart';
import 'package:piapiri_v2/core/bloc/time/time_bloc.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/order_status_enum.dart';
import 'package:piapiri_v2/core/model/order_type_enum.dart';
import 'package:piapiri_v2/core/model/order_validity_enum.dart';
import 'package:piapiri_v2/core/model/position_model.dart';
import 'package:piapiri_v2/core/model/symbol_type_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/transaction_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

import '../bloc/orders_event.dart';

class OrderUpdatePage extends StatefulWidget {
  final TransactionModel selectedOrder;
  const OrderUpdatePage({
    super.key,
    required this.selectedOrder,
  });

  @override
  State<OrderUpdatePage> createState() => _OrderUpdatePageState();
}

class _OrderUpdatePageState extends State<OrderUpdatePage> {
  late final SymbolBloc _symbolBloc;
  late final OrdersBloc _ordersBloc;
  final SymbolSearchBloc _symbolSearchBloc = getIt<SymbolSearchBloc>();
  String? _symbolName = '';
  MarketListModel? _subscribedSymbol;
  final TextEditingController _orderUnitTC = TextEditingController();
  final TextEditingController _orderPriceTC = TextEditingController(text: '0');
  final TextEditingController _orderStopLossTC = TextEditingController();
  final TextEditingController _orderTakeProfitTC = TextEditingController();
  double? _tradeLimit;
  final FocusNode _focusNodeUnit = FocusNode(canRequestFocus: false);
  final FocusNode _focusNodePrice = FocusNode(canRequestFocus: false);
  final FocusNode _focusNodeCondition = FocusNode(canRequestFocus: false);
  final FocusNode _focusNodeStopLoss = FocusNode(canRequestFocus: false);
  final FocusNode _focusNodeTakeProfit = FocusNode(canRequestFocus: false);
  final ScrollController _scrollController = ScrollController();
  double _amount = 0;
  MarketListModel? _conditionSubscribedSymbol;
  double? _conditionPrice;
  String? _conditionType;
  double? _stopLossPrice;
  double? _takeProfitPrice;
  DateTime? _validityDate;
  DateTime? _initialValidityDate;
  bool _isLoading = false;
  int? _sellableUnit;
  final AssetsBloc _assetsBloc = getIt<AssetsBloc>();

  @override
  void initState() {
    _symbolBloc = getIt<SymbolBloc>();
    _ordersBloc = getIt<OrdersBloc>();

    if (widget.selectedOrder.orderStatus == 'PARTIALLYFILLED') {
      _orderUnitTC.text = '${(widget.selectedOrder.remainingUnit ?? 0).toInt()}';
    } else {
      _orderUnitTC.text = '${widget.selectedOrder.orderUnit?.toInt() ?? 0}';
    }

    _orderPriceTC.text = MoneyUtils().readableMoney(
      widget.selectedOrder.orderPrice ?? widget.selectedOrder.price ?? 0,
    );

    _amount = MoneyUtils().fromReadableMoney(_orderPriceTC.text) *
        MoneyUtils().fromReadableMoney(_orderUnitTC.text.isEmpty ? '0' : _orderUnitTC.text);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.selectedOrder.transactionExtId?.isNotEmpty == true) {
        _ordersBloc.add(
          GetPeriodicOrdersEvent(
            accountId: widget.selectedOrder.accountExtId ?? '',
            transactionExidId: widget.selectedOrder.transactionExtId!,
            successCallback: (periodEndDate) {
              setState(() {
                DateTime validityDate = periodEndDate ?? _getDefaultValidity();
                _validityDate = validityDate;
                _initialValidityDate = validityDate;
              });
            },
            onErrorCallBack: () {
              setState(() {
                DateTime validityDate = _getDefaultValidity();
                _validityDate = validityDate;
                _initialValidityDate = validityDate;
              });
            },
          ),
        );
      }
    });
    _initFunction();
    super.initState();
  }

  DateTime _getDefaultValidity() {
    return DateTimeUtils().checkStopLossDate(
      getIt<TimeBloc>().state.mxTime?.timestamp != null
          ? DateTime.fromMicrosecondsSinceEpoch(
              getIt<TimeBloc>().state.mxTime!.timestamp.toInt(),
            )
          : DateTime.now(),
    );
  }

  void _initFunction() async {
    _symbolName = widget.selectedOrder.symbol ?? widget.selectedOrder.asset ?? '';

    if (widget.selectedOrder.tpPrice != null) {
      _takeProfitPrice = widget.selectedOrder.tpPrice ?? 0;
    }

    if (widget.selectedOrder.slPrice != null) {
      _stopLossPrice = widget.selectedOrder.slPrice ?? 0;
    }

    _symbolBloc.add(
      SymbolSubOneTopicEvent(
        symbol: _symbolName ?? '',
        callback: (symbol) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => setState(() => _subscribedSymbol = symbol),
          );

          if (symbol.type == SymbolTypes.option.name || symbol.type == SymbolTypes.future.name) {
            _ordersBloc.add(
              GetCollateralInfoEvent(
                callback: (limit) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => setState(() => _tradeLimit = limit?.usableColl),
                  );
                },
              ),
            );
          } else {
            _ordersBloc.add(
              GetTradeLimitEvent(
                symbolName: _symbolName ?? '',
                symbolType: symbol.type,
                accountId: widget.selectedOrder.accountExtId ?? '100',
                callback: (limit) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => setState(() => _tradeLimit = limit),
                  );
                },
              ),
            );
          }

          // satış emri ise position listesini çekiyoruz
          if (widget.selectedOrder.sideType == 2) {
            _symbolSearchBloc.add(
              GetPostitionListEvent(
                accountId: widget.selectedOrder.accountExtId ?? '100',
                callback: (positionList) {
                  PositionModel? positionModel = positionList.firstWhereOrNull(
                    (element) =>
                        element.symbolName ==
                        (getIt<AppInfoBloc>().state.symbolSuffixList.any((e) => e.name == widget.selectedOrder.symbol)
                            ? getIt<AppInfoBloc>()
                                .state
                                .symbolSuffixList
                                .firstWhere(
                                  (e) => e.name == widget.selectedOrder.symbol,
                                )
                                .nameWithSuffix
                            : widget.selectedOrder.symbol ?? widget.selectedOrder.asset ?? ''),
                  );

                  if (positionModel != null) {
                    _sellableUnit = (widget.selectedOrder.orderUnit?.toInt() ?? 0) + positionModel.qty.toInt();
                  } else {
                    _sellableUnit = (widget.selectedOrder.orderUnit?.toInt() ?? 0) + 0;
                  }

                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => setState(() {}),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isConditionOrder =
        widget.selectedOrder.conditionSymbol != null && widget.selectedOrder.conditionSymbol!.isNotEmpty;

    bool isTakeProfitStopLoss = widget.selectedOrder.slPrice != null &&
        widget.selectedOrder.slPrice != 0 &&
        widget.selectedOrder.tpPrice != null &&
        widget.selectedOrder.tpPrice != 0;

    bool isLimitOrder = widget.selectedOrder.transactionType == OrderTypeEnum.limit.value ||
        widget.selectedOrder.transactionType == OrderTypeEnum.reserve.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: OrderDetailStyledWidget(
            text: 'order_update_alert',
            selectedOrder: widget.selectedOrder,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            vertical: Grid.m,
          ),
          child: PDivider(),
        ),
        widget.selectedOrder.symbolType == SymbolTypeEnum.mfList
            ? const SizedBox.shrink()
            : PBlocConsumer<SymbolBloc, SymbolState>(
                bloc: _symbolBloc,
                listenWhen: (previous, current) {
                  return current.isUpdated &&
                      _subscribedSymbol != null &&
                      current.watchingItems.map((e) => e.symbolCode).toList().contains(
                            _subscribedSymbol!.symbolCode,
                          );
                },
                listener: (BuildContext context, SymbolState state) {
                  MarketListModel? newModel = state.watchingItems.firstWhereOrNull(
                    (element) => element.symbolCode == _subscribedSymbol!.symbolCode,
                  );
                  if (newModel == null) return;
                  setState(() {
                    _subscribedSymbol = newModel;
                  });
                },
                builder: (context, state) {
                  if (_subscribedSymbol == null) {
                    return const PLoading();
                  }

                  return Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.sizeOf(context).height * .75,
                    ),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PSymbolTile(
                            key: ValueKey(widget.selectedOrder.symbol),
                            variant: PSymbolVariant.equityTab,
                            symbolName: widget.selectedOrder.symbolType == SymbolTypeEnum.mfList ||
                                    widget.selectedOrder.symbolType == SymbolTypeEnum.wrList ||
                                    widget.selectedOrder.symbolType == SymbolTypeEnum.viopList
                                ? widget.selectedOrder.underlying
                                : widget.selectedOrder.symbol ?? '',
                            symbolType: widget.selectedOrder.symbolType == SymbolTypeEnum.mfList
                                ? SymbolTypes.fund
                                : SymbolTypes.equity,
                            title: widget.selectedOrder.symbol,
                            subTitle: _subscribedSymbol?.description,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: Grid.s,
                            ),
                            child: PDivider(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OrderDetailPriceTile(
                                title: L10n.tr('son_fiyat'),
                                content: MoneyUtils().readableMoney(
                                  _subscribedSymbol?.last ?? 0,
                                  pattern: widget.selectedOrder.decimalCount == 0
                                      ? '#,##0'
                                      : '#,##0.${'0' * (widget.selectedOrder.decimalCount ?? 2)}',
                                ),
                              ),
                              InkWell(
                                onTap: () => setState(() {
                                  final buyPrice = _subscribedSymbol != null
                                      ? MoneyUtils().getPrice(_subscribedSymbol!, OrderActionTypeEnum.buy)
                                      : _subscribedSymbol?.bid ?? 0;
                                  _orderPriceTC.text = MoneyUtils().readableMoney(buyPrice);
                                  if (isLimitOrder) {
                                    _amount = MoneyUtils()
                                            .fromReadableMoney(_orderPriceTC.text.isEmpty ? '0' : _orderPriceTC.text) *
                                        MoneyUtils()
                                            .fromReadableMoney(_orderUnitTC.text.isEmpty ? '0' : _orderUnitTC.text);
                                  }
                                }),
                                child: OrderDetailPriceTile(
                                  title: L10n.tr('market_buy_price'),
                                  content: MoneyUtils().readableMoney(
                                    _subscribedSymbol != null
                                        ? MoneyUtils().getPrice(_subscribedSymbol!, OrderActionTypeEnum.buy)
                                        : _subscribedSymbol?.bid ?? 0,
                                    pattern: widget.selectedOrder.decimalCount == 0
                                        ? '#,##0'
                                        : '#,##0.${'0' * (widget.selectedOrder.decimalCount ?? 2)}',
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => setState(() {
                                  final sellPrice = _subscribedSymbol != null
                                      ? MoneyUtils().getPrice(_subscribedSymbol!, OrderActionTypeEnum.sell)
                                      : _subscribedSymbol?.ask ?? 0;
                                  _orderPriceTC.text = MoneyUtils().readableMoney(sellPrice);
                                  if (isLimitOrder) {
                                    _amount = MoneyUtils()
                                            .fromReadableMoney(_orderPriceTC.text.isEmpty ? '0' : _orderPriceTC.text) *
                                        MoneyUtils()
                                            .fromReadableMoney(_orderUnitTC.text.isEmpty ? '0' : _orderUnitTC.text);
                                  }
                                }),
                                child: OrderDetailPriceTile(
                                  title: L10n.tr('eurobond_sellprice'),
                                  content: MoneyUtils().readableMoney(
                                    _subscribedSymbol != null
                                        ? MoneyUtils().getPrice(_subscribedSymbol!, OrderActionTypeEnum.sell)
                                        : _subscribedSymbol?.ask ?? 0,
                                    pattern: widget.selectedOrder.decimalCount == 0
                                        ? '#,##0'
                                        : '#,##0.${'0' * (widget.selectedOrder.decimalCount ?? 2)}',
                                  ),
                                ),
                              ),
                              OrderDetailPriceTile(
                                title: L10n.tr('equity_bist_difference2'),
                                content: '',
                                textWidget: DiffPercentage(percentage: (_subscribedSymbol?.differencePercent ?? 0)),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: Grid.l,
                          ),
                          Text(
                            L10n.tr(
                              OrderTypeEnum.values
                                      .firstWhereOrNull(
                                        (element) => element.value == widget.selectedOrder.transactionType,
                                      )
                                      ?.value ??
                                  '-',
                            ),
                            style: context.pAppStyle.labelMed14primary,
                          ),
                          const SizedBox(
                            height: Grid.s,
                          ),
                          if (isLimitOrder) ...[
                            PPriceTextfield(
                              controller: _orderPriceTC,
                              title: L10n.tr('limit_price'),
                              action: OrderActionTypeEnum.buy,
                              focusNode: _focusNodePrice,
                              marketListModel: _subscribedSymbol,
                              onPriceChanged: (price) {
                                setState(() {
                                  _amount = MoneyUtils().fromReadableMoney(_orderPriceTC.text) *
                                      MoneyUtils()
                                          .fromReadableMoney(_orderUnitTC.text.isEmpty ? '0' : _orderUnitTC.text);
                                  if (isTakeProfitStopLoss) {
                                    /// limit fiyatı kar al dan fazla ise veya zarar durdur dan küçük ise kullancıya uyarı çıkardığımız yer.
                                    _checkTPSLPrice();
                                  }
                                });
                              },
                            ),
                            const SizedBox(
                              height: Grid.s,
                            ),
                          ],
                          _unitWidget(
                            isLimitOrder,
                          ),
                          const SizedBox(
                            height: Grid.s,
                          ),

                          /// Tutar gosterilen alan yetersiz limitte hata verir
                          ConsistentEquivalence(
                            title: L10n.tr('estimated_amount'),
                            titleValue:
                                '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(widget.selectedOrder.symbolType == SymbolTypeEnum.viopList ? _amount * (widget.selectedOrder.multiplier ?? 0) : _amount)}',
                          ),
                          if (isConditionOrder) ...[
                            const SizedBox(
                              height: Grid.l,
                            ),
                            Text(
                              L10n.tr('advanced_order_features'),
                              style: context.pAppStyle.labelMed14primary,
                            ),
                            const SizedBox(
                              height: Grid.s,
                            ),
                            ConditionSelector(
                              symbolCode:
                                  _conditionSubscribedSymbol?.symbolCode ?? widget.selectedOrder.conditionSymbol,
                              priceFocusNode: _focusNodeCondition,
                              initialConditionPrice: widget.selectedOrder.conditionPrice ?? 0,
                              initialConditionType: widget.selectedOrder.conditionType,
                              action: widget.selectedOrder.sideType == 1
                                  ? OrderActionTypeEnum.buy
                                  : OrderActionTypeEnum.sell,
                              onTapPrice: (fieldKey) => KeyboardUtils().scrollOnFocus(
                                context,
                                fieldKey,
                                _scrollController,
                              ),
                              fieldColor: context.pColorScheme.lightLow,
                              equityGroupCode: widget.selectedOrder.equityGroupCode ?? '',
                              onChange: ({conditionPrice, conditionType, selectedSymbol}) {
                                if (conditionPrice != null) _conditionPrice = conditionPrice;
                                if (conditionType != null) _conditionType = conditionType;
                                if (selectedSymbol != null) _conditionSubscribedSymbol = selectedSymbol;
                                setState(() {});
                              },
                            ),
                          ] else if (isTakeProfitStopLoss) ...[
                            const SizedBox(
                              height: Grid.l,
                            ),
                            Text(
                              L10n.tr('advanced_order_features'),
                              style: context.pAppStyle.labelMed14primary,
                            ),
                            const SizedBox(
                              height: Grid.s,
                            ),
                            _validityDate == null
                                ? const PLoading()
                                : TakeProfitStopLossSelector(
                                    marketListModel: _subscribedSymbol,
                                    lossController: _orderStopLossTC,
                                    profitController: _orderTakeProfitTC,
                                    slFocusNode: _focusNodeStopLoss,
                                    tpFocusNode: _focusNodeTakeProfit,
                                    initialSlPrice: widget.selectedOrder.slPrice,
                                    initialTpPrice: widget.selectedOrder.tpPrice,
                                    showValidityDate: true,
                                    initialValidityDate: _validityDate!,
                                    currentPrice: MoneyUtils().fromReadableMoney(_orderPriceTC.text),
                                    transactionExtId: widget.selectedOrder.transactionExtId,
                                    accountId: widget.selectedOrder.accountExtId ?? '',
                                    onTapPrice: (fieldKey) => KeyboardUtils().scrollOnFocus(
                                      context,
                                      fieldKey,
                                      _scrollController,
                                    ),
                                    action: widget.selectedOrder.sideType == 1
                                        ? OrderActionTypeEnum.buy
                                        : OrderActionTypeEnum.sell,
                                    onChange: ({stopLoss, takeProfit, validityDate}) {
                                      if (stopLoss != null) _stopLossPrice = stopLoss;
                                      if (takeProfit != null) _takeProfitPrice = takeProfit;
                                      if (validityDate != null) _validityDate = validityDate;

                                      double limitPrice = MoneyUtils().fromReadableMoney(_orderPriceTC.text);

                                      //Alış Emri için
                                      if (widget.selectedOrder.sideType == 1) {
                                        /// girilen kar al değeri limit fiyattan düşükse kullanıcıya uyarı gösteriyoruz.
                                        if (limitPrice > (_takeProfitPrice ?? 0)) {
                                          PBottomSheet.showError(
                                            context,
                                            content: L10n.tr('tpsl_limit_up_alert'),
                                          );
                                          return;
                                        }

                                        /// girilen zarar durdur değeri limit fiyattan büyükse kullanıcıya uyarı gösteriyoruz.
                                        if (limitPrice < (_stopLossPrice ?? 0)) {
                                          PBottomSheet.showError(
                                            context,
                                            content: L10n.tr('tpsl_limit_down_alert'),
                                          );
                                          return;
                                        }
                                      } else {
                                        //Satış Emri için

                                        if (limitPrice < (_takeProfitPrice ?? 0)) {
                                          PBottomSheet.showError(
                                            context,
                                            content: L10n.tr('tpsl_limit_sell_down_alert'),
                                          );
                                          return;
                                        }

                                        /// girilen zarar durdur değeri limit fiyattan büyükse kullanıcıya uyarı gösteriyoruz.
                                        if (limitPrice > (_stopLossPrice ?? 0)) {
                                          PBottomSheet.showError(
                                            context,
                                            content: L10n.tr('tpsl_limit_sell_up_alert'),
                                          );
                                          return;
                                        }
                                      }
                                    },
                                    onTPSLChanged: ({takeProfit, stopLoss}) {
                                      setState(() {
                                        if (takeProfit != null) {
                                          _takeProfitPrice = takeProfit;
                                        }
                                        if (stopLoss != null) {
                                          _stopLossPrice = stopLoss;
                                        }
                                      });
                                    },
                                  ),
                          ],
                          const SizedBox(
                            height: Grid.m,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: POutlinedButton(
                                  text: L10n.tr('vazgec'),
                                  fillParentWidth: true,
                                  sizeType: PButtonSize.medium,
                                  onPressed: _isLoading
                                      ? null
                                      : () {
                                          router.maybePop();
                                        },
                                ),
                              ),
                              const SizedBox(
                                width: Grid.s,
                              ),
                              Expanded(
                                child: PButton(
                                  text: L10n.tr('onayla'),
                                  fillParentWidth: true,
                                  onPressed: _isLoading ||
                                          !_hasChanges() ||
                                          widget.selectedOrder.sideType == 2 && _sellableUnit == null
                                      ? null
                                      : () => _onTapApprove(
                                            isTakeProfitStopLoss,
                                            isConditionOrder,
                                            state,
                                            isLimitOrder,
                                          ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }

  bool _checkTPSLPrice() {
    double limitPrice = MoneyUtils().fromReadableMoney(_orderPriceTC.text);

    if (widget.selectedOrder.sideType == 1) {
      //Alış
      if (_takeProfitPrice != null && limitPrice > _takeProfitPrice!) {
        PBottomSheet.showError(
          context,
          content: L10n.tr('tpsl_limit_up_alert'),
        );
        return false;
      }

      if (_stopLossPrice != null && limitPrice < _stopLossPrice!) {
        PBottomSheet.showError(
          context,
          content: L10n.tr('tpsl_limit_down_alert'),
        );
        return false;
      }
    } else {
      //Satış
      if (_takeProfitPrice != null && limitPrice < _takeProfitPrice!) {
        PBottomSheet.showError(
          context,
          content: L10n.tr('tpsl_limit_sell_down_alert'),
        );
        return false;
      }

      if (_stopLossPrice != null && limitPrice > _stopLossPrice!) {
        PBottomSheet.showError(
          context,
          content: L10n.tr('tpsl_limit_sell_up_alert'),
        );
        return false;
      }
    }
    return true;
  }

  Widget _unitWidget(bool isLimitOrder) {
    int buyableUnit = 0;
    OrderTypeEnum orderType = OrderTypeEnum.values.firstWhere((e) => e.value == widget.selectedOrder.transactionType);
    bool isMarketOrMarketToLimit = orderType == OrderTypeEnum.market || orderType == OrderTypeEnum.marketToLimit;
    double price = isMarketOrMarketToLimit
        ? MoneyUtils().getPrice(
            _subscribedSymbol!,
            OrderActionTypeEnum.buy,
          )
        : widget.selectedOrder.orderPrice ?? 0;

    buyableUnit = CreateOrdersUtils().getBuyableUnit(
      symbol: _subscribedSymbol,
      action: widget.selectedOrder.sideType == 1 ? OrderActionTypeEnum.buy : OrderActionTypeEnum.sell,
      priceControllerText: _orderPriceTC.text,
      isMarketOrMarketToLimit: isMarketOrMarketToLimit,
      tradeLimit: (((widget.selectedOrder.orderUnit?.toInt() ?? 0) * price) + (_tradeLimit ?? 0)),
    );
    return PValueTextfieldWidget(
      controller: _orderUnitTC,
      title: L10n.tr('adet'),
      focusNode: _focusNodeUnit,
      keyboardType: TextInputType.number,
      inputFormatters: [
        AppInputFormatters.decimalFormatter(
          maxDigitAfterSeparator: 0,
        ),
      ],
      subTitle: widget.selectedOrder.symbolType == SymbolTypeEnum.viopList
          ? null
          : InkWell(
              onTap: () {
                setState(() {
                  // Alış emri ise
                  if (widget.selectedOrder.sideType == 1) {
                    _orderUnitTC.text = buyableUnit.toString();

                    if (isLimitOrder) {
                      _amount = buyableUnit * MoneyUtils().fromReadableMoney(_orderPriceTC.text);
                    } else {
                      _amount = buyableUnit *
                          MoneyUtils().getPrice(
                            _subscribedSymbol!,
                            OrderActionTypeEnum.buy,
                          );
                    }
                  } else {
                    // Satış emri ise
                    _orderUnitTC.text = _sellableUnit.toString();

                    if (isLimitOrder) {
                      _amount = (_sellableUnit ?? 0) * MoneyUtils().fromReadableMoney(_orderPriceTC.text);
                    } else {
                      _amount = (_sellableUnit ?? 0) *
                          MoneyUtils().getPrice(
                            _subscribedSymbol!,
                            OrderActionTypeEnum.sell,
                          );
                    }
                  }
                });
              },
              child: Shimmerize(
                enabled: widget.selectedOrder.sideType == 2 && _sellableUnit == null,
                child: Text(
                  widget.selectedOrder.sideType == 1
                      ? '${L10n.tr('alinabilir_adet')}: ${MoneyUtils().readableMoney(
                          isLimitOrder ? buyableUnit : buyableUnit,
                          pattern: '#,##0',
                        )}'
                      : '${L10n.tr('satilabilir_adet')}: $_sellableUnit',
                  style: context.pAppStyle.labelMed12textSecondary,
                ),
              ),
            ),
      onTapPrice: () {
        if (MoneyUtils().fromReadableMoney(_orderUnitTC.text) == 0) {
          _orderUnitTC.text = '';
        }
      },
      onChanged: (deger) {
        setState(() {
          _orderUnitTC.text = deger.toString();

          if (isLimitOrder) {
            _amount = MoneyUtils().fromReadableMoney(deger) * MoneyUtils().fromReadableMoney(_orderPriceTC.text);
          } else {
            _amount = MoneyUtils().fromReadableMoney(deger) * _subscribedSymbol!.last;
          }
        });
      },
      onSubmitted: (value) {
        setState(() {
          _orderUnitTC.text = MoneyUtils().fromReadableMoney(value).toInt().toString();
          FocusScope.of(context).unfocus();
        });
      },
    );
  }

  _chainOrderUpdate() async {
    _ordersBloc.add(
      UpdateChainOrderEvent(
        accountExtId: widget.selectedOrder.accountExtId ?? '',
        chainNo: widget.selectedOrder.chainNo ?? 0,
        transactionExtId: widget.selectedOrder.transactionExtId ?? '',
        equityName: _symbolName ?? '',
        debitCredit: widget.selectedOrder.sideType == 1 ? 'CREDIT' : 'DEBIT',
        session: widget.selectedOrder.session ?? 0,
        price: MoneyUtils().fromReadableMoney(_orderPriceTC.text),
        units: _stringToUnit(),
        transactionTypeName: _stringTransactionTypeName(widget.selectedOrder.transactionType!),
        orderValidity: double.parse(widget.selectedOrder.validity!).toStringAsFixed(0),
        onSuccess: (successMessage) async {
          _ordersBloc.add(
            RefreshOrdersEvent(
              account: _ordersBloc.state.selectedAccount,
              symbolType: _ordersBloc.state.selectedSymbolType,
              orderStatus: OrderStatusEnum.pending,
              refreshData: true,
              isLoading: true,
              onFetched: () async {
                router.push(
                  InfoRoute(
                    variant: InfoVariant.success,
                    message: L10n.tr(successMessage),
                    buttonText: L10n.tr('emirlerime_don'),
                    onTapButton: () {
                      router.popUntilRoot();
                    },
                  ),
                );
                await router.maybePop();
              },
            ),
          );
        },
        onFailed: () => setState(
          () => _isLoading = false,
        ),
      ),
    );
  }

  int _stringToUnit() {
    return _orderUnitTC.text.isEmpty ? 1 : MoneyUtils().fromReadableMoney(_orderUnitTC.text).toInt();
  }

  int _stringTransactionTypeName(String transactionType) {
    switch (transactionType) {
      case 'MTL':
        return 6;
      case 'MKT':
        return 5;
      case 'LOT':
        return 0;
      default:
        return 0;
    }
  }

  _viopOrderUpdate() async {
    setState(
      () => _isLoading = true,
    );
    _ordersBloc.add(
      UpdateViopOrderEvent(
        transactionId: widget.selectedOrder.transactionId ?? '',
        accountId: widget.selectedOrder.accountExtId ?? '',
        price: MoneyUtils().fromReadableMoney(_orderPriceTC.text),
        endingDate: widget.selectedOrder.endingMarketSessionDate.toString(),
        units: MoneyUtils().fromReadableMoney(
          _orderUnitTC.text,
        ),
        orderType: widget.selectedOrder.orderType ?? '',
        timeInForce: widget.selectedOrder.validity ?? '',
        callback: (response) async {
          setState(
            () => _isLoading = false,
          );

          router.push(
            InfoRoute(
              variant: InfoVariant.success,
              message: L10n.tr('order_update_success'),
              buttonText: L10n.tr('emirlerime_don'),
              onTapButton: () {
                router.popUntilRoot();
              },
            ),
          );
          _assetsBloc.add(
            GetOverallSummaryEvent(
              accountId: '',
              isConsolidated: true,
              allAccounts: true,
              includeCashFlow: true,
              includeCreditDetail: true,
              calculateTradeLimit: true,
            ),
          );
        },
        onFailed: () => setState(
          () => _isLoading = false,
        ),
      ),
    );
  }

  _conditionOrderUpdate() async {
    _ordersBloc.add(
      CreateConditionOrderEvent(
        transactionId: widget.selectedOrder.transactionId.toString(),
        symbolName: _symbolName ?? '',
        units: MoneyUtils().fromReadableMoney(_orderUnitTC.text).toInt(),
        orderActionType: widget.selectedOrder.sideType == 1 ? OrderActionTypeEnum.buy : OrderActionTypeEnum.sell,
        orderType: OrderTypeEnum.values.firstWhere((element) => element.value == widget.selectedOrder.transactionType),
        orderValidity: OrderValidityEnum.values
            .firstWhere((element) => element.value == double.parse(widget.selectedOrder.validity!).toInt().toString()),
        account: widget.selectedOrder.accountExtId ?? '',
        price: MoneyUtils().fromReadableMoney(
          _orderPriceTC.text,
        ),
        conditionSymbolCode: _conditionSubscribedSymbol?.symbolCode ?? '',
        conditionType: _conditionType!,
        conditionPrice: _conditionPrice!,
        callback: (String message, bool isError) async {
          if (isError) {
            setState(() {
              _isLoading = false;
            });
            return PBottomSheet.show(
              context,
              title: L10n.tr('error'),
              child: Column(
                children: [
                  const SizedBox(
                    height: Grid.m,
                  ),
                  SvgPicture.asset(
                    ImagesPath.alert_circle,
                    height: 52,
                    width: 52,
                    colorFilter: ColorFilter.mode(
                      context.pColorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(
                    height: Grid.m,
                  ),
                  Text(
                    message,
                    style: context.pAppStyle.labelReg16textPrimary,
                  ),
                  const SizedBox(
                    height: Grid.m,
                  )
                ],
              ),
            );
          }

          router.push(
            InfoRoute(
              variant: InfoVariant.success,
              message: message,
              buttonText: L10n.tr('emirlerime_don'),
              onTapButton: () {
                router.popUntilRoot();
              },
            ),
          );
        },
      ),
    );
  }

  _orderUpdate(
    bool isTakeProfitStopLoss,
  ) async {
    bool isSuccess = !isTakeProfitStopLoss ? true : _checkTPSLPrice();
    if (!isSuccess) {
      if (_isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }
    _ordersBloc.add(
      ReplaceOrderEvent(
        transactionId: widget.selectedOrder.transactionId.toString(),
        oldPrice: widget.selectedOrder.orderPrice ?? widget.selectedOrder.price ?? 0,
        oldUnit: widget.selectedOrder.remainingUnit?.toInt() ??
            widget.selectedOrder.orderUnit?.toInt() ??
            widget.selectedOrder.units?.toInt() ??
            0,
        newPrice: MoneyUtils().fromReadableMoney(_orderPriceTC.text),
        newUnit: _stringToUnit(),
        stopLossPrice: isTakeProfitStopLoss ? _stopLossPrice : null,
        takeProfitPrice: isTakeProfitStopLoss ? _takeProfitPrice : null,
        periodicTransactionId: widget.selectedOrder.periodicTransactionId,
        timeInForce: double.parse(widget.selectedOrder.validity ?? '0.0').toInt().toString(),
        periodEndingDate: isTakeProfitStopLoss ? _validityDate : null,
        errorCallback: (errorMessage) async {
          setState(() {
            _isLoading = false;
          });
        },
        successCallback: (successMessage) async {
          _ordersBloc.add(
            RefreshOrdersEvent(
              account: _ordersBloc.state.selectedAccount,
              symbolType: _ordersBloc.state.selectedSymbolType,
              orderStatus: OrderStatusEnum.pending,
              refreshData: true,
              isLoading: true,
              onFetched: () async {
                await router.maybePop();
                return router.popAndPush(
                  InfoRoute(
                    variant: InfoVariant.success,
                    message: L10n.tr('order_update_success'),
                    buttonText: L10n.tr('emirlerime_don'),
                    onTapButton: () {
                      router.popUntilRoot();
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future _onTapApprove(
    bool isTakeProfitStopLoss,
    bool isConditionOrder,
    SymbolState state,
    bool isLimitOrder,
  ) async {
    bool isViop = widget.selectedOrder.symbolType == SymbolTypeEnum.viopList;

    double unit = MoneyUtils().fromReadableMoney(_orderUnitTC.text);
    //double price = MoneyUtils().fromReadableMoney(_orderPriceTC.text);
    int buyableUnit = 0;

    bool isMarketOrMarketToLimit = widget.selectedOrder.orderPrice == null;
    double price = isMarketOrMarketToLimit
        ? MoneyUtils().getPrice(
            _subscribedSymbol!,
            OrderActionTypeEnum.buy,
          )
        : widget.selectedOrder.orderPrice ?? 0;

    buyableUnit = CreateOrdersUtils().getBuyableUnit(
      symbol: _subscribedSymbol,
      action: widget.selectedOrder.sideType == 1 ? OrderActionTypeEnum.buy : OrderActionTypeEnum.sell,
      priceControllerText: _orderPriceTC.text,
      isMarketOrMarketToLimit: isMarketOrMarketToLimit,
      tradeLimit: ((widget.selectedOrder.orderUnit?.toInt() ?? 0) * price + (_tradeLimit ?? 0)),
    );

    /// Al/Sat sayfasında olduğu gibi vioplarda alınabilir adet hesaplanmadığı için bu kontrol eklendi.
    if (!isViop) {
      if (widget.selectedOrder.sideType == 1 && unit > buyableUnit) {
        return PBottomSheet.showError(
          context,
          content: L10n.tr(
            'max_unit_warning',
            args: [
              (MoneyUtils().readableMoney(
                buyableUnit,
                pattern: '###,###.###',
              ))
            ],
          ),
        );
      }
    }

    if (widget.selectedOrder.sideType == 2 && unit > _sellableUnit! && !isViop) {
      return PBottomSheet.showError(
        context,
        content: L10n.tr(
          'max_unit_warning',
          args: [
            (MoneyUtils().readableMoney(
              _sellableUnit!,
              pattern: '###,###.###',
            ))
          ],
        ),
      );
    }

    setState(() {
      _isLoading = true;
    });
    if (widget.selectedOrder.parentTransactionId != null && widget.selectedOrder.chainNo != 0) {
      await _chainOrderUpdate();
    } else if (widget.selectedOrder.symbolType == SymbolTypeEnum.viopList) {
      await _viopOrderUpdate();
    } else if (isConditionOrder) {
      await _conditionOrderUpdate();
    } else {
      await _orderUpdate(
        isTakeProfitStopLoss,
      );
    }
  }

  bool _hasChanges() {
    double? unit = widget.selectedOrder.orderUnit != null ? MoneyUtils().fromReadableMoney(_orderUnitTC.text) : null;
    double? price = widget.selectedOrder.orderPrice != null ? MoneyUtils().fromReadableMoney(_orderPriceTC.text) : null;
    double? stopPrice =
        widget.selectedOrder.slPrice != null ? MoneyUtils().fromReadableMoney(_orderStopLossTC.text) : null;
    double? takePrice =
        widget.selectedOrder.tpPrice != null ? MoneyUtils().fromReadableMoney(_orderTakeProfitTC.text) : null;

    if (unit != null && unit != 0 && unit != widget.selectedOrder.orderUnit) return true;
    if (price != null && price != 0 && price != widget.selectedOrder.orderPrice) return true;
    if (stopPrice != null && stopPrice != widget.selectedOrder.slPrice) return true;
    if (takePrice != null && takePrice != widget.selectedOrder.tpPrice) return true;
    if (_validityDate != null &&
        _initialValidityDate != null &&
        !DateTimeUtils().isSameDay(_initialValidityDate!, _validityDate!)) {
      return true;
    }

    if (_conditionPrice != null && _conditionPrice != (widget.selectedOrder.conditionPrice ?? 0)) return true;
    if (_conditionSubscribedSymbol?.symbolCode != null &&
        _conditionSubscribedSymbol?.symbolCode != widget.selectedOrder.conditionSymbol) {
      return true;
    }
    return false;
  }
}
