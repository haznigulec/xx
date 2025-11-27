import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/transaction_history/bloc/transaction_history_bloc.dart';
import 'package:piapiri_v2/app/transaction_history/bloc/transaction_history_event.dart';
import 'package:piapiri_v2/app/transaction_history/bloc/transaction_history_state.dart';
import 'package:piapiri_v2/app/transaction_history/model/transaction_history_main_type_enum.dart';
import 'package:piapiri_v2/app/transaction_history/model/transaction_history_type_enum.dart';
import 'package:piapiri_v2/app/transaction_history/widgets/shimmer_transaction_history.dart';
import 'package:piapiri_v2/app/transaction_history/widgets/transaction_history_filter_widget.dart';
import 'package:piapiri_v2/app/transaction_history/widgets/transaction_history_filtered_widget.dart';
import 'package:piapiri_v2/app/transaction_history/widgets/transaction_type_card.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/account_statement_date_filter_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class TransactionHistoryDomesticPage extends StatefulWidget {
  const TransactionHistoryDomesticPage({super.key});

  @override
  State<TransactionHistoryDomesticPage> createState() => _TransactionHistoryDomesticPageState();
}

class _TransactionHistoryDomesticPageState extends State<TransactionHistoryDomesticPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  TransactionMainTypeEnum _selectedTransactionMainType = TransactionMainTypeEnum.all;
  late TransactionHistoryBloc _transactionHistoryBloc;
  final ScrollController _controller = ScrollController();
  DateFilterMultiEnum _selectedDate = DateFilterMultiEnum.sumaryToday;
  TransactionHistoryTypeEnum? _selectedSide;

  @override
  void initState() {
    _transactionHistoryBloc = getIt<TransactionHistoryBloc>();

    _transactionHistoryBloc.add(
      GetTransactionHistoryEvent(),
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
      bloc: _transactionHistoryBloc,
      builder: (context, state) {
        if (state.isLoading) {
          return const Shimmerize(
            enabled: true,
            child: ShimmerTransactionHistory(),
          );
        }

        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
            _transactionHistoryBloc.add(
              SetTransactionHistoryFilter(
                transactionHistoryFilter: _transactionHistoryBloc.state.transactionHistoryFilter.clearAllFilter(),
                fetchTransactionHistory: false,
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TransactionHistoryFilterWidget(
                selectedTransactionMainType: _selectedTransactionMainType,
                selectedDate: _selectedDate,
                onSelectedSymbol: (symbol) {
                  _transactionHistoryBloc.add(
                    SetTransactionHistoryFilter(
                      transactionHistoryFilter: _transactionHistoryBloc.state.transactionHistoryFilter.copyWith(
                        finInstName: symbol,
                      ),
                    ),
                  );
                },
                onSelectedTransactionTypeAndAccount: (transactionType, account) {
                  setState(() {
                    _selectedSide = transactionType;

                    _transactionHistoryBloc.add(
                      SetTransactionHistoryFilter(
                        transactionHistoryFilter: state.transactionHistoryFilter.copyWith(
                          transactionType: _selectedSide,
                          account: account,
                        ),
                      ),
                    );
                  });
                },
                onSelectTransactionMainType: (transactionType) {
                  _selectedTransactionMainType = transactionType;

                  _transactionHistoryBloc.add(
                    SetTransactionHistoryFilter(
                      transactionHistoryFilter: state.transactionHistoryFilter.copyWith(
                        transactionMainType: _selectedTransactionMainType,
                      ),
                    ),
                  );

                  setState(() {});
                },
                onSelectedDateFilter: (selectedDateFilter) {
                  setState(() {
                    _selectedDate = selectedDateFilter;
                  });
                },
                onChangedStartEndDate: (startDate, endDate) {
                  setState(() {
                    _startDate = startDate;
                    _endDate = endDate;

                    if (_startDate!.isAfter(_endDate!)) {
                      _endDate = _startDate!.add(
                        const Duration(days: 1),
                      );
                    }
                    if (endDate.isBefore(startDate)) {
                      _startDate = endDate.subtract(
                        const Duration(days: 1),
                      );
                    }

                    _transactionHistoryBloc.add(
                      SetTransactionHistoryFilter(
                        transactionHistoryFilter: state.transactionHistoryFilter.copyWith(
                          startDate: _startDate,
                          endDate: endDate,
                        ),
                      ),
                    );
                  });
                },
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (state.transactionHistoryFilter.account != null)
                      TransactionHistoryFilteredWidget(
                        text: L10n.tr(
                          state.transactionHistoryFilter.account!.accountId,
                        ),
                        onTap: () {
                          _transactionHistoryBloc.add(
                            SetTransactionHistoryFilter(
                              transactionHistoryFilter: state.transactionHistoryFilter.clearAccount(),
                              fetchTransactionHistory: state.transactionHistoryFilter.americanStockExchanges == null,
                            ),
                          );
                        },
                      ),
                    if (state.transactionHistoryFilter.transactionType != null)
                      TransactionHistoryFilteredWidget(
                        text: L10n.tr(
                          state.transactionHistoryFilter.transactionType!.localizationKey,
                        ),
                        onTap: () {
                          _transactionHistoryBloc.add(
                            SetTransactionHistoryFilter(
                              transactionHistoryFilter: state.transactionHistoryFilter.clearTransactionType(),
                              fetchTransactionHistory: state.transactionHistoryFilter.americanStockExchanges == null,
                            ),
                          );
                        },
                      ),
                    if (state.transactionHistoryFilter.transactionMainType != null)
                      TransactionHistoryFilteredWidget(
                        text: L10n.tr(
                          state.transactionHistoryFilter.transactionMainType!.name,
                        ),
                        onTap: () {
                          _transactionHistoryBloc.add(
                            SetTransactionHistoryFilter(
                              transactionHistoryFilter: state.transactionHistoryFilter.clearTransactionMainType(),
                              fetchTransactionHistory: state.transactionHistoryFilter.americanStockExchanges == null,
                            ),
                          );

                          _selectedTransactionMainType = TransactionMainTypeEnum.all;

                          setState(() {});
                        },
                      ),
                    if (state.transactionHistoryFilter.finInstName != null)
                      TransactionHistoryFilteredWidget(
                        text: state.transactionHistoryFilter.finInstName!,
                        onTap: () {
                          _transactionHistoryBloc.add(
                            SetTransactionHistoryFilter(
                              transactionHistoryFilter: state.transactionHistoryFilter.clearFinInstName(),
                              fetchTransactionHistory: state.transactionHistoryFilter.americanStockExchanges == null,
                            ),
                          );
                        },
                      ),
                    if (_selectedDate == DateFilterMultiEnum.sumaryDateRange &&
                        state.transactionHistoryFilter.startDate != null &&
                        state.transactionHistoryFilter.endDate != null)
                      TransactionHistoryFilteredWidget(
                        text:
                            '${state.transactionHistoryFilter.startDate!.formatDayMonthYearDot()}-${state.transactionHistoryFilter.endDate!.formatDayMonthYearDot()}',
                        onTap: () {
                          _transactionHistoryBloc.add(
                            SetTransactionHistoryFilter(
                              transactionHistoryFilter: state.transactionHistoryFilter.clearDateRange(),
                              fetchTransactionHistory: state.transactionHistoryFilter.americanStockExchanges == null,
                            ),
                          );

                          _selectedDate = DateFilterMultiEnum.sumaryToday;

                          setState(() {});
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(
                height: Grid.s,
              ),
              Expanded(
                child: state.transactionHistory.isEmpty && state.isSuccess
                    ? Center(
                        child: NoDataWidget(
                          message: L10n.tr('no_transaction_history_found'),
                          iconName: ImagesPath.telescope_on,
                        ),
                      )
                    : ListView.builder(
                        controller: _controller,
                        shrinkWrap: true,
                        itemCount: state.transactionHistory.keys.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          final String date = state.transactionHistory.keys.elementAt(index).toString();

                          return StickyHeader(
                            header: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(
                                top: Grid.s,
                                bottom: Grid.s,
                              ),
                              decoration: BoxDecoration(
                                color: context.pColorScheme.backgroundColor,
                                border: Border(
                                  bottom: BorderSide(
                                    color: context.pColorScheme.textSecondary,
                                    width: 0.2,
                                  ),
                                  top: BorderSide(
                                    color: context.pColorScheme.textSecondary,
                                    width: 0.2,
                                  ),
                                ),
                              ),
                              child: Text(
                                date,
                                style: context.pAppStyle.labelMed14textSecondary,
                              ),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...List.generate(
                                  state.transactionHistory[date]?.length ?? 0,
                                  (index) => TransactionTypeCard(
                                    data: state.transactionHistory[date]![index],
                                    hasDivider: state.transactionHistory[date]![index].length - 1 != index,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
