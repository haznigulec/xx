import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:piapiri_v2/app/balance/pages/balance_page.dart';
import 'package:piapiri_v2/app/dividend/bloc/dividend_bloc.dart';
import 'package:piapiri_v2/app/dividend/bloc/dividend_state.dart';
import 'package:piapiri_v2/app/dividend/widgets/symbol_dividend_history_widget.dart';
import 'package:piapiri_v2/app/income/pages/income_page.dart';
import 'package:piapiri_v2/common/widgets/tab_controller/model/tab_bar_item.dart';
import 'package:piapiri_v2/common/widgets/tab_controller/tab_controllers/p_sub_tab_bar_controller.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class SymbolFinancialPage extends StatefulWidget {
  final MarketListModel marketListModel;

  const SymbolFinancialPage({
    super.key,
    required this.marketListModel,
  });

  @override
  State<SymbolFinancialPage> createState() => _SymbolFinancialPageState();
}

class _SymbolFinancialPageState extends State<SymbolFinancialPage> {
  late final DividendBloc _dividendBloc;
  @override
  void initState() {
    _dividendBloc = getIt<DividendBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<DividendBloc, DividendState>(
      bloc: _dividendBloc,
      builder: (context, state) => PSubTabController(
        tabList: [
          PTabItem(
            title: L10n.tr('bilanco'),
            page: BalancePage(
              marketListModel: widget.marketListModel,
            ),
          ),
          PTabItem(
            title: L10n.tr('gelir_tablosu'),
            page: IncomePage(
              marketListModel: widget.marketListModel,
            ),
          ),
          if (!(_dividendBloc.state.symbolDividend == null || _dividendBloc.state.symbolDividend?.perShare == 0))
            PTabItem(
              title: L10n.tr('dividend'),
              page: state.symbolDividendHistories?.isNotEmpty == false
                  ? NoDataWidget(
                      message: L10n.tr('dividend_no_data_message'),
                    )
                  : SymbolDividendHistoryWidget(
                      dividendList: state.symbolDividendHistories,
                    ),
            ),
        ],
      ),
    );
  }
}
