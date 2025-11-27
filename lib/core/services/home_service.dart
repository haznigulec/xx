import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class HomeService {
  final ApiClient api;

  const HomeService(this.api);

  static const String _getTemplatesUrl = '/usersettings/getdashboardtemplates';
  static const String _updateTemplatesUrl = '/usersettings/updatedashboardtemplates';
  static const String _setLanguageUrlByDeviceIdUrl = '/usersettings/setlanguagebydeviceid';

  Future<ApiResponse> getDashboardTemplates() async {
    return api.post(
      _getTemplatesUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
      },
    );
  }

  Future<ApiResponse> updateDashboardTemplates(
    String customerId,
    int templateIndex,
  ) async {
    return api.post(
      _updateTemplatesUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'dashboardTemplateId': templateIndex,
      },
    );
  }

  Future<ApiResponse> setLanguageByDeviceId(
    String deviceId,
    String languageCode,
  ) async {
    return api.post(
      _setLanguageUrlByDeviceIdUrl,
      body: {
        'deviceId': getIt<AppInfo>().deviceId,
        'langCode': languageCode,
      },
    );
  }
}
