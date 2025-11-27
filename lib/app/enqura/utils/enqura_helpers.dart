import 'dart:math';

import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:p_core/keys/navigator_keys.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

String guidGenerator() {
  final Random random = Random();

  String generateHex(int length) {
    const chars = '0123456789abcdef';
    return List.generate(length, (_) => chars[random.nextInt(16)]).join();
  }

  return '${generateHex(8)}-'
      '${generateHex(4)}-'
      '4${generateHex(3)}-'
      '${['8', '9', 'a', 'b'][random.nextInt(4)]}${generateHex(3)}-'
      '${generateHex(12)}';
}

TimeOfDay parseTime(String timeStr) {
  final parts = timeStr.split(':');
  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);
  return TimeOfDay(hour: hour, minute: minute);
}

String formatTimeRange(AppointmentSlotItem item) {
  final start = parseTime(item.startTime);
  final end = parseTime(item.endTime);
  return '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')} - '
      '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
}

Future<bool> handlePermission({
  required Permission permission,
  required String message,
  required BuildContext ctx,
}) async {
  var status = await permission.status;

  if (status.isGranted) {
    return true;
  }

  if (status.isDenied) {
    var newStatus = await permission.request();
    if (newStatus.isGranted) {
      return true;
    }
  }

  PBottomSheet.showError(
    NavigatorKeys.navigatorKey.currentContext ?? ctx,
    content: message,
    isDismissible: true,
    showFilledButton: true,
    filledButtonText: L10n.tr('open_settings'),
    onFilledButtonPressed: () {
      Navigator.of(ctx).pop();
      openAppSettings();
    },
  );

  return false;
}

class AppointmentResponse {
  final List<AppointmentData> data;
  final bool isSuccessful;
  final String referenceId;

  AppointmentResponse({
    required this.data,
    required this.isSuccessful,
    required this.referenceId,
  });

  factory AppointmentResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentResponse(
      data: (json['Data'] as List?)?.map((e) => AppointmentData.fromJson(e)).toList() ?? [],
      isSuccessful: json['IsSuccessful'] ?? false,
      referenceId: json['ReferenceId'] ?? '',
    );
  }
}

class AppointmentData {
  final String callType;
  final String callTypeValue;
  final String email;
  final AppointmentDate startDate;
  final AppointmentDate endDate;
  final String identityNo;
  final String identityType;
  final bool isPriorityCustomer;
  final String name;
  final String surname;
  final String phone;
  final String uid;

  AppointmentData({
    required this.callType,
    required this.callTypeValue,
    required this.email,
    required this.startDate,
    required this.endDate,
    required this.identityNo,
    required this.identityType,
    required this.isPriorityCustomer,
    required this.name,
    required this.surname,
    required this.phone,
    required this.uid,
  });

  factory AppointmentData.fromJson(Map<String, dynamic> json) {
    return AppointmentData(
      callType: json['CallType'] ?? '',
      callTypeValue: json['CallTypeValue'] ?? '',
      email: json['Email'] ?? '',
      startDate: AppointmentDate.fromJson(json['StartDate']),
      endDate: AppointmentDate.fromJson(json['EndDate']),
      identityNo: json['IdentityNo'] ?? '',
      identityType: json['IdentityType'] ?? '',
      isPriorityCustomer: json['IsPriorityCustomer'] ?? false,
      name: json['Name'] ?? '',
      surname: json['Surname'] ?? '',
      phone: json['Phone'] ?? '',
      uid: json['UId'] ?? '',
    );
  }
}

class AppointmentSlotsResponse {
  final List<AppointmentSlotItem> data;
  final bool isSuccessful;
  final String referenceId;

  AppointmentSlotsResponse({
    required this.data,
    required this.isSuccessful,
    required this.referenceId,
  });

  factory AppointmentSlotsResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentSlotsResponse(
      data: (json['Data'] as List?)?.map((e) => AppointmentSlotItem.fromJson(e)).toList() ?? [],
      isSuccessful: json['IsSuccessful'] ?? false,
      referenceId: json['ReferenceId'] ?? '',
    );
  }
}

class AppointmentSlotItem {
  final int count;
  final AppointmentDate date;
  final String startTime;
  final String endTime;

  AppointmentSlotItem({
    required this.count,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  factory AppointmentSlotItem.fromJson(Map<String, dynamic> json) {
    return AppointmentSlotItem(
      count: json['Count'] ?? 0,
      date: AppointmentDate.fromJson(json['Date']),
      startTime: json['StartTime'] ?? '',
      endTime: json['EndTime'] ?? '',
    );
  }
}

class AppointmentDate {
  final DateTimeDetails dateTime;
  final OffsetDetails offset;

  AppointmentDate({
    required this.dateTime,
    required this.offset,
  });

  factory AppointmentDate.fromJson(Map<String, dynamic> json) {
    return AppointmentDate(
      dateTime: DateTimeDetails.fromJson(json['dateTime']),
      offset: OffsetDetails.fromJson(json['offset']),
    );
  }
}

class DateTimeDetails {
  final SimpleDate date;
  final SimpleTime time;

  DateTimeDetails({
    required this.date,
    required this.time,
  });

  factory DateTimeDetails.fromJson(Map<String, dynamic> json) {
    return DateTimeDetails(
      date: SimpleDate.fromJson(json['date']),
      time: SimpleTime.fromJson(json['time']),
    );
  }
}

class SimpleDate {
  final int day;
  final int month;
  final int year;

  SimpleDate({required this.day, required this.month, required this.year});

  factory SimpleDate.fromJson(Map<String, dynamic> json) {
    return SimpleDate(
      day: json['day'] ?? 0,
      month: json['month'] ?? 0,
      year: json['year'] ?? 0,
    );
  }
}

class SimpleTime {
  final int hour;
  final int minute;
  final int second;
  final int nano;

  SimpleTime({
    required this.hour,
    required this.minute,
    required this.second,
    required this.nano,
  });

  factory SimpleTime.fromJson(Map<String, dynamic> json) {
    return SimpleTime(
      hour: json['hour'] ?? 0,
      minute: json['minute'] ?? 0,
      second: json['second'] ?? 0,
      nano: json['nano'] ?? 0,
    );
  }
}

class OffsetDetails {
  final int totalSeconds;

  OffsetDetails({required this.totalSeconds});

  factory OffsetDetails.fromJson(Map<String, dynamic> json) {
    return OffsetDetails(totalSeconds: json['totalSeconds'] ?? 0);
  }
}
