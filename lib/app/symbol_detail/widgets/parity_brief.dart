import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_brief_info.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ParityBrief extends StatefulWidget {
  final MarketListModel symbol;

  const ParityBrief({
    super.key,
    required this.symbol,
  });

  @override
  State<ParityBrief> createState() => _ParityBriefState();
}

class _ParityBriefState extends State<ParityBrief> {
  late Map<String, dynamic> _symbolBriefs;
  late SymbolTypes _symbolType;
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
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._generateHederInfos(),
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
}
