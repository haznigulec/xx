import 'package:collection/collection.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/app/warrant/bloc/warrant_bloc.dart';
import 'package:piapiri_v2/app/warrant/bloc/warrant_event.dart';
import 'package:piapiri_v2/app/warrant/bloc/warrant_state.dart';
import 'package:piapiri_v2/app/warrant/widgets/warrant_filter_sheet.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/extension/string_extension.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/warrant_dropdown_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class WarrantFilter extends StatefulWidget {
  const WarrantFilter({
    super.key,
  });

  @override
  State<WarrantFilter> createState() => _WarrantFilterState();
}

class _WarrantFilterState extends State<WarrantFilter> {
  late WarrantBloc _warrantBloc;

  @override
  void initState() {
    _warrantBloc = getIt<WarrantBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<WarrantBloc, WarrantState>(
      bloc: _warrantBloc,
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                PCustomOutlinedButtonWithIcon(
                  text: L10n.tr('Filtrele'),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  iconSource: ImagesPath.chevron_down,
                  buttonType: PCustomOutlinedButtonTypes.smallPrimary,
                  onPressed: () {
                    PBottomSheet.show(
                      context,
                      title: L10n.tr('Filtrele'),
                      titlePadding: const EdgeInsets.only(
                        top: Grid.m,
                      ),
                      child: WarrantFilterSheet(
                        selectedMaturity: state.selectedMaturity,
                        selectedType: state.selectedType,
                        selectedRisk: state.selectedRisk,
                        onSetFilter: (maturity, risk, type) {
                          _warrantBloc.add(
                            OnApplyFilterEvent(
                              underlyingAsset: state.selectedUnderlyingAsset,
                              marketMaker: state.selectedMarketMaker,
                              risk: risk,
                              maturity: maturity,
                              type: type,
                            ),
                          );
                        },
                        maturityDateSet: state.maturityDateSet,
                      ),
                    );
                  },
                ),
                const SizedBox(
                  width: Grid.s,
                ),
                if (state.underlyingAssetList.isNotEmpty) ...[
                  PCustomOutlinedButtonWithIcon(
                    text: L10n.tr(state.selectedUnderlyingAsset),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    iconAlignment: IconAlignment.end,
                    foregroundColorApllyBorder: false,
                    foregroundColor: context.pColorScheme.primary,
                    backgroundColor: context.pColorScheme.secondary,
                    icon: SvgPicture.asset(
                      ImagesPath.chevron_down,
                      colorFilter: ColorFilter.mode(
                        context.pColorScheme.primary,
                        BlendMode.srcIn,
                      ),
                      width: 15,
                      height: 15,
                    ),
                    onPressed: () {
                      PBottomSheet.show(
                        maxHeight: MediaQuery.sizeOf(context).height * 0.7,
                        context,
                        title: L10n.tr('underlying_asset'),
                        titlePadding: const EdgeInsets.only(
                          top: Grid.m,
                        ),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: state.underlyingAssetList.length,
                            separatorBuilder: (context, index) => const PDivider(),
                            itemBuilder: (context, index) {
                              WarrantDropdownModel item = state.underlyingAssetList[index];
                              return BottomsheetSelectTile(
                                title: L10n.tr(item.name),
                                value: item.key,
                                isSelected: item.key == state.selectedUnderlyingAsset,
                                prefix: SymbolIcon(
                                  symbolName: state.underlyingAssetList[index].name,
                                  symbolType: getIt<WarrantBloc>()
                                          .state
                                          .warrantUsUnderlying
                                          .values
                                          .contains(state.underlyingAssetList[index].name)
                                      ? SymbolTypes.foreign
                                      : SymbolTypes.warrant,
                                  size: 16,
                                ),
                                onTap: (_, listItem) {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    _warrantBloc.add(
                                      OnApplyFilterEvent(
                                        underlyingAsset: item.key,
                                        marketMaker: state.selectedMarketMaker,
                                      ),
                                    );
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
                const SizedBox(
                  width: Grid.s,
                ),
                PCustomOutlinedButtonWithIcon(
                  text: state.marketMakerList
                          .firstWhereOrNull(
                            (e) => e.key == state.selectedMarketMaker,
                          )
                          ?.name
                          .split('MENKUL')
                          .first
                          .toCapitalizeCaseTr ??
                      '',
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  iconAlignment: IconAlignment.end,
                  foregroundColorApllyBorder: false,
                  foregroundColor: context.pColorScheme.primary,
                  backgroundColor: context.pColorScheme.secondary,
                  icon: SvgPicture.asset(
                    ImagesPath.chevron_down,
                    colorFilter: ColorFilter.mode(
                      context.pColorScheme.primary,
                      BlendMode.srcIn,
                    ),
                    width: 15,
                    height: 15,
                  ),
                  onPressed: () {
                    PBottomSheet.show(
                      maxHeight: MediaQuery.sizeOf(context).height * 0.7,
                      context,
                      title: L10n.tr('market_maker'),
                      titlePadding: const EdgeInsets.only(
                        top: Grid.m,
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: state.marketMakerList.length,
                        itemBuilder: (context, index) {
                          WarrantDropdownModel item = state.marketMakerList[index];
                          return BottomsheetSelectTile(
                            title: L10n.tr(item.name).toCapitalizeCaseTr,
                            value: item.key,
                            isSelected: item.key == state.selectedMarketMaker,
                            prefix: item.key == ''
                                ? null
                                : SymbolIcon(
                                    symbolName: state.marketMakerList[index].key,
                                    symbolType: SymbolTypes.marketMaker,
                                    size: 16,
                                  ),
                            onTap: (_, listItem) {
                              Navigator.of(context).pop();
                              _warrantBloc.add(
                                OnApplyFilterEvent(
                                  underlyingAsset: state.selectedUnderlyingAsset,
                                  marketMaker: item.key,
                                ),
                              );
                            },
                          );
                        },
                        separatorBuilder: (context, index) => const PDivider(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: Grid.s,
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (state.selectedMaturity != null) ...[
                  PButtonWithIcon(
                    text: state.selectedMaturity!,
                    iconAlignment: IconAlignment.end,
                    variant: PButtonVariant.secondary,
                    sizeType: PButtonSize.small,
                    height: 24,
                    icon: SvgPicture.asset(
                      ImagesPath.x,
                      colorFilter: ColorFilter.mode(
                        context.pColorScheme.primary,
                        BlendMode.srcIn,
                      ),
                      width: 15,
                      height: 15,
                    ),
                    onPressed: () {
                      _warrantBloc.add(
                        OnRemoveSelectedEvent(
                          removeMaturity: true,
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    width: Grid.s,
                  ),
                ],
                if (state.selectedRisk != null) ...[
                  PButtonWithIcon(
                    text: L10n.tr('warrant.filter.${state.selectedRisk?.text ?? '-'}'),
                    iconAlignment: IconAlignment.end,
                    variant: PButtonVariant.secondary,
                    sizeType: PButtonSize.small,
                    height: 24,
                    icon: SvgPicture.asset(
                      ImagesPath.x,
                      colorFilter: ColorFilter.mode(
                        context.pColorScheme.primary,
                        BlendMode.srcIn,
                      ),
                      width: 15,
                      height: 15,
                    ),
                    onPressed: () {
                      _warrantBloc.add(
                        OnRemoveSelectedEvent(
                          removeRisk: true,
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    width: Grid.s,
                  ),
                ],
                if (state.selectedType != null)
                  PButtonWithIcon(
                    text: L10n.tr('warrant.filter.${state.selectedType}'),
                    iconAlignment: IconAlignment.end,
                    variant: PButtonVariant.secondary,
                    sizeType: PButtonSize.small,
                    height: 24,
                    icon: SvgPicture.asset(
                      ImagesPath.x,
                      colorFilter: ColorFilter.mode(
                        context.pColorScheme.primary,
                        BlendMode.srcIn,
                      ),
                      width: 15,
                      height: 15,
                    ),
                    onPressed: () {
                      _warrantBloc.add(
                        OnRemoveSelectedEvent(
                          removeType: true,
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
