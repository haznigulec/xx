import 'package:equatable/equatable.dart';
import 'package:piapiri_v2/core/model/general_settings.dart';
import 'package:piapiri_v2/core/model/order_settings.dart';

class AppSettings extends Equatable {
  final GeneralSettings generalSettings;
  final OrderSettings orderSettings;

  AppSettings({
    GeneralSettings? generalSettings,
    OrderSettings? orderSettings,
  })  : generalSettings = generalSettings ?? const GeneralSettings(),
        orderSettings = orderSettings ?? OrderSettings();

  AppSettings copyWith({
    GeneralSettings? generalSettings,
    OrderSettings? orderSettings,
  }) {
    return AppSettings(
      generalSettings: generalSettings ?? this.generalSettings,
      orderSettings: orderSettings ?? this.orderSettings,
    );
  }

  @override
  List<Object?> get props => [
        generalSettings,
        orderSettings,
      ];
}
