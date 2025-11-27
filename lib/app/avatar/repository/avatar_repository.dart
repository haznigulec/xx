import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class AvatarRepository {
  Future<ApiResponse> getAvatarAndLimit({
    String? refCode,
  });

  Future<ApiResponse> uploadAvatar({
    String image = '',
  });

  Future<ApiResponse> generateAvatar({
    String descriptionText = '',
  });

  Future<ApiResponse> setAvatar({
    String refCode = '',
  });
}
