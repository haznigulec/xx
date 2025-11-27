import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/app/us_symbol_detail/widgets/dividend_column_widget.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class DividendDetailWidget extends StatelessWidget {
  final String symbol;
  const DividendDetailWidget({
    super.key,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Grid.l,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PBlocBuilder<UsEquityBloc, UsEquityState>(
            bloc: getIt<UsEquityBloc>(),
            builder: (context, state) {
              if (state.dividendWeeklyState == PageState.loading) {
                return const SizedBox.shrink();
              }

              if (state.dividend == null || state.dividend?.symbol != symbol) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    L10n.tr('dividend_details'),
                    style: context.pAppStyle.labelMed18textPrimary,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: Grid.xs,
                    children: [
                      Expanded(
                        child: DividendColumnWidget(
                          title: 'dividend_date',
                          value: DateTimeUtils.dateFormat(state.dividend!.dateTime!),
                        ),
                      ),
                      state.dividend!.value == null
                          ? const Spacer()
                          : Expanded(
                              child: DividendColumnWidget(
                                title: 'dividend_per_share',
                                value: '\$${state.dividend!.value!}',
                              ),
                            ),
                    ],
                  ),
                ],
              );
            },
          ),
          PBlocBuilder<UsEquityBloc, UsEquityState>(
            bloc: getIt<UsEquityBloc>(),
            builder: (context, state) {
              if (state.dividendYearlyState == PageState.loading || state.dividendYearlyList.isEmpty) {
                return const SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.dividend == null)
                    Text(
                      L10n.tr('dividend_details'),
                      style: context.pAppStyle.labelMed18textPrimary,
                    ),
                  DividendColumnWidget(
                    title: 'dividend_payment_frequency',
                    value: L10n.tr(
                      'times_a_year',
                      args: [
                        state.dividendYearlyList.length.toString(),
                      ],
                    ),
                  ),
                  InkWell(
                    splashColor: context.pColorScheme.transparent,
                    highlightColor: context.pColorScheme.transparent,
                    onTap: () {
                      router.push(
                        SymbolUsDividendHistoryRoute(
                          dividendList: state.dividendYearlyList,
                          symbol: symbol,
                        ),
                      );
                    },
                    child: Text(
                      L10n.tr('show_dividend_history'),
                      style: context.pAppStyle.labelReg16primary,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
