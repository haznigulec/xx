import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/app/viop/bloc/viop_bloc.dart';
import 'package:piapiri_v2/app/viop/bloc/viop_event.dart';
import 'package:piapiri_v2/app/viop/bloc/viop_state.dart';
import 'package:piapiri_v2/app/viop/widgets/viop_filter_sheet.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ViopFilter extends StatefulWidget {
  final String? subMarketCode;
  const ViopFilter({
    super.key,
    this.subMarketCode,
  });

  @override
  State<ViopFilter> createState() => _ViopFilterState();
}

class _ViopFilterState extends State<ViopFilter> {
  late ViopBloc _viopBloc;

  @override
  void initState() {
    _viopBloc = getIt<ViopBloc>();
    _viopBloc.add(
      GetUnderlyingListEvent(),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<ViopBloc, ViopState>(
      bloc: _viopBloc,
      builder: (context, state) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Grid.m,
        ),
        child: Wrap(
          spacing: Grid.s,
          runSpacing: Grid.s,
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            if (widget.subMarketCode == null)
              PCustomOutlinedButtonWithIcon(
                text: L10n.tr('Filtrele'),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                iconSource: ImagesPath.chevron_down,
                onPressed: () {
                  PBottomSheet.show(
                    context,
                    title: L10n.tr('Filtrele'),
                    titlePadding: const EdgeInsets.only(
                      top: Grid.m,
                    ),
                    child: ViopFilterSheet(
                      selectedMaturity: state.selectedMaturity,
                      selectedContractType: state.selectedContractType,
                      selectedTransactionType: state.selectedTransactionType,
                      maturityList: state.maturityList,
                      onSetFilter: (maturity, contractType, transactionType) {
                        _viopBloc.add(
                          ApplyFiltersEvent(
                            maturityDate: maturity,
                            contractType: contractType,
                            transactionType: transactionType,
                            subMaketCode: widget.subMarketCode,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            if (widget.subMarketCode == null)
              PCustomOutlinedButtonWithIcon(
                text: state.selectedUnderlying,
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
                    context,
                    title: L10n.tr('underlying_asset'),
                    titlePadding: const EdgeInsets.only(
                      top: Grid.m,
                    ),
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.7,
                      ),
                      child: ListView.separated(
                        itemCount: state.underlyingList.length,
                        shrinkWrap: true,
                        separatorBuilder: (context, _) => const PDivider(),
                        itemBuilder: (context, index) => BottomsheetSelectTile(
                          title: state.underlyingList[index],
                          isSelected: state.selectedUnderlying == state.underlyingList[index],
                          prefix: SymbolIcon(
                            symbolName: state.underlyingList[index],
                            symbolType: SymbolTypes.future,
                            size: 14,
                          ),
                          onTap: (String title, value) {
                            Navigator.of(context).pop();
                            _viopBloc.add(
                              ApplyFiltersEvent(
                                underlyingName: title,
                                subMaketCode: widget.subMarketCode,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            if (widget.subMarketCode != null)
              PCustomOutlinedButtonWithIcon(
                text: state.selectedMaturity ?? L10n.tr('maturity'),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                iconSource: ImagesPath.chevron_down,
                iconAlignment: IconAlignment.end,
                foregroundColor: state.selectedMaturity != null ? context.pColorScheme.primary : null,
                onPressed: () {
                  PBottomSheet.show(
                    context,
                    title: L10n.tr('maturity'),
                    titlePadding: const EdgeInsets.only(
                      top: Grid.m,
                    ),
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.7,
                      ),
                      child: ListView.separated(
                        itemCount: state.maturityList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return BottomsheetSelectTile(
                            title: state.maturityList[index],
                            value: state.maturityList[index],
                            isSelected: state.maturityList[index] == state.selectedMaturity,
                            onTap: (String title, value) {
                              Navigator.of(context).pop();
                              if (state.selectedMaturity != state.maturityList[index]) {
                                _viopBloc.add(
                                  ApplyFiltersEvent(
                                    maturityDate: state.maturityList[index],
                                    subMaketCode: widget.subMarketCode,
                                  ),
                                );
                              } else {
                                _viopBloc.add(
                                  OnRemoveSelectedEvent(
                                    removeMaturity: true,
                                    subMarketCode: widget.subMarketCode,
                                  ),
                                );
                              }
                            },
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                      ),
                    ),
                  );
                },
              ),
            if (state.selectedMaturity != null && widget.subMarketCode == null)
              PCustomOutlinedButtonWithIcon(
                text: state.selectedMaturity!,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                iconAlignment: IconAlignment.end,
                foregroundColorApllyBorder: false,
                foregroundColor: context.pColorScheme.primary,
                backgroundColor: context.pColorScheme.secondary,
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
                  _viopBloc.add(
                    OnRemoveSelectedEvent(
                      removeMaturity: true,
                    ),
                  );
                },
              ),
            if (state.selectedContractType != null)
              PCustomOutlinedButtonWithIcon(
                text: L10n.tr(state.selectedContractType!.localization),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                iconAlignment: IconAlignment.end,
                foregroundColorApllyBorder: false,
                foregroundColor: context.pColorScheme.primary,
                backgroundColor: context.pColorScheme.secondary,
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
                  _viopBloc.add(
                    OnRemoveSelectedEvent(
                      removeContractType: true,
                      removeTransactionType: true,
                    ),
                  );
                },
              ),
            if (state.selectedTransactionType != null)
              PCustomOutlinedButtonWithIcon(
                text: L10n.tr(state.selectedTransactionType!.localizationKey),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                iconAlignment: IconAlignment.end,
                foregroundColorApllyBorder: false,
                foregroundColor: context.pColorScheme.primary,
                backgroundColor: context.pColorScheme.secondary,
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
                  _viopBloc.add(
                    OnRemoveSelectedEvent(
                      removeTransactionType: true,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
