import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_brief_info.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/p_expandable_panel.dart';

import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class CryptoBrief extends StatefulWidget {
  final MarketListModel symbol;
  const CryptoBrief({
    super.key,
    required this.symbol,
  });

  @override
  State<CryptoBrief> createState() => _CryptoBriefState();
}

class _CryptoBriefState extends State<CryptoBrief> {
  late Map<String, dynamic> _symbolBriefs;
  late SymbolTypes _symbolType;
  bool _isExpanded = false;
  @override
  void initState() {
    super.initState();
    _symbolType = stringToSymbolType(widget.symbol.type);
    _symbolBriefs = {
      L10n.tr('chartOpen'): '${MoneyUtils().getCurrency(_symbolType)}${MoneyUtils().readableMoney(widget.symbol.open)}',
      L10n.tr('onceki_kapanis'):
          '${MoneyUtils().getCurrency(_symbolType)}${MoneyUtils().readableMoney(widget.symbol.dayClose)}',
      L10n.tr('chartHigh'):
          '${MoneyUtils().getCurrency(_symbolType)}${MoneyUtils().readableMoney(widget.symbol.dailyHigh)}',
      L10n.tr('chartLow'):
          '${MoneyUtils().getCurrency(_symbolType)}${MoneyUtils().readableMoney(widget.symbol.dailyLow)}',
      L10n.tr('52_weeks_highest'):
          '${MoneyUtils().getCurrency(_symbolType)}${MoneyUtils().readableMoney(widget.symbol.yearHigh)}',
      L10n.tr('52_weeks_lowest'):
          '${MoneyUtils().getCurrency(_symbolType)}${MoneyUtils().readableMoney(widget.symbol.yearLow)}',
      L10n.tr('number_of_transactions'): MoneyUtils().compactMoney(widget.symbol.quantity),
      L10n.tr('volume'): '${MoneyUtils().getCurrency(_symbolType)}${MoneyUtils().compactMoney(widget.symbol.volume)}',
      L10n.tr('piyasa_degeri'):
          '${MoneyUtils().getCurrency(_symbolType)}${MoneyUtils().compactMoney(widget.symbol.capital * widget.symbol.last)}',
      L10n.tr('share_in_circulation'):
          '${MoneyUtils().getCurrency(_symbolType)}${MoneyUtils().compactMoney(widget.symbol.circulationShare)}',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._generateHederInfos(),
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

  List<Widget> _generateHederInfos() {
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
    for (var i = 6; i < 10; i += 2) {
      headerInfos.add(
        SizedBox(
          height: 52,
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
}
