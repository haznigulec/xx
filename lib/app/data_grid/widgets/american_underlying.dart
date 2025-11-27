import 'package:collection/collection.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/app/warrant/bloc/warrant_bloc.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/diff_percentage.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/us_symbol_snapshot.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AmericanUnderlying extends StatefulWidget {
  final String underlyingName;
  const AmericanUnderlying({
    super.key,
    required this.underlyingName,
  });

  @override
  State<AmericanUnderlying> createState() => _BistUnderlyingState();
}

class _BistUnderlyingState extends State<AmericanUnderlying> {
  final UsEquityBloc _usEquityBloc = getIt<UsEquityBloc>();
  final WarrantBloc _warrantBloc = getIt<WarrantBloc>();
  late UsSymbolSnapshot underlyingAsset;
  bool _canSubscribe = false;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _canSubscribe = _warrantBloc.state.warrantUsUnderlying.keys.contains(widget.underlyingName);
    underlyingAsset = UsSymbolSnapshot(
      ticker: _canSubscribe ? _warrantBloc.state.warrantUsUnderlying[widget.underlyingName] : widget.underlyingName,
    );
    if (_canSubscribe) {
    _usEquityBloc.add(
      SubscribeSymbolEvent(
          symbolName: [underlyingAsset.ticker],
          callback: (symbols, _) {
            if (symbols.isNotEmpty) {
              underlyingAsset = symbols.first;
            } else {
              _canSubscribe = false;
            }
            _isLoading = false;
            setState(() {});
          },
      ),
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PBlocConsumer<UsEquityBloc, UsEquityState>(
      bloc: _usEquityBloc,
      listener: (context, state) {
        if (_canSubscribe) {
          UsSymbolSnapshot? newModel =
              state.polygonWatchingItems.firstWhereOrNull((element) => element.ticker == underlyingAsset.ticker);
          if (newModel == null) return;
          underlyingAsset = newModel;
          setState(() {});          
        }
      },
      builder: (context, state) {
        return SizedBox(
          height: 48,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SymbolIcon(
                symbolName: underlyingAsset.ticker,
                symbolType: SymbolTypes.foreign,
                size: 28,
              ),
              const SizedBox(
                width: Grid.s,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    underlyingAsset.ticker,
                    style: context.pAppStyle.labelReg14textPrimary,
                  ),
                  Text(
                    L10n.tr('underlying_asset'),
                    style: context.pAppStyle.labelMed12textSecondary,
                  ),
                ],
              ),
              const Spacer(),
              if (_canSubscribe)
                Shimmerize(
                  enabled: _isLoading,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${CurrencyEnum.dollar.symbol}${MoneyUtils().getUsPrice(underlyingAsset)}',
                        style: context.pAppStyle.labelMed14textPrimary,
                      ),
                      DiffPercentage(
                        percentage: underlyingAsset.session?.regularTradingChangePercent ?? 0,
                      ),
                    ],
                  ),
              )
            ],
          ),
        );
      },
    );
  }
}
