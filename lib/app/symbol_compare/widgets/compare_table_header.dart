import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_compare/compare_constants.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class CompareTableHeader extends StatelessWidget {
  final SymbolTypes symbolType;
  const CompareTableHeader({
    super.key,
    required this.symbolType,
  });

  @override
  Widget build(BuildContext context) {
    List<String> headers;
    if (symbolType == SymbolTypes.fund) {
      headers = CompareConstants().fundHeaders;
    } else if (symbolType == SymbolTypes.foreign) {
      headers = CompareConstants().usHeaders;
    } else {
      headers = CompareConstants().bistHeaders;
    }
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: headers
            .map(
              (row) => Container(
                height: CompareConstants().cellHeight.toDouble(),
                padding: const EdgeInsets.only(right: Grid.m),
                alignment: Alignment.centerLeft,
                child: Text(
                  L10n.tr(row),
                  style: context.pAppStyle.labelReg14textPrimary,
                ),
              ),
            )
            .expand((widget) => [widget, const PDivider()])
            .toList()
          ..removeLast(),
      ),
    );
  }
}
