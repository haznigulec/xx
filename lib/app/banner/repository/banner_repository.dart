import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class BannerRepository {
  Future<ApiResponse> getBanners();

  Future<ApiResponse> getMemberBanners({
    required String phoneNumber,
  });

  bool readBannerIsExpanded();

  void writeBannerIsExpanded({
    required bool isExpanded,
  });
}
