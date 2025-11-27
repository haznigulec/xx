import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:piapiri_v2/app/banner/bloc/banner_event.dart';
import 'package:piapiri_v2/app/banner/bloc/banner_state.dart';
import 'package:piapiri_v2/app/banner/repository/banner_repository.dart';
import 'package:piapiri_v2/common/utils/local_keys.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/banner_model.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';

class BannerBloc extends PBloc<BannerState> {
  final BannerRepository _bannerRepository;
  BannerBloc({required BannerRepository bannerRepository})
      : _bannerRepository = bannerRepository,
        super(initialState: const BannerState()) {
    on<GetBannersEvent>(_onGetBanners);
    on<GetCachedBannersEvent>(_onGetCachedBanners);
    on<GetMemberBannersEvent>(_onGetMemberBanners);
    on<SetExpandedBannersEvent>(_onSetExpandedBannersEvent);
    on<ResetBannersEvent>(_onResetBanners);
    on<GetBannerIsExpandedEvent>(_onGetBannerIsExpanded);
  }

  FutureOr<void> _onGetBanners(
    GetBannersEvent event,
    Emitter<BannerState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.fetching,
      ),
    );

    ApiResponse response = await _bannerRepository.getBanners();

    if (response.success) {
      List<BannerModel> banners = [];
      if (response.data['bannerList'] != null) {
        banners.addAll(response.data['bannerList'].map<BannerModel>((e) => BannerModel.fromJson(e)).toList());
      }

      final LocalStorage localStorage = getIt<LocalStorage>();
      final localStorageBanners = await localStorage.readSecure(LocalKeys.loginUserBanners);
      if (localStorageBanners != null) {
        await localStorage.deleteSecureAsync(LocalKeys.loginUserBanners);
      }

      if (banners.isNotEmpty) {
        String jsonString = jsonEncode(response.data['bannerList']);
        await localStorage.writeSecureAsync(LocalKeys.loginUserBanners, jsonString);
      }

      emit(
        state.copyWith(
          type: PageState.success,
          banners: banners.where((element) => element.isActive == true).toList(),
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            message: response.error?.message ?? '',
            showErrorWidget: true,
            errorCode: '00BANR01',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetCachedBanners(
    GetCachedBannersEvent event,
    Emitter<BannerState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.fetching,
      ),
    );

    List<BannerModel> banners = [];
    final LocalStorage localStorage = getIt<LocalStorage>();
    final localStorageBanners = await localStorage.readSecure(LocalKeys.loginUserBanners);
    if (localStorageBanners != null) {
      final List<dynamic> jsonList = jsonDecode(localStorageBanners);
      banners.addAll(jsonList.map((json) => BannerModel.fromJson(json)).toList());
    }

    emit(
      state.copyWith(
        type: PageState.success,
        banners: banners.where((element) => element.isActive == true).toList(),
      ),
    );
  }

  FutureOr<void> _onGetMemberBanners(
    GetMemberBannersEvent event,
    Emitter<BannerState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.fetching,
      ),
    );
    ApiResponse response = await _bannerRepository.getMemberBanners(
      phoneNumber: event.phoneNumber,
    );

    if (response.success) {
      List<BannerModel> banners = response.data['bannerList'].map<BannerModel>((e) => BannerModel.fromJson(e)).toList();
      emit(
        state.copyWith(
          type: PageState.success,
          banners: banners.where((element) => element.isActive == true).toList(),
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            message: response.error?.message ?? '',
            showErrorWidget: true,
            errorCode: '00BANR02',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onSetExpandedBannersEvent(
    SetExpandedBannersEvent event,
    Emitter<BannerState> emit,
  ) async {
    _bannerRepository.writeBannerIsExpanded(
      isExpanded: event.isExpanded,
    );

    emit(
      state.copyWith(
        isExpanded: event.isExpanded,
      ),
    );
  }

  FutureOr<void> _onGetBannerIsExpanded(
    GetBannerIsExpandedEvent event,
    Emitter<BannerState> emit,
  ) async {
    event.onIsExpanded(
      _bannerRepository.readBannerIsExpanded(),
    );
  }

  FutureOr<void> _onResetBanners(
    ResetBannersEvent event,
    Emitter<BannerState> emit,
  ) async {
    emit(
      state.copyWith(
        banners: [],
      ),
    );
  }
}
