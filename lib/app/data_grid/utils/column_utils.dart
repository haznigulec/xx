import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/settings_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ColumnUtils {
  static List<GridColumn> generateColumns(
    BuildContext context, {
    required List<SettingsModel> source,
    bool showAdd = false,
    bool hasAddToList = false,
    bool hasMenuButton = true,
    Function()? onTapAdd,
    required String symbolKey,
  }) {
    List<GridColumn> columns = [];
    source.sort((a, b) => a.order.compareTo(b.order));

    for (var columnName in source) {
      GridColumn gridColumn = GridColumn(
        columnWidthMode: ColumnWidthMode.fill,
        columnName: columnName.key,
        allowSorting: columnName.key == symbolKey,
        label: Container(
          alignment:
              columnName.key == symbolKey || columnName.key == 'graphic' ? Alignment.centerLeft : Alignment.centerRight,
          padding: EdgeInsets.only(
            right: Grid.s,
            left: (columnName.key == symbolKey || columnName.key == 'graphic') ? Grid.s : 0,
          ),
          child: Row(
            mainAxisAlignment: columnName.key == symbolKey ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              Text(
                maxLines: 2,
                L10n.tr(columnName.key),
                overflow: TextOverflow.ellipsis,
                style: context.pAppStyle.labelMed12textSecondary,
              ),
              if (columnName.key == symbolKey) ...[
                const SizedBox(
                  width: Grid.xs,
                ),
                SvgPicture.asset(
                  height: 14,
                  width: 14,
                  ImagesPath.arrows_down_up,
                  colorFilter: ColorFilter.mode(
                    context.pColorScheme.textSecondary,
                    BlendMode.srcIn,
                  ),
                )
              ],
            ],
          ),
        ),
      );
      columns.add(gridColumn);
    }
    return columns;
  }

  static List<GridColumn> generateFundColumns(
    BuildContext context, {
    required List<SettingsModel> source,
    required String sortKey,
    required DataGridSortDirection sortDirection,
    bool showAdd = false,
    bool hasAddToList = false,
    bool hasMenuButton = true,
    Function()? onTapAdd,
    VoidCallback? callBack,
    required String symbolKey,
  }) {
    List<GridColumn> columns = [];
    source.sort((a, b) => a.order.compareTo(b.order));
    for (var columnName in source) {
      GridColumn gridColumn = GridColumn(
        columnWidthMode: ColumnWidthMode.fill,
        columnName: columnName.key,
        allowSorting: true,
        label: Container(
          alignment: columnName.key == symbolKey ? Alignment.centerLeft : Alignment.centerRight,
          padding: EdgeInsets.only(right: Grid.xs, left: columnName.key == symbolKey ? Grid.s : 0),
          child: Text(
            textAlign: TextAlign.left,
            maxLines: 2,
            L10n.tr(columnName.key),
            overflow: TextOverflow.ellipsis,
            style: context.pAppStyle.interMediumBase.copyWith(fontSize: Grid.s + Grid.xs),
          ),
        ),
      );
      columns.add(gridColumn);
    }
    return columns;
  }

  static List<GridColumn> generateRankerColumns(BuildContext context, List<String> columnNames) {
    bool isVolume = columnNames.contains('volumePercent');
    List<GridColumn> columns = [
      GridColumn(
        columnName: 'key',
        label: Container(
          padding: const EdgeInsets.only(right: Grid.s, left: Grid.s),
          alignment: Alignment.centerLeft,
          child: Text(
            L10n.tr('symbol'),
            overflow: TextOverflow.ellipsis,
            style: context.pAppStyle.interMediumBase.copyWith(fontSize: Grid.s + Grid.xs),
          ),
        ),
        columnWidthMode: ColumnWidthMode.fill,
      ),
    ];
    if (isVolume) {
      columns.add(
        GridColumn(
          columnName: 'volumePercent',
          label: Container(
            padding: const EdgeInsets.only(right: Grid.s),
            alignment: Alignment.centerRight,
            child: Text(
              L10n.tr('volume'),
              overflow: TextOverflow.ellipsis,
              style: context.pAppStyle.interMediumBase.copyWith(fontSize: Grid.s + Grid.xs),
            ),
          ),
          columnWidthMode: ColumnWidthMode.fill,
        ),
      );
    } else {
      columns.add(
        GridColumn(
          columnName: 'value',
          label: Container(
            padding: const EdgeInsets.only(right: Grid.s),
            alignment: Alignment.centerRight,
            child: Text(
              '%${L10n.tr('fark')}',
              overflow: TextOverflow.ellipsis,
              style: context.pAppStyle.interMediumBase.copyWith(fontSize: Grid.s + Grid.xs),
            ),
          ),
          columnWidthMode: ColumnWidthMode.fill,
        ),
      );
    }
    return columns;
  }

  /// Returns the background color of the cell according to the difference percentage.
  Color getGridBoxColor(BuildContext context, double difference) {
    if (difference == 0) {
      return context.pColorScheme.iconPrimary.withAlpha((.5 * 255).toInt());
    }
    double diffOpacity = (1 - ((10 - difference.ceil().abs()) * 0.05)).clamp(0.0, 1.0);
    if (difference < 0) {
      return context.pColorScheme.critical.withAlpha((diffOpacity * 255).toInt());
    } else {
      return context.pColorScheme.success.withAlpha((diffOpacity * 255).toInt());
    }
  }
}
