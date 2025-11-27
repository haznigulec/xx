import 'package:piapiri_v2/app/favorite_lists/repository/favorite_list_repository.dart';
import 'package:piapiri_v2/common/utils/local_keys.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/database/db_helper.dart';
import 'package:piapiri_v2/core/model/favorite_sorting_enum.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';

class FavoriteListRepositoryImpl implements FavoriteListRepository {
  DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Future<ApiResponse> getFavoriteList() {
    return getIt<PPApi>().favoriteListsService.getFavoriteList();
  }

  @override
  Future<ApiResponse> createFavoriteList({
    required String name,
    required List<Map<String, dynamic>> items,
  }) {
    return getIt<PPApi>().favoriteListsService.createFavoriteList(
          name: name,
          items: items,
        );
  }

  @override
  Future<ApiResponse> updateFavoriteList({
    required int id,
    required String name,
    required FavoriteSortingEnum sortingEnum,
    required List<Map<String, dynamic>> items,
  }) {
    return getIt<PPApi>().favoriteListsService.updateFavoriteList(
          id: id,
          name: name,
          sortingEnum: sortingEnum,
          items: items,
        );
  }

  @override
  Future<ApiResponse> favoriteListDelete({
    required int id,
  }) {
    return getIt<PPApi>().favoriteListsService.favoriteListDelete(
          id: id,
        );
  }

  @override
  Future<Map<String, dynamic>> getSymbolsDetail({
    required List<String> symbolCode,
  }) async {
    List<Map<String, dynamic>> selectedListItem = await dbHelper.getFavoriteDetails(symbolCode);
    Map<String, dynamic> mappedListItems = {
      for (var item in selectedListItem)
        item['Name']!: {
          'Description': item['Description'] ?? '',
          'UnderlyingName': item['UnderlyingName'] ?? '',
          'TypeCode': item['TypeCode']
        }
    };

    return mappedListItems;
  }

  @override
  Future<int?> getSelectedFavoriteListIdLocal() async {
    return await getIt<LocalStorage>().read(LocalKeys.favoriteListId);
  }

  @override
  void createSelectedFavoriteListIdLocal({required int listId}) async {
    getIt<LocalStorage>().write(LocalKeys.favoriteListId, listId);
  }

  @override
  void deleteSelectedFavoriteListIdLocal() async {
    getIt<LocalStorage>().delete(LocalKeys.favoriteListId);
  }
}
