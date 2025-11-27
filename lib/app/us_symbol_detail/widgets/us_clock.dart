import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_event.dart';
import 'package:piapiri_v2/core/bloc/time/time_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/gen/Timestamp/Timestamp.pb.dart';
import 'package:piapiri_v2/core/model/us_market_status_enum.dart';
import 'package:piapiri_v2/core/model/us_time_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest_all.dart';
//Us piyasası market durumu

UsMarketStatus getMarketStatus() {
  USTimeModel usTime = getIt<AppInfoBloc>().state.usTime ?? USTimeModel();

  String preMarketHour = L10n.tr('preMarketHour');
  String afterMarketHour = L10n.tr('postMarketHour');

  int nextHourPart = int.parse(preMarketHour.split(':')[0]);
  int nextMinutePart = int.parse(preMarketHour.split(':')[1]);
  int afterHourPart = int.parse(afterMarketHour.split(':')[0]);
  int afterMinutePart = int.parse(afterMarketHour.split(':')[1]);

  TimeMessage? mxTime = getIt<TimeBloc>().state.mxTime;

  // mx time null gelirse usTime.timestamp a bakılıyor USTimeModel() default değerler null geliyor bunun için kontrol eklendi.
  if (mxTime == null && usTime.timestamp == null) {
    return UsMarketStatus.closed;
  }

  DateTime currentTime = parseIsoTime(
    mxTime != null
        ? DateTime.fromMicrosecondsSinceEpoch(
            mxTime.timestamp.toInt(),
          ).toUtc().toIso8601String()
        : DateTime.parse(usTime.timestamp!).subtract(const Duration(minutes: 15)).toIso8601String(),
  );

  // USTimeModel() default değerler null geliyor bunun için kontrol eklendi.
  if (usTime.nextOpen == null || usTime.nextClose == null) {
    return UsMarketStatus.closed;
  }

  DateTime nextOpen = parseIsoTime(usTime.nextOpen!);
  DateTime nextClose = parseIsoTime(usTime.nextClose!);
  checkTime(nextOpen, nextClose, currentTime);
  if (usTime.isOpen == true) {
    return UsMarketStatus.open;
  } else {
    DateTime marketPrePhaseStart = nextOpen.subtract(
      Duration(
        hours: nextHourPart,
        minutes: nextMinutePart,
      ),
    );

    if (DateTimeUtils().isWeekend(
        date: currentTime.subtract(Duration(
      hours: nextHourPart,
      minutes: nextMinutePart,
    )))) {
      return UsMarketStatus.weekend;
    }

    if (currentTime.isBefore(nextOpen) && currentTime.isAfter(marketPrePhaseStart)) {
      return UsMarketStatus.preMarket;
    } else if (currentTime.isAfter(nextClose.subtract(const Duration(days: 1))) &&
        currentTime.isBefore(
          nextClose.subtract(const Duration(days: 1)).add(
                Duration(
                  hours: afterHourPart,
                  minutes: afterMinutePart,
                ),
              ),
        )) {
      return UsMarketStatus.afterMarket;
    } else {
      return UsMarketStatus.closed;
    }
  }
}

UsMarketStatus getMarketPhase(int timestampUtcSeconds) {
  final rawNanoTimestamp = timestampUtcSeconds;
  final utcSeconds = rawNanoTimestamp ~/ 1000000000;
  initializeTimeZones();
  final et = getLocation('America/New_York');

  final utc = DateTime.fromMillisecondsSinceEpoch(utcSeconds * 1000, isUtc: true);
  final etTime = TZDateTime.from(utc, et);

  if (etTime.weekday < DateTime.monday || etTime.weekday > DateTime.friday) {
    return UsMarketStatus.closed;
  }

  // ET zamanına göre pazartesi-cuma kontrolü yapıldıktan sonra
  final etMinutes = etTime.hour * 60 + etTime.minute;

  const preStart = 4 * 60; // 04:00
  const preEnd = 9 * 60 + 30; // 09:30
  const regStart = preEnd; // 09:30
  const regEnd = 16 * 60; // 16:00
  const aftEnd = 20 * 60; // 20:00

  if (etMinutes >= preStart && etMinutes < preEnd) {
    return UsMarketStatus.preMarket;
  } else if (etMinutes >= regStart && etMinutes < regEnd) {
    return UsMarketStatus.open;
  } else if (etMinutes >= regEnd && etMinutes < aftEnd) {
    return UsMarketStatus.afterMarket;
  }
  return UsMarketStatus.closed;
}

DateTime parseIsoTime(String isoTime) {
  return DateTime.parse(isoTime);
}

bool isOpenTriggered = false;
bool isCloseTriggered = false;

void checkTime(
  DateTime nextOpen,
  DateTime nextClose,
  DateTime currentTime,
) {
  if (currentTime.hour == nextOpen.hour && currentTime.minute == nextOpen.minute && !isOpenTriggered) {
    isOpenTriggered = true;
    getIt<AppInfoBloc>().add(GetUSClockEvent());
  }

  if (currentTime.hour == nextClose.hour && currentTime.minute == nextOpen.minute && !isCloseTriggered) {
    isCloseTriggered = true;
    getIt<AppInfoBloc>().add(GetUSClockEvent());
  }

  // Sıfırlama
  if (currentTime.hour == 0 && currentTime.minute == 0) {
    isOpenTriggered = false;
    isCloseTriggered = false;
  }
}
