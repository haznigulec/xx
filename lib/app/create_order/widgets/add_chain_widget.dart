import 'package:collection/collection.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/sliding_segment/model/sliding_segment_model.dart';
import 'package:piapiri_v2/common/widgets/sliding_segment/sliding_segment.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/create_order/bloc/create_orders_bloc.dart';
import 'package:piapiri_v2/app/create_order/bloc/create_orders_event.dart';
import 'package:piapiri_v2/app/create_us_order/widgets/consistent_equivalence.dart';
import 'package:piapiri_v2/app/orders/widgets/order_detail_price_tile.dart';
import 'package:piapiri_v2/app/orders/widgets/order_type_widget.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/pvalue_textfield_widget.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_bloc.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_event.dart';
import 'package:piapiri_v2/app/search_symbol/enum/symbol_search_filter_enum.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
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
import 'package:piapiri_v2/core/model/order_model.dart';
import 'package:piapiri_v2/core/model/order_type_enum.dart';
import 'package:piapiri_v2/core/model/position_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/widgets/styled_text.dart';

class AddChainWidget extends StatefulWidget {
  final String? title;
  final int? index;
  final String? symbol;
  final bool forDeleteUpdate;
  final ChainOrderModel? chainOrder;
  final double transactionLimit;
  final String accountId;
  final SymbolTypes type;
  final VoidCallback? onSuccess;
  const AddChainWidget({
    super.key,
    this.title,
    this.index,
    this.symbol,
    this.forDeleteUpdate = false,
    this.chainOrder,
    required this.transactionLimit,
    required this.accountId,
    required this.type,
    this.onSuccess,
  });

  @override
  State<AddChainWidget> createState() => _AddChainWidgetState();
}

class _AddChainWidgetState extends State<AddChainWidget> {
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
  late final CreateOrdersBloc _createOrdersBloc;
  MarketListModel? _subscribedSymbol;
  final SymbolSearchBloc _symbolSearchBloc = getIt<SymbolSearchBloc>();
  num? _buyableSellableUnit;

  @override
  void initState() {
    _selectedOrderType = OrderTypeEnum.market;

    _symbolBloc = getIt<SymbolBloc>();
    _createOrdersBloc = getIt<CreateOrdersBloc>();

    if (widget.symbol != null) {
      _symbol = widget.symbol!;

      _subscribeSymbol(_symbol);

      _orderUnitTC.text = '${widget.chainOrder?.units}';

      _amount = widget.chainOrder?.price ?? 0;
    }

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
            _symbol = _subscribedSymbol!.symbolCode;

            _orderPriceTC.text = MoneyUtils().readableMoney(
              MoneyUtils().getPrice(_subscribedSymbol!, _selectedOrderAction),
            );

            if (_selectedOrderAction == OrderActionTypeEnum.buy) {
              /// Al
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
        return SingleChildScrollView(
          child: Column(
            children: [
              PSymbolTile(
                key: ValueKey(_subscribedSymbol?.symbolCode ?? _symbol),
                variant: PSymbolVariant.equityTab,
                title: _symbol.isEmpty ? L10n.tr('sembol_seciniz') : _symbol,
                subTitle: _subscribedSymbol?.description,
                symbolName: _subscribedSymbol != null &&
                        _subscribedSymbol?.type != null &&
                        stringToSymbolType(_subscribedSymbol!.type) == SymbolTypes.warrant
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

                          _orderUnitTC.text = '0';
                          _amount = 0;

                          _subscribeSymbol(_symbol);
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
                              content: MoneyUtils().readableMoney(
                                MoneyUtils().getPrice(
                                  _subscribedSymbol!,
                                  _selectedOrderAction,
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

                          int unit = int.tryParse(_orderUnitTC.text.isEmpty ? '0' : _orderUnitTC.text) ?? 0;
                          if (_selectedOrderType == OrderTypeEnum.limit ||
                              _selectedOrderType == OrderTypeEnum.reserve) {
                            _amount = unit * MoneyUtils().fromReadableMoney(_orderPriceTC.text);
                          } else {
                            _amount = unit * (_subscribedSymbol?.last ?? 0);
                          }
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
                            marketListModel: _subscribedSymbol ??
                                MarketListModel(
                                  symbolCode: '',
                                  updateDate: DateTime.now().toString(),
                                ),
                            onPriceChanged: (price) {
                              _orderPriceTC.text = MoneyUtils().readableMoney(price);
                              _buyableSellableUnit = (widget.transactionLimit / price).toInt();

                              if (!(_selectedOrderType == OrderTypeEnum.limit ||
                                  _selectedOrderType == OrderTypeEnum.reserve)) {
                                price = (_subscribedSymbol?.last ?? 0);
                              }

                              setState(() {
                                _amount = price * int.parse(_orderUnitTC.text);
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
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            AppInputFormatters.decimalFormatter(
                              maxDigitAfterSeparator: 0,
                            ),
                          ],
                          onTapPrice: () {
                            if (_orderUnitTC.text == '0' || _orderUnitTC.text == '0,00') {
                              _orderUnitTC.text = '';
                            }
                          },
                          onFocusChange: (hasFocus) {
                            int unit = int.tryParse(_orderUnitTC.text.isEmpty ? '0' : _orderUnitTC.text) ?? 0;
                            if (unit == 0) {
                              _orderUnitTC.text = hasFocus ? '' : unit.toString();
                            }
                          },
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
                                _amount = MoneyUtils().fromReadableMoney(deger) *
                                    MoneyUtils().getPrice(
                                      _subscribedSymbol!,
                                      _selectedOrderAction,
                                    );
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

                      /// Tutar gosterilen alan yetersiz limitte hata verir
                      ConsistentEquivalence(
                        title: L10n.tr('estimated_amount'),
                        titleValue: '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(_amount)}',
                      ),
                      const SizedBox(
                        height: Grid.m,
                      ),
                      widget.forDeleteUpdate ? _deleteUpdateButton() : _addButton(),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: Grid.s,
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleBuyableUnit() {
    double orderPrice = MoneyUtils().fromReadableMoney(_orderPriceTC.text);
    _buyableSellableUnit = (widget.transactionLimit / orderPrice).toInt();
  }

  void _handleSellableUnit() {
    _symbolSearchBloc.add(
      GetPostitionListEvent(
        accountId: widget.accountId,
        callback: (positionList) {
          PositionModel? positionModel = positionList.firstWhereOrNull(
            (element) => element.symbolName == _symbol,
          );
          if (positionModel != null) {
            _buyableSellableUnit = positionModel.qty.toInt();
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
          _orderUnitTC.text = '${(_buyableSellableUnit ?? 0).toInt()}';
        });
      },
      child: Text(
        _selectedOrderAction == OrderActionTypeEnum.buy
            ? '${L10n.tr('alinabilir_adet')}: ${(_buyableSellableUnit ?? 0).toInt()}'
            : '${L10n.tr('satilabilir_adet')}: ${_buyableSellableUnit ?? 0}',
        style: context.pAppStyle.labelReg12textSecondary,
      ),
    );
  }

  Widget _deleteUpdateButton() {
    return OrderApprovementButtons(
      cancelButtonText: L10n.tr('sil'),
      approveButtonText: L10n.tr('guncelle'),
      onPressedCancel: () async {
        await PBottomSheet.show(
          context,
          title: L10n.tr('delete_order_title'),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              spacing: Grid.m,
              children: [
                SvgPicture.asset(
                  ImagesPath.alert_circle,
                  width: 52,
                  height: 52,
                  colorFilter: ColorFilter.mode(
                    context.pColorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
                StyledText(
                  text: L10n.tr(
                    'delete_chain_alert',
                    namedArgs: {
                      'symbol': '<bold>${widget.chainOrder?.marketListModel.symbolCode}</bold>',
                      'side': widget.chainOrder?.orderAction == OrderActionTypeEnum.buy
                          ? '<green>${L10n.tr('alis').toUpperCase()}</green>'
                          : '<red>${L10n.tr('satis').toUpperCase()}</red>',
                      'unit': '${widget.chainOrder?.units}',
                      'amount': MoneyUtils().readableMoney(widget.chainOrder?.price ?? 0),
                    },
                  ),
                  textAlign: TextAlign.center,
                  style: context.pAppStyle.labelReg16textPrimary,
                  tags: {
                    'bold': StyledTextTag(
                      style: context.pAppStyle.labelMed16textPrimary,
                    ),
                    'green': StyledTextTag(
                        style: context.pAppStyle.labelReg16textPrimary.copyWith(
                      color: context.pColorScheme.success,
                    )),
                    'red': StyledTextTag(
                        style: context.pAppStyle.labelReg16textPrimary.copyWith(
                      color: context.pColorScheme.critical,
                    )),
                  },
                ),
                const SizedBox(
                  height: Grid.s,
                ),
                OrderApprovementButtons(
                  onPressedApprove: () async {
                    _createOrdersBloc.add(
                      RemoveChainListEvent(
                        index: widget.index!,
                      ),
                    );

                    await router.maybePop();
                    await router.maybePop();
                  },
                )
              ],
            ),
          ),
        );
      },
      onPressedApprove: () async {
        _createOrdersBloc.add(
          UpdateChainListByIndexEvent(
            marketListModel: _subscribedSymbol ?? _symbolBloc.state.tempSelectedItem!,
            orderAction: _selectedOrderAction,
            unit: MoneyUtils().fromReadableMoney(_orderUnitTC.text).toInt(),
            price: _selectedOrderType == OrderTypeEnum.limit || _selectedOrderType == OrderTypeEnum.reserve
                ? MoneyUtils().fromReadableMoney(_orderPriceTC.text)
                : _subscribedSymbol?.last ?? 0,
            index: widget.index!,
          ),
        );

        await router.maybePop();
      },
    );
  }

  Widget _addButton() {
    return PButton(
      text: L10n.tr('add'),
      fillParentWidth: true,
      onPressed: _subscribedSymbol == null || MoneyUtils().fromReadableMoney(_orderUnitTC.text) == 0
          ? null
          : () async {
              if (_orderUnitTC.text.isEmpty || _orderUnitTC.text == '0' || _orderUnitTC.text == '0,00') {
                return PBottomSheet.show(
                  context,
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: Column(
                      children: [
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
                          height: Grid.s,
                        ),
                        Text(
                          L10n.tr('please_enter_unit'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (widget.index != null) {
                _createOrdersBloc.add(
                  AddChainListByIndexEvent(
                    marketListModel: _subscribedSymbol ?? _symbolBloc.state.tempSelectedItem!,
                    orderAction: _selectedOrderAction,
                    unit: MoneyUtils().fromReadableMoney(_orderUnitTC.text).toInt(),
                    price: _selectedOrderType == OrderTypeEnum.limit || _selectedOrderType == OrderTypeEnum.reserve
                        ? MoneyUtils().fromReadableMoney(_orderPriceTC.text)
                        : _subscribedSymbol?.last ?? 0,
                    index: widget.index!,
                  ),
                );

                await router.maybePop();
              } else {
                _createOrdersBloc.add(
                  AddChainListEvent(
                    marketListModel: _subscribedSymbol ?? _symbolBloc.state.tempSelectedItem!,
                    orderAction: _selectedOrderAction,
                    unit: MoneyUtils().fromReadableMoney(_orderUnitTC.text).toInt(),
                    price: _selectedOrderType == OrderTypeEnum.limit || _selectedOrderType == OrderTypeEnum.reserve
                        ? MoneyUtils().fromReadableMoney(_orderPriceTC.text)
                        : _subscribedSymbol?.last ?? 0,
                  ),
                );
                await router.maybePop();
                await router.maybePop();
              }

              widget.onSuccess?.call();
            },
    );
  }
}
