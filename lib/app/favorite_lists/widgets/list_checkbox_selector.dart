import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/list/list_item.dart';
import 'package:piapiri_v2/common/widgets/selection_control/checkbox.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_event.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_state.dart';
import 'package:piapiri_v2/app/favorite_lists/favorite_list_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/favorite_list.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/model/symbol_soruce_enum.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ListCheckboxSelector extends StatefulWidget {
  final String symbolName;
  final SymbolTypes symbolType;

  const ListCheckboxSelector({
    super.key,
    required this.symbolName,
    required this.symbolType,
  });

  @override
  State<ListCheckboxSelector> createState() => _ListCheckboxSelectorState();
}

class _ListCheckboxSelectorState extends State<ListCheckboxSelector> {
  late FavoriteListBloc _favoriteListBloc;
  List<int> addedListIds = [];
  List<int> removedListIds = [];

  @override
  initState() {
    _favoriteListBloc = getIt<FavoriteListBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<FavoriteListBloc, FavoriteListState>(
      bloc: _favoriteListBloc,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.watchList.length,
              separatorBuilder: (context, index) => const PDivider(),
              itemBuilder: (context, index) {
                /// 50 den fazla sembol ekelenemedigi icin suanki listede olup olmadigini kontrol eder
                bool containsSymbol = state.watchList[index].favoriteListItems.any(
                  (element) => element.symbol == widget.symbolName && element.symbolType == widget.symbolType,
                );
                bool isChecked = containsSymbol && !removedListIds.contains(state.watchList[index].id) ||
                    addedListIds.contains(state.watchList[index].id);

                return PListItem(
                  title: '${state.watchList[index].name} (${state.watchList[index].favoriteListItems.length})',
                  leadingWidgetSize: const Size(23, 30),
                  disabled: !containsSymbol && state.watchList[index].favoriteListItems.length >= 50,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  leading: Padding(
                    padding: const EdgeInsets.only(
                      right: Grid.s,
                    ),
                    child: PCheckbox(
                      value: isChecked,
                      onChanged: !containsSymbol && state.watchList[index].favoriteListItems.length >= 50
                          ? null
                          : (value) => _onTapCheckBox(value!, state.watchList[index]),
                    ),
                  ),
                  onTap: () => _onTapCheckBox(!isChecked, state.watchList[index]),
                );
              },
            ),
            if (state.watchList.length < 5) ...[
              if (state.watchList.isNotEmpty) const PDivider(),
              PTextButtonWithIcon(
                text: L10n.tr('create_favorite_list'),
                sizeType: PButtonSize.medium,
                padding: EdgeInsets.zero,
                icon: SvgPicture.asset(
                  ImagesPath.plus,
                  height: 17,
                  colorFilter: ColorFilter.mode(
                    context.pColorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () => FavoriteListUtils().createFavoriteList(
                  context,
                  popTimes: 2,
                  favoriteListItem: [
                    FavoriteListItem(
                      symbol: widget.symbolName,
                      symbolType: widget.symbolType,
                      symbolSource: SymbolSourceEnum.values.firstWhere(
                        (element) => element.symbolTypes.contains(widget.symbolType),
                      ),
                    ),
                  ],
                ),
              )
            ],
            const SizedBox(
              height: Grid.m,
            ),
            PButton(
              text: L10n.tr('kaydet'),
              fillParentWidth: true,
              onPressed: () {
                if (addedListIds.isNotEmpty) {
                  getIt<Analytics>().track(
                    AnalyticsEvents.itemAddedToCart,
                    taxonomy: [
                      InsiderEventEnum.controlPanel.value,
                      InsiderEventEnum.marketsPage.value,
                      InsiderEventEnum.symbolDetail.value,
                    ],
                    properties: {
                      'product_id': widget.symbolName,
                      'name': widget.symbolName,
                      'image_url': '',
                      'price': 0.0,
                      'currency': 'TRY',
                    },
                  );
                }

                if (removedListIds.isNotEmpty) {
                  getIt<Analytics>().track(
                    AnalyticsEvents.itemRemovedFromCart,
                    taxonomy: [
                      InsiderEventEnum.controlPanel.value,
                      InsiderEventEnum.marketsPage.value,
                      InsiderEventEnum.symbolDetail.value,
                    ],
                    properties: {
                      'product_id': widget.symbolName,
                      'name': widget.symbolName,
                      'image_url': '',
                      'price': 0.0,
                      'currency': 'TRY',
                    },
                  );
                }

                Navigator.pop(context);
                _favoriteListBloc.add(
                  UpdateBulkListEvent(
                    item: FavoriteListItem(
                        symbol: widget.symbolName,
                        symbolType: widget.symbolType,
                        symbolSource: SymbolSourceEnum.values
                            .firstWhere((element) => element.symbolTypes.contains(widget.symbolType))),
                    addedListIds: addedListIds,
                    removedListIds: removedListIds,
                  ),
                );
              },
            )
          ],
        );
      },
    );
  }

  void _onTapCheckBox(bool value, FavoriteList selectedWatchList) {
    /// yeni eklenecek listelerin ve cikarilmasi istenen listelerin idlerini olusturur
    if (value) {
      if (removedListIds.contains(selectedWatchList.id)) {
        removedListIds.remove(selectedWatchList.id);
      } else {
        addedListIds.add(selectedWatchList.id);
      }
    } else {
      if (addedListIds.contains(selectedWatchList.id)) {
        addedListIds.remove(selectedWatchList.id);
      } else {
        removedListIds.add(selectedWatchList.id);
      }
    }
    setState(() {});
  }
}
