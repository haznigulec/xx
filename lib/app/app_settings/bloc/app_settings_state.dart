import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/general_settings.dart';
import 'package:piapiri_v2/core/model/order_settings.dart';

class AppSettingsState extends PState {
  final GeneralSettings generalSettings;
  final OrderSettings orderSettings;

  AppSettingsState({
    super.type = PageState.initial,
    super.error,
    GeneralSettings? generalSettings,
    OrderSettings? orderSettings,
  })  : generalSettings = generalSettings ?? const GeneralSettings(),
        orderSettings = orderSettings ?? OrderSettings();

  @override
  AppSettingsState copyWith({
    PageState? type,
    PBlocError? error,
    GeneralSettings? generalSettings,
    OrderSettings? orderSettings,
  }) {
    return AppSettingsState(
      type: type ?? this.type,
      error: error ?? this.error,
      generalSettings: generalSettings ?? this.generalSettings,
      orderSettings: orderSettings ?? this.orderSettings,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        generalSettings,
        orderSettings,
      ];
}
