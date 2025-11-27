import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/route/page_navigator.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_blockage_model.dart';
import 'package:piapiri_v2/app/ipo/widgets/demand_edit_widget.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class FinancialInstrumentDataSource extends DataGridSource {
  final String amountText;
  final DataGridController controller;
  final List<FinancialInstrument> financialInstrument;
  final int paymentTypeId;
  final Function(String) onChangeAmount;
  final MaterialColor dividerColor;
  final double? demandedAmount;

  FinancialInstrumentDataSource({
    required this.controller,
    required this.financialInstrument,
    required this.amountText,
    required this.paymentTypeId,
    required this.onChangeAmount,
    required this.dividerColor,
    required this.demandedAmount,
  }) {
    dataGridRows = financialInstrument
        .map<DataGridRow>(
          (dataGridRow) => DataGridRow(
            cells: [
              const DataGridCell<String>(
                columnName: 'checkbox',
                value: '',
              ),
              DataGridCell<String>(
                columnName: 'finInstName',
                value: paymentTypeId == 5 // fon iconları için eklenen kontrol
                    ? '${dataGridRow.founderCode}-${dataGridRow.finInstName.toString().split('-')[0]}'
                    : dataGridRow.finInstName,
              ),
              DataGridCell<double>(
                columnName: 'rationalAmount',
                value: dataGridRow.rationalAmount,
              ),
              DataGridCell<double>(
                columnName: 'demandAmount',
                value: dataGridRow.demandAmount,
              ),
            ],
          ),
        )
        .toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        bool isLast = row == dataGridRows.last;

        if (dataGridCell.columnName == 'checkbox') {
          // Checkbox
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(
              right: Grid.s,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: dividerColor,
                  width: isLast ? 0 : 1,
                ),
              ),
            ),
            child: Checkbox(
              activeColor: PageNavigator.globalContext!.pColorScheme.primary,
              value: controller.selectedRows.contains(row),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  Grid.xs,
                ),
              ),
              onChanged: (bool? value) {
                if (value == true) {
                  row.getCells()[3] = DataGridCell<double>(
                    columnName: 'demandAmount',
                    value: row.getCells()[2].value,
                  );
                  controller.selectedRows.add(row);
                } else {
                  row.getCells()[3] = DataGridCell<double>(
                    columnName: 'demandAmount',
                    value: row.getCells()[2].value,
                  );
                  controller.selectedRows.remove(row);
                }
                //_changeAmount yorum satırının sebebi; checkbox'a tıklar tıklamaz değeri, Girilen Tutar'a atamamak için daha sonra tekrar istenirse açılabilir.
                // _changeAmount();

                notifyListeners();
              },
            ),
          );
        }
        if (dataGridCell.columnName == 'demandAmount') {
          // Blokaj Tutarı
          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: dividerColor,
                  width: isLast ? 0 : 1,
                ),
              ),
            ),
            child: DemandEdit(
              enabled: controller.selectedRows.contains(row),
              // initialValue: MoneyUtils().readableMoney(row.getCells()[2].value), // yorum satırının sebebi; checkbox'a tıklar tıklamaz değeri, Girilen Tutar'a atamamak için daha sonra tekrar istenirse açılabilir.
              initialValue: MoneyUtils().readableMoney(0),
              onFieldChanged: (value) {
                row.getCells()[3] = DataGridCell<double>(
                  columnName: 'demandAmount',
                  value: MoneyUtils().fromReadableMoney(value),
                );
                _changeAmount();
              },
              onEditingComplete: () => notifyListeners(),
            ),
          );
        }
        if (dataGridCell.columnName == 'finInstName') {
          // Sembol
          return Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: dividerColor,
                  width: isLast ? 0 : 1,
                ),
              ),
            ),
            child: Row(
              spacing: Grid.xs,
              children: [
                SymbolIcon(
                  symbolName:
                      paymentTypeId == 5 ? dataGridCell.value.toString().split('-')[0] : '${dataGridCell.value}',
                  symbolType: paymentTypeId == 5
                      ? SymbolTypes.fund
                      : paymentTypeId == 4
                          ? SymbolTypes.foreign
                          : SymbolTypes.equity,
                  size: 15,
                ),
                Expanded(
                  child: Text(
                    //paymentTypeId == 5 için, sembol uzun geldiği için sadece kodu göstermek için eklenen kontrol.
                    paymentTypeId == 5 ? dataGridCell.value.toString().split('-')[1] : '${dataGridCell.value}',
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    style: PageNavigator.globalContext!.pAppStyle.labelReg14textPrimary,
                  ),
                ),
              ],
            ),
          );
        }

        // Bakiye
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            horizontal: Grid.s,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: dividerColor,
                width: isLast ? 0 : 1,
              ),
            ),
          ),
          child: Text(
            maxLines: 1,
            dataGridCell.columnName == 'rationalAmount'
                ? '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(double.parse(dataGridCell.value.toString()))}'
                : dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: PageNavigator.globalContext!.pAppStyle.labelMed14textPrimary,
          ),
        );
      }).toList(),
    );
  }

  void _changeAmount() {
    onChangeAmount(
      controller.selectedRows
          .fold<double>(
            0,
            (previousValue, element) => previousValue + element.getCells()[3].value,
          )
          .toString(),
    );
  }
}
