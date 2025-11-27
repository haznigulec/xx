import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/pivot_analysis/bloc/pivot_bloc.dart';
import 'package:piapiri_v2/app/pivot_analysis/bloc/pivot_event.dart';
import 'package:piapiri_v2/app/pivot_analysis/bloc/pivot_state.dart';
import 'package:piapiri_v2/app/pivot_analysis/widgets/pivot_resistance_tile.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class PivotAnalysisPage extends StatefulWidget {
  final MarketListModel symbol;
  final SymbolTypes type;

  const PivotAnalysisPage({
    super.key,
    required this.symbol,
    required this.type,
  });

  @override
  State<PivotAnalysisPage> createState() => _PivotAnalysisPageState();
}

class _PivotAnalysisPageState extends State<PivotAnalysisPage> {
  late PivotBloc _pivotBloc;
  @override
  initState() {
    _pivotBloc = getIt<PivotBloc>();
    _pivotBloc.add(
      GetPivotAnalysisEvent(
        symbol: widget.symbol.symbolCode,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PivotBloc, PivotState>(
      bloc: _pivotBloc,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              L10n.tr('pivot_analysis'),
              style: context.pAppStyle.labelMed18textPrimary,
            ),
            const SizedBox(height: Grid.s + Grid.xs),
            Row(
              children: [
                Text(
                  L10n.tr('pivot'),
                  style: context.pAppStyle.labelReg14textSecondary,
                ),
                const Spacer(),
                Text(
                  '${MoneyUtils().getCurrency(widget.type)}${MoneyUtils().readableMoney(state.pivotAnalysis?.pivot ?? 0)}',
                  style: context.pAppStyle.labelMed14textPrimary,
                ),
              ],
            ),
            const SizedBox(height: Grid.s + Grid.xs),
            PivotResistanceTile(
              index: 1,
              pivotResistance: state.pivotAnalysis?.resistance1 ?? 0,
              pivotSupport: state.pivotAnalysis?.support1 ?? 0,
              type: widget.type,
            ),
            const SizedBox(height: Grid.s),
            PivotResistanceTile(
              index: 2,
              pivotResistance: state.pivotAnalysis?.resistance2 ?? 0,
              pivotSupport: state.pivotAnalysis?.support2 ?? 0,
              type: widget.type,
            ),
            const SizedBox(height: Grid.s),
            PivotResistanceTile(
              index: 3,
              pivotResistance: state.pivotAnalysis?.resistance3 ?? 0,
              pivotSupport: state.pivotAnalysis?.support3 ?? 0,
              type: widget.type,
            ),
            const SizedBox(
              height: Grid.l,
            ),
          ],
        );
      },
    );
  }
}
