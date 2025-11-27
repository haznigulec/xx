import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_bloc.dart';
import 'package:piapiri_v2/app/depth/bloc/depth_bloc.dart';
import 'package:piapiri_v2/app/depth/bloc/depth_event.dart';
import 'package:piapiri_v2/app/depth/bloc/depth_state.dart';
import 'package:piapiri_v2/app/depth/widgets/depth_row.dart';
import 'package:piapiri_v2/app/depth/widgets/depth_title.dart';
import 'package:piapiri_v2/app/license/bloc/license_bloc.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/p_expandable_panel.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/api/model/proto_model/depthstats/depthstats_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_state.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/gen/DepthTable/DepthTable.pb.dart';
import 'package:piapiri_v2/core/model/depth_type_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class DepthPage extends StatefulWidget {
  final MarketListModel symbol;
  const DepthPage({
    super.key,
    required this.symbol,
  });

  @override
  State<DepthPage> createState() => _DepthPageState();
}

class _DepthPageState extends State<DepthPage> {
  bool _isDepthExpanded = true;
  late String _selectedStageName;
  final List<int> _stageList = [];
  bool _isDepthStatsEnabled = false;
  bool _isDepthExtendedEnabled = false;
  final MatriksState _matriksState = getIt<MatriksBloc>().state;
  final DepthBloc _depthBloc = getIt<DepthBloc>();
  final AppSettingsBloc _appSettingsBloc = getIt<AppSettingsBloc>();
  final LicenseBloc _licenseBloc = getIt<LicenseBloc>();
  @override
  void initState() {
    SymbolTypes symbolType = stringToSymbolType(widget.symbol.type);
    int totalStage = 1;

    if (symbolType == SymbolTypes.future || symbolType == SymbolTypes.option) {
      _isDepthExtendedEnabled = _licenseBloc.state.isViopDepthExtendedEnabled;
      totalStage = _licenseBloc.state.totalViopStage;
    } else {
      _isDepthExtendedEnabled = _licenseBloc.state.isDepthExtendedEnabled;
      totalStage = _licenseBloc.state.totalStage;
    }
    _isDepthStatsEnabled = _matriksState.topics['mqtt']['depthstats'] != null;

    int depthCount = _appSettingsBloc.state.orderSettings.depthCount;
    if (depthCount > totalStage && !_isDepthExtendedEnabled) {
      depthCount = totalStage;
    }
    _depthBloc.add(
      ConnectDepthEvent(
        symbol: widget.symbol,
        isDepthStatsEnabled: _isDepthStatsEnabled,
        isDepthExtendedEnabled: _isDepthExtendedEnabled,
        stage: depthCount,
      ),
    );

    _selectedStageName = '$depthCount ${L10n.tr('stage')}';
    _stageList.addAll(List<int>.generate(totalStage, (index) => index + 1));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PExpandablePanel(
      initialExpanded: _isDepthExpanded,
      isExpandedChanged: (isExpanded) => setState(() => _isDepthExpanded = isExpanded),
      animationDuration: const Duration(milliseconds: 0),
      titleBuilder: (_) => Row(
        children: [
          Text(
            L10n.tr('derinlik'),
            style: context.pAppStyle.labelMed16textPrimary,
          ),
          const SizedBox(width: Grid.xs),
          SvgPicture.asset(
            _isDepthExpanded ? ImagesPath.chevron_up : ImagesPath.chevron_down,
            height: 16,
            width: 16,
            colorFilter: ColorFilter.mode(
              context.pColorScheme.textPrimary,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: Grid.s + Grid.xs,
          ),
          BottomsheetButton(
            title: _selectedStageName,
            onPressed: () {
              PBottomSheet.show(
                context,
                title: L10n.tr('derinlik'),
                child: SizedBox(
                  height: 300,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _stageList.length,
                    itemBuilder: (context, index) {
                      return BottomsheetSelectTile(
                        title: '${_stageList[index]} ${L10n.tr('stage')}',
                        isSelected: _selectedStageName == '${_stageList[index]} ${L10n.tr('stage')}',
                        onTap: (selected, _) {
                          setState(() {
                            _selectedStageName = selected;
                          });
                          _depthBloc.add(
                            SetStageEvent(
                              symbol: widget.symbol,
                              stage: _stageList[index],
                            ),
                          );
                          router.maybePop();
                        },
                      );
                    },
                    separatorBuilder: (context, index) => const PDivider(),
                  ),
                ),
              );
            },
          ),
          PBlocBuilder<DepthBloc, DepthState>(
            bloc: _depthBloc,
            builder: (context, state) {
              if (state.isSuccess && (state.depth == null || state.depth!.bids.isEmpty)) {
                return NoDataWidget(
                  message: L10n.tr('no_data'),
                );
              }
              int bidsStage = state.stage;
              int asksStage = state.stage;
              int stage = state.stage;
              List<DepthCell> bids = [];
              List<DepthCell> asks = [];
              if (!(state.isLoading || state.isInitial)) {
                bidsStage = state.depth!.bids.length < state.stage ? state.depth!.bids.length : state.stage;
                asksStage = state.depth!.asks.length < state.stage ? state.depth!.asks.length : state.stage;
                bids = state.depth!.bids.sublist(0, bidsStage);
                asks = state.depth!.asks.sublist(0, asksStage);

                stage = bidsStage > asksStage ? bidsStage : asksStage;

                if (_isDepthExtendedEnabled && state.extendedStage > 0) {
                  int bidsExtStage = (state.depthExtended?.bids.length ?? 0) < state.stage
                      ? state.depthExtended?.bids.length ?? 0
                      : state.extendedStage;
                  int asksExtStage = (state.depthExtended?.asks.length ?? 0) < state.stage
                      ? state.depthExtended?.asks.length ?? 0
                      : state.extendedStage;
                  int extendedStage = bidsExtStage > asksExtStage ? bidsExtStage : asksExtStage;
                  bids.addAll(
                    (state.depthExtended?.bids ?? []).sublist(
                      0,
                      (state.depthExtended?.bids ?? []).length < bidsExtStage
                          ? state.depthExtended?.bids.length ?? 0
                          : bidsExtStage,
                    ),
                  );
                  asks.addAll(
                    (state.depthExtended?.asks ?? []).sublist(
                      0,
                      (state.depthExtended?.asks ?? []).length < asksExtStage
                          ? state.depthExtended?.asks.length ?? 0
                          : asksExtStage,
                    ),
                  );
                  stage += extendedStage;
                }
              }
              return Shimmerize(
                enabled: state.isLoading || state.isInitial,
                child: Column(
                  children: [
                    const SizedBox(height: Grid.s + Grid.xs),
                    const PDivider(),
                    const SizedBox(height: Grid.s + Grid.xs),
                    const DepthTitle(),
                    const SizedBox(height: Grid.s + Grid.xs),
                    const PDivider(),
                    const SizedBox(height: Grid.s),
                    ListView.builder(
                      key: Key('depth_list_$_selectedStageName'),
                      shrinkWrap: true,
                      itemCount: stage,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _generateRowData(
                          index > bids.length - 1 ? DepthCell() : bids[index],
                          index > asks.length - 1 ? DepthCell() : asks[index],
                        );
                      },
                    ),
                    _depthStats(
                      state.depthStats,
                      asks,
                      bids,
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _depthStats(
    DepthStats? value,
    List<DepthCell> asks,
    List<DepthCell> bids,
  ) {
    return _appSettingsBloc.state.orderSettings.depthType == DepthTypeEnum.total
        ? Builder(
            builder: (context) {
              if (value == null) return const SizedBox.shrink();

              Map<String, dynamic> data = {
                'alis_adet': value.totalBidQuantity,
                'alis': value.totalBidWAvg,
                'satis': value.totalAskWAvg,
                'satis_adet': value.totalAskQuantity,
              };

              return DepthRow(
                data: data,
                isStats: true,
              );
            },
          )
        : _depthStatsByStage(
            asks,
            bids,
          );
  }

  Widget _depthStatsByStage(
    List<DepthCell> asks,
    List<DepthCell> bids,
  ) {
    int bidOrderCount = 0;
    double bidOrderQuantity = 0.0;
    double bidOrderTotal = 0.0;
    int askOrderCount = 0;
    double askOrderQuantity = 0.0;
    double askOrderTotal = 0.0;

    for (var ask in asks) {
      askOrderCount += ask.orderCount.toInt();
      askOrderQuantity += ask.quantity.toDouble();
      askOrderTotal += ask.price.toDouble() * ask.quantity.toDouble();
    }

    for (var bid in bids) {
      bidOrderCount += bid.orderCount.toInt();
      bidOrderQuantity += bid.quantity.toDouble();
      bidOrderTotal += bid.price.toDouble() * bid.quantity.toDouble();
    }

    Map<String, dynamic> data = {
      'alis_emir': bidOrderCount,
      'alis_adet': bidOrderQuantity,
      'alis': bidOrderTotal / bidOrderQuantity,
      'satis': askOrderTotal / askOrderQuantity,
      'satis_adet': askOrderQuantity,
      'satis_emir': askOrderCount,
    };

    return DepthRow(
      data: data,
      isStats: true,
    );
  }

  Widget _generateRowData(DepthCell? bid, DepthCell? ask) {
    double bidQuantity = double.parse((bid?.quantity ?? 0).toString());
    double bidOrderCount = double.parse((bid?.orderCount ?? 0).toString());
    DateTime bidTime = DateTime.fromMillisecondsSinceEpoch(
      bid?.timestamp != null ? bid!.timestamp.toInt() : 0,
    );
    double bidPrice = bid?.price ?? 0;

    double askQuantity = double.parse((ask?.quantity ?? 0).toString());
    double askOrderCount = double.parse((ask?.orderCount ?? 0).toString());
    DateTime askTime = DateTime.fromMillisecondsSinceEpoch(
      ask?.timestamp != null ? ask!.timestamp.toInt() : 0,
    );
    double askPrice = ask?.price ?? 0;

    Map<String, dynamic> data = {
      'alis_emir': bidOrderCount,
      'alis_adet': bidQuantity,
      'alis_time': bidTime,
      'alis': bidPrice,
      'satis': askPrice,
      'satis_adet': askQuantity,
      'satis_time': askTime,
      'satis_emir': askOrderCount,
    };

    return DepthRow(
      data: data,
    );
  }
}
