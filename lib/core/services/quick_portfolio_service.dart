import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/language_enum.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class QuickPortfolioService {
  final ApiClient api;

  QuickPortfolioService(
    this.api,
  );

  static const String _getModelPortfolio = '/cmsportfolio/Getall';
  static const String _getKeyByKey = '/cmscontentvalue/getbykey';
  static const String _specificList = '/specificList/getallspeciallists';
  static const String _getById = '/cmsportfolio/getbyid';
  static const String _getFundInfoFromSpecialListById = '/specificList/getFundInfoFromSpecialListById';

  Future<ApiResponse> getSpecificList({
    required String mainGroup,
  }) async {
    return getIt<PPApi>().quickPortfolioService.api.post(
      _specificList,
      body: {
        'mainGrup': mainGroup,
      },
    );
  }

  Future<ApiResponse> getFundInfoFromSpecialListById({
    required String specialListId,
  }) async {
    return getIt<PPApi>().quickPortfolioService.api.post(
      _getFundInfoFromSpecialListById,
      body: {
        'specialListId': specialListId,
      },
    );
  }

  Future<ApiResponse> getRoboticBaskets(
    int portfolioId,
  ) async {
    return getIt<PPApi>().genericApiClient.get(
          'https://api.riskolog.com/Portfoy/SonTarihDagilim?portfoyId=$portfolioId',
        );
  }

  Future<ApiResponse> getModelPortfolio({
    required String languageCode,
  }) async {
    return getIt<PPApi>().quickPortfolioService.api.post(
      _getModelPortfolio,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        if (languageCode == LanguageEnum.english.value) 'language': LanguageEnum.english.value,
      },
    );
  }

  //Model portfolio detay bilgileri
  Future<ApiResponse> getById({
    required int id,
    required String languageCode,
  }) async {
    return getIt<PPApi>().quickPortfolioService.api.post(
      _getById,
      tokenized: true,
      body: {
        'id': id,
        'customerExtId': UserModel.instance.customerId,
        if (languageCode == LanguageEnum.english.value) 'language': LanguageEnum.english.value,
      },
    );
  }

  Future<ApiResponse> getPreparedPortfolios({
    required String porfolioKey,
    required String languageCode,
  }) async {
    return getIt<PPApi>().quickPortfolioService.api.post(
      _getKeyByKey,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'key': porfolioKey,
        if (languageCode == LanguageEnum.english.value) 'language': LanguageEnum.english.value,
      },
    );
  }
}
