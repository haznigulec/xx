import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/create_order/model/condition.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_bloc.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_event.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_state.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/textfields/order_text_fields/p_condition_textfield.dart';
import 'package:piapiri_v2/common/widgets/list/p_symbol_tile.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_state.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/condition_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

class ConditionSelector extends StatefulWidget {
  final String? symbolCode;
  final Function(GlobalKey) onTapPrice;
  final Function({
    MarketListModel? selectedSymbol,
    String? conditionType,
    double? conditionPrice,
  }) onChange;
  final FocusNode? priceFocusNode;
  final double? initialConditionPrice;
  final String? initialConditionType;
  final Color? fieldColor;
  final OrderActionTypeEnum action;
  final String? equityGroupCode;
  const ConditionSelector({
    super.key,
    this.symbolCode,
    required this.onTapPrice,
    required this.onChange,
    this.priceFocusNode,
    this.initialConditionPrice,
    this.initialConditionType,
    this.fieldColor,
    required this.action,
    this.equityGroupCode,
  });

  @override
  State<ConditionSelector> createState() => _ConditionSelectorState();
}

class _ConditionSelectorState extends State<ConditionSelector> {
  MarketListModel? _marketListModel;
  String _condition = '2';
  final TextEditingController _priceController = TextEditingController(text: '0.0');
  late SymbolBloc _symbolBloc;
  late OrdersBloc _ordersBloc;
  late FocusNode _priceFocusNode;
  late GlobalKey _priceKey;
  String? _symbolCode;
  Condition? _selectedCondition;
  bool _isInitialConditionPrice = true;

  @override
  initState() {
    super.initState();
    _priceKey = GlobalKey(debugLabel: 'conditionPrice');
    _symbolBloc = getIt<SymbolBloc>();
    _ordersBloc = getIt<OrdersBloc>();

    _symbolCode = widget.symbolCode ?? '';

    subscribeConditionSymbol(
      context,
      _symbolCode ?? '',
      setPrice: false,
    );

    _condition = widget.initialConditionType ?? '2';
    _priceFocusNode = widget.priceFocusNode ??
        FocusNode(
          debugLabel: _symbolCode ?? 'price',
          canRequestFocus: false,
        );
  }

  @override
  void didUpdateWidget(covariant ConditionSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.symbolCode != oldWidget.symbolCode) {
      _symbolCode = widget.symbolCode!;
    }
  }

  @override
  void dispose() {
    _ordersBloc.add(RemoveConditionEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocConsumer<OrdersBloc, OrdersState>(
      bloc: _ordersBloc,
      listenWhen: (previous, current) => previous.newOrder.conditionPrice != current.newOrder.conditionPrice,
      listener: (context, ordersState) {
        _priceController.text = MoneyUtils().readableMoney(ordersState.newOrder.conditionPrice ?? 0);
      },
      builder: (context, ordersState) {
        return PBlocBuilder<SymbolBloc, SymbolState>(
          bloc: _symbolBloc,
          builder: (context, state) {
            if (_marketListModel == null) {
              const PLoading();
            }

            return Column(
              children: [
                PSymbolTile(
                  key: ValueKey(_symbolCode),
                  variant: PSymbolVariant.equityTab,
                  title: _symbolCode,
                  symbolName: _symbolCode,
                  symbolType: stringToSymbolType(
                    _symbolCode ?? '',
                  ),
                  trailingWidget: InkWell(
                    onTap: () {
                      router.push(
                        SymbolSearchRoute(
                          appBarTitle: L10n.tr('symbol'),
                          showExchangesFilter: false,
                          onTapSymbol: (List<SymbolModel> newSymbols) {
                            _priceFocusNode.unfocus();
                            _symbolCode = newSymbols[0].name;

                            setState(() {
                              subscribeConditionSymbol(
                                context,
                                _symbolCode ?? '',
                              );
                            });

                            router.maybePop();
                          },
                        ),
                      );
                    },
                    child: SvgPicture.asset(
                      ImagesPath.search,
                      width: 14,
                      height: 14,
                      colorFilter: ColorFilter.mode(
                        context.pColorScheme.iconPrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const PDivider(
                  padding: EdgeInsets.only(
                    top: Grid.s,
                    bottom: Grid.m,
                  ),
                ),
                if (_selectedCondition != null)
                  PConditionTextfield(
                    key: _priceKey,
                    controller: _priceController,
                    action: widget.action,
                    marketListModel: _marketListModel,
                    title: L10n.tr('Condition_Price'),
                    condition: _selectedCondition!,
                    onTapPrice: () => widget.onTapPrice(_priceKey),
                    onConditionChanged: (newCondition) {
                      setState(() {
                        widget.onChange(
                          conditionType: newCondition.value.toString(),
                        );

                        _selectedCondition = Condition(
                          symbol: _marketListModel!,
                          price: MoneyUtils().getPrice(
                            _marketListModel!,
                            widget.action,
                          ),
                          condition: newCondition,
                        );
                      });
                      router.maybePop();
                    },
                    onPriceChanged: (newPrice) {
                      setState(() {
                        widget.onChange(
                          conditionPrice: newPrice,
                        );

                        _priceController.text = MoneyUtils().readableMoney(
                          newPrice,
                        );
                      });
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }

  void subscribeConditionSymbol(
    BuildContext context,
    String symbolName, {
    bool setPrice = true,
  }) {
    _symbolBloc.add(
      SymbolSubOneTopicEvent(
        symbol: symbolName,
        symbolType: widget.equityGroupCode == 'V' ? SymbolTypes.warrant : SymbolTypes.equity,
        callback: (subscribedSymbol) {
          _selectSymbol(
            subscribedSymbol,
            setPrice,
          );
        },
      ),
    );
  }

  void _selectSymbol(
    MarketListModel subscribedSymbol,
    bool setPrice,
  ) {
    _marketListModel = subscribedSymbol;
    _selectedCondition = Condition(
      symbol: _marketListModel!,
      price: MoneyUtils().getPrice(
        _marketListModel!,
        widget.action,
      ),
      condition: ConditionEnum.greatherThen,
    );

    double price = _preparePrice(subscribedSymbol);
    if (setPrice) {
      widget.onChange(
        selectedSymbol: _marketListModel,
        conditionType: _condition,
        conditionPrice: price,
      );
    } else {
      widget.onChange(
        selectedSymbol: _marketListModel,
        conditionType: _condition,
      );
    }

    if (_isInitialConditionPrice) {
      _priceController.text = MoneyUtils().readableMoney(widget.initialConditionPrice ?? 0);
      setState(() {
        _isInitialConditionPrice = false;
      });
    } else {
      _priceController.text = MoneyUtils().readableMoney(price);
    }
  }

  double _preparePrice(MarketListModel? symbol) {
    if (symbol == null) return 0;
    if (symbol.ask != 0) return symbol.ask;
    if (symbol.bid != 0) return symbol.bid;
    if (symbol.last != 0) return symbol.last;
    return symbol.dayClose;
  }
}
