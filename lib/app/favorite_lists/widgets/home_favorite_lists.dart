import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_event.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_state.dart';
import 'package:piapiri_v2/app/favorite_lists/favorite_list_utils.dart';
import 'package:piapiri_v2/app/favorite_lists/pages/favorite_symbol_listing.dart';
import 'package:piapiri_v2/app/favorite_lists/widgets/list_selector.dart';
import 'package:piapiri_v2/app/favorite_lists/widgets/no_fav.dart';
import 'package:piapiri_v2/app/markets/model/market_menu.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_bloc.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_event.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/favorite_list.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class HomeFavoriteList extends StatefulWidget {
  const HomeFavoriteList({super.key});

  @override
  State<HomeFavoriteList> createState() => _HomeFavoriteListState();
}

class _HomeFavoriteListState extends State<HomeFavoriteList> {
  late FavoriteListBloc _favoriteListBloc;

  @override
  void initState() {
    _favoriteListBloc = getIt<FavoriteListBloc>();

    _favoriteListBloc.add(
      GetListEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<FavoriteListBloc, FavoriteListState>(
      bloc: _favoriteListBloc,
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Grid.m,
              ),
              child: Text(
                L10n.tr('my_favorites'),
                style: context.pAppStyle.labelMed18textPrimary,
              ),
            ),
            state.watchList.isEmpty
                ? _emptyList()
                : _lists(
                    state.watchList,
                    state.selectedList,
                  )
          ],
        );
      },
    );
  }

  Widget _emptyList() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Grid.m,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: Grid.s,
          ),
          Text(
            L10n.tr('create_list_desc'),
            style: context.pAppStyle.labelReg14textPrimary,
          ),
          PCustomPrimaryTextButton(
            margin: const EdgeInsets.only(
              top: Grid.s + Grid.xs,
            ),
            text: L10n.tr('create_favorite_list'),
            iconSource: ImagesPath.plus,
            onPressed: () => FavoriteListUtils().createFavoriteList(context),
          ),
        ],
      ),
    );
  }

  Widget _lists(
    List<FavoriteList> watchList,
    FavoriteList? selectedList,
  ) {
    bool showMore = false;
    // limit items to 5
    if ((selectedList?.favoriteListItems ?? []).length > 5) {
      showMore = true;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Grid.m,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PCustomOutlinedButtonWithIcon(
                onPressed: () {
                  PBottomSheet.show(
                    context,
                    title: L10n.tr('lists'),
                    titlePadding: const EdgeInsets.only(
                      top: Grid.m,
                    ),
                    child: ListSelector(
                      watchList: watchList,
                      selectedList: selectedList,
                    ),
                  );
                },
                iconSource: ImagesPath.chevron_down,
                text: selectedList?.name ?? '',
              ),
              if (watchList.isNotEmpty) ...{
                PCustomPrimaryTextButton(
                  text: L10n.tr('sembol_ekle'),
                  iconSource: ImagesPath.plus,
                  onPressed: () => FavoriteListUtils().updateFavoriteList(
                    context,
                    selectedList?.favoriteListItems ?? [],
                  ),
                ),
              }
            ],
          ),
        ),
        if (selectedList != null && selectedList.favoriteListItems.isEmpty) ...[
          const PDivider(),
          const SizedBox(
            height: Grid.m + Grid.xs,
          ),
        ],
        if (selectedList?.favoriteListItems.isNotEmpty == true) ...[
          FavoriteSymbolListing(
            key: ValueKey('WATCH_LIST_${selectedList!.favoriteListItems}'),
            symbols: selectedList.favoriteListItems.length > 5
                ? selectedList.favoriteListItems.sublist(0, 5)
                : selectedList.favoriteListItems,
            isHome: true,
          ),
        ] else ...[
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: NoFav(
              isHomePage: true,
            ),
          ),
        ],
        if (showMore)
          PCustomPrimaryTextButton(
            margin: const EdgeInsets.symmetric(
              horizontal: Grid.m,
              vertical: Grid.s,
            ),
            text: L10n.tr('show_more_list'),
            onPressed: () {
              getIt<TabBloc>().add(
                const TabChangedEvent(
                  tabIndex: 2,
                  marketMenu: MarketMenu.favorites,
                ),
              );
            },
          ),
      ],
    );
  }
}
