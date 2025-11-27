import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class AvatarService {
  final ApiClient api;

  AvatarService(this.api);

  static const String _validateAvatar = '/adkavatar/validateavatar';
  static const String _uploadAvatar = '/adkavatar/uploadavatar';
  static const String _generateAvatar = '/adkavatar/generateavatar';
  static const String _setAvatar = '/adkavatar/setavatar';

  Future<ApiResponse> validateAvatar({
    String? refCode,
  }) async {
    return api.post(
      _validateAvatar,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'deviceId': getIt<AppInfo>().deviceId,
        'refCode': refCode,
      },
    );
  }

  Future<ApiResponse> uploadAvatar({
    String image = '',
  }) async {
    return api.post(
      _uploadAvatar,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'deviceId': getIt<AppInfo>().deviceId,
        'image': image,
      },
    );
  }

  Future<ApiResponse> generateAvatar({
    String descriptionText = '',
  }) async {
    return api.post(
      _generateAvatar,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'deviceId': getIt<AppInfo>().deviceId,
        'descriptionText': descriptionText,
      },
    );
  }

  Future<ApiResponse> setAvatar({
    String refCode = '',
  }) async {
    return api.post(
      _setAvatar,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'deviceId': getIt<AppInfo>().deviceId,
        'refCode': refCode,
      },
    );
  }
}
