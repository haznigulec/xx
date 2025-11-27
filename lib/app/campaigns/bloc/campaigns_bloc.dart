import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:piapiri_v2/app/campaigns/bloc/campaigns_event.dart';
import 'package:piapiri_v2/app/campaigns/bloc/campaigns_state.dart';
import 'package:piapiri_v2/app/campaigns/model/campaign_model.dart';
import 'package:piapiri_v2/app/campaigns/repository/campaigns_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class CampaignsBloc extends PBloc<CampaignsState> {
  final CampaignsRepository _campaignsRepository;

  CampaignsBloc({
    required CampaignsRepository campaignsRepository,
  })  : _campaignsRepository = campaignsRepository,
        super(initialState: const CampaignsState()) {
    on<CampaignsGetEvent>(_onGetCampaigns);
    on<CampaignsGetDetailEvent>(_onGetCampaignDetail);
    on<CampaignsGetParticipationCodeEvent>(_onGetParticipationCode);
    on<GetCampaignIsAvailable>(_onGetCampaignIsAvailable);
  }

  FutureOr<void> _onGetCampaigns(
    CampaignsGetEvent event,
    Emitter<CampaignsState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _campaignsRepository.getCampaigns();

    if (response.success) {
      List<CampaignModel> campaigns =
          response.data['campaignList'].map<CampaignModel>((e) => CampaignModel.fromJson(e)).toList();

      bool rightToParticipate = campaigns.any((e) => e.rightToParticipate > 0);

      emit(
        state.copyWith(
          type: PageState.success,
          campaigns: campaigns,
          rightToParticipate: rightToParticipate,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            message: response.error?.message ?? '',
            errorCode: 'CMP001',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetCampaignDetail(
    CampaignsGetDetailEvent event,
    Emitter<CampaignsState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _campaignsRepository.getCampaignDetail(
      campaignCode: event.campaignCode,
    );

    if (response.success) {
      emit(
        CampaignsState(
          type: PageState.success,
          detail: CampaignDetailModel.fromJson(
            response.data['campaign'],
          ),
          campaigns: state.campaigns,
          rightToParticipate: state.rightToParticipate,
          isCampaignsAvailable: state.isCampaignsAvailable,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            message: response.error?.message ?? '',
            errorCode: 'CMP002',
          ),
          isCampaignsAvailable: state.isCampaignsAvailable,
        ),
      );
    }
  }

  FutureOr<void> _onGetParticipationCode(
    CampaignsGetParticipationCodeEvent event,
    Emitter<CampaignsState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _campaignsRepository.getCampaignParticipationCode(
      campaignCode: event.campaignCode,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
          campaignCode: response.data['campaignCode'],
        ),
      );

      add(
        CampaignsGetEvent(),
      );

      event.callback();
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: 'CMP003',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetCampaignIsAvailable(
    GetCampaignIsAvailable event,
    Emitter<CampaignsState> emit,
  ) async {
    bool isCampaignsAvailable = remoteConfig.getBool(
      AppConfig.instance.isProd ? 'isCampaignsAvailable' : 'isCampaignsAvailable_dev',
    );

    emit(
      state.copyWith(
        isCampaignsAvailable: isCampaignsAvailable,
      ),
    );
  }
}
