import 'package:piapiri_v2/app/global_account_onboarding/model/account_setting_status_model.dart';
import 'package:piapiri_v2/app/global_account_onboarding/model/onboarding_account_info_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';

class GlobalAccountOnboardingState extends PState {
  final String? cutomerId;
  final AccountSettingStatusModel? accountSettingStatus;
  final OnboardingAccountInfoModel? accountInfo;
  const GlobalAccountOnboardingState({
    super.type = PageState.initial,
    super.error,
    this.cutomerId,
    this.accountSettingStatus,
    this.accountInfo,
  });

  @override
  GlobalAccountOnboardingState copyWith({
    PageState? type,
    PBlocError? error,
    String? cutomerId,
    AccountSettingStatusModel? accountSettingStatus,
    OnboardingAccountInfoModel? accountInfo,
  }) {
    return GlobalAccountOnboardingState(
      type: type ?? this.type,
      error: error ?? this.error,
      cutomerId: cutomerId ?? this.cutomerId,
      accountSettingStatus: accountSettingStatus ?? this.accountSettingStatus,
      accountInfo: accountInfo ?? this.accountInfo,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        cutomerId,
        accountSettingStatus,
        accountInfo,
      ];
}
