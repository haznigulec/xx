import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/extensions/string_extensions.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:talker_flutter/talker_flutter.dart';

class ViopInstantProfitLossWidget extends StatefulWidget {
  final double totalUsdOverall;
  final bool isDefaultParity;
  final bool isVisible;
  final double cost;
  final String symbol;
  final num multiplier;
  final double quantity;
  final double price;
  const ViopInstantProfitLossWidget({
    super.key,
    required this.totalUsdOverall,
    required this.isDefaultParity,
    required this.isVisible,
    required this.cost,
    required this.symbol,
    required this.multiplier,
    required this.quantity,
    required this.price,
  });

  @override
  State<ViopInstantProfitLossWidget> createState() => _ViopInstantProfitLossWidgetState();
}

class _ViopInstantProfitLossWidgetState extends State<ViopInstantProfitLossWidget> {
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
          // cost => müşterinin emir verdiği fiyat
          double instantProfitLossValue = 0;

          double settlement = newSymbol?.settlement ?? widget.price;

          instantProfitLossValue = (settlement - widget.cost) * widget.multiplier * widget.quantity;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: Grid.xxs,
            children: [
              Text(
                '${L10n.tr('instantProfitlossSymbol')}:',
                style: context.pAppStyle.labelMed12textSecondary.copyWith(
                  fontSize: Grid.l / 2 - Grid.xxs / 2,
                  color: instantProfitLossValue == 0
                      ? context.pColorScheme.iconPrimary
                      : (instantProfitLossValue) > 0
                          ? context.pColorScheme.success
                          : context.pColorScheme.critical,
                ),
              ),
              Text(
                widget.isDefaultParity
                    ? widget.isVisible
                        ? instantProfitLossValue == 0 || settlement == 0
                            ? '-'
                            : '(${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(
                                instantProfitLossValue,
                              )})'
                                .formatNegativePriceAndPercentage()
                        : '(${CurrencyEnum.turkishLira.symbol}**)'
                    : widget.isVisible
                        ? instantProfitLossValue == 0 || settlement == 0
                            ? '-'
                            : '(${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(
                                instantProfitLossValue / widget.totalUsdOverall,
                              )})'
                                .formatNegativePriceAndPercentage()
                        : '(${CurrencyEnum.dollar.symbol}**)',
                style: context.pAppStyle.labelMed12primary.copyWith(
                  color: instantProfitLossValue == 0
                      ? context.pColorScheme.textPrimary
                      : instantProfitLossValue > 0
                          ? context.pColorScheme.success
                          : context.pColorScheme.critical,
                  fontSize: Grid.l / 2 - Grid.xxs / 2,
                ),
              ),
            ],
          );
        });
  }
}
