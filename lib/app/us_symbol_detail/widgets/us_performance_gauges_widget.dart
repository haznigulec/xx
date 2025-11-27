import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/us_performance_gauge.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/performance_gauge_mdoel.dart';
import 'package:piapiri_v2/core/model/us_symbol_snapshot.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class UsPerformanceGaugesWidget extends StatefulWidget {
  final String ticker;
  const UsPerformanceGaugesWidget({
    super.key,
    required this.ticker,
  });

  @override
  State<UsPerformanceGaugesWidget> createState() => _UsPerformanceGaugesWidgetState();
}

class _UsPerformanceGaugesWidgetState extends State<UsPerformanceGaugesWidget> {
  final UsEquityBloc _usEquityBloc = getIt<UsEquityBloc>();
  PerformanceGaugeModel? _weeklyBar;
  PerformanceGaugeModel? _monthlyBar;
  PerformanceGaugeModel? _yearlyBar;
  @override
  initState() {
    super.initState();
    _usEquityBloc.add(
      GetPerformanceGaugeEvent(
        symbolName: widget.ticker,
        callback: (weeklyBar, monthlyBar, yearlyBar) => setState(() {
          _weeklyBar = weeklyBar;
          _monthlyBar = monthlyBar;
          _yearlyBar = yearlyBar;
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<UsEquityBloc, UsEquityState>(
        bloc: _usEquityBloc,
        buildWhen: (previous, current) =>
            current.updatedSymbol?.ticker == widget.ticker ||
            (!previous.polygonWatchingItems.any((element) => element.ticker == widget.ticker) &&
                current.polygonWatchingItems.any((element) => element.ticker == widget.ticker)),
        builder: (context, state) {
          UsSymbolSnapshot? usSymbolSnapshot =
              state.polygonWatchingItems.firstWhereOrNull((e) => e.ticker == widget.ticker);
          double price = MoneyUtils().fromReadableMoney(MoneyUtils().getUsPrice(usSymbolSnapshot));

          return Column(
            children: [
              UsPerformanceGauge(
                title: L10n.tr('7g'),
                low: _weeklyBar?.low ?? 0.0,
                high: _weeklyBar?.high ?? 0.0,
                mean: price,
                performance: _weeklyBar?.referancePrice == null
                    ? 0
                    : ((price - _weeklyBar!.referancePrice) / _weeklyBar!.referancePrice) * 100,
                currency: CurrencyEnum.dollar,
                shimmerize: _weeklyBar == null,
              ),
              UsPerformanceGauge(
                title: L10n.tr('30g'),
                low: _monthlyBar?.low ?? 0.0,
                high: _monthlyBar?.high ?? 0.0,
                mean: price,
                performance: _monthlyBar?.referancePrice == null
                    ? 0
                    : ((price - _monthlyBar!.referancePrice) / _monthlyBar!.referancePrice) * 100,
                currency: CurrencyEnum.dollar,
                shimmerize: _monthlyBar == null,
              ),
              UsPerformanceGauge(
                title: L10n.tr('52h'),
                low: _yearlyBar?.low ?? 0.0,
                high: _yearlyBar?.high ?? 0.0,
                mean: price,
                performance: _yearlyBar?.referancePrice == null
                    ? 0
                    : ((price - _yearlyBar!.referancePrice) / _yearlyBar!.referancePrice) * 100,
                currency: CurrencyEnum.dollar,
                shimmerize: _yearlyBar == null,
              ),
            ],
          );
        });
  }
}
