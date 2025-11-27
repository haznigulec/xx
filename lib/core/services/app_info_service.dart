import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/client/generic_api_client.dart';
import 'package:piapiri_v2/core/api/client/matriks_api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class AppInfoService {
  final ApiClient api;
  final MatriksApiClient matriksApiClient;
  final GenericApiClient genericApiClient;

  AppInfoService(
    this.api,
    this.matriksApiClient,
    this.genericApiClient,
  );

  static const String _appJustInstalledUrl = '/adkcustomer/appjustinstalled';
  static const String _getAllLanguageDictionaryUrl = '/usersettings/getalllanguagedictionary';
  static const String _getApplicationSettingsByCustomerIdUrl = '/usersettings/getapplicationsettingsbycustomerextid';
  static const String _getApplicationSettingsByDeviceIdUrlUrl = '/usersettings/getapplicationsettingsbydeviceid';
  static const String _updateApplicationSettingsByCustomerIdUrl =
      '/usersettings/updateapplicationsettingsbycustomerextid';
  static const String _updateApplicationSettingsByDeviceIdUrl = '/usersettings/updateapplicationsettingsbydeviceid';
  static const String _getUpdatedRecordsUrl = '/cmssymbol/getUpdatedRecords';
  static const String _getUSClock = '/capra/getmarketclockinfo';
  static const String _getSplashStoriesDev = 'https://piapiri-test.b-cdn.net/Splash/splash.json';
  static const String _getSplashStoriesProd = 'https://piapiri-std.b-cdn.net/Splash/splash.json';

  Future<ApiResponse> checkAppFirstOpen(String deviceId) async {
    return api.post(
      _appJustInstalledUrl,
      body: {
        'deviceId': deviceId,
      },
    );
  }

  Future<ApiResponse> getAllLanguageDictionary() async {
    return api.post(
      _getAllLanguageDictionaryUrl,
      body: {
        'language': 'all',
      },
    );
  }

  Future<ApiResponse> getApplicationSettings({
    required int id,
    String? deviceId,
  }) async {
    Map<String, dynamic> data = {
      'applicationTabId': id,
    };
    bool isTokenized = false;
    if (UserModel.instance.customerId != null) {
      data['customerExtId'] = UserModel.instance.customerId;
      isTokenized = true;
    } else {
      data['deviceId'] = deviceId;
    }
    try {
      return await api.post(
        isTokenized ? _getApplicationSettingsByCustomerIdUrl : _getApplicationSettingsByDeviceIdUrlUrl,
        body: data,
        tokenized: isTokenized,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse> fetchMemberCodes(String url) async {
    return matriksApiClient.get(
      url,
    );
  }

  Future<ApiResponse> updateApplicationSettings({
    required int id,
    required List<Map<String, dynamic>> list,
    required bool isLoggedIn,
    String? deviceId,
  }) async {
    final Map<String, dynamic> body = {
      'settings': list,
      'applicationTabId': id,
    };

    if (isLoggedIn) {
      body['customerExtId'] = UserModel.instance.customerId;
    } else {
      body['deviceId'] = deviceId;
    }

    return api.post(
      isLoggedIn ? _updateApplicationSettingsByCustomerIdUrl : _updateApplicationSettingsByDeviceIdUrl,
      body: body,
      tokenized: isLoggedIn,
    );
  }

  Future<ApiResponse> getUpdatedRecords({
    required String lastDate,
  }) async {
    return api.post(
      _getUpdatedRecordsUrl,
      body: {
        'filter': lastDate,
      },
    );
  }

  Future<ApiResponse> getPriceSteps() async {
    return matriksApiClient.get(
      getIt<MatriksBloc>().state.endpoints!.rest!.priceStepV2!.url ?? '',
    );
  }

  Future<File> getPrecautionList() async {
    return DefaultCacheManager().getSingleFile(
      'https://www.borsaistanbul.com/erd/menkul_tedbir_listesi.csv',
      key: 'caution_list',
    );
  }

  Future<ApiResponse> getUSClock() async {
    return api.post(
      _getUSClock,
    );
  }

  Future<ApiResponse> getSessionHours() async {
    return matriksApiClient.get(
      '${AppConfig.instance.matriksUrl}/dumrul/v1/session-hours?${DateTimeUtils.serverDate(DateTime.now())}',
    );
  }

  Future<ApiResponse> getSplashStoriesHead() async {
    return genericApiClient.head(
      AppConfig.instance.flavor == Flavor.prod ? _getSplashStoriesProd : _getSplashStoriesDev,
    );
  }

  Future<ApiResponse> getSplashStories() async {
    return genericApiClient.get(
      AppConfig.instance.flavor == Flavor.prod ? _getSplashStoriesProd : _getSplashStoriesDev,
    );
  }
}
