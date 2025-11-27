import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_brief_info.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/p_expandable_panel.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class EquityBrief extends StatefulWidget {
  final MarketListModel symbol;
  final SymbolTypes type;
  const EquityBrief({
    super.key,
    required this.symbol,
    required this.type,
  });

  @override
  State<EquityBrief> createState() => _EquityBriefState();
}

class _EquityBriefState extends State<EquityBrief> {
  late double _pd;
  late Map<String, dynamic> _symbolBriefs;
  bool _isExpanded = false;
  final double _rowHeight = 54;

  @override
  Widget build(BuildContext context) {
    double lastPrice = MoneyUtils().getPrice(widget.symbol, null);
    _pd = widget.symbol.capital * lastPrice;
    _symbolBriefs = {
      L10n.tr('chartOpen'): '${MoneyUtils().getCurrency(widget.type)}${MoneyUtils().readableMoney(widget.symbol.open)}',
      L10n.tr('onceki_kapanis'):
          '${MoneyUtils().getCurrency(widget.type)}${MoneyUtils().readableMoney(widget.symbol.dayClose)}',
      L10n.tr('chartHigh'):
          '${MoneyUtils().getCurrency(widget.type)}${MoneyUtils().readableMoney(widget.symbol.dailyHigh)}',
      L10n.tr('chartLow'):
          '${MoneyUtils().getCurrency(widget.type)}${MoneyUtils().readableMoney(widget.symbol.dailyLow)}',
      L10n.tr('tavan'): '${MoneyUtils().getCurrency(widget.type)}${MoneyUtils().readableMoney(widget.symbol.limitUp)}',
      L10n.tr('taban'):
          '${MoneyUtils().getCurrency(widget.type)}${MoneyUtils().readableMoney(widget.symbol.limitDown)}',
      L10n.tr('52_weeks_highest'):
          '${MoneyUtils().getCurrency(widget.type)}${MoneyUtils().readableMoney(widget.symbol.yearHigh)}',
      L10n.tr('52_weeks_lowest'):
          '${MoneyUtils().getCurrency(widget.type)}${MoneyUtils().readableMoney(widget.symbol.yearLow)}',
      L10n.tr('number_of_transactions'): MoneyUtils().compactMoney(widget.symbol.quantity),
      L10n.tr('volume'): '${MoneyUtils().getCurrency(widget.type)}${MoneyUtils().compactMoney(widget.symbol.volume)}',
      L10n.tr('fk'): MoneyUtils()
          .readableMoney(((lastPrice) / ((widget.symbol.shiftedNetProceed) / (widget.symbol.capital))) / 1000),
      L10n.tr('pd_dd'): MoneyUtils().readableMoney(_pd / widget.symbol.equity),
      L10n.tr('net_kar'): MoneyUtils().compactMoney(widget.symbol.netProceeds),
      L10n.tr('hisse_basi_kar'): (widget.symbol.netProceeds / widget.symbol.circulationShare).toStringAsFixed(2),
      L10n.tr('piyasa_degeri'):
          '${MoneyUtils().getCurrency(widget.type)}${MoneyUtils().compactMoney(widget.symbol.capital * lastPrice)}',
      L10n.tr('defter_degeri'): MoneyUtils().readableMoney(widget.symbol.equity / widget.symbol.capital),
      L10n.tr('capital'): '${MoneyUtils().getCurrency(widget.type)}${MoneyUtils().compactMoney(widget.symbol.capital)}',
      L10n.tr('ozsermaye'):
          '${MoneyUtils().getCurrency(widget.type)}${MoneyUtils().compactMoney(widget.symbol.equity)}',
      L10n.tr('share_in_circulation'):
          '${MoneyUtils().getCurrency(widget.type)}${MoneyUtils().compactMoney(widget.symbol.circulationShare)}',
      L10n.tr('share_in_circulation_percentage'): MoneyUtils().readableMoney(widget.symbol.circulationSharePer),
      L10n.tr('teorik_eslesme_fiyati'): MoneyUtils().readableMoney(widget.symbol.eqPrice),
      L10n.tr('teorik_eslesme_fark'): MoneyUtils().readableMoney(
        ((widget.symbol.eqPrice - lastPrice) / lastPrice) * 100,
      ),
      L10n.tr('teorik_eslesme_miktari'): MoneyUtils().readableMoney(widget.symbol.eqRemainingBidQuantity),
      L10n.tr('teorik_eslesme_kalan_miktar'): MoneyUtils().readableMoney(
        (widget.symbol.eqRemainingBidQuantity - widget.symbol.eqRemainingAskQuantity),
      ),
    };
    return Column(
      children: [
        ..._generateHeaderInfos(),
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
            children: _generateExpansionInfos(),
          ),
        ),
      ],
    );
  }

  List<Widget> _generateHeaderInfos() {
    List<Widget> headerInfos = [];
    for (var i = 0; i < 6; i += 2) {
      headerInfos.add(
        SizedBox(
          height: _rowHeight,
          child: Row(
            children: [
              Expanded(
                child: SymbolBriefInfo(
                  label: _symbolBriefs.keys.elementAt(i),
                  value: _symbolBriefs.values.elementAt(i),
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
          height: _rowHeight,
          child: Row(
            children: [
              Expanded(
                child: SymbolBriefInfo(
                  label: _symbolBriefs.keys.elementAt(i),
                  value: _symbolBriefs.values.elementAt(i),
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
