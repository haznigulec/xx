import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_event.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_state.dart';
import 'package:piapiri_v2/app/favorite_lists/pages/favorite_symbol_listing.dart';
import 'package:piapiri_v2/app/favorite_lists/widgets/list_selector.dart';
import 'package:piapiri_v2/app/favorite_lists/widgets/no_list.dart';
import 'package:piapiri_v2/app/markets/model/market_menu.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/create_account_widget.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

class FavoriteListPage extends StatefulWidget {
  final bool showSymbolIcon;
  const FavoriteListPage({super.key, this.showSymbolIcon = true});

  @override
  State<FavoriteListPage> createState() => _FavoriteListPageState();
}

class _FavoriteListPageState extends State<FavoriteListPage> {
  late FavoriteListBloc _favoriteListBloc;
  late AuthBloc _authBloc;
  bool _showHeatMap = false;
  @override
  void initState() {
    _favoriteListBloc = getIt<FavoriteListBloc>();
    _authBloc = getIt<AuthBloc>();
    if (_authBloc.state.isLoggedIn) {
      _favoriteListBloc.add(
        GetListEvent(),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !_authBloc.state.isLoggedIn
        ? CreateAccountWidget(
            memberMessage: L10n.tr('create_account_favorite_list_alert'),
            loginMessage: L10n.tr('login_favorite_list_alert'),
            onLogin: () => router.push(
              AuthRoute(
                activeIndex: 2,
                marketMenu: MarketMenu.favorites,
              ),
            ),
          )
        : PBlocBuilder<FavoriteListBloc, FavoriteListState>(
            bloc: _favoriteListBloc,
            builder: (context, state) {
              if (state.isLoading) {
                return const PLoading();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Favori listesi sectirir
                  if (state.watchList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Grid.m),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PCustomOutlinedButtonWithIcon(
                            text: state.selectedList?.name ?? '',
                            iconSource: ImagesPath.chevron_down,
                            onPressed: () {
                              PBottomSheet.show(
                                context,
                                title: L10n.tr('lists'),
                                titlePadding: const EdgeInsets.only(
                                  top: Grid.m,
                                ),
                                child: ListSelector(
                                  watchList: state.watchList,
                                  selectedList: state.selectedList,
                                ),
                              );
                            },
                          ),
                          InkWell(
                            child: SvgPicture.asset(
                              _showHeatMap ? ImagesPath.drag : ImagesPath.table,
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(
                                context.pColorScheme.iconPrimary,
                                BlendMode.srcIn,
                              ),
                            ),
                            onTap: () =>
                                setState(() => _showHeatMap = !_showHeatMap),
                          )
                        ],
                      ),
                    ),
                  const SizedBox(
                    height: Grid.s + Grid.xs,
                  ),
                  Expanded(
                    child: state.watchList.isEmpty
                        ? const NoList()
                        : FavoriteSymbolListing(
                            key: ValueKey(
                                'WATCH_LIST_${state.selectedList!.favoriteListItems}'),
                            symbols: state.selectedList!.favoriteListItems,
                            showHeatMap: _showHeatMap,
                            isHome: false,
                          ),
                  ),
                ],
              );
            },
          );
  }
}
