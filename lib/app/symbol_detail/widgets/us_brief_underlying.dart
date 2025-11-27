import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_brief_info.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/us_symbol_snapshot.dart';

class UsBriefUnderlying extends StatefulWidget {
  final String label;
  final String underlyingName;
  const UsBriefUnderlying({
    super.key,
    required this.label,
    required this.underlyingName,
  });

  @override
  State<UsBriefUnderlying> createState() => _BistUnderlyingState();
}

class _BistUnderlyingState extends State<UsBriefUnderlying> {
  final UsEquityBloc _usEquityBloc = getIt<UsEquityBloc>();
  late UsSymbolSnapshot underlyingAsset;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    underlyingAsset = UsSymbolSnapshot(
      ticker: widget.underlyingName,
    );
    _usEquityBloc.add(
      SubscribeSymbolEvent(
        symbolName: [underlyingAsset.ticker],
        callback: (symbols, _) {
          if (symbols.isNotEmpty) {
            underlyingAsset = symbols.first;
          }
          _isLoading = false;
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PBlocConsumer<UsEquityBloc, UsEquityState>(
      bloc: _usEquityBloc,
      listener: (context, state) {
        UsSymbolSnapshot? newModel =
            state.polygonWatchingItems.firstWhereOrNull((element) => element.ticker == underlyingAsset.ticker);
        if (newModel == null) return;
        underlyingAsset = newModel;
        setState(() {});
      },
      builder: (context, state) {
        return Expanded(
          child: Shimmerize(
            enabled: _isLoading,
            child: SymbolBriefInfo(
              label: widget.label,
              value: '${CurrencyEnum.dollar.symbol}${MoneyUtils().getUsPrice(underlyingAsset)}',
            ),
          ),
        );
      },
    );
  }
}
