import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/alarm_model.dart';

class AlarmState extends PState {
  final List<PriceAlarm> priceAlarms;
  final List<NewsAlarm> newsAlarms;
  final int? notificationUnReadCount;

  const AlarmState({
    super.type = PageState.initial,
    super.error,
    this.notificationUnReadCount,
    this.priceAlarms = const [],
    this.newsAlarms = const [],
  });

  @override
  AlarmState copyWith({
    PageState? type,
    PBlocError? error,
    int? notificationUnReadCount,
    List<PriceAlarm>? priceAlarms,
    List<NewsAlarm>? newsAlarms,
  }) {
    return AlarmState(
      type: type ?? this.type,
      error: error ?? this.error,
      notificationUnReadCount: notificationUnReadCount ?? this.notificationUnReadCount,
      priceAlarms: priceAlarms ?? this.priceAlarms,
      newsAlarms: newsAlarms ?? this.newsAlarms,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        notificationUnReadCount,
        priceAlarms,
        newsAlarms,
      ];
}
