import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/market_list_model.dart';

class PriceAlarmLastPriceWidget extends StatefulWidget {
  final String symbol;
  final String currencySymbol;
  const PriceAlarmLastPriceWidget({
    super.key,
    required this.symbol,
    required this.currencySymbol,
  });

  @override
  State<PriceAlarmLastPriceWidget> createState() => _PriceAlarmLastPriceWidgetState();
}

class _PriceAlarmLastPriceWidgetState extends State<PriceAlarmLastPriceWidget> {
  late SymbolBloc _symbolBloc;
  MarketListModel? _marketListModel;

  @override
  void initState() {
    _symbolBloc = getIt<SymbolBloc>();

    _symbolBloc.add(
      SymbolSubOneTopicEvent(
        symbol: widget.symbol,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocConsumer<SymbolBloc, SymbolState>(
      bloc: _symbolBloc,
      listenWhen: (previous, current) {
        return current.isUpdated &&
            current.watchingItems.map((e) => e.symbolCode).toList().contains(
                  widget.symbol,
                );
      },
      listener: (BuildContext context, SymbolState state) {
        MarketListModel? newModel = state.watchingItems.firstWhereOrNull(
          (element) => element.symbolCode == widget.symbol,
        );
        if (newModel == null) return;
        setState(() {
          _marketListModel = newModel;
        });
      },
      builder: (context, state) {
        return Expanded(
          child: Text(
            '${widget.currencySymbol}${MoneyUtils().readableMoney(_marketListModel?.last ?? 0)}',
            style: context.pAppStyle.labelMed14textPrimary,
          ),
        );
      },
    );
  }
}
