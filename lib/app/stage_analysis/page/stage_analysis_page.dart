import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/license/bloc/license_bloc.dart';
import 'package:piapiri_v2/app/stage_analysis/bloc/stage_analysis_bloc.dart';
import 'package:piapiri_v2/app/stage_analysis/bloc/stage_analysis_event.dart';
import 'package:piapiri_v2/app/stage_analysis/bloc/stage_analysis_state.dart';
import 'package:piapiri_v2/app/stage_analysis/page/stage_analysis_no_license.dart';
import 'package:piapiri_v2/app/stage_analysis/widgets/stage_analysis_row.dart';
import 'package:piapiri_v2/app/stage_analysis/widgets/stage_analysis_title.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/stage_analysis_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class StageAnalysisPage extends StatefulWidget {
  final MarketListModel symbol;

  const StageAnalysisPage({
    super.key,
    required this.symbol,
  });

  @override
  State<StageAnalysisPage> createState() => _StageAnalysisPageState();
}

class _StageAnalysisPageState extends State<StageAnalysisPage> {
  final StageAnalysisBloc _stageAnalysisBloc = getIt<StageAnalysisBloc>();
  final LicenseBloc _licenseBloc = getIt<LicenseBloc>();
  bool _hasLicense = false;
  @override
  void initState() {
    SymbolTypes symbolType = stringToSymbolType(widget.symbol.type);

    if (symbolType == SymbolTypes.future || symbolType == SymbolTypes.option) {
      _hasLicense = _licenseBloc.state.isViopDepthEnabled;
    } else {
      _hasLicense = _licenseBloc.state.isDepthEnabled;
    }
    if (_hasLicense) {      
    _stageAnalysisBloc.add(
      StageAnalysisListEvent(
        symbol: widget.symbol.symbolCode,
      ),
    );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasLicense) {
      return const StageAnalysisNoLicense();
    }
    return PBlocBuilder<StageAnalysisBloc, StageAnalysisState>(
      bloc: _stageAnalysisBloc,
      builder: (context, state) {
        List<StageAnalysisModel> stageAnalysisList = [];
        stageAnalysisList.addAll(state.stageAnalysisList ?? []);

        stageAnalysisList.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));

        int totalUnit = stageAnalysisList.fold<int>(
          0,
          (a, b) => a + ((b.bidQuantity as int) + (b.askQuantity as int)),
        );

        if (state.isLoading) {
          return const PLoading();
        }

        if (state.stageAnalysisList == null || state.stageAnalysisList!.isEmpty) {
          return NoDataWidget(
            message: L10n.tr('no_stage_analysis'),
          );
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const StageAnalysisTitle(),
            Expanded(
              child: ListView.builder(
                itemCount: stageAnalysisList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return StageAnalysisRow(
                    stageAnalysisModel: stageAnalysisList[index],
                    symbolType: stringToSymbolType(widget.symbol.symbolType),
                    maxBidQuantity: stageAnalysisList
                            .map((e) => e.bidQuantity)
                            .toList()
                            .reduce((value, element) => (value ?? 0) > (element ?? 0) ? value : element) ??
                        0,
                    maxAskQuantity: stageAnalysisList
                            .map((e) => e.askQuantity)
                            .toList()
                            .reduce((value, element) => (value ?? 0) > (element ?? 0) ? value : element) ??
                        0,
                    totalUnit: totalUnit,
                  );
                },
              ),
            )
          ],
        );
      },
    );
  }
}
