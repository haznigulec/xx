import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/language_enum.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class AdvicesService {
  final ApiClient api;

  AdvicesService(this.api);

  static const String _getAllAdviceUrl = '/cmsadvice/getalladvicev2';
  static const String _getAdviceHistoryUrl = '/cmsadvice/getadvicehistoryv2';

  Future<ApiResponse> getAdvices({
    String mainGroup = '',
    required String languageCode,
  }) async {
    return api.post(
      _getAllAdviceUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'mainGroup': mainGroup,
        if (languageCode == LanguageEnum.english.value) 'language': LanguageEnum.english.value,
      },
    );
  }

  Future<ApiResponse> getAdviceHistory({
    required String mainGroup,
    required int year,
  }) {
    return api.post(
      _getAdviceHistoryUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'mainGroup': mainGroup,
        'year': year
      },
    );
  }
}
