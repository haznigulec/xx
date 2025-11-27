import 'package:piapiri_v2/app/campaigns/model/campaign_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';

class CampaignsState extends PState {
  final List<CampaignModel> campaigns;
  final CampaignDetailModel? detail;
  final bool rightToParticipate;
  final String campaignCode;
  final bool? isCampaignsAvailable;

  const CampaignsState({
    super.type = PageState.initial,
    super.error,
    this.campaigns = const [],
    this.detail,
    this.rightToParticipate = false,
    this.campaignCode = '',
    this.isCampaignsAvailable,
  });

  @override
  CampaignsState copyWith({
    PageState? type,
    PBlocError? error,
    List<CampaignModel>? campaigns,
    CampaignDetailModel? detail,
    bool? rightToParticipate,
    String? campaignCode,
    bool? isCampaignsAvailable,
  }) {
    return CampaignsState(
      type: type ?? this.type,
      error: error ?? this.error,
      campaigns: campaigns ?? this.campaigns,
      detail: detail ?? this.detail,
      rightToParticipate: rightToParticipate ?? this.rightToParticipate,
      campaignCode: campaignCode ?? this.campaignCode,
      isCampaignsAvailable: isCampaignsAvailable ?? this.isCampaignsAvailable,
    );
  }
}
