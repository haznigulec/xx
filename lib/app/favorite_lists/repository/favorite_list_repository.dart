import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/favorite_sorting_enum.dart';

abstract class FavoriteListRepository {
  Future<ApiResponse> getFavoriteList();
  Future<ApiResponse> createFavoriteList({
    required String name,
    required List<Map<String, dynamic>> items,
  });

  Future<ApiResponse> updateFavoriteList({
    required int id,
    required String name,
    required FavoriteSortingEnum sortingEnum,
    required List<Map<String, dynamic>> items,
  });

  Future<ApiResponse> favoriteListDelete({
    required int id,
  });

  Future<Map<String, dynamic>> getSymbolsDetail({
    required List<String> symbolCode,
  });

  void createSelectedFavoriteListIdLocal({
    required int listId,
  });

  Future<int?> getSelectedFavoriteListIdLocal();

  void deleteSelectedFavoriteListIdLocal();
}
