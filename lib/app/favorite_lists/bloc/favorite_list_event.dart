import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/model/favorite_list.dart';
import 'package:piapiri_v2/core/model/favorite_sorting_enum.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';

abstract class FavoriteListEvent extends PEvent {}

class GetListEvent extends FavoriteListEvent {
  final int? listId;
  final Function(List<FavoriteList>)? callback;

  GetListEvent({
    this.callback,
    this.listId,
  });
}

class SelectListEvent extends FavoriteListEvent {
  final FavoriteList selectedList;

  SelectListEvent({
    required this.selectedList,
  });
}

class UpdateListEvent extends FavoriteListEvent {
  final int id;
  final String name;
  final List<SymbolModel>? items;
  final List<FavoriteListItem>? favoriteListItems;
  final FavoriteSortingEnum sortingEnum;
  final Function()? onSuccess;

  UpdateListEvent({
    required this.id,
    required this.name,
    required this.sortingEnum,
    this.items,
    this.favoriteListItems,
    this.onSuccess,
  });
}

class CreateListEvent extends FavoriteListEvent {
  final String name;
  final List<FavoriteListItem> items;
  final Function(int listId) onSuccess;

  CreateListEvent({
    required this.name,
    required this.items,
    required this.onSuccess,
  });
}

class RemoveListEvent extends FavoriteListEvent {
  final int id;
  final Function()? callback;

  RemoveListEvent({
    required this.id,
    this.callback,
  });
}

class UpdateBulkListEvent extends FavoriteListEvent {
  final FavoriteListItem item;
  final List<int> addedListIds;
  final List<int> removedListIds;
  final Function()? callback;

  UpdateBulkListEvent({
    required this.item,
    required this.addedListIds,
    required this.removedListIds,
    this.callback,
  });
}

class GetQuickListEvent extends FavoriteListEvent {}

class ClearWatchListEvent extends FavoriteListEvent {}
