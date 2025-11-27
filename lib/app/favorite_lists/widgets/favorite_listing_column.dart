import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_event.dart';
import 'package:piapiri_v2/app/favorite_lists/widgets/sort_list.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/bottomsheet_select_tile.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/fund_model.dart';
import 'package:piapiri_v2/core/model/favorite_sorting_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class FavoriteListingColumn extends StatelessWidget {
  final Function() onTap;
  final List<FundDetailModel> tefasSymbolDetails;
  const FavoriteListingColumn({
    super.key,
    required this.onTap,
    required this.tefasSymbolDetails,
  });

  @override
  Widget build(BuildContext context) {
    final FavoriteListBloc favoriteListBloc = getIt<FavoriteListBloc>();
    return Column(
      children: [
        const PDivider(),
        SizedBox(
          height: 38,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      L10n.tr('asset'),
                      style: context.pAppStyle.labelMed12textSecondary,
                    ),
                    const SizedBox(
                      width: Grid.xs,
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        onTap();
                        PBottomSheet.show(
                          context,
                          contentPadding: EdgeInsets.zero,
                          title: L10n.tr('sorting'),
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: FavoriteSortingEnum.values.length,
                            separatorBuilder: (_, __) => const PDivider(),
                            itemBuilder: (context, index) {
                              FavoriteSortingEnum sortingEnum = FavoriteSortingEnum.values[index];
                              return BottomsheetSelectTile(
                                title: L10n.tr(sortingEnum.localization),
                                padding: EdgeInsets.zero,
                                isSelected: favoriteListBloc.state.selectedList!.sortingEnum == sortingEnum,
                                onTap: (_, __) {
                                  /// Eger secili olan sortingEnum ayni ise bottomsheet kapatilir
                                  if (sortingEnum != FavoriteSortingEnum.custom &&
                                      sortingEnum == favoriteListBloc.state.selectedList!.sortingEnum) {
                                    Navigator.pop(context);
                                    return;
                                  }

                                  /// Eger secili olan sortingEnum farkli ise ve custom siralam secilmeid ise siralar ve gunceller
                                  if (sortingEnum == FavoriteSortingEnum.alphabetic ||
                                      sortingEnum == FavoriteSortingEnum.reverseAlphabetic) {
                                    favoriteListBloc.add(
                                      UpdateListEvent(
                                        id: favoriteListBloc.state.selectedList!.id,
                                        name: favoriteListBloc.state.selectedList!.name,
                                        favoriteListItems: favoriteListBloc.state.selectedList!.favoriteListItems,
                                        sortingEnum: sortingEnum,
                                      ),
                                    );
                                    Navigator.pop(context);
                                    return;
                                  }

                                  /// Eger secili olan sortingEnum farkli ise ve custom siralama secildi custom sort bottomsheet acilir
                                  if (sortingEnum == FavoriteSortingEnum.custom) {
                                    PBottomSheet.show(
                                      context,
                                      title: L10n.tr('custom_sort'),
                                      titlePadding: const EdgeInsets.only(
                                        top: Grid.m,
                                      ),
                                      child: SortList(
                                        items: favoriteListBloc.state.selectedList!.favoriteListItems,
                                        tefasSymbolDetails: tefasSymbolDetails,
                                        onApprove: (items) {
                                          favoriteListBloc.add(
                                            UpdateListEvent(
                                              id: favoriteListBloc.state.selectedList!.id,
                                              name: favoriteListBloc.state.selectedList!.name,
                                              favoriteListItems: items,
                                              sortingEnum: sortingEnum,
                                            ),
                                          );
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          return;
                                        },
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        );
                      },
                      child: SvgPicture.asset(
                        ImagesPath.arrows_down_up,
                        height: 14,
                        width: 14,
                        colorFilter: ColorFilter.mode(
                          context.pColorScheme.textSecondary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        L10n.tr('equity_column_difference'),
                        style: context.pAppStyle.labelMed12textSecondary,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        L10n.tr('equity_column_last_price'),
                        style: context.pAppStyle.labelMed12textSecondary,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const PDivider(),
      ],
    );
  }
}
