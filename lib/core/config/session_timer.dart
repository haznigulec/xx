import 'dart:async';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:p_core/keys/navigator_keys.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_event.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class SessionTimer {
  static SessionTimer? instance;
  static late int _sessionTimeout;

  factory SessionTimer({
    required int sessionTimeout,
  }) {
    instance = SessionTimer._internal();
    _sessionTimeout = sessionTimeout;
    return instance!;
  }

  SessionTimer._internal();

  late Timer? timer;
  void startTimer() {
    timer = Timer.periodic(Duration(minutes: _sessionTimeout), (_) {
      timedOut();
    });
  }

  void userActivityDetected([_]) {
    if (getIt<AuthBloc>().state.isLoggedIn) {
      if (timer != null && timer?.isActive == true) {
        timer!.cancel();
        startTimer();
      }
      return;
    }
  }

  Future<void> timedOut() async {
    timer!.cancel();
    PBottomSheet.showError(
      NavigatorKeys.navigatorKey.currentContext!,
      content: L10n.tr('session.timeout_message'),
      showFilledButton: true,
      filledButtonText: L10n.tr('tamam'),
      onFilledButtonPressed: () {
        getIt<AuthBloc>().add(const LogoutEvent());
      },
    );
  }

  void cancelTimer() {
    if (timer != null && timer!.isActive) timer!.cancel();
  }
}
