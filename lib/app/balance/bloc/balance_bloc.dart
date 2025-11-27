import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/balance/balance_constants.dart';
import 'package:piapiri_v2/app/balance/bloc/balance_event.dart';
import 'package:piapiri_v2/app/balance/bloc/balance_state.dart';
import 'package:piapiri_v2/app/balance/repository/balance_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/conolidate_enum.dart';

class BalanceBloc extends PBloc<BalanceState> {
  final BalanceRepository _balanceRepository;

  BalanceBloc({
    required BalanceRepository balanceRepository,
  })  : _balanceRepository = balanceRepository,
        super(initialState: const BalanceState()) {
    on<GetYearInfoEvent>(_onGetYearInfo);
    on<GetBalanceEvent>(_onGetBalance);
  }

  FutureOr<void> _onGetBalance(
    GetBalanceEvent event,
    Emitter<BalanceState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    String symbolName = event.symbolName;
    if (event.isConsolidate) {
      symbolName = '$symbolName@C';
    }

    ApiResponse response = await _balanceRepository.getBalance(
      symbolName: symbolName,
      period: '${event.year}${event.month}',
    );

    if (response.success) {
      List<Map<String, dynamic>> mainValueList = [];

      /// This loop is used to get the main values of the balance sheet.
      for (var element in response.data) {
        if (BalanceConstants.balanceItems.contains(element['item'])) {
          mainValueList.add({
            'item': element['item'],
            'description': element['description'],
            'value': element['val'][0]['value'],
          });
        }
      }

      Map<Map, List> dataList = {};

      /// This loop is used to get the sub values of the balance sheet.
      for (var mainValue in mainValueList) {
        dataList[mainValue] = response.data
            .where((element) =>
                element['item'].toString().startsWith(mainValue['item']) && element['item'] != mainValue['item'])
            .map((e) => {
                  'item': e['item'],
                  'description': e['description'],
                  'value': e['val'][0]['value'],
                })
            .toList();
      }
      event.callback?.call(dataList);
      emit(
        state.copyWith(
          type: PageState.success,
          balanceList: dataList,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: false,
            message: response.error?.message ?? '',
            errorCode: '01BLNC01',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetYearInfo(
    GetYearInfoEvent event,
    Emitter<BalanceState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _balanceRepository.getBalanceYearInfo(
      symbolName: event.symbolName,
    );
    if (response.success) {
      Map<String, dynamic> yearMonthList = {};
      for (Map data in response.data['BS']) {
        List<dynamic> months = data['months'].map((month) => month['month']).toList();
        months.sort();
        yearMonthList[data['year']] = {'months': months};
      }
      final consolidateList = response.data['BS'].first['months'].first['types'];
      List<ConsolidateEnum> consolidateEnumList = consolidateList
          .map<ConsolidateEnum>((e) => ConsolidateEnum.values.firstWhere((element) => element.value == e))
          .toList();
      event.callback?.call(yearMonthList, consolidateEnumList);
      emit(
        state.copyWith(
          type: PageState.success,
          yearMonthList: yearMonthList,
        ),
      );
    } else {
      state.copyWith(
        type: PageState.failed,
        error: PBlocError(
          showErrorWidget: false,
          message: response.error?.message ?? '',
          errorCode: '01BLNC02',
        ),
      );
    }
  }
}
