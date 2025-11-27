import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_event.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_state.dart';
import 'package:piapiri_v2/app/global_account_onboarding/model/account_setting_status_model.dart';
import 'package:piapiri_v2/app/global_account_onboarding/model/onboarding_account_info_model.dart';
import 'package:piapiri_v2/app/global_account_onboarding/repository/global_account_onboarding_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class GlobalAccountOnboardingBloc extends PBloc<GlobalAccountOnboardingState> {
  final GlobalAccountOnboardingRepository _globalAccountOnboardingRepository;

  GlobalAccountOnboardingBloc({
    required GlobalAccountOnboardingRepository globalAccountOnboardingRepository,
  })  : _globalAccountOnboardingRepository = globalAccountOnboardingRepository,
        super(initialState: const GlobalAccountOnboardingState()) {
    on<AccountSettingStatusEvent>(_onAccountSettingStatus);
    on<AccountInfoEvent>(_onAccountInfo);
    on<UploadAccountInfoEvent>(_onUploadAccountInfo);
  }
  FutureOr<void> _onAccountSettingStatus(
    AccountSettingStatusEvent event,
    Emitter<GlobalAccountOnboardingState> emit,
  ) async {
    if (UserModel.instance.customerId != null &&
        UserModel.instance.customerId == state.cutomerId &&
        state.accountSettingStatus?.accountStatus == 'ACTIVE') {
      event.succesCallback?.call(state.accountSettingStatus!);
      return;
    }

    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _globalAccountOnboardingRepository.accountSettingStatus();
    if (response.success && response.data != null) {
      AccountSettingStatusModel accountSettingStatus = AccountSettingStatusModel.fromJson(response.data);
      event.succesCallback?.call(accountSettingStatus);
      emit(
        state.copyWith(
          type: PageState.success,
          accountSettingStatus: accountSettingStatus,
          cutomerId: UserModel.instance.customerId,
        ),
      );
    } else {
      event.errorCallback?.call();
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05GONB01',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onAccountInfo(
    AccountInfoEvent event,
    Emitter<GlobalAccountOnboardingState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _globalAccountOnboardingRepository.getAccountInfo(
      listType: event.listType,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
          accountInfo: OnboardingAccountInfoModel.fromJson(response.data),
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05GONB02',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onUploadAccountInfo(
    UploadAccountInfoEvent event,
    Emitter<GlobalAccountOnboardingState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _globalAccountOnboardingRepository.uploadAccountInfo(
      countryOfCitizenship: event.countryOfCitizenship,
      countryOfTaxResidence: event.countryOfTaxResidence,
      employmentStatus: event.employmentStatus,
      totalAssets: event.totalAssets,
      fundingSource: event.fundingSource,
      isAffiliatedFinra: event.isAffiliatedFinra,
      isControlPerson: event.isControlPerson,
      isPoliticallyExposed: event.isPoliticallyExposed,
      immediateFamilyExposed: event.immediateFamilyExposed,
      employerName: event.employerName,
      employerAddress: event.employerAddress,
      employmentPosition: event.employmentPosition,
      agreementAcknowledgement: event.agreementAcknowledgement,
      digitalSignatureAcknowledgement: event.digitalSignatureAcknowledgement,
      agreementSignedAt: event.agreementSignedAt,
      agreementIpAddress: event.agreementIpAddress,
      createAccount: event.createAccount,
    );

    if (response.success) {
      event.callback(response);
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
    } else {
      event.callback(response);
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: event.createAccount == null,
            message: response.error?.message ?? '',
            errorCode: '05GONB02',
          ),
        ),
      );
    }
  }
}
