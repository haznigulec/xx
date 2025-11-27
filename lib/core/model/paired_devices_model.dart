import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class PairedDevicesModel {
  final String deviceId;
  final String? deviceModel;
  final DateTime lastLoginDate;
  final DateTime matchDate;
  final bool isCurrentDevice;

  PairedDevicesModel({
    required this.deviceId,
    this.deviceModel,
    required this.lastLoginDate,
    required this.matchDate,
    this.isCurrentDevice = false,
  });

  factory PairedDevicesModel.fromJson(Map<String, dynamic> json) {
    return PairedDevicesModel(
      deviceId: json['deviceId'] as String,
      deviceModel: json['deviceModel'] != null ? json['deviceModel'] as String : null,
      lastLoginDate: DateTime.parse(json['lastLoginDate'] as String),
      matchDate: DateTime.parse(json['matchDate'] as String),
      isCurrentDevice: json['deviceId'] as String == getIt<AppInfo>().deviceId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'deviceModel': deviceModel ?? '',
      'lastLoginDate': lastLoginDate.toIso8601String(),
      'matchDate': matchDate.toIso8601String(),
    };
  }
}
