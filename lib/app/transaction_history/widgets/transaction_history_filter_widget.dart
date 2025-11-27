import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/transaction_history/model/transaction_history_main_type_enum.dart';
import 'package:piapiri_v2/app/transaction_history/model/transaction_history_type_enum.dart';
import 'package:piapiri_v2/app/transaction_history/widgets/transaction_history_multi_filter_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/date_filter_multi_selection.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/account_model.dart';
import 'package:piapiri_v2/core/model/account_statement_date_filter_enum.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class TransactionHistoryFilterWidget extends StatelessWidget {
  final TransactionMainTypeEnum selectedTransactionMainType;
  final DateFilterMultiEnum selectedDate;
  final Function(TransactionMainTypeEnum) onSelectTransactionMainType;
  final Function(DateTime, DateTime) onChangedStartEndDate;
  final Function(DateFilterMultiEnum) onSelectedDateFilter;
  final Function(TransactionHistoryTypeEnum?, AccountModel?) onSelectedTransactionTypeAndAccount;
  final Function(String) onSelectedSymbol;

  const TransactionHistoryFilterWidget({
    super.key,
    required this.selectedTransactionMainType,
    required this.onSelectTransactionMainType,
    required this.selectedDate,
    required this.onChangedStartEndDate,
    required this.onSelectedDateFilter,
    required this.onSelectedTransactionTypeAndAccount,
    required this.onSelectedSymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: Row(
                children: [
                  PCustomOutlinedButtonWithIcon(
                    text: L10n.tr('filtrele'),
                    iconSource: ImagesPath.chevron_down,
                    onPressed: () {
                      PBottomSheet.show(
                        context,
                        title: L10n.tr('filtrele'),
                        child: TransactionHistoryMultiFilterWidget(
                          selectedTransactionMainType: selectedTransactionMainType,
                          onSelectedTransactionTypeAndAccount: (transactionType, account) {
                            onSelectedTransactionTypeAndAccount(transactionType, account);
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    width: Grid.s,
                  ),
                  PCustomOutlinedButtonWithIcon(
                    text: L10n.tr(selectedTransactionMainType.name),
                    iconSource: ImagesPath.chevron_down,
                    onPressed: () {
                      PBottomSheet.show(
                        context,
                        title: L10n.tr('stock_exchanges'),
                        titlePadding: const EdgeInsets.only(
                          top: Grid.m,
                        ),
                        child: ListView.separated(
                          itemCount: TransactionMainTypeEnum.values.length,
                          separatorBuilder: (context, index) => const Divider(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return BottomsheetSelectTile(
                              title: L10n.tr(
                                TransactionMainTypeEnum.values[index].name,
                              ),
                              isSelected: selectedTransactionMainType == TransactionMainTypeEnum.values[index],
                              value: TransactionMainTypeEnum.values[index],
                              onTap: (title, value) {
                                onSelectTransactionMainType(value);

                                router.maybePop();
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    width: Grid.s,
                  ),
                  DateFilterMultiSelection(
                    selectedDate: selectedDate,
                    isSelectedDate: true,
                    onChangedStartEndDate: (startDate, endDate) {
                      onChangedStartEndDate(startDate, endDate);
                    },
                    differenceDay: 30,
                    onSelectedDateFilter: (selectedDateFilter) {
                      onSelectedDateFilter(selectedDateFilter);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          width: Grid.xs,
        ),
        InkWell(
          onTap: () {
            router.push(
              SymbolSearchRoute(
                appBarTitle: L10n.tr('symbol'),
                showExchangesFilter: false,
                onTapSymbol: (List<SymbolModel> searchedSymbol) {
                  onSelectedSymbol(searchedSymbol[0].name);

                  router.maybePop();
                },
              ),
            );
          },
          child: SvgPicture.asset(
            ImagesPath.search,
            width: 23,
            height: 23,
          ),
        ),
      ],
    );
  }
}
