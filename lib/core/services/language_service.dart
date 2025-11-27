import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';

class LanguageService {
  final ApiClient api;

  LanguageService(this.api);

  static const String _getAllLanguageDictionaryUrl = '/usersettings/getalllanguagedictionary';

  Future<ApiResponse> getDictionary() {
    return api.post(
      _getAllLanguageDictionaryUrl,
      body: {
        'language': 'all',
      },
    );
  }
}
