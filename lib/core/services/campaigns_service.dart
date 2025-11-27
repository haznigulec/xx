import 'package:piapiri_v2/app/campaigns/repository/campaigns_repository_impl.dart';
import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class CampaignsService {
  final ApiClient api;

  CampaignsService(this.api);
  final Map<dynamic, dynamic> _hasMembership = CampaignsRepositoryImpl().hasMembership();
  final Map? _loginCount = CampaignsRepositoryImpl().loginCount();

  static const String _getCampaignsUrl = '/Campaign/GetAllCampaigns';
  static const String _getCampaignDetailUrl = '/Campaign/GetByCampaignCode';
  static const String _getCampaignParticipationCodeUrl = '/Campaign/GetCustomerCampaignCode';

  Future<ApiResponse> getCampaigns() async {
    return api.post(
      _getCampaignsUrl,
      body: {
        'customerExtId':
            _hasMembership['status'] && _loginCount == null ? _hasMembership['gsm'] : UserModel.instance.customerId,
      },
    );
  }

  Future<ApiResponse> getCampaignDetail({
    required String campaignCode,
  }) async {
    return api.post(
      _getCampaignDetailUrl,
      body: {
        'CampaignCode': campaignCode,
        'customerExtId':
            _hasMembership['status'] && _loginCount == null ? _hasMembership['gsm'] : UserModel.instance.customerId,
      },
    );
  }

  Future<ApiResponse> getCampaignParticipationCode({
    required String campaignCode,
  }) async {
    return api.post(
      _getCampaignParticipationCodeUrl,
      tokenized: true,
      body: {
        'CampaignCode': campaignCode,
        'customerExtId': UserModel.instance.customerId,
      },
    );
  }
}
