import 'package:collection/collection.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/assets/model/us_capra_summary_model.dart';
import 'package:piapiri_v2/app/create_us_order/bloc/create_us_orders_bloc.dart';
import 'package:piapiri_v2/app/create_us_order/bloc/create_us_orders_event.dart';
import 'package:piapiri_v2/app/create_us_order/bloc/create_us_orders_state.dart';
import 'package:piapiri_v2/app/create_us_order/create_us_orders_utils.dart';
import 'package:piapiri_v2/app/create_us_order/widgets/consistent_equivalence.dart';
import 'package:piapiri_v2/app/create_us_order/widgets/us_inputs.dart';
import 'package:piapiri_v2/app/info/model/info_variant.dart';
import 'package:piapiri_v2/app/orders/model/american_order_type_enum.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/us_symbol_search_selected.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/insufficient_limit_widget.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/order_status_enum.dart';
import 'package:piapiri_v2/core/model/transaction_model.dart';
import 'package:piapiri_v2/core/model/us_symbol_snapshot.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class OrderUsUpdate extends StatefulWidget {
  final TransactionModel selectedOrder;
  final OrderStatusEnum orderStatus;
  const OrderUsUpdate({
    super.key,
    required this.selectedOrder,
    required this.orderStatus,
  });

  @override
  State<OrderUsUpdate> createState() => _OrderUsUpdateState();
}

class _OrderUsUpdateState extends State<OrderUsUpdate> {
  final UsEquityBloc _usEquityBloc = getIt<UsEquityBloc>();
  final CreateUsOrdersBloc _createUsOrdersBloc = getIt<CreateUsOrdersBloc>();
  final TextEditingController _unitController = TextEditingController(text: '0');
  final TextEditingController _amountController = TextEditingController(text: '0');
  final TextEditingController _priceController = TextEditingController(text: MoneyUtils().readableMoney(0));
  final TextEditingController _stopPriceController = TextEditingController(text: MoneyUtils().readableMoney(0));
  UsSymbolSnapshot? _symbol;
  OrderActionTypeEnum _action = OrderActionTypeEnum.buy;
  late AmericanOrderTypeEnum _orderType;
  double _amount = 0;
  bool _fractionable = false;
  bool _stopListening = false;
  double _tradeLimit = 0;
  num _sellableUnit = 0;
  bool _isMarket = true;
  late double _comission;
  bool isLoading = true;

  bool _isQuantitative = true;

  @override
  initState() {
    super.initState();
    _symbol = UsSymbolSnapshot(ticker: widget.selectedOrder.symbol!);
    _orderType =
        AmericanOrderTypeEnum.values.firstWhereOrNull((element) => element.value == widget.selectedOrder.orderType) ??
            AmericanOrderTypeEnum.market;
    _isMarket = _orderType == AmericanOrderTypeEnum.market || _orderType == AmericanOrderTypeEnum.stop;
    _action = OrderActionTypeEnum.values.firstWhere((e) => e.name == widget.selectedOrder.transactionType);
    if (_isMarket && _action == OrderActionTypeEnum.buy) {
      _isQuantitative = false;
    }
    _fractionable = _usEquityBloc.state.fractionableSymbols.contains(widget.selectedOrder.symbol ?? '');
    _usEquityBloc.add(
      SubscribeSymbolEvent(
        symbolName: [widget.selectedOrder.symbol ?? ''],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PBlocConsumer<UsEquityBloc, UsEquityState>(
      bloc: _usEquityBloc,
      listenWhen: (previous, current) => CreateOrdersUtils().refreshWhen(
        previous,
        current,
        _symbol,
        _stopListening,
      ),
      buildWhen: (previous, current) => CreateOrdersUtils().refreshWhen(
        previous,
        current,
        _symbol,
        _stopListening,
      ),
      listener: (BuildContext context, UsEquityState state) {
        UsSymbolSnapshot? newModel =
            state.polygonWatchingItems.firstWhereOrNull((element) => element.ticker == widget.selectedOrder.symbol);
        if (newModel == null) return;
        setState(() {
          _symbol = newModel;
          if (_fractionable) {
            _fractionable = _orderType == AmericanOrderTypeEnum.market || _orderType == AmericanOrderTypeEnum.limit;
          }
          _setTextFields();
          _comission = CreateOrdersUtils().calculateCommission(MoneyUtils().fromReadableMoney(_unitController.text));

          if (_action == OrderActionTypeEnum.buy) {
            _createUsOrdersBloc.add(
              GetTradeLimitEvent(
                callback: (limit) {
                  _tradeLimit = limit +
                      double.parse(widget.selectedOrder.commission ?? '0') +
                      MoneyUtils().fromReadableMoney(_amountController.text);
                  isLoading = false;
                  setState(() {});
                },
              ),
            );
          } else {
            _createUsOrdersBloc.add(
              GetPositionListEvent(
                callback: (positionList) {
                  isLoading = false;
                  UsOverallSubItem? selectedPosition =
                      positionList.firstWhereOrNull((element) => element.symbol == _symbol!.ticker);
                  if (selectedPosition != null) {
                    num? orderUnit = widget.selectedOrder.orderUnit;
                    double price = (_isMarket ? _symbol?.fmv : widget.selectedOrder.orderPrice) ?? 0;
                    if (orderUnit == null && price != 0) {
                      orderUnit = (widget.selectedOrder.orderAmount! / price);
                    }

                    _sellableUnit = (selectedPosition.qtyAvailable ?? 0) + (orderUnit ?? 0);
                  }
                  setState(() {});
                },
              ),
            );
          }

          if (!_stopListening) {
            _stopListening = true;
          }
        });
      },
      builder: (context, symbolState) {
        if (isLoading) {
          return const Center(
            child: PLoading(),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UsSymbolSearchSelected(
              symbolName: widget.selectedOrder.symbol,
              searchable: false,
            ),
            const SizedBox(
              height: Grid.l,
            ),
            Text(
              L10n.tr(_orderType.localizationKey),
              style: context.pAppStyle.labelMed14textPrimary,
            ),
            const SizedBox(
              height: Grid.s,
            ),
            UsInputs(
              action: _action,
              orderType: _orderType,
              tradeLimit: _tradeLimit,
              sellableUnit: _sellableUnit,
              buyableUnit: _getBuyableUnit(
                _tradeLimit - _createUsOrdersBloc.state.minCommission,
                _fractionable,
              ),
              isQuantitative: _isQuantitative,
              fractionable: _fractionable,
              stopPriceController: _stopPriceController,
              priceController: _priceController,
              unitController: _unitController,
              amountController: _amountController,
              pattern: (_symbol?.fmv ?? 0) >= 1 ? '#,##0.00' : '#,##0.0000#####',
              onSegmentChanged: (isQuantitative) {
                setState(() {
                  _isQuantitative = isQuantitative;
                });
              },
              onStopPriceChanged: (price) {
                setState(() {});
              },
              onPriceChanged: (price) {
                if (_isQuantitative) {
                  double unit = MoneyUtils().fromReadableMoney(_unitController.text);
                  _amount = unit * price;
                  _amountController.text = MoneyUtils().readableMoney(
                    _amount,
                  );
                } else {
                  double rawUnit = (_amount / price);
                  int unitDecimal = getUnitDecimal(rawUnit);
                  _unitController.text = _fractionable
                      ? MoneyUtils().readableMoney((rawUnit * unitDecimal).floor() / unitDecimal,
                          pattern: CreateOrdersUtils()
                              .getUnitPattern(_fractionable, (rawUnit * unitDecimal).floor() / unitDecimal))
                      : MoneyUtils().readableMoney(rawUnit.floor(),
                          pattern: CreateOrdersUtils().getUnitPattern(_fractionable, rawUnit.floor()));
                }
                setState(() {});
              },
              onUnitChanged: (unit) {
                _comission = CreateOrdersUtils().calculateCommission(unit.toDouble());
                double price = _isMarket ? _symbol?.fmv ?? 0 : MoneyUtils().fromReadableMoney(_priceController.text);
                _amount = price * unit;
                _amountController.text = MoneyUtils().readableMoney(
                  _amount,
                );
                setState(() {});
              },
              onAmountChanged: (amount) {
                double price = _isMarket ? _symbol?.fmv ?? 0 : MoneyUtils().fromReadableMoney(_priceController.text);
                double rawUnit = (amount / price);
                int unitDecimal = getUnitDecimal(rawUnit);
                _unitController.text = _fractionable
                    ? MoneyUtils().readableMoney((rawUnit * unitDecimal).floor() / unitDecimal,
                        pattern: CreateOrdersUtils()
                            .getUnitPattern(_fractionable, (rawUnit * unitDecimal).floor() / unitDecimal))
                    : MoneyUtils().readableMoney(rawUnit.floor(),
                        pattern: CreateOrdersUtils().getUnitPattern(_fractionable, rawUnit.floor()));
                _comission = CreateOrdersUtils().calculateCommission(rawUnit);
                _amount = MoneyUtils().fromReadableMoney(_unitController.text) * price;
                if ((_amount - amount).abs() < 0.001) {
                  _amount = amount;
                }

                _amountController.text = MoneyUtils().readableMoney(
                  _amount,
                );
                setState(() {});
              },
            ),
            const SizedBox(
              height: Grid.l,
            ),

            /// Tutar gosterilen alan yetersiz limitte hata verir
            ConsistentEquivalence(
              title: _isQuantitative ? L10n.tr('estimated_amount') : L10n.tr('estimated_number_shares'),
              titleValue: _isQuantitative
                  ? '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(_amount)}'
                  : _unitController.text,
              subTitle: _action == OrderActionTypeEnum.buy
                  ? '${L10n.tr('american_stock_exchanges_collateral')}:'
                  : !_isQuantitative
                      ? '${L10n.tr('satilabilir_adet')}:'
                      : null,
              subTitleValue: _action == OrderActionTypeEnum.buy
                  ? '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(_tradeLimit)}'
                  : '$_sellableUnit',
              errorMessage: getConsistentEquivalenceError(_tradeLimit),
            ),
            const SizedBox(
              height: Grid.s,
            ),
            if (_amount != 0 && _amount + _comission > _tradeLimit && _action == OrderActionTypeEnum.buy) ...[
              const SizedBox(
                height: Grid.m,
              ),
              InsufficientLimitWidget(
                text: L10n.tr('deposit_usd_continue'),
                onTap: () {
                  router.push(const UsBalanceRoute());
                },
              ),
            ],
            const SizedBox(
              height: Grid.l,
            ),
            PBlocBuilder<CreateUsOrdersBloc, CreateUsOrdersState>(
                bloc: _createUsOrdersBloc,
                builder: (context, state) {
                  return OrderApprovementButtons(
                    onPressedApprove: _disableButton() || state.isLoading
                        ? null
                        : () async {
                            _createUsOrdersBloc.add(
                              DeleteOrderEvent(
                                id: widget.selectedOrder.id!,
                                callback: (isSuccess, message) {
                                  if (isSuccess) {
                                    _createUsOrdersBloc.add(
                                      CreateOrderEvent(
                                        symbolName: widget.selectedOrder.symbol!,
                                        quantity: widget.selectedOrder.orderUnit != null
                                            ? MoneyUtils().fromReadableMoney(_unitController.text).toString()
                                            : null,
                                        limitPrice: widget.selectedOrder.orderPrice != null
                                            ? MoneyUtils().fromReadableMoney(_priceController.text)
                                            : null,
                                        amount: widget.selectedOrder.orderAmount != null
                                            ? MoneyUtils().fromReadableMoney(_amountController.text)
                                            : null,
                                        stopPrice: widget.selectedOrder.stopPrice != null
                                            ? MoneyUtils().fromReadableMoney(_stopPriceController.text)
                                            : null,
                                        orderActionType: widget.selectedOrder.transactionType == 'buy'
                                            ? OrderActionTypeEnum.buy
                                            : OrderActionTypeEnum.sell,
                                        orderType: AmericanOrderTypeEnum.values.firstWhere(
                                          (element) => element.value == widget.selectedOrder.orderType,
                                        ),
                                        extendedHours: widget.selectedOrder.extendedHours ?? false,
                                        equityPrice: _isMarket ? _symbol?.fmv ?? 0 : null,
                                        callback: (isSuccess, message) async {
                                          if (isSuccess) {
                                            await router.replace(
                                              InfoRoute(
                                                variant: InfoVariant.success,
                                                message: L10n.tr('emir_guncelleme_talebiniz_iletilmistir'),
                                                buttonText: L10n.tr('emirlerime_don'),
                                                onTapButton: () => router.maybePop(),
                                              ),
                                            );
                                          } else {
                                            await router.push(
                                              InfoRoute(
                                                  variant: InfoVariant.failed,
                                                  message: L10n.tr(message ?? ''),
                                                  buttonText: L10n.tr('emirlerime_don'),
                                                  onTapButton: () => router.popUntilRoot(),
                                                  onPressedCloseIcon: () => router.maybePop()),
                                            );
                                          }
                                        },
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                  );
                }),
          ],
        );
      },
    );
  }

  String? getConsistentEquivalenceError(double tradeLimit) {
    if (_action == OrderActionTypeEnum.buy && _amount != 0 && _amount + _comission > tradeLimit) {
      return L10n.tr('insufficiant_trade_limit',
          args: ['${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(_amount + _comission)}']);
    }
    if (_action == OrderActionTypeEnum.sell &&
        MoneyUtils().fromReadableMoney(_unitController.text) > _sellableUnit &&
        !_isQuantitative) {
      return L10n.tr('insufficient_transaction_unit');
    }
    return null;
  }

  num _getBuyableUnit(double tradeLimit, bool fractionable) {
    if (_isMarket && (_symbol?.fmv == null || _symbol?.fmv == 0)) {
      return 0;
    }
    if (!_isMarket && (_priceController.text.isEmpty || MoneyUtils().fromReadableMoney(_priceController.text) == 0)) {
      return 0;
    }

    double price = _isMarket ? _symbol?.fmv ?? 0 : MoneyUtils().fromReadableMoney(_priceController.text);
    double rawUnit = (tradeLimit / price);

    if (fractionable) {
      int unitDecimal = getUnitDecimal(rawUnit);
      return ((rawUnit * unitDecimal).floor() / unitDecimal);
    } else {
      return rawUnit.floor();
    }
  }

  void _setTextFields() {
    if (widget.selectedOrder.orderPrice != null) {
      _priceController.text = MoneyUtils().readableMoney(
        widget.selectedOrder.orderPrice!,
        pattern: widget.selectedOrder.orderPrice! >= 1 ? '#,##0.00' : '#,##0.0000#####',
      );
    }
    if (widget.selectedOrder.orderUnit != null) {
      // Parcali bir emir degilse int olarak gosterilmeli
      _unitController.text = MoneyUtils().readableMoney(widget.selectedOrder.orderUnit!,
          pattern: MoneyUtils().getPatternByUnitDecimal(widget.selectedOrder.orderUnit!));
      _amount = widget.selectedOrder.orderUnit! *
          (widget.selectedOrder.orderPrice != null ? widget.selectedOrder.orderPrice! : _symbol?.fmv ?? 0);
      _amountController.text = MoneyUtils().readableMoney(
        _amount,
        pattern: _amount >= 1 ? '#,##0.00' : '#,##0.0000#####',
      );
    }

    if (widget.selectedOrder.orderAmount != null) {
      _amount = widget.selectedOrder.orderAmount!;
      _amountController.text = MoneyUtils().readableMoney(
        _amount,
        pattern: _amount >= 1 ? '#,##0.00' : '#,##0.0000#####',
      );
      num unit =
          _amount / (widget.selectedOrder.orderPrice != null ? widget.selectedOrder.orderPrice! : _symbol?.fmv ?? 0);
      _unitController.text = MoneyUtils().readableMoney(unit, pattern: MoneyUtils().getPatternByUnitDecimal(unit));
    }

    if (widget.selectedOrder.stopPrice != null) {
      _stopPriceController.text = MoneyUtils().readableMoney(
        widget.selectedOrder.stopPrice!,
        pattern: widget.selectedOrder.stopPrice! >= 1 ? '#,##0.00' : '#,##0.0000#####',
      );
    }
  }

  int getUnitDecimal(double rawUnit) {
    int unitDecimal = MoneyUtils().countDecimalPlaces(rawUnit);
    return int.parse('1${'0' * unitDecimal}');
  }

  bool _disableButton() {
    if (!hasChanges()) return true;

    num qty = MoneyUtils().fromReadableMoney(_unitController.text.isEmpty ? '0' : _unitController.text);

    if (_symbol == null) return true;

    if (qty == 0) return true;
    if (!_isMarket && (_priceController.text.isEmpty || MoneyUtils().fromReadableMoney(_priceController.text) == 0)) {
      return true;
    }
    if (_amount < 1) {
      return true;
    }

    if (_action == OrderActionTypeEnum.buy) {
      num currentBuyableUnit = _getBuyableUnit(
            _tradeLimit - _comission,
            _fractionable,
          ) +
          (widget.selectedOrder.orderUnit ?? 0);
      if (currentBuyableUnit == 0) return true;
      if (qty > currentBuyableUnit) return true;
    } else if (_action == OrderActionTypeEnum.sell) {
      if (_sellableUnit == 0) return true;
      if (qty > _sellableUnit) return true;
    }
    return false;
  }

  bool hasChanges() {
    double? unit = widget.selectedOrder.orderUnit != null ? MoneyUtils().fromReadableMoney(_unitController.text) : null;
    double? amount =
        widget.selectedOrder.orderAmount != null ? MoneyUtils().fromReadableMoney(_amountController.text) : null;
    double? price =
        widget.selectedOrder.orderPrice != null ? MoneyUtils().fromReadableMoney(_priceController.text) : null;
    double? stopPrice =
        widget.selectedOrder.stopPrice != null ? MoneyUtils().fromReadableMoney(_stopPriceController.text) : null;
    if (unit != null && unit != widget.selectedOrder.orderUnit) return true;
    if (amount != null && amount != widget.selectedOrder.orderAmount) return true;
    if (price != null && price != widget.selectedOrder.orderPrice) return true;
    if (stopPrice != null && stopPrice != widget.selectedOrder.stopPrice) return true;
    return false;
  }
}
