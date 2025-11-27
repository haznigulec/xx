import 'package:piapiri_v2/app/banner/repository/banner_repository.dart';
import 'package:piapiri_v2/common/utils/local_keys.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';

class BannerRepositoryImpl extends BannerRepository {
  @override
  Future<ApiResponse> getBanners() async {
    return getIt<PPApi>().bannerService.getBanners();
  }

  @override
  Future<ApiResponse> getMemberBanners({
    required String phoneNumber,
  }) async {
    return getIt<PPApi>().bannerService.getMemberBanners(
          phoneNumber: phoneNumber,
        );
  }

  @override
  bool readBannerIsExpanded() {
    return getIt<LocalStorage>().read(LocalKeys.bannerIsExpanded) ?? true;
  }

  @override
  void writeBannerIsExpanded({required bool isExpanded}) {
    return getIt<LocalStorage>().write(
      LocalKeys.bannerIsExpanded,
      isExpanded,
    );
  }
}
