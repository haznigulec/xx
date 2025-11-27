import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_brief_info.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/p_expandable_panel.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/ticker_overview.dart';
import 'package:piapiri_v2/core/model/us_symbol_snapshot.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class UsBrief extends StatefulWidget {
  final UsSymbolSnapshot usSymbolSnapshot;
  final TickerOverview tickerOverview;
  const UsBrief({
    super.key,
    required this.usSymbolSnapshot,
    required this.tickerOverview,
  });

  @override
  State<UsBrief> createState() => _UsBriefState();
}

class _UsBriefState extends State<UsBrief> {
  final UsEquityBloc _usEquityBloc = getIt<UsEquityBloc>();
  bool _isExpanded = false;

  Map<String, String?> symbolBriefs = {
    'chartOpen': null,
    'onceki_kapanis': null,
    'chartHigh': null,
    'chartLow': null,
    'primary_exch': null,
    'volume': null,
    'fk': null,
    'piyasa_degeri': null,
    'pd_dd': null,
  };

  @override
  initState() {
    _usEquityBloc.add(
      GetFinancialDataEvent(
        symbolName: widget.tickerOverview.ticker,
        callback: (usFinancialModel) {
          if (usFinancialModel?.financials.incomeStatement?.items['basic_earnings_per_share']?.value != null) {
            symbolBriefs['fk'] = MoneyUtils().readableMoney((widget.usSymbolSnapshot.session?.price ?? 0) /
                usFinancialModel!.financials.incomeStatement!.items['basic_earnings_per_share']!.value);
          } else {
            symbolBriefs.remove('fk');
          }
          if (widget.tickerOverview.marketCap != null &&
              usFinancialModel?.financials.balanceSheet?.items['equity']?.value != null) {
            symbolBriefs['pd_dd'] = MoneyUtils().readableMoney(widget.tickerOverview.marketCap!.toDouble() /
                usFinancialModel!.financials.balanceSheet!.items['equity']!.value);
          } else {
            symbolBriefs.remove('pd_dd');
          }
          setState(() {});
        },
      ),
    );

    symbolBriefs['primary_exch'] = widget.tickerOverview.primaryExchange ?? '';

    symbolBriefs['piyasa_degeri'] =
        CurrencyEnum.dollar.symbol + MoneyUtils().compactMoney(widget.tickerOverview.marketCap?.toDouble() ?? 0);

    symbolBriefs['chartOpen'] = CurrencyEnum.dollar.symbol +
        MoneyUtils().readableMoney(
          widget.usSymbolSnapshot.session?.open ?? 0,
          pattern: (widget.usSymbolSnapshot.session?.open ?? 0) >= 1 ? '#,##0.00' : '#,##0.0000#####',
        );
    symbolBriefs['onceki_kapanis'] = CurrencyEnum.dollar.symbol +
        MoneyUtils().readableMoney(
          widget.usSymbolSnapshot.session?.previousClose ?? 0,
          pattern: (widget.usSymbolSnapshot.session?.previousClose ?? 0) >= 1 ? '#,##0.00' : '#,##0.0000#####',
        );
    symbolBriefs['chartHigh'] = CurrencyEnum.dollar.symbol +
        MoneyUtils().readableMoney(
          widget.usSymbolSnapshot.session?.high ?? 0,
          pattern: (widget.usSymbolSnapshot.session?.high ?? 0) >= 1 ? '#,##0.00' : '#,##0.0000#####',
        );
    symbolBriefs['chartLow'] = CurrencyEnum.dollar.symbol +
        MoneyUtils().readableMoney(
          widget.usSymbolSnapshot.session?.low ?? 0,
          pattern: (widget.usSymbolSnapshot.session?.low ?? 0) >= 1 ? '#,##0.00' : '#,##0.0000#####',
        );
    symbolBriefs['primary_exch'] = widget.tickerOverview.primaryExchange;

    symbolBriefs['volume'] = MoneyUtils().compactMoney(widget.usSymbolSnapshot.session?.volume ?? 0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            L10n.tr('piyasa_ozeti'),
            style: context.pAppStyle.labelMed18textPrimary,
          ),
          const SizedBox(
            height: Grid.s + Grid.xs,
          ),
          Column(
            children: [
              ..._generateHeaderInfos(symbolBriefs),
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
                  children: _generateExpansionInfos(symbolBriefs),
                ),
              ),
            ],
          )
        ]);
  }

  List<Widget> _generateHeaderInfos(Map<String, dynamic> symbolBriefs) {
    List<Widget> headerInfos = [];
    final keys = symbolBriefs.keys.toList();
    final values = symbolBriefs.values.toList();

    for (var i = 0; i < 4; i += 2) {
      headerInfos.add(
        SizedBox(
          height: 54,
          child: Row(
            children: [
              Expanded(
                child: SymbolBriefInfo(
                  label: L10n.tr(keys[i]),
                  value: values[i] ?? '00000',
                  shimmerize: values[i] == null,

                ),
              ),
              if (i + 1 < keys.length)
                Expanded(
                  child: SymbolBriefInfo(
                    label: L10n.tr(keys[i + 1]),
                    value: values[i + 1] ?? '00000',
                    shimmerize: values[i + 1] == null,
                  ),
                ),
              if (i + 1 >= keys.length) const Expanded(child: SizedBox()),
            ],
          ),
        ),
      );
    }
    return headerInfos;
  }

  List<Widget> _generateExpansionInfos(Map<String, dynamic> symbolBriefs) {
    List<Widget> headerInfos = [];
    final keys = symbolBriefs.keys.toList();
    final values = symbolBriefs.values.toList();

    for (var i = 4; i < symbolBriefs.keys.length; i += 2) {
      headerInfos.add(
        SizedBox(
          height: 54,
          child: Row(
            children: [
              Expanded(
                child: SymbolBriefInfo(
                  label: L10n.tr(keys[i]),
                  value: values[i] ?? '00000',
                  shimmerize: values[i] == null,
                ),
              ),
              if (i + 1 < keys.length)
                Expanded(
                  child: SymbolBriefInfo(
                    label: L10n.tr(keys[i + 1]),
                    value: values[i + 1] ?? '00000',
                    shimmerize: values[i + 1] == null,
                  ),
                ),
              if (i + 1 >= keys.length) const Expanded(child: SizedBox()),
            ],
          ),
        ),
      );
    }
    return headerInfos;
  }
}
