import 'package:cached_network_svg_image/cached_network_svg_image.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_event.dart';
import 'package:piapiri_v2/app/favorite_lists/favorite_list_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/favorite_list.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/model/favorite_sorting_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class NoFav extends StatefulWidget {
  final FavoriteList? watchList;
  final bool isHomePage;

  const NoFav({
    super.key,
    this.watchList,
    this.isHomePage = false,
  });

  @override
  State<NoFav> createState() => _NoFavState();
}

class _NoFavState extends State<NoFav> {
  final FavoriteListBloc _favoriteListBloc = getIt<FavoriteListBloc>();
  @override
  Widget build(BuildContext context) {
    return widget.isHomePage
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                L10n.tr('not_contains_symbol'),
                style: context.pAppStyle.labelMed14textPrimary,
              ),
              const SizedBox(
                height: Grid.m,
              ),
              Text(
                L10n.tr('no_fav_desc'),
                style: context.pAppStyle.labelReg14textPrimary,
              ),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                ImagesPath.telescope_off,
                width: 32,
              ),
              const SizedBox(
                height: Grid.xs,
              ),
              Text(
                L10n.tr('not_contains_symbol'),
                style: context.pAppStyle.interMediumBase.copyWith(fontSize: Grid.m + Grid.xxs),
              ),
              const SizedBox(
                height: Grid.xs,
              ),
              Text(
                L10n.tr('no_fav_desc'),
                textAlign: TextAlign.center,
                style: context.pAppStyle.interRegularBase.copyWith(
                  fontSize: Grid.m - Grid.xxs,
                ),
              ),
              const SizedBox(
                height: Grid.m,
              ),
              PButtonWithIcon(
                text: L10n.tr('sembol_ekle'),
                sizeType: PButtonSize.small,
                icon: SvgPicture.asset(
                  ImagesPath.plus,
                  width: Grid.m,
                  colorFilter: ColorFilter.mode(
                    context.pColorScheme.lightHigh,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () => FavoriteListUtils().updateFavoriteList(context, []),
              ),
              const SizedBox(
                height: Grid.xl,
              ),
              Text(
                L10n.tr('no_fav_unlu'),
                textAlign: TextAlign.center,
                style: context.pAppStyle.interRegularBase.copyWith(
                  fontSize: Grid.m - Grid.xxs,
                ),
              ),
              const SizedBox(
                height: Grid.xs,
              ),
              Wrap(
                spacing: Grid.xs,
                children: _favoriteListBloc.state.quickList
                    .map(
                      (symbol) => PCustomOutlinedButtonWithIcon(
                        text: symbol.symbol,
                        iconAlignment: IconAlignment.start,
                        icon: ClipRRect(
                          borderRadius: BorderRadius.circular(Grid.s),
                          child: CachedNetworkSVGImage(
                            FavoriteListUtils().getIconPath(symbol.symbolType, symbol),
                            width: 12,
                            height: 12,
                            fit: BoxFit.cover,
                            errorWidget: const Icon(
                              Icons.error,
                              size: 12,
                            ),
                          ),
                        ),
                        onPressed: null,
                      ),
                    )
                    .toList(),
              ),
              PTextButtonWithIcon(
                text: L10n.tr('addList'),
                icon: SvgPicture.asset(
                  ImagesPath.plus,
                  width: Grid.m,
                  colorFilter: ColorFilter.mode(
                    context.pColorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () {
                  _favoriteListBloc.add(
                    UpdateListEvent(
                      id: _favoriteListBloc.state.selectedList?.id ?? 0,
                      name: _favoriteListBloc.state.selectedList?.name ?? '',
                      favoriteListItems: _favoriteListBloc.state.quickList,
                      sortingEnum: _favoriteListBloc.state.selectedList?.sortingEnum ?? FavoriteSortingEnum.alphabetic,
                      onSuccess: () async {
                        _trackItemChanges(_favoriteListBloc.state.quickList.map((e) => e.symbol).toList());
                      },
                    ),
                  );
                },
              )
            ],
          );
  }

  void _trackItemChanges(List<String> symbols) {
    for (var element in symbols) {
      getIt<Analytics>().track(
        AnalyticsEvents.itemAddedToCart,
        taxonomy: widget.isHomePage
            ? [
                InsiderEventEnum.controlPanel.value,
                InsiderEventEnum.homePage.value,
              ]
            : [
                InsiderEventEnum.controlPanel.value,
                InsiderEventEnum.marketsPage.value,
                InsiderEventEnum.favoriteTab.value,
              ],
        properties: {
          'product_id': element,
          'name': element,
          'image_url': '',
          'price': 0.0,
          'currency': 'TRY',
        },
      );
    }
  }
}
