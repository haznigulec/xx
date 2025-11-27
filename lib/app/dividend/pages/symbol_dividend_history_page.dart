import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/dividend/widgets/symbol_dividend_history_widget.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/model/symbol_dividend_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class SymbolDividendHistoryPage extends StatelessWidget {
  final String symbol;
  final List<SymbolDividendModel>? dividendList;
  const SymbolDividendHistoryPage({
    super.key,
    required this.symbol,
    required this.dividendList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('symbol_dividend_history'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Grid.m + Grid.xs,
          horizontal: Grid.m,
        ),
        child: dividendList?.isNotEmpty == false
            ? NoDataWidget(
                message: L10n.tr('no_data'),
              )
            : SymbolDividendHistoryWidget(dividendList: dividendList),
      ),
    );
  }
}
