import 'package:collection/collection.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/app/search_symbol/enum/symbol_search_filter_enum.dart';
import 'package:piapiri_v2/app/search_symbol/page/symbol_position_list.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/symbol_price_info.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
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
import 'package:piapiri_v2/core/model/position_model.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class SymbolSearchSelected extends StatefulWidget {
  final SymbolModel? symbolModel;
  final String? subMarketCode;
  final Function(MarketListModel marketListModel)? onTapSymbol;
  final Function(PositionModel positionModel)? onTapPosition;
  final bool showPriceInfo;
  final bool showPositonList;
  final bool showSearchPositon;
  final bool searchable;
  final List<SymbolSearchFilterEnum>? filterList;
  final SymbolSearchFilterEnum? selectedFilter;
  final String? selectedUnderlying;
  final String accountId;
  final Function(String)? onSelectedPrice;

  const SymbolSearchSelected({
    super.key,
    this.symbolModel,
    this.subMarketCode,
    this.onTapSymbol,
    this.onTapPosition,
    this.showPriceInfo = true,
    this.showPositonList = false,
    this.showSearchPositon = false,
    this.searchable = true,
    this.filterList,
    this.selectedFilter,
    this.selectedUnderlying,
    required this.accountId,
    this.onSelectedPrice,
  });

  @override
  State<SymbolSearchSelected> createState() => _SymbolSearchSelectedState();
}

class _SymbolSearchSelectedState extends State<SymbolSearchSelected> {
  SymbolModel? symbolModel;
  MarketListModel? marketListModel;
  late SymbolBloc _symbolBloc;
  late UsEquityBloc _usEquityBloc;
  List<SymbolSearchFilterEnum> _filterList = [];
  @override
  void initState() {
    _symbolBloc = getIt<SymbolBloc>();
    _usEquityBloc = getIt<UsEquityBloc>();
    _filterList = widget.filterList ?? SymbolSearchFilterEnum.values;
    marketListModel = MarketListModel(
      symbolCode: widget.symbolModel?.name ?? '',
      description: widget.symbolModel?.description ?? '',
      underlying: widget.symbolModel?.underlyingName ?? '',
      type: widget.symbolModel?.typeCode ?? '',
      updateDate: '',
    );
    if (widget.symbolModel != null) {
      symbolModel = widget.symbolModel;
      _symbolBloc.add(
        SymbolSubOneTopicEvent(
          symbol: symbolModel!.name,
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocConsumer<SymbolBloc, SymbolState>(
      bloc: _symbolBloc,
      listenWhen: (previous, current) {
        return symbolModel != null && current.watchingItems.any((element) => element.symbolCode == symbolModel!.name);
      },
      listener: (BuildContext context, SymbolState state) {
        MarketListModel? newModel = state.watchingItems.firstWhereOrNull(
          (element) => element.symbolCode == symbolModel!.name,
        );
        if (newModel == null) return;
        setState(() {
          marketListModel = newModel.copyWith(
            description: symbolModel?.description ?? '',
            underlying: symbolModel?.underlyingName ?? '',
          );
        });
      },
      builder: (context, state) {
        return Column(
          children: [
            InkWell(
              onTap: !widget.searchable
                  ? null
                  : () {
                      if (widget.showPositonList) {
                        PBottomSheet.show(
                          context,
                          titlePadding: const EdgeInsets.only(
                            top: Grid.m,
                          ),
                          title: L10n.tr('position_list'),
                          child: SymbolPositionList(
                            accountId: widget.accountId,
                            onTapPosition: widget.onTapPosition,
                            showSearch: widget.showSearchPositon,
                          ),
                        );
                      } else {
                        _routeSearchPage();
                      }
                    },
              child: Padding(
                padding: const EdgeInsets.only(bottom: Grid.s),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (symbolModel != null) ...[
                      SymbolIcon(
                        size: 28,
                        symbolName: [SymbolTypes.future, SymbolTypes.option, SymbolTypes.warrant]
                                .contains(stringToSymbolType(marketListModel?.type ?? ''))
                            ? marketListModel?.underlying ?? ''
                            : marketListModel?.symbolCode ?? '',
                        symbolType: stringToSymbolType(marketListModel?.type ?? ''),
                      ),
                      const SizedBox(
                        width: Grid.s,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 15,
                            child: Text(
                              symbolModel!.name,
                              style: context.pAppStyle.labelReg14textPrimary,
                              strutStyle: const StrutStyle(
                                forceStrutHeight: true,
                                height: 1.0,
                                leading: 0.0,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          SizedBox(
                            height: 14,
                            child: Text(
                              marketListModel?.description ?? '',
                              style: context.pAppStyle.labelMed12textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ] else
                      Text(
                        L10n.tr('sembol_arama'),
                        style: context.pAppStyle.labelReg14textSecondary,
                      ),
                    const Spacer(),
                    if (widget.searchable)
                      SvgPicture.asset(
                        ImagesPath.search,
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(
                          context.pColorScheme.iconPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            PDivider(
              color: context.pColorScheme.line,
              tickness: 1,
            ),
            _bottomInforTile(),
          ],
        );
      },
    );
  }

  _bottomInforTile() {
    if (symbolModel != null && widget.showPriceInfo) {
      SymbolTypes symbolType = stringToSymbolType(symbolModel!.typeCode);
      if (symbolType != SymbolTypes.foreign) {
        String pattern = symbolModel?.underlyingName == 'RUBTRY'
            ? '#,##0.00000#####'
            : MoneyUtils().getPricePattern(symbolType, widget.subMarketCode ?? marketListModel?.subMarketCode);
        return Padding(
          padding: const EdgeInsets.only(top: Grid.s),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => widget.onSelectedPrice?.call(MoneyUtils().readableMoney(
                  MoneyUtils().getPrice(marketListModel!, OrderActionTypeEnum.buy),
                  pattern: pattern,
                )),
                child: SymbolPriceInfo(
                    label: L10n.tr('market_buy_price'),
                    value: marketListModel != null
                        ? '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                            MoneyUtils().getPrice(marketListModel!, OrderActionTypeEnum.buy),
                            pattern: pattern,
                          )}'
                        : '-'),
              ),
              InkWell(
                onTap: () => widget.onSelectedPrice?.call(
                  MoneyUtils().readableMoney(
                    MoneyUtils().getPrice(marketListModel!, OrderActionTypeEnum.sell),
                    pattern: pattern,
                  ),
                ),
                child: SymbolPriceInfo(
                    label: L10n.tr('eurobond_sellprice'),
                    value: marketListModel != null
                        ? '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                            MoneyUtils().getPrice(marketListModel!, OrderActionTypeEnum.sell),
                            pattern: pattern,
                          )}'
                        : '-'),
              ),
              SymbolPriceInfo(
                  label: L10n.tr('son_fiyat'),
                  value: marketListModel != null
                      ? '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                          marketListModel!.last,
                          pattern: pattern,
                        )}'
                      : '-'),
              SymbolPriceInfo(
                label: L10n.tr('equity_bist_difference2'),
                value: MoneyUtils().ratioFormat((marketListModel?.differencePercent ?? 0).abs()),
                color: (marketListModel?.differencePercent ?? 0) == 0
                    ? context.pColorScheme.iconPrimary
                    : (marketListModel?.differencePercent ?? 0) < 0
                        ? context.pColorScheme.critical
                        : context.pColorScheme.success,
                leadingIconPath: (marketListModel?.differencePercent ?? 0) == 0
                    ? ImagesPath.trending_notr
                    : (marketListModel?.differencePercent ?? 0) < 0
                        ? ImagesPath.trending_down
                        : ImagesPath.trending_up,
              ),
            ],
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(top: Grid.s),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SymbolPriceInfo(
                  label: L10n.tr('eurobond_buyprice'),
                  value: '₺${MoneyUtils().readableMoney(marketListModel?.bid ?? 0)}'),
              SymbolPriceInfo(
                  label: L10n.tr('eurobond_sellprice'),
                  value: '₺${MoneyUtils().readableMoney(marketListModel?.ask ?? 0)}'),
              SymbolPriceInfo(
                  label: L10n.tr('son_fiyat'), value: '₺${MoneyUtils().readableMoney(marketListModel?.last ?? 0)}'),
              SymbolPriceInfo(
                label: L10n.tr('equity_bist_difference2'),
                value: MoneyUtils().ratioFormat(marketListModel?.differencePercent ?? 0),
                color: (marketListModel?.differencePercent ?? 0) == 0
                    ? context.pColorScheme.iconPrimary
                    : (marketListModel?.differencePercent ?? 0) < 0
                        ? context.pColorScheme.critical
                        : context.pColorScheme.success,
                leadingIconPath: (marketListModel?.differencePercent ?? 0) == 0
                    ? ImagesPath.trending_notr
                    : (marketListModel?.differencePercent ?? 0) < 0
                        ? ImagesPath.trending_down
                        : ImagesPath.trending_up,
              ),
            ],
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  void _routeSearchPage() {
    router.push(
      SymbolSearchRoute(
        filterList: _filterList,
        selectedFilter: widget.selectedFilter ?? SymbolSearchFilterEnum.all,
        selectedUnderlying: widget.selectedUnderlying,
        onTapSymbol: (symbolModelList) {
          setState(() {
            symbolModel = symbolModelList.first;
          });
          if (symbolModel == null) return;
          SymbolTypes symbolType = stringToSymbolType(symbolModel!.typeCode);

          if (symbolType == SymbolTypes.fund) {
            widget.onTapSymbol?.call(
              MarketListModel(
                symbolCode: symbolModel!.name,
                type: symbolModel!.typeCode,
                updateDate: '',
              ),
            );
          } else if (symbolType == SymbolTypes.foreign) {
            _usEquityBloc.add(
              SubscribeSymbolEvent(
                symbolName: [symbolModelList.first.name],
              ),
            );
            widget.onTapSymbol?.call(
              MarketListModel(
                symbolCode: symbolModelList.first.name,
                type: symbolModelList.first.typeCode,
                updateDate: '',
              ),
            );
          } else {
            _symbolBloc.add(
              SymbolSubOneTopicEvent(
                symbol: symbolModelList.first.name,
                callback: (MarketListModel marketListModel) => widget.onTapSymbol?.call(marketListModel),
              ),
            );
          }
          router.maybePop();
        },
      ),
    );
  }
}
