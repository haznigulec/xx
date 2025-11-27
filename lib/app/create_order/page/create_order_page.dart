import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/selection_control/checkbox.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/sliding_segment/model/sliding_segment_model.dart';
import 'package:piapiri_v2/common/widgets/sliding_segment/sliding_segment.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/utils/keyboard_utils.dart';
import 'package:p_core/utils/string_utils.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_bloc.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/create_order/bloc/create_orders_bloc.dart';
import 'package:piapiri_v2/app/create_order/bloc/create_orders_event.dart';
import 'package:piapiri_v2/app/create_order/bloc/create_orders_state.dart';
import 'package:piapiri_v2/app/create_order/create_orders_constants.dart';
import 'package:piapiri_v2/app/create_order/create_orders_utils.dart';
import 'package:piapiri_v2/app/create_order/model/condition.dart';
import 'package:piapiri_v2/app/create_order/model/stoploss_takeprofit.dart';
import 'package:piapiri_v2/app/create_order/widgets/advenced_orders.dart';
import 'package:piapiri_v2/app/create_order/widgets/order_detail.dart';
import 'package:piapiri_v2/app/create_us_order/widgets/consistent_equivalence.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_bloc.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_event.dart';
import 'package:piapiri_v2/app/search_symbol/enum/symbol_search_filter_enum.dart';
import 'package:piapiri_v2/app/search_symbol/symbol_search_utils.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/symbol_search_selected.dart';
import 'package:piapiri_v2/app/symbol_detail/symbol_detail_utils.dart';
import 'package:piapiri_v2/common/utils/button_padding.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/order_validator.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/cashflow_transaction_widget.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/create_account_widget.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/ink_wrapper.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/insufficient_limit_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/common/widgets/buttons/text_button_selector.dart';
import 'package:piapiri_v2/common/widgets/textfields/order_text_fields/p_amount_textfield.dart';
import 'package:piapiri_v2/common/widgets/textfields/order_text_fields/p_price_textfield.dart';
import 'package:piapiri_v2/common/widgets/textfields/order_text_fields/p_quantity_textfield.dart';
import 'package:piapiri_v2/common/widgets/textfields/order_text_fields/p_reserve_textfield.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_state.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/account_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/order_type_enum.dart';
import 'package:piapiri_v2/core/model/order_validity_enum.dart';
import 'package:piapiri_v2/core/model/position_model.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

@RoutePage()
class CreateOrderPage extends StatefulWidget {
  final MarketListModel? symbol;
  final OrderActionTypeEnum? action;
  const CreateOrderPage({
    super.key,
    this.symbol,
    this.action,
  });

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  MarketListModel? _symbol;
  final CreateOrdersBloc _createOrdersBloc = getIt<CreateOrdersBloc>();
  final SymbolBloc _symbolBloc = getIt<SymbolBloc>();
  final SymbolSearchBloc _symbolSearchBloc = getIt<SymbolSearchBloc>();
  final AppSettingsBloc _appSettingsBloc = getIt<AppSettingsBloc>();
  final AuthBloc _authBloc = getIt<AuthBloc>();
  bool _didPriceGet = false;
  bool _virmanSell = false;
  final TextEditingController _unitController = TextEditingController(text: '0');
  final TextEditingController _priceController = TextEditingController(text: MoneyUtils().readableMoney(0));
  final TextEditingController _amountController = TextEditingController(text: MoneyUtils().readableMoney(0));
  final TextEditingController _reserveController = TextEditingController(text: '0');
  final FocusNode _priceFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  late GlobalKey _priceKey;
  late GlobalKey _qtyKey;
  late GlobalKey _amountKey;
  late GlobalKey _reserveKey;
  Condition? _conditionalOrder;
  StopLossTakeProfit? _stopLossTakeProfit;
  List<AccountModel> _accountList = [];
  OrderActionTypeEnum _action = OrderActionTypeEnum.buy;
  late OrderValidityEnum _orderValidity;
  late List<OrderTypeEnum> _orderTypes;
  late OrderTypeEnum _orderType;
  late AccountModel _selectedAccount;
  int? _sellableUnit;
  bool _isQuantitative = true;

  @override
  initState() {
    _priceKey = GlobalKey(debugLabel: 'generalPrice');
    _qtyKey = GlobalKey(debugLabel: 'generalQTY');
    _amountKey = GlobalKey(debugLabel: 'generalAmount');
    _reserveKey = GlobalKey(debugLabel: 'generalReserve');

    /// ayarlardan girilmis olan emir iletim ayarlari cekilir
    if (_authBloc.state.isLoggedIn) {
      _accountList =
          UserModel.instance.accounts.where((element) => element.currency == CurrencyEnum.turkishLira).toList();
      _selectedAccount = _accountList.firstWhere(
        (element) => element.accountId.split('-').last == _appSettingsBloc.state.orderSettings.equityDefaultAccount,
        orElse: () => _accountList.first,
      );
      _orderTypes = widget.symbol?.type == SymbolTypes.warrant.dbKey
          ? OrderTypeEnum.values.where((e) => e != OrderTypeEnum.market && e != OrderTypeEnum.marketToLimit).toList()
          : OrderTypeEnum.values;

      CreateOrdersUtils().setDefaultOrderType(
        orderTypes: _orderTypes,
        onChanged: (orderType, orderValidity) {
          _orderType = orderType;
          _orderValidity = orderValidity;
        },
      );

      _symbol = widget.symbol;
      if (widget.action != null) {
        _action = widget.action!;
      }
      if (_symbol != null) {
        _symbolBloc.add(
          SymbolSubOneTopicEvent(
            symbol: _symbol!.symbolCode,
            callback: (p0) {
              setState(() {
                _symbol = SymbolDetailUtils().fetchWithSubscribedSymbol(p0, widget.symbol);
                if (MoneyUtils().getPrice(_symbol!, _action) != 0) {
                  _setTextFields();
                  _didPriceGet = true;
                }
              });
            },
          ),
        );

        // trade limit ve pozisyon listesi cekilir
        _getLimit();
      }
      //  hissenin elde olan adeti cekilir
      _getBalance();
    }

    super.initState();
  }

  @override
  void dispose() {
    // Zincir emir listesini temizliyoruz.
    _createOrdersBloc.add(
      RemoveChainListEvent(
        index: 0,
        removeAll: true,
      ),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PInnerAppBar(
        title: L10n.tr('buy_sell'),
        actions: !_authBloc.state.isLoggedIn
            ? null
            : [
                /// Emir iletim ayarlarina yonelndirir
                InkWrapper(
                  child: SvgPicture.asset(
                    ImagesPath.preference,
                    height: 24,
                    width: 24,
                    colorFilter: ColorFilter.mode(
                      context.pColorScheme.iconPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                  onTap: () async {
                    if (_symbol == null) {
                      //Hizli al satta herhangi bir sembol secilmeidginde genel emir iletim ayarlarina yonlendirir
                      await router.push(const OrderSettingsRoute());
                    } else {
                      ///guncel emir iletim ayarlarini cektikten sonra sayafdaki degerleri gunceller
                      await router.push(const EquitySettingsRoute());
                    }
                    _selectedAccount = _accountList.firstWhere(
                      (element) =>
                          element.accountId.split('-').last ==
                          _appSettingsBloc.state.orderSettings.equityDefaultAccount,
                      orElse: () => _accountList.first,
                    );
                    CreateOrdersUtils().setDefaultOrderType(
                      orderTypes: _orderTypes,
                      onChanged: (orderType, orderValidity) {
                        _orderType = orderType;
                        _orderValidity = orderValidity;
                        _setTextFields();
                        setState(() {});
                      },
                    );
                  },
                ),
              ],
      ),
      body: !_authBloc.state.isLoggedIn
          ? CreateAccountWidget(
              memberMessage: L10n.tr('create_account_order_alert'),
              loginMessage: L10n.tr('login_order_alert'),
              onLogin: () => router.push(
                AuthRoute(
                  afterLoginAction: () async {
                    router.push(
                      CreateOrderRoute(
                        symbol: widget.symbol,
                        action: widget.action,
                      ),
                    );
                  },
                ),
              ),
            )
          : PBlocBuilder<CreateOrdersBloc, CreateOrdersState>(
              bloc: _createOrdersBloc,
              builder: (context, ordersState) {
                bool isMarketOrMarketToLimit =
                    _orderType == OrderTypeEnum.market || _orderType == OrderTypeEnum.marketToLimit;
                return Scaffold(
                  body: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Padding(
                            padding: const EdgeInsets.all(
                              Grid.m,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                /// sayfanin yukarisindaki sembolun bilgileriin buludnugu widget
                                SymbolSearchSelected(
                                  key: ValueKey('SELECTED_SYMBOL_${_symbol?.symbolCode}'),
                                  filterList: [
                                    ...SymbolSearchFilterEnum.values.where(
                                      (element) => ![
                                        SymbolSearchFilterEnum.crypto,
                                        SymbolSearchFilterEnum.parity,
                                        SymbolSearchFilterEnum.preciousMetals,
                                        SymbolSearchFilterEnum.endeks,
                                        SymbolSearchFilterEnum.etf,
                                      ].contains(element),
                                    ),
                                  ],
                                  accountId: _selectedAccount.accountId.split('-').last,
                                  symbolModel: _symbol != null ? SymbolModel.fromMarketListModel(_symbol!) : null,
                                  showPositonList: _action != OrderActionTypeEnum.buy,
                                  onTapSymbol: (marketListModel) => _symbolSearchSelected(marketListModel),
                                  onTapPosition: (positionModel) {
                                    _symbol = MarketListModel(
                                      symbolCode: positionModel.symbolName,
                                      description: positionModel.description,
                                      underlying: positionModel.underlyingName,
                                      type: positionModel.symbolType.dbKey,
                                      updateDate: '',
                                    );
                                    SymbolSearchUtils.goCreateSymbol(
                                        _symbol!, _action, SymbolTypes.equity, CreateOrderRoute.name);
                                    _didPriceGet = false;
                                    _sellableUnit = positionModel.qty.toInt();
                                    setState(() {});
                                  },
                                  onSelectedPrice: (price) => setState(() {
                                    _priceController.text = price;
                                  }),
                                ),
                                const SizedBox(
                                  height: Grid.l,
                                ),
                                PBlocConsumer<SymbolBloc, SymbolState>(
                                  bloc: _symbolBloc,
                                  listenWhen: (previous, current) {
                                    return _symbol != null &&
                                        !_didPriceGet &&
                                        current.watchingItems.map((e) => e.symbolCode).toList().contains(
                                              _symbol!.symbolCode,
                                            );
                                  },
                                  listener: (BuildContext context, SymbolState state) {
                                    MarketListModel? newModel = state.watchingItems.firstWhereOrNull(
                                      (element) => element.symbolCode == _symbol!.symbolCode,
                                    );
                                    if (newModel == null) return;

                                    _symbol = SymbolDetailUtils().fetchWithSubscribedSymbol(newModel, widget.symbol);
                                    if (!_didPriceGet) {
                                      SymbolTypes? symbolType = stringToSymbolType(_symbol!.type);
                                      _setTextFields();
                                      _didPriceGet = symbolType == SymbolTypes.warrant
                                          ? MoneyUtils().getPrice(_symbol!, _action) != 0
                                          : newModel.limitUp != 0;
                                    }
                                    setState(() {});
                                  },
                                  builder: (context, symbolState) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        /// al sat sliderinin bulundugu widget
                                        SizedBox(
                                          height: 35,
                                          child: SlidingSegment(
                                            key: ValueKey('ORDER_ACTION_SEGMENT${_symbol?.type}'),
                                            initialSelectedSegment: _action == OrderActionTypeEnum.buy
                                                ? 0
                                                : _action == OrderActionTypeEnum.sell
                                                    ? 1
                                                    : 2,
                                            backgroundColor: context.pColorScheme.card,
                                            selectedTextColor: context.pColorScheme.lightHigh,
                                            unSelectedTextColor: context.pColorScheme.textSecondary,
                                            segmentList: (_symbol == null ||
                                                        stringToSymbolType(_symbol!.type) == SymbolTypes.warrant
                                                    ? OrderActionTypeEnum.values
                                                        .where((e) => e != OrderActionTypeEnum.shortSell)
                                                    : OrderActionTypeEnum.values)
                                                .map((e) => PSlidingSegmentModel(
                                                      segmentTitle: StringUtils.capitalize(L10n.tr(e.localizationKey1)),
                                                      segmentColor: e.color,
                                                    ))
                                                .toList(),
                                            onValueChanged: (index) {
                                              if (index == 0) {
                                                _action = OrderActionTypeEnum.buy;
                                              }
                                              if (index == 1) {
                                                _action = OrderActionTypeEnum.sell;
                                              }
                                              if (index == 2) {
                                                _action = OrderActionTypeEnum.shortSell;
                                                _stopLossTakeProfit = null;
                                                //Açığa satış uyarı metni bottomsheeti
                                                PBottomSheet.showError(
                                                  context,
                                                  content: L10n.tr('short_selling_info'),
                                                  showFilledButton: true,
                                                  filledButtonText: L10n.tr('tamam'),
                                                  onFilledButtonPressed: () => router.maybePop(),
                                                );
                                              }
                                              _unitController.text = '0';
                                              _amountController.text = MoneyUtils().readableMoney(0);
                                              _conditionalOrder = null;
                                              _stopLossTakeProfit = null;
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          height: Grid.l,
                                        ),

                                        /// Emir tipinin bulundugu widget
                                        TextButtonSelector(
                                          selectedItem: L10n.tr(_orderType.localizationKey),
                                          selectedTextStyle: context.pAppStyle.labelMed14primary,
                                          onSelect: () {
                                            PBottomSheet.show(
                                              context,
                                              title: L10n.tr('emir_tipi'),
                                              titlePadding: const EdgeInsets.only(
                                                top: Grid.m,
                                              ),
                                              child: ListView.separated(
                                                itemCount: _orderTypes.length,
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  return BottomsheetSelectTile(
                                                    title: L10n.tr(_orderTypes[index].localizationKey),
                                                    subTitle: L10n.tr(_orderTypes[index].descLocalizationKey),
                                                    isSelected: _orderType == _orderTypes[index],
                                                    value: _orderTypes[index],
                                                    onTap: (_, value) {
                                                      Navigator.of(context).pop();

                                                      setState(() {
                                                        _orderType = value;
                                                        isMarketOrMarketToLimit = _orderType == OrderTypeEnum.market ||
                                                            _orderType == OrderTypeEnum.marketToLimit;
                                                        if (_orderType != OrderTypeEnum.limit &&
                                                            _stopLossTakeProfit != null) {
                                                          _stopLossTakeProfit = null;
                                                        }
                                                        _setTextFields();
                                                      });

                                                      if (_orderType ==
                                                          _appSettingsBloc.state.orderSettings.equityDefaultOrderType) {
                                                        _orderValidity =
                                                            _appSettingsBloc.state.orderSettings.equityDefaultValidity;
                                                      } else {
                                                        _orderValidity =
                                                            OrdersConstants().validityList[_orderType]!.first;
                                                      }
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
                                        SizedBox(
                                          height: 35,
                                          child: SlidingSegment(
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
                                            onValueChanged: (p0) {
                                              setState(() {
                                                _isQuantitative = p0 == 0;
                                              });
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          height: Grid.s,
                                        ),
                                        if (!isMarketOrMarketToLimit) ...[
                                          /// Fiyat girme alani
                                          PPriceTextfield(
                                            key: _priceKey,
                                            title: _orderType == OrderTypeEnum.limit
                                                ? L10n.tr('limit_price')
                                                : L10n.tr('fiyat'),
                                            controller: _priceController,
                                            action: _action,
                                            focusNode: _priceFocusNode,
                                            onTapPrice: () => KeyboardUtils().scrollOnFocus(
                                              context,
                                              _priceKey,
                                              _scrollController,
                                            ),
                                            onPriceChanged: (price) {
                                              double amount = price *
                                                  MoneyUtils().fromReadableMoney(
                                                      _unitController.text.isEmpty ? '0' : _unitController.text);
                                              _amountController.text = MoneyUtils().readableMoney(amount);
                                              setState(() {});
                                            },
                                            marketListModel: _symbol ?? widget.symbol,
                                            stopLossTakeProfit: _stopLossTakeProfit,
                                            onSLTPChanged: (sltp) {
                                              setState(() {
                                                _stopLossTakeProfit = sltp;
                                              });
                                            },
                                          ),
                                          const SizedBox(
                                            height: Grid.s,
                                          ),
                                        ],
                                        _isQuantitative
                                            ?

                                            ///Adet girme alani
                                            PQuantityTextfield(
                                                key: _qtyKey,
                                                controller: _unitController,
                                                action: _action,
                                                autoFocus: false,
                                                subtitle: CreateOrdersUtils().getQtySubtitle(
                                                  action: _action,
                                                  buyableUnit: CreateOrdersUtils().getBuyableUnit(
                                                    symbol: _symbol,
                                                    action: _action,
                                                    priceControllerText: _priceController.text,
                                                    isMarketOrMarketToLimit: isMarketOrMarketToLimit,
                                                    tradeLimit: ordersState.tradeLimit,
                                                  ),
                                                  sellableUnit: _sellableUnit?.toInt() ?? 0,
                                                ),
                                                onTapSubtitle: () {
                                                  int unit = _action == OrderActionTypeEnum.buy
                                                      ? CreateOrdersUtils().getBuyableUnit(
                                                          symbol: _symbol,
                                                          action: _action,
                                                          priceControllerText: _priceController.text,
                                                          isMarketOrMarketToLimit: isMarketOrMarketToLimit,
                                                          tradeLimit: ordersState.tradeLimit,
                                                        )
                                                      : (_sellableUnit?.toInt() ?? 0);
                                                  _unitController.text = MoneyUtils().readableMoney(
                                                    unit,
                                                    pattern: '#,##0',
                                                  );

                                                  if (_symbol != null) {
                                                    double price = isMarketOrMarketToLimit
                                                        ? MoneyUtils().getPrice(
                                                            _symbol!,
                                                            _action,
                                                          )
                                                        : MoneyUtils().fromReadableMoney(_priceController.text);
                                                    _amountController.text = MoneyUtils().readableMoney(
                                                      price * unit,
                                                    );
                                                    setState(() {});
                                                  }
                                                },
                                                isError: CreateOrdersUtils().isQtyError(
                                                  action: _action,
                                                  sellableUnit: _sellableUnit?.toInt(),
                                                  unit: MoneyUtils().fromReadableMoney(_unitController.text).toInt(),
                                                ),
                                                errorText: L10n.tr('insufficient_transaction_unit'),
                                                onTapQuantity: () => KeyboardUtils().scrollOnFocus(
                                                  context,
                                                  _qtyKey,
                                                  _scrollController,
                                                ),
                                                onUnitChanged: (unit) {
                                                  if (_symbol != null) {
                                                    double price = isMarketOrMarketToLimit
                                                        ? MoneyUtils().getPrice(
                                                            _symbol!,
                                                            _action,
                                                          )
                                                        : MoneyUtils().fromReadableMoney(_priceController.text);
                                                    _amountController.text = MoneyUtils().readableMoney(
                                                      price * unit,
                                                    );
                                                    setState(() {});
                                                  }
                                                },
                                              )
                                            : PAmountTextfield(
                                                key: _amountKey,
                                                controller: _amountController,
                                                action: _action,
                                                isError: MoneyUtils().fromReadableMoney(_amountController.text) >
                                                        ordersState.tradeLimit &&
                                                    _action == OrderActionTypeEnum.buy,
                                                errorText: L10n.tr('insufficient_transaction_limit'),
                                                onTapAmount: () => KeyboardUtils().scrollOnFocus(
                                                  context,
                                                  _amountKey,
                                                  _scrollController,
                                                ),
                                                onAmountChanged: (amount) {
                                                  double price = isMarketOrMarketToLimit
                                                      ? MoneyUtils().getPrice(
                                                          _symbol!,
                                                          _action,
                                                        )
                                                      : MoneyUtils().fromReadableMoney(_priceController.text);
                                                  int rawUnit = (amount / price).floor();
                                                  _unitController.text = rawUnit.toString();
                                                  _amountController.text = MoneyUtils().readableMoney(
                                                    price * rawUnit,
                                                  );
                                                  setState(() {});
                                                },
                                              ),
                                        const SizedBox(
                                          height: Grid.l,
                                        ),

                                        /// Tutar gosterilen alan yetersiz limitte hata verir
                                        ConsistentEquivalence(
                                          title: _isQuantitative
                                              ? L10n.tr('estimated_amount')
                                              : L10n.tr('estimated_number_shares'),
                                          titleValue: _isQuantitative
                                              ? '${CurrencyEnum.turkishLira.symbol}${_amountController.text}'
                                              : _unitController.text,
                                          subTitle: !_isQuantitative
                                              ? _action == OrderActionTypeEnum.buy
                                                  ? '${L10n.tr('alinabilir_adet')} :'
                                                  : '${L10n.tr('satilabilir_adet')}:'
                                              : null,
                                          subTitleValue: _action == OrderActionTypeEnum.buy
                                              ? '${CreateOrdersUtils().getBuyableUnit(
                                                  symbol: _symbol,
                                                  action: _action,
                                                  priceControllerText: _priceController.text,
                                                  isMarketOrMarketToLimit: isMarketOrMarketToLimit,
                                                  tradeLimit: ordersState.tradeLimit,
                                                )}'
                                              : '${_sellableUnit ?? 0}',
                                          onTapSubtitle: (value) {
                                            _unitController.text = MoneyUtils().readableMoney(
                                              value,
                                              pattern: '#,##0',
                                            );
                                            double price = isMarketOrMarketToLimit
                                                ? MoneyUtils().getPrice(
                                                    _symbol!,
                                                    _action,
                                                  )
                                                : MoneyUtils().fromReadableMoney(_priceController.text);
                                            _amountController.text = MoneyUtils().readableMoney(
                                              price * value,
                                            );
                                            setState(() {});
                                          },
                                          errorMessage: CreateOrdersUtils().getConsistentEquivalenceError(
                                            action: _action,
                                            amount: MoneyUtils().fromReadableMoney(_amountController.text),
                                            unit: MoneyUtils().fromReadableMoney(_unitController.text).toInt(),
                                            tradeLimit: ordersState.tradeLimit,
                                            sellableUnit: _sellableUnit?.toInt(),
                                            isQuantitative: _isQuantitative,
                                          ),
                                        ),
                                        if (MoneyUtils().fromReadableMoney(_amountController.text) != 0 &&
                                            MoneyUtils().fromReadableMoney(_amountController.text) >
                                                ordersState.tradeLimit &&
                                            _action == OrderActionTypeEnum.buy) ...[
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
                                        if (_orderType == OrderTypeEnum.reserve) ...[
                                          const SizedBox(
                                            height: Grid.m,
                                          ),
                                          PReserveTextfield(
                                            key: _reserveKey,
                                            controller: _reserveController,
                                            onUnitChanged: (unit) {
                                              setState(() {});
                                            },
                                            onTapReserve: () => KeyboardUtils().scrollOnFocus(
                                              context,
                                              _reserveKey,
                                              _scrollController,
                                            ),
                                          ),
                                        ],
                                        const SizedBox(
                                          height: Grid.l,
                                        ),

                                        ///Hesap sectirilen alan
                                        TextButtonSelector(
                                          selectedItem:
                                              '${UserModel.instance.customerId ?? ''} - ${_selectedAccount.accountId.split('-')[1]}',
                                          selectedTextStyle: _accountList.length > 1
                                              ? context.pAppStyle.labelMed14primary
                                              : context.pAppStyle.labelMed14textPrimary,
                                          enable: _accountList.length > 1,
                                          onSelect: () {
                                            PBottomSheet.show(
                                              context,
                                              title: L10n.tr('hesap'),
                                              titlePadding: const EdgeInsets.only(
                                                top: Grid.m,
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
                                                      Navigator.of(context).pop();
                                                      setState(() {
                                                        _selectedAccount = value;
                                                      });
                                                      _getLimit();
                                                      _getBalance();
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
                                          cashValue: ordersState.cashLimit,
                                          limitValue: ordersState.tradeLimit,
                                        ),

                                        ///Virmanli satis cehckboxu sadece satista gozukur
                                        if (_action == OrderActionTypeEnum.sell && _symbol != null) ...[
                                          const SizedBox(
                                            height: Grid.m,
                                          ),
                                          PCheckboxRow(
                                            label: L10n.tr('virmanli_satis'),
                                            value: _virmanSell,
                                            removeCheckboxPadding: true,
                                            padding: const EdgeInsets.only(
                                              left: Grid.s,
                                            ),
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            onChanged: (value) {
                                              setState(() {
                                                _virmanSell = value!;
                                              });
                                            },
                                          ),
                                        ],
                                        if (_symbol != null) ...[
                                          const SizedBox(
                                            height: Grid.l,
                                          ),

                                          /// Gecerlilik suresini sectirir
                                          TextButtonSelector(
                                            selectedItem: L10n.tr(_orderValidity.localizationKey),
                                            selectedColor: context.pColorScheme.primary,
                                            onSelect: () {
                                              List<OrderValidityEnum> validityList =
                                                  OrdersConstants().validityList[_orderType] ?? [];
                                              PBottomSheet.show(
                                                context,
                                                title: L10n.tr('validity_period'),
                                                titlePadding: const EdgeInsets.only(
                                                  top: Grid.m,
                                                ),
                                                child: ListView.separated(
                                                  itemCount: validityList.length,
                                                  shrinkWrap: true,
                                                  itemBuilder: (context, index) {
                                                    return BottomsheetSelectTile(
                                                      title: L10n.tr(validityList[index].localizationKey),
                                                      subTitle: L10n.tr(
                                                        'order_validity_desc_${validityList[index].localizationKey}',
                                                      ),
                                                      isSelected: _orderValidity == validityList[index],
                                                      value: validityList[index],
                                                      onTap: (_, value) {
                                                        setState(() {
                                                          _orderValidity = value;
                                                        });
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
                                            height: Grid.l,
                                          ),
                                          AdvencedOrders(
                                            symbol: _symbol!,
                                            action: _action,
                                            selectedAccount: _selectedAccount,
                                            tradeLimit: ordersState.tradeLimit,
                                            stopLossTakeProfit: _stopLossTakeProfit,
                                            conditionalOrder: _conditionalOrder,
                                            orderType: _orderType,
                                            price: MoneyUtils().fromReadableMoney(
                                              _priceController.text,
                                            ),
                                            onSLTPChanged: (sltp) {
                                              setState(() {
                                                _stopLossTakeProfit = sltp;
                                              });
                                            },
                                            onConditionChanged: (condition) {
                                              setState(() {
                                                _conditionalOrder = condition;
                                              });
                                            },
                                          ),
                                        ],
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: ordersState.isLoading,
                        child: const PLoading(
                          isFullScreen: true,
                        ),
                      ),
                    ],
                  ),
                  bottomNavigationBar: ordersState.isLoading
                      ? const SizedBox.shrink()
                      : generalButtonPadding(
                          context: context,
                          viewPadddingOfBottom: MediaQuery.viewPaddingOf(context).bottom,
                          child: PButton(
                            fillParentWidth: true,
                            text: '${_symbol?.symbolCode ?? ''} ${L10n.tr(_action.localizationKey1)}',
                            onPressed: _getButtonDisability()
                                ? null
                                : () => _appSettingsBloc
                                        .state.orderSettings.transactionApprovalRequest // İşlem Onay İsteği Kontrolü
                                    ? _orderApproveSheet()
                                    : _checkOrderError(),
                            variant: _action == OrderActionTypeEnum.buy
                                ? PButtonVariant.success
                                : _action == OrderActionTypeEnum.sell
                                    ? PButtonVariant.error
                                    : PButtonVariant.brand,
                          ),
                        ),
                );
              },
            ),
    );
  }

  //  hesabin islem limitini ceker
  void _getLimit() {
    _createOrdersBloc.add(
      GetTradeLimitEvent(
        symbolName: _symbol!.symbolCode,
        accountId: _selectedAccount.accountId.split('-').last,
      ),
    );
    _createOrdersBloc.add(
      GetCashLimitEvent(
        symbolName: _symbol!.symbolCode,
        accountId: _selectedAccount.accountId.split('-').last,
      ),
    );
  }

  // hissenin elde olan adetini ceker
  void _getBalance() {
    _symbolSearchBloc.add(
      GetPostitionListEvent(
        accountId: _selectedAccount.accountId.split('-').last,
        callback: (positionList) {
          if (_symbol == null) return;
          PositionModel? positionModel = positionList.firstWhereOrNull(
            (element) => element.symbolName == _symbol!.symbolCode,
          );
          if (positionModel != null) {
            _sellableUnit = positionModel.qty.toInt();
          } else {
            _sellableUnit = 0;
          }
        },
      ),
    );
  }

  /// islem yapamk icin uygun rakamlar girilmediginde buton inaktif olur
  bool _getButtonDisability() {
    if (_symbol == null) return true;
    SymbolTypes? symbolType = stringToSymbolType(_symbol!.type);
    double currentPrice = MoneyUtils().fromReadableMoney(_priceController.text);
    int qty = MoneyUtils().fromReadableMoney(_unitController.text.isEmpty ? '0' : _unitController.text).toInt();

    double newPrice = OrderValidator.priceValidator(
      context,
      symbolName: _symbol!.symbolCode,
      price: currentPrice,
      limitUp: _symbol!.limitUp,
      limitDown: _symbol!.limitDown,
      type: symbolType,
      showPopup: false,
    );
    if (newPrice != currentPrice) return true;
    if (MoneyUtils().fromReadableMoney(_unitController.text.isEmpty ? '0' : _unitController.text) == 0) return true;
    if (_orderType == OrderTypeEnum.reserve && MoneyUtils().fromReadableMoney(_reserveController.text) == 0) {
      return true;
    }
    if (_action == OrderActionTypeEnum.buy) {
      int currentBuyableUnit = MoneyUtils().getPrice(_symbol!, _action) != 0
          ? (_createOrdersBloc.state.tradeLimit /
                  ((_orderType == OrderTypeEnum.market || _orderType == OrderTypeEnum.marketToLimit)
                      ? MoneyUtils().getPrice(_symbol!, _action)
                      : MoneyUtils().fromReadableMoney(_priceController.text)))
              .floor()
          : 0;
      if (currentBuyableUnit == 0) return true;
      if (qty > currentBuyableUnit) return true;
      if (MoneyUtils().fromReadableMoney(_amountController.text) > _createOrdersBloc.state.tradeLimit) return true;
    } else if (_action == OrderActionTypeEnum.sell) {
      if (_sellableUnit == null) return true;
      if (_sellableUnit == 0) return true;
      if (qty > _sellableUnit!) return true;
    }
    return false;
  }

  //Emir onay ekrani acilir
  void _orderApproveSheet() {
    PBottomSheet.show(
      context,
      title: L10n.tr('order_confirmation'),
      titlePadding: const EdgeInsets.only(
        top: Grid.m,
      ),
      child: Column(
        children: [
          const SizedBox(
            height: Grid.m,
          ),
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: _orderType == OrderTypeEnum.market || _orderType == OrderTypeEnum.marketToLimit
                        ? L10n.tr(
                            'order_send_span_market',
                            args: [_unitController.text, _symbol!.symbolCode],
                          )
                        : L10n.tr(
                            'order_send_span_3',
                            args: [
                              '${MoneyUtils().getCurrency(stringToSymbolType(_symbol!.type))}${_priceController.text}',
                              _unitController.text,
                              _symbol!.symbolCode
                            ],
                          ),
                    style: context.pAppStyle.labelReg16textPrimary,
                  ),
                  TextSpan(
                    text: '${L10n.tr(_action.localizationKey2).toUpperCase()} ',
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
              )),
          const SizedBox(
            height: Grid.s,
          ),
          TextButton(
            onPressed: () async {
              await PBottomSheet.show(
                context,
                title: L10n.tr('emir_detay'),
                titlePadding: const EdgeInsets.only(
                  top: Grid.m,
                ),
                maxHeight: MediaQuery.of(context).size.height * 0.9,
                child: OrderDetail(
                  symbolCode: _symbol!.symbolCode,
                  symbolType: stringToSymbolType(_symbol!.type),
                  action: _action,
                  orderType: _orderType.localizationKey,
                  price: MoneyUtils().fromReadableMoney(_priceController.text),
                  unit: MoneyUtils().fromReadableMoney(_unitController.text),
                  shownQty: _orderType == OrderTypeEnum.reserve
                      ? MoneyUtils().fromReadableMoney(_reserveController.text).toInt()
                      : null,
                  amount: MoneyUtils().fromReadableMoney(_amountController.text),
                  validityLocalizationKey: _orderValidity.localizationKey,
                  accountExtId: _selectedAccount.accountId,
                  stopLossTakeProfit: _stopLossTakeProfit,
                  condition: _conditionalOrder,
                  orderDate: DateTime.now(),
                  onPressedApprove: () async {
                    await router.maybePop();
                    _checkOrderError();
                  },
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
            onPressedApprove: () async {
              await router.maybePop();
              _checkOrderError();
            },
          ),
          const SizedBox(
            height: Grid.s,
          ),
        ],
      ),
    );
  }

  ///Alt Pazar bildirimini gosterir
  void _checkOrderError() {
    if (Utils.shouldWarnBeforeBuy(
      orderActionType: _action,
      marketCode: _symbol!.marketCode,
      swapType: _symbol!.swapType,
      actionType: _symbol!.actionType,
    )) {
      PBottomSheet.showError(
        context,
        content: Utils.prepareWarnMessagesOnBuy(
          symbolCode: _symbol!.symbolCode,
          marketCode: _symbol!.marketCode,
          swapType: _symbol!.swapType,
          actionType: _symbol!.actionType,
          typeCode: _symbol!.type,
        ),
        showFilledButton: true,
        showOutlinedButton: true,
        outlinedButtonText: L10n.tr('vazgec'),
        filledButtonText: L10n.tr('tamam'),
        onFilledButtonPressed: () {
          router.maybePop();
          _createOrder();
        },
        onOutlinedButtonPressed: () => Navigator.of(context).pop(),
      );
      return;
    }
    _createOrder();
  }

  /// Emir olusturma istegi atilir
  void _createOrder() {
    _createOrdersBloc.add(
      CreateOrderEvent(
        symbolName: _symbol!.symbolCode,
        account: _selectedAccount.accountId,
        unit: MoneyUtils().fromReadableMoney(_unitController.text).toInt(),
        price: MoneyUtils().fromReadableMoney(_priceController.text),
        orderActionType: _action,
        orderType: _orderType,
        orderValidity: _orderValidity,
        shownUnit: MoneyUtils().fromReadableMoney(_reserveController.text).toInt(),
        symbolType: stringToSymbolType(_symbol!.type),
        condition: _conditionalOrder,
        stopLossTakeProfit: _stopLossTakeProfit,
        orderCompletionType: _appSettingsBloc.state.orderSettings.orderCompletion,
        callback: (String successMessage, bool isError) {
          CreateOrdersUtils().createOrderCallback(
            context,
            isError: isError,
            successMessage: successMessage,
            action: _action,
            symbol: _symbol!,
            accountId: _selectedAccount.accountId.split('-').last,
            amount: MoneyUtils().fromReadableMoney(_amountController.text),
            price: MoneyUtils().fromReadableMoney(_priceController.text),
            onSuccessSubMarketContractCallback: () => _createOrder(),
          );
        },
      ),
    );
  }

  void _setTextFields() {
    int decimalCount = _symbol?.decimalCount ?? 0;
    if (decimalCount < 2) decimalCount = 2;
    double price = _orderType == OrderTypeEnum.market || _orderType == OrderTypeEnum.marketToLimit
        ? MoneyUtils().getPrice(
            _symbol!,
            _action,
          )
        : MoneyUtils().fromReadableMoney(_priceController.text);
    int unit = MoneyUtils().fromReadableMoney(_unitController.text).toInt();
    _priceController.text = MoneyUtils().readableMoney(
      price == 0
          ? MoneyUtils().getPrice(
              _symbol!,
              _action,
            )
          : price,
      pattern: '#,##0.${'0' * decimalCount}',
    );
    _amountController.text = MoneyUtils().readableMoney(
      price * unit,
    );
  }

  void _symbolSearchSelected(MarketListModel marketListModel) {
    SymbolSearchUtils.goCreateSymbol(marketListModel, _action, SymbolTypes.equity, CreateOrderRoute.name);
    _symbol = marketListModel;
    _getLimit();
    List<PositionModel> positionList = _symbolSearchBloc.state.positionList;
    PositionModel? positionModel = positionList.firstWhereOrNull(
      (element) => element.symbolName == _symbol!.symbolCode,
    );
    if (positionModel != null) {
      _sellableUnit = positionModel.qty.toInt();
    } else {
      _sellableUnit = 0;
    }

    _didPriceGet = MoneyUtils().getPrice(_symbol!, _action) != 0;
    if (_didPriceGet) {
      _setTextFields();
    }
    setState(() {});
  }
}
