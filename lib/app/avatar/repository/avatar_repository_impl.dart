import 'package:piapiri_v2/app/avatar/repository/avatar_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class AvatarRepositoryImpl extends AvatarRepository {

  @override
  Future<ApiResponse> getAvatarAndLimit({
    String? refCode,
  }) async {
    return getIt<PPApi>().avatarService.validateAvatar(
          refCode: refCode,
        );
  }

  @override
  Future<ApiResponse> uploadAvatar({
    String image = '',
  }) async {
    return getIt<PPApi>().avatarService.uploadAvatar(
          image: image,
        );
  }

  @override
  Future<ApiResponse> generateAvatar({
    String descriptionText = '',
  }) async {
    return getIt<PPApi>().avatarService.generateAvatar(
          descriptionText: descriptionText,
        );
  }

  @override
  Future<ApiResponse> setAvatar({
    String refCode = '',
  }) async {
    return getIt<PPApi>().avatarService.setAvatar(
          refCode: refCode,
        );
  }
}
