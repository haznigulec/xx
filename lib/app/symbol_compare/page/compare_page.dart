import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/tab_controller/model/tab_bar_item.dart';
import 'package:piapiri_v2/common/widgets/tab_controller/tab_controllers/p_main_tab_controller.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_compare/page/bist_compare_analysis_page.dart';
import 'package:piapiri_v2/app/symbol_compare/page/fund_compare_analysis_page.dart';
import 'package:piapiri_v2/app/symbol_compare/page/symbol_compare_page.dart';
import 'package:piapiri_v2/app/symbol_compare/page/us_compare_analysis_page.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/model/fund_model.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class ComparePage extends StatelessWidget {
  final String symbolName;
  final String underLyingName;
  final String? subType;
  final String description;
  final SymbolTypes symbolType;
  final FundDetailModel? fundDetailModel;
  final MarketListModel? marketListModel;

  const ComparePage({
    super.key,
    required this.symbolName,
    required this.underLyingName,
    this.subType,
    required this.description,
    required this.symbolType,
    this.fundDetailModel,
    this.marketListModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('symbol_compare'),
      ),
      body: PMainTabController(
        preloadAllTabs: true,
        tabs: [
          PTabItem(
            title: L10n.tr('graph'),
            page: SymbolComparePage(
              symbolName: symbolName,
              underLyingName: underLyingName,
              description: description,
              symbolType: symbolType,
            ),
          ),
          if (fundDetailModel != null)
            PTabItem(
              title: L10n.tr('compare_table'),
              page: FundCompareAnalysisPage(
                fundDetailModel: fundDetailModel!,
                symbolType: symbolType,
              ),
            ),
          if (symbolType == SymbolTypes.foreign)
            PTabItem(
              title: L10n.tr('compare_table'),
              page: UsCompareAnalysisPage(
                symbolName: symbolName,
                symbolType: symbolType,
              ),
            ),
          if (marketListModel != null)
            PTabItem(
              title: L10n.tr('compare_table'),
              page: BistCompareAnalysisPage(
                symbol: marketListModel!,
                symbolType: symbolType,
              ),
            ),
        ],
      ),
    );
  }
}
