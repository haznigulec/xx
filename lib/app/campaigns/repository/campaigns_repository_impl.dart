import 'package:piapiri_v2/app/campaigns/repository/campaigns_repository.dart';
import 'package:piapiri_v2/common/utils/local_keys.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';

class CampaignsRepositoryImpl extends CampaignsRepository {
  @override
  Map<dynamic, dynamic> hasMembership() {
    return getIt<LocalStorage>().read(LocalKeys.hasMembership) ?? {'status': false, 'gsm': ''};
  }

  @override
  Map<dynamic, dynamic>? loginCount() {
    return getIt<LocalStorage>().read(LocalKeys.loginCount);
  }

  @override
  Future<ApiResponse> getCampaigns() async {
    return getIt<PPApi>().campaignsService.getCampaigns();
  }

  @override
  Future<ApiResponse> getCampaignDetail({
    required String campaignCode,
  }) async {
    return getIt<PPApi>().campaignsService.getCampaignDetail(
          campaignCode: campaignCode,
        );
  }

  @override
  Future<ApiResponse> getCampaignParticipationCode({
    required String campaignCode,
  }) async {
    return getIt<PPApi>().campaignsService.getCampaignParticipationCode(
          campaignCode: campaignCode,
        );
  }
}
