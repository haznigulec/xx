import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/bloc/language/repository/language_repository.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class LanguageRepositoryImpl extends LanguageRepository {
  @override
  Future<ApiResponse> getDictionary() {
    return getIt<PPApi>().appInfoService.getAllLanguageDictionary();
  }
}
