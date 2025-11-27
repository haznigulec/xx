import 'package:piapiri_v2/common/widgets/tab_controller/model/tab_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/booklet/bloc/booklet_bloc.dart';
import 'package:piapiri_v2/app/booklet/bloc/booklet_event.dart';
import 'package:piapiri_v2/app/booklet/pages/booklet_tab.dart';
import 'package:piapiri_v2/app/brokerage_distribution/page/brokerage_distribution_page.dart';
import 'package:piapiri_v2/app/depth/bloc/depth_bloc.dart';
import 'package:piapiri_v2/app/depth/bloc/depth_event.dart' as depth_event;
import 'package:piapiri_v2/app/depth/pages/depth_tab.dart';
import 'package:piapiri_v2/app/stage_analysis/page/stage_analysis_page.dart';
import 'package:piapiri_v2/common/widgets/tab_controller/tab_controllers/p_sub_tab_bar_controller.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class SymbolData extends StatefulWidget {
  final MarketListModel symbol;
  const SymbolData({
    super.key,
    required this.symbol,
  });

  @override
  State<SymbolData> createState() => _SymbolDataState();
}

class _SymbolDataState extends State<SymbolData> {
  @override
  void dispose() {
    super.dispose();
    getIt<DepthBloc>().add(
      depth_event.DisconnectEvent(),
    );
    getIt<BookletBloc>().add(
      DisconnectEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    SymbolTypes symbolType = stringToSymbolType(widget.symbol.type);

    return PSubTabController(
      
      tabList: [
        PTabItem(
          title: L10n.tr('derinlik'),
          page: DepthTab(
            symbol: widget.symbol,
          ),
        ),
        PTabItem(
          title: L10n.tr('kademe_analizi'),
          page: StageAnalysisPage(symbol: widget.symbol),
        ),
        if (symbolType == SymbolTypes.equity || symbolType == SymbolTypes.warrant)
          PTabItem(
            title: L10n.tr('emir_defteri'),
            page: BookletTab(symbol: widget.symbol),
        ),
        PTabItem(
          title: L10n.tr('brokerage_distribution'),
          page: BrokerageDistributionPage(
            marketListModel: widget.symbol,
          ),
        ),
      ],
    );
  }
}
