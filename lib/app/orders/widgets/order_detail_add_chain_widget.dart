import 'package:collection/collection.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/sliding_segment/model/sliding_segment_model.dart';
import 'package:piapiri_v2/common/widgets/sliding_segment/sliding_segment.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/create_us_order/widgets/consistent_equivalence.dart';
import 'package:piapiri_v2/app/info/model/info_variant.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_bloc.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_event.dart';
import 'package:piapiri_v2/app/orders/widgets/order_detail_price_tile.dart';
import 'package:piapiri_v2/app/orders/widgets/order_type_widget.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/pvalue_textfield_widget.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_bloc.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_event.dart';
import 'package:piapiri_v2/app/search_symbol/enum/symbol_search_filter_enum.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/text_input_formatters.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/diff_percentage.dart';
import 'package:piapiri_v2/common/widgets/textfields/order_text_fields/p_price_textfield.dart';
import 'package:piapiri_v2/common/widgets/list/p_symbol_tile.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_state.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/order_type_enum.dart';
import 'package:piapiri_v2/core/model/position_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/transaction_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class OrderDetailAddChainWidget extends StatefulWidget {
  final TransactionModel selectedOrder;
  const OrderDetailAddChainWidget({
    super.key,
    required this.selectedOrder,
  });

  @override
  State<OrderDetailAddChainWidget> createState() => _OrderDetailAddChainWidgetState();
}

class _OrderDetailAddChainWidgetState extends State<OrderDetailAddChainWidget> {
  String _symbol = '';
  OrderActionTypeEnum _selectedOrderAction = OrderActionTypeEnum.buy;
  late OrderTypeEnum _selectedOrderType;
  final TextEditingController _orderUnitTC = TextEditingController();
  final TextEditingController _orderPriceTC = TextEditingController();
  double _amount = 0;
  final FocusNode _focusNodeUnit = FocusNode(canRequestFocus: false);
  final FocusNode _focusNodePrice = FocusNode(canRequestFocus: false);
  bool _didPriceGet = false;
  late final SymbolBloc _symbolBloc;
  late final OrdersBloc _ordersBloc;
  final SymbolSearchBloc _symbolSearchBloc = getIt<SymbolSearchBloc>();
  MarketListModel? _subscribedSymbol;
  num? _buyableSellableUnit;

  @override
  void initState() {
    _selectedOrderType = OrderTypeEnum.market;

    _symbolBloc = getIt<SymbolBloc>();
    _ordersBloc = getIt<OrdersBloc>();

    super.initState();
  }

  _subscribeSymbol(String symbolName) {
    _symbolBloc.add(
      SymbolSubOneTopicEvent(
        symbol: symbolName,
        symbolType: SymbolTypes.equity,
        callback: (symbol) {
          setState(() {
            _subscribedSymbol = symbol;
            _orderPriceTC.text = MoneyUtils().readableMoney(
              MoneyUtils().getPrice(_subscribedSymbol!, _selectedOrderAction),
            );

            if (_selectedOrderAction == OrderActionTypeEnum.buy) {
              _handleBuyableUnit();
            } else {
              /// SAT
              _handleSellableUnit();
            }

            _didPriceGet = true;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, bottomSheetSetState) {
        return Column(
          children: [
            PSymbolTile(
              key: ValueKey(_subscribedSymbol?.symbolCode ?? _symbol),
              variant: PSymbolVariant.equityTab,
              title: _symbol.isEmpty ? L10n.tr('sembol_seciniz') : _symbol,
              subTitle: _subscribedSymbol?.description,
              symbolName:
                  _subscribedSymbol != null && stringToSymbolType(_subscribedSymbol!.type) == SymbolTypes.warrant
                      ? _subscribedSymbol?.underlying
                      : _subscribedSymbol?.symbolCode,
              symbolType: _subscribedSymbol != null ? stringToSymbolType(_subscribedSymbol!.type) : null,
              trailingWidget: SvgPicture.asset(
                ImagesPath.search,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  context.pColorScheme.textSecondary,
                  BlendMode.srcIn,
                ),
              ),
              onTap: () {
                router.push(
                  SymbolSearchRoute(
                    appBarTitle: L10n.tr('symbol'),
                    filterList: SymbolSearchFilterEnum.values
                        .where(
                          (e) =>
                              e != SymbolSearchFilterEnum.foreign &&
                              e != SymbolSearchFilterEnum.fund &&
                              e != SymbolSearchFilterEnum.crypto &&
                              e != SymbolSearchFilterEnum.parity &&
                              e != SymbolSearchFilterEnum.preciousMetals &&
                              e != SymbolSearchFilterEnum.future &&
                              e != SymbolSearchFilterEnum.option &&
                              e != SymbolSearchFilterEnum.etf,
                        )
                        .toList(),
                    onTapSymbol: (symbolModelList) {
                      setState(() {
                        _symbol = symbolModelList[0].name;

                        _ordersBloc.add(
                          GetTradeLimitEvent(
                            symbolName: _symbol,
                            accountId: widget.selectedOrder.accountExtId ?? '',
                            callback: (tradeLimit) {
                              _orderUnitTC.text = '0';
                              _amount = 0;
                              _subscribeSymbol(_symbol);
                            },
                          ),
                        );
                      });
                    },
                  ),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: Grid.m,
              ),
              child: PDivider(),
            ),
            PBlocConsumer<SymbolBloc, SymbolState>(
              bloc: _symbolBloc,
              listenWhen: (previous, current) {
                return current.isUpdated &&
                    !_didPriceGet &&
                    current.watchingItems.map((e) => e.symbolCode).toList().contains(
                          _symbol,
                        );
              },
              listener: (BuildContext context, SymbolState state) {
                MarketListModel? newModel = state.watchingItems.firstWhereOrNull(
                  (element) => element.symbolCode == _symbol,
                );
                if (newModel == null) return;
                setState(() {
                  _subscribedSymbol = newModel;

                  if (!_didPriceGet) {
                    _orderPriceTC.text = MoneyUtils().readableMoney(
                      MoneyUtils().getPrice(_subscribedSymbol!, _selectedOrderAction),
                    );
                    _didPriceGet = newModel.limitUp != 0;
                  }
                });
              },
              builder: (context, state) {
                return Column(
                  children: [
                    if (_subscribedSymbol != null && _symbol.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => setState(() {
                              _orderPriceTC.text = MoneyUtils().readableMoney(_subscribedSymbol!.bid);
                            }),
                            child: OrderDetailPriceTile(
                              title: L10n.tr('market_buy_price'),
                              content: MoneyUtils().readableMoney(_subscribedSymbol!.bid),
                            ),
                          ),
                          InkWell(
                            onTap: () => setState(() {
                              _orderPriceTC.text = MoneyUtils().readableMoney(_subscribedSymbol!.ask);
                            }),
                            child: OrderDetailPriceTile(
                              title: L10n.tr('eurobond_sellprice'),
                              content: MoneyUtils().readableMoney(_subscribedSymbol!.ask),
                            ),
                          ),
                          OrderDetailPriceTile(
                            title: L10n.tr('son_fiyat'),
                            content: MoneyUtils().readableMoney(_subscribedSymbol!.last),
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
                    ],
                    SizedBox(
                      height: 35,
                      child: SlidingSegment(
                        initialSelectedSegment: _selectedOrderAction == OrderActionTypeEnum.buy ? 0 : 1,
                        backgroundColor: context.pColorScheme.card,
                        selectedTextColor: context.pColorScheme.card.shade50,
                        unSelectedTextColor: context.pColorScheme.textSecondary,
                        onValueChanged: (action) {
                          setState(() {
                            _selectedOrderAction = action == 0 ? OrderActionTypeEnum.buy : OrderActionTypeEnum.sell;

                            if (_subscribedSymbol != null) {
                              if (_selectedOrderAction == OrderActionTypeEnum.buy) {
                                _handleBuyableUnit();
                              } else {
                                /// SAT
                                _handleSellableUnit();
                              }
                            }
                          });
                        },
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
                    OrderTypeWidget(
                      orderType: _selectedOrderType,
                      onOrderTypeChanged: (orderType) => setState(() {
                        _selectedOrderType = orderType;
                      }),
                    ),
                    const SizedBox(
                      height: Grid.s,
                    ),
                    if (_selectedOrderType == OrderTypeEnum.limit || _selectedOrderType == OrderTypeEnum.reserve) ...[
                      IgnorePointer(
                        ignoring: _symbol.isEmpty,
                        child: PPriceTextfield(
                          controller: _orderPriceTC,
                          title: L10n.tr('limit_price'),
                          action: OrderActionTypeEnum.buy,
                          focusNode: _focusNodePrice,
                          marketListModel: _subscribedSymbol ?? _symbolBloc.state.tempSelectedItem,
                          onPriceChanged: (price) {
                            _orderPriceTC.text = MoneyUtils().readableMoney(price);

                            _buyableSellableUnit = (_ordersBloc.state.tradeLimit.toInt() / price).toInt();

                            setState(() {
                              if (_selectedOrderType == OrderTypeEnum.limit ||
                                  _selectedOrderType == OrderTypeEnum.reserve) {
                                _amount = price * MoneyUtils().fromReadableMoney(_orderUnitTC.text);
                              } else {
                                _amount = price * (_subscribedSymbol?.last ?? 0);
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: Grid.s,
                      ),
                    ],
                    IgnorePointer(
                      ignoring: _symbol.isEmpty,
                      child: PValueTextfieldWidget(
                        controller: _orderUnitTC,
                        title: L10n.tr('adet'),
                        onTapPrice: () {
                          if (MoneyUtils().fromReadableMoney(_orderUnitTC.text) == 0) {
                            _orderUnitTC.text = '';
                          }
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          AppInputFormatters.decimalFormatter(
                            maxDigitAfterSeparator: 0,
                          ),
                        ],
                        focusNode: _focusNodeUnit,
                        subTitle: _subscribedSymbol == null ? null : _buyableSellableUnitWidget(),
                        onChanged: (deger) {
                          setState(() {
                            _orderUnitTC.text = deger;

                            if (_selectedOrderType == OrderTypeEnum.limit ||
                                _selectedOrderType == OrderTypeEnum.reserve) {
                              _amount = MoneyUtils().fromReadableMoney(deger) *
                                  MoneyUtils().fromReadableMoney(_orderPriceTC.text);
                            } else {
                              _amount = MoneyUtils().fromReadableMoney(deger) * (_subscribedSymbol?.last ?? 0);
                            }
                          });
                        },
                        onSubmitted: (value) {
                          setState(() {
                            _orderUnitTC.text = value;
                            FocusScope.of(context).unfocus();
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: Grid.s,
                    ),
                    ConsistentEquivalence(
                      title: L10n.tr('estimated_amount'),
                      titleValue: '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(_amount)}',
                    ),
                    const SizedBox(
                      height: Grid.m,
                    ),
                    PButton(
                      text: L10n.tr('add'),
                      fillParentWidth: true,
                      onPressed: MoneyUtils().fromReadableMoney(_orderUnitTC.text) == 0 || _subscribedSymbol == null
                          ? null
                          : () async {
                              _ordersBloc.add(
                                AddChainListEvent(
                                  marketListModel: _subscribedSymbol ?? _symbolBloc.state.tempSelectedItem!,
                                  orderAction: _selectedOrderAction,
                                  unit: MoneyUtils().fromReadableMoney(_orderUnitTC.text).toInt(),
                                  price: MoneyUtils().fromReadableMoney(_orderPriceTC.text),
                                ),
                              );

                              _ordersBloc.add(
                                CreateChainOrderEvent(
                                  parentTransactionId: widget.selectedOrder.transactionId ?? '',
                                  chainNo: widget.selectedOrder.chainNo ?? 0,
                                  accountExtId: widget.selectedOrder.accountExtId ?? '',
                                  callback: (value) {
                                    router.maybePop();
                                    router.push(
                                      InfoRoute(
                                        variant: InfoVariant.success,
                                        message: value.isEmpty
                                            ? L10n.tr('order_success')
                                            : L10n.tr(
                                                'chain_order_error',
                                                args: [
                                                  '(${value.toString().substring(1, value.toString().length - 1)}) ${value.length}',
                                                ],
                                              ),
                                        buttonText: L10n.tr('emirlerime_don'),
                                        onTapButton: () {
                                          router.popUntilRoot();
                                        },
                                      ),
                                    );
                                  },
                                ),
                              );
                              router.maybePop();
                            },
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _handleBuyableUnit() {
    _buyableSellableUnit = (_ordersBloc.state.tradeLimit / MoneyUtils().fromReadableMoney(_orderPriceTC.text)).floor();
  }

  void _handleSellableUnit() {
    _symbolSearchBloc.add(
      GetPostitionListEvent(
        accountId: widget.selectedOrder.accountExtId ?? '',
        callback: (positionList) {
          PositionModel? positionModel = positionList.firstWhereOrNull(
            (element) => element.symbolName == _symbol,
          );
          if (positionModel != null) {
            _buyableSellableUnit = positionModel.qty;
          } else {
            _buyableSellableUnit = 0;
          }
        },
      ),
    );
  }

  Widget _buyableSellableUnitWidget() {
    return InkWell(
      onTap: () {
        setState(() {
          _orderUnitTC.text = '${(_buyableSellableUnit ?? 0)}';
        });
      },
      child: Text(
        _selectedOrderAction == OrderActionTypeEnum.buy
            ? '${L10n.tr('alinabilir_adet')}: ${(_buyableSellableUnit ?? 0)}'
            : '${L10n.tr('satilabilir_adet')}: ${_buyableSellableUnit ?? 0}',
        style: context.pAppStyle.labelReg12textSecondary,
      ),
    );
  }
}
