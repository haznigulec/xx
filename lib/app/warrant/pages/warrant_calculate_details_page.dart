import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_brief_info.dart';
import 'package:piapiri_v2/app/warrant/widgets/warrant_calculated_chart.dart';
import 'package:piapiri_v2/app/warrant/widgets/warrant_calculated_header.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/model/warrant_calculation_model.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class WarrantCalculateDetailsPage extends StatefulWidget {
  final WarrantCalculateDetailsModel calculateDetails;
  final SymbolModel symbol;
  const WarrantCalculateDetailsPage({
    super.key,
    required this.calculateDetails,
    required this.symbol,
  });

  @override
  State<WarrantCalculateDetailsPage> createState() => _WarrantCalculateDetailsPageState();
}

class _WarrantCalculateDetailsPageState extends State<WarrantCalculateDetailsPage> {
  List items = [
    L10n.tr('warrant_price'),
    L10n.tr('delta'),
    L10n.tr('gamma'),
    L10n.tr('theta'),
    L10n.tr('vega'),
  ];
  late List<Graph> graphList;
  late MatriksBloc _matriksBloc;
  late Map<String, dynamic> _data;
  late MarketListModel symbol;
  @override
  void initState() {
    _matriksBloc = getIt<MatriksBloc>();
    _data = {
      L10n.tr('instrinsic_value'):
          MoneyUtils().readableMoney(widget.calculateDetails.instrinsicValue.toDouble(), pattern: '#,##0.000'),
      L10n.tr('sensitivity'):
          MoneyUtils().readableMoney(widget.calculateDetails.sensitivity ?? 0, pattern: '#,##0.000'),
      L10n.tr('omega'): MoneyUtils().readableMoney(widget.calculateDetails.omega ?? 0),
      L10n.tr('break_even_price'): MoneyUtils().readableMoney(widget.calculateDetails.breakEvenPrice ?? 0),
      L10n.tr('delta'): MoneyUtils().readableMoney(widget.calculateDetails.delta ?? 0),
      L10n.tr('gamma'): MoneyUtils().readableMoney(widget.calculateDetails.gamma ?? 0),
      L10n.tr('theta'): MoneyUtils().readableMoney(widget.calculateDetails.theta ?? 0, pattern: '#,##0.000'),
      L10n.tr('vega'): MoneyUtils().readableMoney(widget.calculateDetails.vega ?? 0, pattern: '#,##0.000'),
      
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('warrant_calculator'),
      ),
      body: PBlocBuilder<MatriksBloc, MatriksState>(
        bloc: _matriksBloc,
        builder: (context, state) {
          if (state.isInitial || state.isLoading) {
            return const PLoading();
          }

          graphList = state.warrantCalculateDetails!.graph!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: Grid.m),
            child: Column(
              children: [
                WarrantCalculatedHeader(
                  symbol: widget.symbol,
                  calculateDetails: widget.calculateDetails,
                ),
                const SizedBox(
                  height: Grid.m + Grid.xs,
                ),
                const PDivider(),
                ...generateHederInfos(),
                const PDivider(),
                const SizedBox(
                  height: Grid.m + Grid.xs,
                ),
                WarrantCalculatedChart(
                  dataSource: graphList,
                ),
              ],
            ),
          );
        },
      ),
    );
  }


  List<Widget> generateHederInfos() {
    List<Widget> infos = [];

    for (var i = 0; i < 8; i += 2) {
      infos.add(
        SizedBox(
          height: 48,
          child: Row(
            children: [
              Expanded(
                child: SymbolBriefInfo(
                  label: _data.keys.elementAt(i),
                  value: _data.values.elementAt(i),
                ),
              ),
              Expanded(
                child: SymbolBriefInfo(
                  label: _data.keys.elementAt(i + 1),
                  value: _data.values.elementAt(i + 1),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return infos;
  }
}
