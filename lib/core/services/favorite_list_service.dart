import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/client/matriks_api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/favorite_sorting_enum.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class FavoriteListService {
  final ApiClient api;
  final MatriksApiClient matriksApiClient;

  FavoriteListService(this.api, this.matriksApiClient);

  static const String _getAllFavoriteList = '/FavoriteList/getallfavoritelist';
  static const String _createFavoriteList = '/FavoriteList/createfavoritelist';
  static const String _updateFavoriteList = '/FavoriteList/updatefavoritelist';
  static const String _deleteFavoriteList = '/FavoriteList/deletefavoritelist';

  Future<ApiResponse> getFavoriteList() {
    Map<String, dynamic> data = {'customerExtId': UserModel.instance.customerId};
    return api.post(
      _getAllFavoriteList,
      body: data,
      tokenized: true,
    );
  }

  Future<ApiResponse> createFavoriteList({
    required String name,
    required List<Map<String, dynamic>> items,
  }) async {
    final Map<String, dynamic> data = {
      'name': name,
      'sort': FavoriteSortingEnum.alphabetic.value,
      'favoriteListItems': items,
      'customerExtId': UserModel.instance.customerId,
    };
    return api.post(
      _createFavoriteList,
      body: data,
      tokenized: true,
    );
  }

  Future<ApiResponse> updateFavoriteList({
    required int id,
    required String name,
    required FavoriteSortingEnum sortingEnum,
    required List<Map<String, dynamic>> items,
  }) async {
    Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'sort': sortingEnum.value,
      'favoriteListItems': items,
      'customerExtId': UserModel.instance.customerId,
    };

    return api.post(
      _updateFavoriteList,
      body: data,
      tokenized: true,
    );
  }

  //Favori Listesi Silme
  Future<ApiResponse> favoriteListDelete({required int id}) async {
    final Map<String, dynamic> params = {
      'id': id,
      'customerExtId': UserModel.instance.customerId,
    };

    return api.post(
      _deleteFavoriteList,
      body: params,
      tokenized: true,
    );
  }

}
