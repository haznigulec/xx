import 'dart:convert';
import 'dart:io';

import 'package:piapiri_v2/common/utils/local_keys.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/app_info/repository/app_info_repository.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';

class AppInfoRepositoryImpl extends AppInfoRepository {
  @override
  Map<dynamic, dynamic> readHasMembership() {
    return getIt<LocalStorage>().read(
          LocalKeys.hasMembership,
        ) ??
        {
          'status': false,
          'gsm': '',
        };
  }

  @override
  void writeHasMembership({
    required bool status,
    required String gsm,
  }) {
    return getIt<LocalStorage>().write(
      LocalKeys.hasMembership,
      {
        'status': status,
        'gsm': gsm,
      },
    );
  }

  @override
  Map<dynamic, dynamic> readLoginCount() {
    return getIt<LocalStorage>().read(
          LocalKeys.loginCount,
        ) ??
        {};
  }

  @override
  bool? readShowCreateAccount() {
    return getIt<LocalStorage>().read(
      LocalKeys.showCreateAccount,
    );
  }

  @override
  Future<ApiResponse> checkAppFirstOpen(String deviceId) async {
    return getIt<PPApi>().appInfoService.checkAppFirstOpen(
          deviceId,
        );
  }

  @override
  Future<ApiResponse> fetchMemberCodes(String url) async {
    return getIt<PPApi>().appInfoService.fetchMemberCodes(
          url,
        );
  }

  @override
  Future<ApiResponse> getUpdatedRecords({
    required String lastDate,
  }) async {
    return getIt<PPApi>().appInfoService.getUpdatedRecords(
          lastDate: lastDate,
        );
  }

  @override
  Future<ApiResponse> getPriceSteps() async {
    return getIt<PPApi>().appInfoService.getPriceSteps();
  }

  @override
  Future<File> getPrecautionList() async {
    return getIt<PPApi>().appInfoService.getPrecautionList();
  }

  @override
  Future<ApiResponse> getDictionary() {
    return getIt<PPApi>().appInfoService.getAllLanguageDictionary();
  }

  @override
  Future<ApiResponse> getUSClock() {
    return getIt<PPApi>().appInfoService.getUSClock();
  }

  @override
  Future<ApiResponse> getSessionHours() {
    return getIt<PPApi>().appInfoService.getSessionHours();
  }

  @override
  Future<Map<String, dynamic>> getIosDeviceModels() async {
    final data = await getIt<LocalStorage>().read(LocalKeys.iosDeviceModels);
    Map<String, dynamic>? iosDeviceModels;
    if (data != null) {
      iosDeviceModels = Map<String, dynamic>.from(data);
    } else {
      iosDeviceModels = jsonDecode(remoteConfig.getString('iosDeviceModels'));
      getIt<LocalStorage>().write(LocalKeys.iosDeviceModels, iosDeviceModels);
    }

    return iosDeviceModels!;
  }

  @override
  Future<Map<String, dynamic>?> readSplashStoriesLocal() async {
    final data = await getIt<LocalStorage>().read(LocalKeys.splashStories);
    return data != null ? Map<String, dynamic>.from(data) : null;
  }

  @override
  Future<ApiResponse> getSplashStoriesHead() {
    return getIt<PPApi>().appInfoService.getSplashStoriesHead();
  }

  @override
  Future writeSplashStoriesLocal(Map<String, dynamic> splashStories) {
    return getIt<LocalStorage>().writeAsync(LocalKeys.splashStories, splashStories);
  }

  @override
  Future<ApiResponse> getSplashStories() {
    return getIt<PPApi>().appInfoService.getSplashStories();
  }
}
