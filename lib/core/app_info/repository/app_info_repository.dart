import 'dart:io';

import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class AppInfoRepository {
  Map<dynamic, dynamic> readHasMembership();
  void writeHasMembership({
    required bool status,
    required String gsm,
  });

  Map<dynamic, dynamic> readLoginCount();

  bool? readShowCreateAccount();

  Future<ApiResponse> checkAppFirstOpen(String deviceId);

  Future<ApiResponse> fetchMemberCodes(String url);

  Future<ApiResponse> getUpdatedRecords({
    required String lastDate,
  });
  Future<ApiResponse> getPriceSteps();
  Future<File> getPrecautionList();
  Future<ApiResponse> getDictionary();
  Future<ApiResponse> getUSClock();
  Future<ApiResponse> getSessionHours();
  Future<Map<String, dynamic>> getIosDeviceModels();
  Future<Map<String, dynamic>?> readSplashStoriesLocal();
  Future<ApiResponse> getSplashStoriesHead();
  Future<ApiResponse> getSplashStories();
  Future<void> writeSplashStoriesLocal(Map<String, dynamic> splashStories);
}
