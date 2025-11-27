import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_event.dart';
import 'package:piapiri_v2/app/favorite_lists/widgets/create_list.dart';
import 'package:piapiri_v2/app/favorite_lists/widgets/list_checkbox_selector.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/favorite_list.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/model/favorite_sorting_enum.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class FavoriteListUtils {
  /// Favori Listesinde var ise true yok ise false döner.
  bool isFavorite(String symbolCode, SymbolTypes symbolType) {
    return getIt<FavoriteListBloc>().state.watchList.any(
          (element) => element.favoriteListItems.any(
            (e) => e.symbol == symbolCode && e.symbolType == symbolType,
          ),
        );
  }

  /// Favori Listesinde var ise çıkarir yok ise ekler.
  Future<void> toggleFavorite(
    BuildContext context,
    String symbolCode,
    SymbolTypes symbolType,
  ) {
    return PBottomSheet.show(
      context,
      title: L10n.tr('lists'),
      titlePadding: const EdgeInsets.only(
        top: Grid.m,
      ),
      child: ListCheckboxSelector(
        symbolName: symbolCode,
        symbolType: symbolType,
      ),
    );
  }

  /// Favori Listesi oluşturur
  Future<void> createFavoriteList(
    BuildContext context, {
    List<FavoriteListItem>? favoriteListItem,
    int popTimes = 1,
  }) async {
    final favoriteListBloc = getIt<FavoriteListBloc>();
    if (favoriteListBloc.state.watchList.length >= 5) {
      PBottomSheet.showError(
        context,
        content: L10n.tr('cant_create_list_anymore'),
      );
    } else {
      await PBottomSheet.show(
        context,
        title: L10n.tr('create_favorite_list'),
        child: StatefulBuilder(
          builder: (context, setState) {
            return CreateList(
              favoriteListItems: favoriteListItem,
              popTimes: popTimes,
            );
          },
        ),
      );
    }
  }

  /// Istenilen favori listesine sembol ekler
  Future<void> updateFavoriteList(BuildContext context, List<FavoriteListItem> currentItems) async {
    final favoriteListBloc = getIt<FavoriteListBloc>();
    if (currentItems.length >= 50) {
      await PBottomSheet.showError(
        context,
        content: L10n.tr('can_not_add_more_than_50_symbols'),
      );
      return;
    }

    router.push(
      SymbolSearchRoute(
        isCheckbox: true,
        selectedSymbolList: currentItems
            .map(
              (e) => SymbolModel(
                name: e.symbol,
                typeCode: e.symbolType.dbKey,
              ),
            )
            .toList(),
        onTapSymbol: (List<SymbolModel> newSymbols) {
          // 1. Favori sembolleri Set olarak topla
          Set<String> favoriteSymbols = currentItems.map((e) => e.symbol).toSet();

          // 2. newSymbols listesinden, favoriteSymbols setinde olmayanları filtrele
          List<SymbolModel> notInFavorites = newSymbols
              .where(
                (symbol) => !favoriteSymbols.contains(symbol.name),
              )
              .toList();

          if (notInFavorites.isNotEmpty) {
            for (var element in notInFavorites) {
              getIt<Analytics>().track(
                AnalyticsEvents.itemAddedToCart,
                taxonomy: [
                  InsiderEventEnum.controlPanel.value,
                  InsiderEventEnum.marketsPage.value,
                  InsiderEventEnum.favoriteTab.value,
                ],
                properties: {
                  'product_id': element.name,
                  'name': element.name,
                  'image_url': '',
                  'price': 0.0,
                  'currency': 'TRY',
                },
              );
            }
          }

          favoriteListBloc.add(
            UpdateListEvent(
              id: favoriteListBloc.state.selectedList?.id ?? 0,
              name: favoriteListBloc.state.selectedList?.name ?? '',
              sortingEnum: favoriteListBloc.state.selectedList?.sortingEnum ?? FavoriteSortingEnum.alphabetic,
              items: newSymbols.length >= 50 ? newSymbols.sublist(0, 50) : newSymbols,
              onSuccess: () {
                if (newSymbols.length >= 50) {
                  PBottomSheet.showError(
                    context,
                    content: L10n.tr('can_not_add_more_than_50_symbols'),
                  );
                  return;
                }
              },
            ),
          );
        },
      ),
    );
  }

  String getIconPath(SymbolTypes symbolType, FavoriteListItem favoriteListItem, {String? fundInstution}) {
    String path = '${getIt<AppInfo>().cdnUrl}icons/${symbolTypeToCdnHandle(favoriteListItem.symbolType)}/';
    // Fund kurumları için özel iconlar
    if (fundInstution != null) {
      return '$path$fundInstution.svg';
    }

    if (favoriteListItem.symbolType == SymbolTypes.warrant ||
        favoriteListItem.symbolType == SymbolTypes.option ||
        favoriteListItem.symbolType == SymbolTypes.future) {
      return '$path${favoriteListItem.underlyingName}.svg';
    }
    return '$path${favoriteListItem.symbol}.svg';
  }
}
