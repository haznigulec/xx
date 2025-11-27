import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/transaction_history/model/transaction_history_abroad_type_enum.dart';
import 'package:piapiri_v2/app/transaction_history/model/transaction_history_type_enum.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/date_filter_multi_selection.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/account_statement_date_filter_enum.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class TransactionHistoryAbroadFilterWidget extends StatelessWidget {
  final DateFilterMultiEnum selectedDate;
  final TransactionHistoryTypeEnum selectedSide;
  final TransactionHistoryAbroadTypeEnum selectedType;
  final bool isSelectedType;
  final bool isSelectedSide;
  final bool isSelectedDate;
  final Function(DateTime, DateTime) onChangedStartEndDate;
  final Function(DateFilterMultiEnum) onSelectedDateFilter;
  final Function(TransactionHistoryTypeEnum) onSelectedSide;
  final Function(TransactionHistoryAbroadTypeEnum) onSelectedType;
  final Function(String) onSelectedSymbol;

  const TransactionHistoryAbroadFilterWidget({
    super.key,
    required this.selectedSide,
    required this.selectedDate,
    required this.selectedType,
    required this.isSelectedType,
    required this.isSelectedSide,
    required this.isSelectedDate,
    required this.onChangedStartEndDate,
    required this.onSelectedDateFilter,
    required this.onSelectedSide,
    required this.onSelectedType,
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
                    text: L10n.tr(selectedType.name),
                    iconSource: ImagesPath.chevron_down,
                    foregroundColorApllyBorder: false,
                    foregroundColor: isSelectedType ? context.pColorScheme.primary : null,
                    backgroundColor: isSelectedType ? context.pColorScheme.secondary : null,
                    onPressed: () {
                      PBottomSheet.show(
                        context,
                        title: L10n.tr('stock_exchanges'),
                        titlePadding: const EdgeInsets.only(
                          top: Grid.m,
                        ),
                        child: Column(
                          children: TransactionHistoryAbroadTypeEnum.values
                              .map(
                                (e) => BottomsheetSelectTile(
                                  title: L10n.tr(
                                    e.name,
                                  ),
                                  isSelected: selectedType == e,
                                  value: e,
                                  onTap: (title, value) {
                                    onSelectedType(value);

                                    router.maybePop();
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    width: Grid.s,
                  ),
                  PCustomOutlinedButtonWithIcon(
                    text: L10n.tr(selectedSide.localizationKey),
                    iconSource: ImagesPath.chevron_down,
                    foregroundColor: isSelectedType ? context.pColorScheme.primary : null,
                    backgroundColor: isSelectedType ? context.pColorScheme.secondary : null,
                    icon: SvgPicture.asset(
                      ImagesPath.chevron_down,
                      width: 15,
                      height: 15,
                      colorFilter: ColorFilter.mode(
                        isSelectedSide ? context.pColorScheme.primary : context.pColorScheme.textSecondary,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () {
                      PBottomSheet.show(
                        context,
                        title: L10n.tr('direction_of_transaction'),
                        titlePadding: const EdgeInsets.only(
                          top: Grid.m,
                        ),
                        child: Column(
                          children: TransactionHistoryTypeEnum.values
                              .map(
                                (e) => BottomsheetSelectTile(
                                  title: L10n.tr(
                                    e.localizationKey,
                                  ),
                                  isSelected: selectedSide == e,
                                  value: e,
                                  onTap: (title, value) {
                                    onSelectedSide(value);

                                    router.maybePop();
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    width: Grid.s,
                  ),
                  DateFilterMultiSelection(
                    selectedDate: selectedDate,
                    isSelectedDate: isSelectedDate,
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
        )
      ],
    );
  }
}
