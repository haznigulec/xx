import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:piapiri_v2/app/data_grid/pages/bist_symbol_listing.dart';
import 'package:piapiri_v2/app/equity/widgets/equity_list_tile.dart';
import 'package:piapiri_v2/app/sectors/bloc/sectors_bloc.dart';
import 'package:piapiri_v2/app/sectors/bloc/sectors_event.dart';
import 'package:piapiri_v2/app/sectors/bloc/sectors_state.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/sector_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

@RoutePage()
class SectorsPage extends StatefulWidget {
  final SectorModel sectorModel;
  final List<String> selectedFilterKeys;
  final List<String> ignoreUnsubList;
  const SectorsPage({
    super.key,
    required this.sectorModel,
    this.selectedFilterKeys = const [],
    this.ignoreUnsubList = const [],
  });

  @override
  State<SectorsPage> createState() => _SectorsPageState();
}

class _SectorsPageState extends State<SectorsPage> {
  final SectorsBloc _sectorsBloc = getIt<SectorsBloc>();
  final List<String> _selectedFilterKeys = [];

  @override
  void initState() {
    _selectedFilterKeys.addAll(widget.selectedFilterKeys);
    if (_selectedFilterKeys.isNotEmpty) {
      _sectorsBloc.add(
        UpdateSelectedSectorKeysEvent(
          selectedFilterKeys: _selectedFilterKeys,
        ),
      );
    }
    _sectorsBloc.add(
      GetEquityListBySectorEvent(
        sectorGroupName: widget.sectorModel.groupName,
        sectorList: _selectedFilterKeys.isEmpty ? widget.sectorModel.sectors : _selectedFilterKeys,
      ),
    );
    super.initState();
  }

  @override
  dispose() {
    _sectorsBloc.add(
      OnDisposeEvent(),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<SectorsBloc, SectorsState>(
      bloc: _sectorsBloc,
      builder: (context, state) {
        List<String> allSectors = [];
        if (_selectedFilterKeys.isNotEmpty) {
          allSectors.addAll(_selectedFilterKeys);
          allSectors.addAll(widget.sectorModel.sectors.where((e) => !_selectedFilterKeys.contains(e)).toList());
        } else {
          allSectors.addAll(widget.sectorModel.sectors);
        }

        final int itemsPerRow = allSectors.length < 3 ? allSectors.length : (allSectors.length / 2).ceil();

        return Scaffold(
          appBar: PInnerAppBar(
            title: L10n.tr(widget.sectorModel.groupName),
          ),
          body: state.isLoading
              ? const Center(
                  child: PLoading(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: Grid.m + Grid.xs,
                    ),
                    if (allSectors.length > 1) ...[
                      SizedBox(
                        height: 33,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Grid.m,
                            ),
                            child: Row(
                              spacing: Grid.s,
                              children: List.generate(
                                itemsPerRow,
                                (index) => PCustomOutlinedButtonWithIcon(
                                  text: L10n.tr('bist.sector.${allSectors[index]}'),
                                  icon: _selectedFilterKeys.contains(allSectors[index])
                                      ? Icon(
                                          Icons.close,
                                          color: context.pColorScheme.primary,
                                          size: Grid.m,
                                        )
                                      : null,
                                  iconAlignment: IconAlignment.end,
                                  foregroundColorApllyBorder: false,
                                  foregroundColor: _selectedFilterKeys.contains(allSectors[index])
                                      ? context.pColorScheme.primary
                                      : null,
                                  backgroundColor: _selectedFilterKeys.contains(allSectors[index])
                                      ? context.pColorScheme.secondary
                                      : null,
                                  buttonType: PCustomOutlinedButtonTypes.smallPrimary,
                                  onPressed: () {
                                    setState(() {
                                      if (_selectedFilterKeys.contains(allSectors[index])) {
                                        _selectedFilterKeys.remove(allSectors[index]);
                                      } else {
                                        _selectedFilterKeys.add(allSectors[index]);
                                      }
                                    });
                                    _sectorsBloc.add(
                                      UpdateSelectedSectorKeysEvent(
                                        selectedFilterKeys: _selectedFilterKeys,
                                      ),
                                    );
                                    _sectorsBloc.add(
                                      GetEquityListBySectorEvent(
                                        sectorGroupName: widget.sectorModel.groupName,
                                        sectorList: _selectedFilterKeys,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (allSectors.length > itemsPerRow) ...[
                        SizedBox(
                          height: 33,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Grid.m,
                              ),
                              child: Row(
                                spacing: Grid.s,
                                children: List.generate(
                                  allSectors.length - itemsPerRow,
                                  (index) => PCustomOutlinedButtonWithIcon(
                                    text: L10n.tr('bist.sector.${allSectors[itemsPerRow + index]}'),
                                    icon: _selectedFilterKeys.contains(allSectors[itemsPerRow + index])
                                        ? Icon(
                                            Icons.close,
                                            color: context.pColorScheme.primary,
                                            size: Grid.m,
                                          )
                                        : null,
                                    iconAlignment: IconAlignment.end,
                                    foregroundColorApllyBorder: false,
                                    foregroundColor: _selectedFilterKeys.contains(allSectors[itemsPerRow + index])
                                        ? context.pColorScheme.primary
                                        : null,
                                    backgroundColor: _selectedFilterKeys.contains(allSectors[itemsPerRow + index])
                                        ? context.pColorScheme.secondary
                                        : null,
                                    buttonType: PCustomOutlinedButtonTypes.smallPrimary,
                                    onPressed: () {
                                      setState(() {
                                        if (_selectedFilterKeys.contains(allSectors[itemsPerRow + index])) {
                                          _selectedFilterKeys.remove(allSectors[itemsPerRow + index]);
                                        } else {
                                          _selectedFilterKeys.add(allSectors[itemsPerRow + index]);
                                        }
                                      });
                                      _sectorsBloc.add(
                                        UpdateSelectedSectorKeysEvent(
                                          selectedFilterKeys: _selectedFilterKeys,
                                        ),
                                      );
                                      _sectorsBloc.add(
                                        GetEquityListBySectorEvent(
                                          sectorGroupName: widget.sectorModel.groupName,
                                          sectorList: _selectedFilterKeys,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                    const SizedBox(
                      height: Grid.m,
                    ),
                    SlidableAutoCloseBehavior(
                      child: Expanded(
                        child: BistSymbolListing(
                          key: ValueKey(
                              'SECTORS_${widget.sectorModel.groupName}_${state.selectedBistSectorKeys.join('_')}'),
                          symbols: state.bistSymbolList,
                          ignoreUnsubList: widget.ignoreUnsubList,
                          columns: [
                            L10n.tr('equity_column_symbol'),
                            L10n.tr('equity_column_difference'),
                            L10n.tr('equity_column_last_price'),
                          ],
                          columnsSpacingIsEqual: true,
                          horizontalPadding: Grid.m,
                          itemBuilder: (symbol, controller) => EquityListTile(
                            key: ValueKey(symbol.symbolCode),
                            controller: controller,
                            symbol: symbol,
                            onTap: () => router.push(
                              SymbolDetailRoute(
                                symbol: symbol,
                                ignoreDispose: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: Grid.m,
                    ),
                  ],
                ),
        );
      },
    );
  }
}
