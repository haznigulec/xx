import 'package:collection/collection.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ViopSettlementPriceWidget extends StatefulWidget {
  final String symbol;
  final bool isDefaultParity;
  final bool isVisible;
  final double price;
  final double totalUsdOverall;
  const ViopSettlementPriceWidget({
    super.key,
    required this.symbol,
    required this.isDefaultParity,
    required this.isVisible,
    required this.price,
    required this.totalUsdOverall,
  });

  @override
  State<ViopSettlementPriceWidget> createState() => _ViopSettlementPriceWidgetState();
}

class _ViopSettlementPriceWidgetState extends State<ViopSettlementPriceWidget> {
  final SymbolBloc _symbolBloc = getIt<SymbolBloc>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _symbolBloc.add(
      SymbolUnsubsubscribeEvent(
        symbolList: [
          MarketListModel(
            symbolCode: widget.symbol.split(' ')[0],
            updateDate: '',
            type: 'FUTURE',
          ),
        ],
      ),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<SymbolBloc, SymbolState>(
        bloc: _symbolBloc,
        buildWhen: (previous, current) => current.isUpdated,
        builder: (context, state) {
          MarketListModel? newSymbol = state.watchingItems.firstWhereOrNull(
            (element) => element.symbolCode == widget.symbol.split(' ')[0],
          );

          // newSymbol?.settlement => uzlaşma fiyatı
          double settlement = newSymbol?.settlement ?? widget.price;

          return Text(
            widget.isDefaultParity
                ? widget.isVisible
                    ? '${L10n.tr('settlement_price')}: ${settlement == 0 ? '-' : CurrencyEnum.turkishLira.symbol + MoneyUtils().readableMoney(
                          settlement,
                          pattern: '#,##0.####',
                        )}'
                    : '${CurrencyEnum.turkishLira.symbol}**'
                : widget.isVisible
                    ? settlement == 0
                        ? '-'
                        : '${L10n.tr('settlement_price')}: ${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(
                            settlement / widget.totalUsdOverall,
                            pattern: '#,##0.####',
                          )}'
                    : '${CurrencyEnum.dollar.symbol}**',
            style: context.pAppStyle.labelMed12textSecondary,
          );
        });
  }
}
