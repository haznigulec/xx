import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_detail/symbol_detail_utils.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_brief_info.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/p_expandable_panel.dart';
import 'package:piapiri_v2/core/api/model/proto_model/computed_values/computed_values.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_state.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/extension/string_extension.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ViopBrief extends StatefulWidget {
  final MarketListModel symbol;
  final SymbolTypes type;

  const ViopBrief({
    super.key,
    required this.symbol,
    required this.type,
  });

  @override
  State<ViopBrief> createState() => _ViopBriefState();
}

class _ViopBriefState extends State<ViopBrief> {
  late SymbolBloc _symbolBloc;
  Map<String, dynamic> _symbolBriefs = {};
  bool _isExpanded = false;
  late MarketListModel _underlyingSymbol;
  @override
  void initState() {
    super.initState();
    _symbolBloc = getIt<SymbolBloc>();
    _underlyingSymbol = MarketListModel(
      symbolCode: widget.symbol.underlying,
      updateDate: '',
    );

    if (widget.type == SymbolTypes.option) {
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
          L10n.tr('underlying_asset'): symbol.underlying,
          L10n.tr('underlying_assets_price'):
              '${MoneyUtils().getCurrency(widget.type)}${MoneyUtils().readableMoney(MoneyUtils().getPrice(_underlyingSymbol, null))}',
          L10n.tr('tavan'): '${MoneyUtils().getCurrency(widget.type)}${MoneyUtils().readableMoney(symbol.limitUp)}',
          L10n.tr('taban'): '${MoneyUtils().getCurrency(widget.type)}${MoneyUtils().readableMoney(symbol.limitDown)}',
          L10n.tr('number_of_transactions'): MoneyUtils().compactMoney(symbol.quantity),
          L10n.tr('volume'): '${MoneyUtils().getCurrency(widget.type)}${MoneyUtils().compactMoney(symbol.volume)}',
          L10n.tr('maturity'):
              (symbol.maturity).isNotNullOrBlank ? DateTimeUtils.dateFormat(DateTime.parse(symbol.maturity)) : '-',
          L10n.tr('days_to_maturity'): (symbol.maturity.isEmpty ? DateTime.now() : DateTime.parse(symbol.maturity))
              .difference(DateTime.now())
              .inDays
              .toString(),
          L10n.tr('open_interest'): symbol.openInterest.toString(),
          L10n.tr('open_interest_change'):
              '${MoneyUtils().getCurrency(widget.type)}${MoneyUtils().readableMoney(symbol.openInterestChange)}',
          L10n.tr('leverage_ratio'): '1:${symbol.multiplier}',
          L10n.tr('open_interest_change_percentage'):
              MoneyUtils().ratioFormat(symbol.openInterestChange / symbol.openInterest * 100),
          L10n.tr('InitialRequirements'):
              '${MoneyUtils().getCurrency(widget.type)}${MoneyUtils().readableMoney(symbol.initialMargin)}',
          L10n.tr('MaintenanceRequirements'):
              '${MoneyUtils().getCurrency(widget.type)}${MoneyUtils().readableMoney(symbol.initialMargin)}',
          L10n.tr('teorik_eslesme_fiyati'): MoneyUtils().readableMoney(symbol.theoricalPrice),
          L10n.tr('teorik_eslesme_fark'): MoneyUtils().ratioFormat(symbol.theoricelPDifPer),
          L10n.tr('teorik_eslesme_miktari'): MoneyUtils().readableMoney(symbol.eqRemainingBidQuantity),
          L10n.tr('teorik_eslesme_kalan_miktar'): MoneyUtils().readableMoney(
            (symbol.eqRemainingBidQuantity - symbol.eqRemainingAskQuantity),
          ),
        };

        if (widget.type == SymbolTypes.option) {
          _symbolBriefs[L10n.tr('turu')] = computedValues?.optionClass ?? '';
          _symbolBriefs[L10n.tr('usage_price')] = MoneyUtils().readableMoney(symbol.strikePrice, pattern: '#,##0.000');
          _symbolBriefs[L10n.tr('settlement')] = MoneyUtils().readableMoney(symbol.settlement, pattern: '#,##0.000');
          _symbolBriefs[L10n.tr('pre_settlement')] =
              MoneyUtils().readableMoney(symbol.preSettlement, pattern: '#,##0.000');
          _symbolBriefs[L10n.tr('simple_multiplier')] =
              MoneyUtils().readableMoney(computedValues?.leverage ?? 0, pattern: '#,##0.000');
          _symbolBriefs[L10n.tr('effective_multiplier')] =
              MoneyUtils().readableMoney(computedValues?.omega ?? 0, pattern: '#,##0.000');
          _symbolBriefs[L10n.tr('breakeven_price')] =
              MoneyUtils().readableMoney(computedValues?.breakEven ?? 0, pattern: '#,##0.000');
          _symbolBriefs[L10n.tr('delta')] =
              MoneyUtils().readableMoney(computedValues?.delta ?? 0, pattern: '#,##0.000');
          _symbolBriefs[L10n.tr('gamma')] =
              MoneyUtils().readableMoney(computedValues?.gamma ?? 0, pattern: '#,##0.000');
          _symbolBriefs[L10n.tr('theta')] =
              MoneyUtils().readableMoney(computedValues?.theta ?? 0, pattern: '#,##0.000');
          _symbolBriefs[L10n.tr('vega')] = MoneyUtils().readableMoney(computedValues?.vega ?? 0, pattern: '#,##0.000');
        }

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

  List<Widget> _generateHeaderInfos(MarketListModel? underlyingSymbol) {
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
                  imagesPath:
                      _symbolBriefs.keys.elementAt(i) == L10n.tr('underlying_asset') ? ImagesPath.arrow_up_right : null,
                  onTap: _symbolBriefs.keys.elementAt(i) == L10n.tr('underlying_asset') && underlyingSymbol != null
                      ? () {
                          router.maybePop();
                          router.push(
                            SymbolDetailRoute(
                              symbol: underlyingSymbol,
                              ignoreDispose: true,
                            ),
                          );
                        }
                      : null,
                ),
              ),
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
                  value: _symbolBriefs.values.elementAt(i) ?? '',
                ),
              ),
              if (i + 1 < _symbolBriefs.keys.length)
                Expanded(
                  child: SymbolBriefInfo(
                    label: _symbolBriefs.keys.elementAt(i + 1),
                    value: _symbolBriefs.values.elementAt(i + 1) ?? '',
                  ),
                ),
            ],
          ),
        ),
      );
    }
    return headerInfos;
  }
}
