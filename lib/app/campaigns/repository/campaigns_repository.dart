import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class CampaignsRepository {
  hasMembership();
  loginCount();

  Future<ApiResponse> getCampaigns();

  Future<ApiResponse> getCampaignDetail({
    required String campaignCode,
  });

  Future<ApiResponse> getCampaignParticipationCode({
    required String campaignCode,
  });
}
