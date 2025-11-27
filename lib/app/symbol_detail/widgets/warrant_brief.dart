import 'package:collection/collection.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_detail/symbol_detail_utils.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_brief_info.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/us_brief_underlying.dart';
import 'package:piapiri_v2/app/warrant/bloc/warrant_bloc.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/p_expandable_panel.dart';
import 'package:piapiri_v2/core/api/model/proto_model/computed_values/computed_values.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_state.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/extension/string_extension.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/risk_level_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class WarrantBrief extends StatefulWidget {
  final MarketListModel symbol;
  final SymbolTypes type;

  const WarrantBrief({
    super.key,
    required this.symbol,
    required this.type,
  });

  @override
  State<WarrantBrief> createState() => _WarrantBriefState();
}

class _WarrantBriefState extends State<WarrantBrief> {
  final SymbolBloc _symbolBloc = getIt<SymbolBloc>();
  final AppInfoBloc _appInfoBloc = getIt<AppInfoBloc>();
  final WarrantBloc _warrantBloc = getIt<WarrantBloc>();
  Map<String, dynamic> _symbolBriefs = {};
  bool _isExpanded = false;
  late MarketListModel _underlyingSymbol;
  @override
  void initState() {
    super.initState();
    _underlyingSymbol = MarketListModel(
      symbolCode: widget.symbol.underlying,
      updateDate: '',
    );
    _symbolBloc.add(
      SymbolSubOneTopicEvent(
        symbol: widget.symbol.underlying,
      ),
    );
    if (!_symbolBloc.state.computedValues.any((element) => element.symbol == widget.symbol.symbolCode)) {
      _symbolBloc.add(
        SymbolSubscribeComputedValuesEvent(
          symbolCode: widget.symbol.symbolCode,
          symbolType: widget.symbol.type,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PBlocConsumer<SymbolBloc, SymbolState>(
      bloc: _symbolBloc,
      listenWhen: (previous, current) =>
          current.watchingItems.any((e) => e.symbolCode == widget.symbol.underlying) &&
          current.watchingItems.firstWhere((e) => e.symbolCode == widget.symbol.underlying).updateDate !=
              _underlyingSymbol.updateDate,
      listener: (context, state) {
        setState(() {
          _underlyingSymbol = state.watchingItems.firstWhereOrNull((e) => e.symbolCode == widget.symbol.underlying) ??
              state.updatedSymbol;
        });
      },
      builder: (context, state) {
        ComputedValues? computedValues =
            state.computedValues.firstWhereOrNull((e) => e.symbol == widget.symbol.symbolCode);
        MarketListModel symbol = state.watchingItems.firstWhere(
          (element) => element.symbolCode == widget.symbol.symbolCode,
          orElse: () => widget.symbol,
        );
        symbol = SymbolDetailUtils().fetchWithSubscribedSymbol(symbol, widget.symbol);
        MarketListModel? underlyingSymbol =
            state.watchingItems.firstWhereOrNull((e) => e.symbolCode == widget.symbol.underlying);
        _symbolBriefs = {
          L10n.tr('chartOpen'): '${MoneyUtils().getCurrency(widget.type)}${MoneyUtils().readableMoney(symbol.open)}',
          L10n.tr('onceki_kapanis'):
              '${MoneyUtils().getCurrency(widget.type)}${MoneyUtils().readableMoney(symbol.dayClose)}',
          L10n.tr('chartHigh'):
              '${MoneyUtils().getCurrency(widget.type)}${MoneyUtils().readableMoney(symbol.dailyHigh)}',
          L10n.tr('chartLow'): '${MoneyUtils().getCurrency(widget.type)}${MoneyUtils().readableMoney(symbol.dailyLow)}',
          L10n.tr('underlying_asset'): _underlyingSymbol.symbolCode,
          L10n.tr('underlying_assets_price'):
              '${MoneyUtils().getCurrency(widget.type)}${underlyingSymbol != null ? MoneyUtils().readableMoney(MoneyUtils().getPrice(_underlyingSymbol, null)) : 0}',
          L10n.tr('maturity'): symbol.maturity,
          L10n.tr('days_to_maturity'): underlyingSymbol?.untilMaturity.toString() ?? '-',
          L10n.tr('turu'): (symbol.optionClass).isNotNullOrBlank
              ? symbol.optionClass == 'C'
                  ? L10n.tr('CREDIT')
                  : L10n.tr('DEBIT')
              : '-',
          L10n.tr('tipi'): (symbol.optionType).isNotNullOrEmpty ? symbol.optionType : '-',
          L10n.tr('risk_group'): symbol.riskLevel,
          L10n.tr('ihrac_eden'): _appInfoBloc.state.memberCodeShortNames[symbol.issuer] ?? '-',
          L10n.tr('usage_price'): MoneyUtils().readableMoney(computedValues?.strikePrice ?? 0),
          L10n.tr('breakeven_price'): MoneyUtils().readableMoney(computedValues?.breakEven ?? 0),
          L10n.tr('base_price'): MoneyUtils().readableMoney(computedValues?.timeValue ?? 0),
          L10n.tr('time_price'): MoneyUtils().readableMoney(symbol.ask),
          L10n.tr('internal_volatility'): MoneyUtils().readableMoney(computedValues?.impliedVolatility ?? 0),
          L10n.tr('simple_mutiplier'): MoneyUtils().readableMoney(computedValues?.leverage ?? 0),
          L10n.tr('effective_mutiplier'): MoneyUtils().readableMoney(computedValues?.omega ?? 0),
          L10n.tr('market_maker_buy'): MoneyUtils().readableMoney(symbol.marketMakerBid),
          L10n.tr('market_maker_sell'): MoneyUtils().readableMoney(symbol.marketMakerAsk),
          L10n.tr('delta'): MoneyUtils().readableMoney(computedValues?.delta ?? 0, pattern: '#,##0.000'),
          L10n.tr('gamma'): MoneyUtils().readableMoney(computedValues?.gamma ?? 0, pattern: '#,##0.000'),
          L10n.tr('theta'): MoneyUtils().readableMoney(computedValues?.theta ?? 0, pattern: '#,##0.000'),
          L10n.tr('vega'): MoneyUtils().readableMoney(computedValues?.vega ?? 0, pattern: '#,##0.000'),
          L10n.tr('teorik_eslesme_fiyati'): MoneyUtils().readableMoney(symbol.theoricalPrice),
          L10n.tr('teorik_eslesme_fark'): MoneyUtils().ratioFormat(symbol.theoricelPDifPer),
          L10n.tr('teorik_eslesme_miktari'): MoneyUtils().readableMoney(symbol.eqRemainingBidQuantity),
          L10n.tr('teorik_eslesme_kalan_miktar'): MoneyUtils().readableMoney(
            (symbol.eqRemainingBidQuantity - symbol.eqRemainingAskQuantity),
          ),
        };
        return Column(
          children: [
            ..._generateHeaderInfos(underlyingSymbol),
            PExpandablePanel(
              initialExpanded: _isExpanded,
              setTitleAtBottom: true,
              isExpandedChanged: (isExpanded) => setState(() {
                _isExpanded = isExpanded;
              }),
              titleBuilder: (isExpanded) => Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  isExpanded ? L10n.tr('daha_az_göster') : L10n.tr('daha_fazla_goster'),
                  style: context.pAppStyle.labelReg16primary,
                ),
              ),
              child: Column(
                children: [
                  ..._generateExpansionInfos(),
                  SymbolBriefInfo(
                    label: L10n.tr('aciklama'),
                    value: symbol.description,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _generateHeaderInfos(MarketListModel? symbol) {
    List<Widget> headerInfos = [];

    for (var i = 0; i < 6; i += 2) {
      headerInfos.add(
        SizedBox(
          height: 52,
          child: Row(
            children: [
              Expanded(
                child: SymbolBriefInfo(
                  label: _symbolBriefs.keys.elementAt(i),
                  value: _symbolBriefs.values.elementAt(i),
                  imagesPath: _symbolBriefs.keys.elementAt(i) == L10n.tr('underlying_asset') &&
                          widget.type != SymbolTypes.certificate
                      ? ImagesPath.arrow_up_right
                      : null,
                  onTap: _symbolBriefs.keys.elementAt(i) == L10n.tr('underlying_asset') &&
                          symbol != null &&
                          widget.type != SymbolTypes.certificate
                      ? () {
                          router.maybePop();
                          if (_warrantBloc.state.warrantUsUnderlying[symbol.symbolCode] != null) {
                            router.push(
                              SymbolUsDetailRoute(
                                symbolName: _warrantBloc.state.warrantUsUnderlying[symbol.symbolCode],
                              ),
                            );
                            return;
                          }
                          router.push(
                            SymbolDetailRoute(
                              symbol: symbol,
                              ignoreDispose: true,
                            ),
                          );
                        }
                      : null,
                ),
              ),
              _warrantBloc.state.warrantUsUnderlying[symbol?.symbolCode] != null
                  ? UsBriefUnderlying(
                      label: _symbolBriefs.keys.elementAt(i + 1),
                      underlyingName: _warrantBloc.state.warrantUsUnderlying[symbol!.symbolCode] ?? '',
                    )
                  :
              Expanded(
                child: SymbolBriefInfo(
                  label: _symbolBriefs.keys.elementAt(i + 1),
                  value: _symbolBriefs.values.elementAt(i + 1),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return headerInfos;
  }

  List<Widget> _generateExpansionInfos() {
    List<Widget> headerInfos = [];
    for (var i = 6; i < _symbolBriefs.keys.length; i += 2) {
      headerInfos.add(
        SizedBox(
          height: 52,
          child: Row(
            children: [
              Expanded(
                child: SymbolBriefInfo(
                  label: _symbolBriefs.keys.elementAt(i),
                  value: _symbolBriefs.keys.elementAt(i) == L10n.tr('risk_group')
                      ? L10n.tr(stringToRiskLevel(_symbolBriefs.values.elementAt(i)).text)
                      : _symbolBriefs.values.elementAt(i),
                  suffixDotColor: _symbolBriefs.keys.elementAt(i) == L10n.tr('risk_group')
                      ? stringToRiskLevel(_symbolBriefs.values.elementAt(i)).color
                      : null,
                ),
              ),
              if (i + 1 < _symbolBriefs.keys.length) ...[
                Expanded(
                  child: SymbolBriefInfo(
                    label: _symbolBriefs.keys.elementAt(i + 1),
                    value: _symbolBriefs.values.elementAt(i + 1),
                  ),
                ),
              ]
            ],
          ),
        ),
      );
    }
    return headerInfos;
  }
}
