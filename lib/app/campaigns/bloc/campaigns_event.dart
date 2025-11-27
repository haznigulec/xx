import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';

abstract class CampaignsEvent extends PEvent {}

class CampaignsGetEvent extends CampaignsEvent {}

class HomeEventGetTemplates extends CampaignsEvent {}

class CampaignsGetDetailEvent extends CampaignsEvent {
  final String campaignCode;

  CampaignsGetDetailEvent(this.campaignCode);
}

class CampaignsGetParticipationCodeEvent extends CampaignsEvent {
  final String campaignCode;
  final VoidCallback callback;

  CampaignsGetParticipationCodeEvent(
    this.campaignCode,
    this.callback,
  );
}

class GetCampaignIsAvailable extends CampaignsEvent {
  GetCampaignIsAvailable();
}
