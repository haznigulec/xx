import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/alarm/bloc/alarm_event.dart';
import 'package:piapiri_v2/app/alarm/bloc/alarm_state.dart';
import 'package:piapiri_v2/app/alarm/repository/alarm_repository.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/alarm_model.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';

class AlarmBloc extends PBloc<AlarmState> {
  final AlarmRepository _alarmRepository;

  AlarmBloc({
    required AlarmRepository alarmRepository,
  })  : _alarmRepository = alarmRepository,
        super(initialState: const AlarmState()) {
    on<SetPriceAlarmEvent>(_onSetPriceAlarm);
    on<SetPriceAlarmStatusEvent>(_onSetPriceAlarmStatus);
    on<SetNewsAlarmEvent>(_onSetNewsAlarm);
    on<RemoveAlarmEvent>(_onRemoveAlarm);
    on<GetAlarmsEvent>(_onGetAlarms);
    on<ResetAlarmEvent>(_onReset);
  }

  FutureOr<void> _onSetPriceAlarm(
    SetPriceAlarmEvent event,
    Emitter<AlarmState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    DateTime expireDate = DateTime.now().add(
      Duration(
        days: event.validity.value,
      ),
    );
    ApiResponse response = await _alarmRepository.setPriceAlarm(
      symbolName: event.symbolName,
      price: event.price,
      condition: event.condition,
      expireDate: DateTimeUtils.toMilliseconds(expireDate),
      note: event.note,
      url: getIt<MatriksBloc>().state.endpoints!.rest!.arf!.insertRule?.url ?? '',
    );

    if (response.success) {
      getIt<PPApi>().alarmService.setMatriksRulePriceAlarm(
            symbolName: event.symbolName,
            price: event.price,
            condition: event.condition,
            expireDate: DateTimeUtils.serverDateAndTimeWithZone(expireDate),
            note: event.note,
            ruleId: response.data,
          );

      add(
        GetAlarmsEvent(),
      );

      event.callback(
        response.success,
      );

      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.dioResponse?.data['error']['code'] == 'EXIST_ERROR'
                ? 'price_alarm_exist_alert'
                : response.error?.message != null
                    ?
                    // Utils.tr('alarm.set_alarm_error.${response.error?.message}')
                    'alarm.set_alarm_error.${response.error?.message}'
                    : '',
            errorCode: '01ALR001',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onSetPriceAlarmStatus(
    SetPriceAlarmStatusEvent event,
    Emitter<AlarmState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await getIt<PPApi>().alarmService.setPriceAlarmStatus(
          alarmId: event.alarmId,
        );

    if (response.success) {
      add(GetAlarmsEvent());
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message != null
                ?
                //  Utils.tr('alarm.set_alarm_error.${response.error?.message}')
                'alarm.set_alarm_error.${response.error?.message}'
                : '',
            errorCode: '',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onSetNewsAlarm(
    SetNewsAlarmEvent event,
    Emitter<AlarmState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await getIt<PPApi>().alarmService.setNewsAlarm(
          symbolName: event.symbolName,
          url: getIt<MatriksBloc>().state.endpoints!.rest!.arf!.insertRule?.url ?? '',
        );

    if (response.success) {
      getIt<PPApi>().alarmService.setMatriksRuleNewsAlarm(
            symbolName: event.symbolName,
            ruleId: response.data,
          );

      add(
        GetAlarmsEvent(),
      );

      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
    } else {
      bool isSymbolExist = response.dioResponse?.data['error']['code'] == 'EXIST_ERROR';
      emit(
        state.copyWith(
          type: isSymbolExist ? PageState.success : PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: isSymbolExist ? 'news_alarm_exist_alert' : response.error?.message ?? '',
            errorCode: isSymbolExist ? '' : '05ALRM02',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onRemoveAlarm(
    RemoveAlarmEvent event,
    Emitter<AlarmState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await getIt<PPApi>().alarmService.removeAlarm(
          id: event.id,
          url: getIt<MatriksBloc>().state.endpoints!.rest!.arf!.deleteRule?.url ?? '',
        );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      event.callback();
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05ALRM03',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetAlarms(
    GetAlarmsEvent event,
    Emitter<AlarmState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse response = await getIt<PPApi>().alarmService.getAlarms(
          getIt<MatriksBloc>().state.endpoints!.rest!.arf!.getAllRules?.url ?? '',
        );
    if (response.success) {
      List<NewsAlarm> newsAlarms = [];
      List<PriceAlarm> priceAlarms = [];

      if (response.data['rules'] != null) {
        List<dynamic> activeAlarms = (response.data['rules'] as List).toList();
        for (dynamic e in activeAlarms) {
          if (e['rule']['is_news_rule'] == true) {
            newsAlarms.add(NewsAlarm.fromJson(e));
          } else {
            priceAlarms.add(PriceAlarm.fromJson(e));
          }
        }
      }

      if (newsAlarms.isNotEmpty) {
        await Future.wait(
          newsAlarms.map((element) async {
            List<MarketListModel>? detailedSymbols = await _alarmRepository.getDetailsOfSymbols(
              symbolCodes: [
                element.symbol,
              ],
            );

            if (detailedSymbols.isNotEmpty) {
              element.symbolType = detailedSymbols.first.type;
              element.underlyingName = detailedSymbols.first.underlying;
              element.description = detailedSymbols.first.description;
            }
          }),
        );
      }

      if (priceAlarms.isNotEmpty) {
        await Future.wait(
          priceAlarms.map((element) async {
            List<MarketListModel>? detailedSymbols = await _alarmRepository.getDetailsOfSymbols(
              symbolCodes: [
                element.symbol,
              ],
            );

            if (detailedSymbols.isNotEmpty) {
              element.symbolType = detailedSymbols.first.type;
              element.underlyingName = detailedSymbols.first.underlying;
              element.description = detailedSymbols.first.description;
            }
          }),
        );
      }

      newsAlarms.sort(
        (a, b) => Utils().sortIncludeTurkishCharacter(
          a.symbol,
          b.symbol,
        ),
      );
      priceAlarms.sort(
        (a, b) => Utils().sortIncludeTurkishCharacter(
          a.symbol,
          b.symbol,
        ),
      );

      emit(
        state.copyWith(
          type: PageState.success,
          newsAlarms: newsAlarms,
          priceAlarms: priceAlarms,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05ALRM04',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onReset(
    ResetAlarmEvent event,
    Emitter<AlarmState> emit,
  ) {
    emit(
      const AlarmState(),
    );
  }
}
