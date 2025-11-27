import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class BannerService {
  final ApiClient api;

  BannerService(this.api);

  static const String _getAllBannersUrl = '/Banner/getallbanners';
  static const String _getAllMemberBannersUrl = '/Banner/getallmemberbanners';

  Future<ApiResponse> getBanners() async {
    return api.post(
      _getAllBannersUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'useCdn': true,
        'userType': UserModel.instance.customerChannel != null &&
                UserModel.instance.customerChannel!.toLowerCase().contains('dijital')
            ? 3
            : 1,
        'version': 2,
      },
    );
  }

  Future<ApiResponse> getMemberBanners({
    required String phoneNumber,
  }) async {
    return api.post(
      _getAllMemberBannersUrl,
      body: {
        'phoneNumber': phoneNumber,
        'useCdn': true,
        'version': 2,
        'deviceId': getIt<AppInfo>().deviceId,
      },
    );
  }
}
