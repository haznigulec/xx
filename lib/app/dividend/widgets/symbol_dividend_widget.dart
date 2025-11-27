import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/dividend/bloc/dividend_bloc.dart';
import 'package:piapiri_v2/app/dividend/bloc/dividend_event.dart';
import 'package:piapiri_v2/app/dividend/bloc/dividend_state.dart';
import 'package:piapiri_v2/app/us_symbol_detail/widgets/dividend_column_widget.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class SymbolDividendWidget extends StatefulWidget {
  const SymbolDividendWidget({
    required this.symbolCode,
    super.key,
  });
  final String symbolCode;

  @override
  State<SymbolDividendWidget> createState() => _SymbolDividendWidgetState();
}

class _SymbolDividendWidgetState extends State<SymbolDividendWidget> {
  late final DividendBloc _dividendBloc;

  @override
  void initState() {
    _dividendBloc = getIt<DividendBloc>();
    _dividendBloc.add(
      GetSymbolDividentEvent(symbolName: widget.symbolCode),
    );
    _dividendBloc.add(
      GetSymbolDividentHistoryEvent(symbolName: widget.symbolCode),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<DividendBloc, DividendState>(
      bloc: _dividendBloc,
      builder: (context, state) {
        if (state.symbolDividend == null || state.symbolDividend?.perShare == 0) {
          return const SizedBox.shrink();
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: Grid.l,
            ),
            Text(
              L10n.tr('symbol_dividend_details'),
              style: context.pAppStyle.labelMed18textPrimary,
            ),
            DividendColumnWidget(
              title: 'symbol_dividend_date',
              value: state.symbolDividend?.recordDate == null
                  ? ''
                  : DateTimeUtils.dateFormat(DateTime.parse(state.symbolDividend!.recordDate!)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: Grid.xs,
              children: [
                Expanded(
                  child: DividendColumnWidget(
                    title: 'symbol_net_dividend',
                    value: state.symbolDividend!.perShare.toString(),
                  ),
                ),
                state.symbolDividend!.perRate > 0
                    ? Expanded(
                        child: DividendColumnWidget(
                          title: 'symbol_net_rate',
                          value: "%${state.symbolDividend!.perRate}",
                        ),
                      )
                    : const Spacer(),
              ],
            ),
            InkWell(
              onTap: () {
                router.push(
                  SymbolDividendHistoryRoute(
                    symbol: widget.symbolCode,
                    dividendList: state.symbolDividendHistories,
                  ),
                );
              },
              child: Text(
                L10n.tr('show_dividend_history'),
                style: context.pAppStyle.labelReg16primary,
              ),
            ),
            const SizedBox(
              height: Grid.l,
            ),
          ],
        );
      },
    );
  }
}
