import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/income/bloc/income_event.dart';
import 'package:piapiri_v2/app/income/bloc/income_state.dart';
import 'package:piapiri_v2/app/income/repository/income_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/conolidate_enum.dart';

class IncomeBloc extends PBloc<IncomeState> {
  final IncomeRepository _incomeRepository;

  IncomeBloc({
    required IncomeRepository incomeRepository,
  })  : _incomeRepository = incomeRepository,
        super(initialState: const IncomeState()) {
    on<GetYearInfoEvent>(_onGetYearInfo);
    on<GetIncomeEvent>(_onGetIncome);
  }

  FutureOr<void> _onGetIncome(
    GetIncomeEvent event,
    Emitter<IncomeState> emit,
  ) async {
    String symbolName = event.symbolName;
    if (event.isConsolidate) {
      symbolName = '$symbolName@C';
    }

    ApiResponse response = await _incomeRepository.getBalance(
      symbolName: symbolName,
      period: '${event.year}${event.month}',
    );
    if (response.success) {
      List<Map<dynamic, dynamic>> mainValueList = [];
      for (var element in response.data) {
        /// Check if the item is in the income list and add it to the mainValueList

        mainValueList.add({
          'item': element['item'],
          'description': element['description'],
          'value': element['val'][0]['value'],
        });
      }

      Map<Map, List> dataList = {};

      /// Loop through the mainValueList and get the values that start with the mainValue item
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
      state.copyWith(
        type: PageState.failed,
        error: PBlocError(
          showErrorWidget: true,
          message: response.error?.message ?? '',
          errorCode: '01INCM01',
        ),
      );
    }
  }

  FutureOr<void> _onGetYearInfo(
    GetYearInfoEvent event,
    Emitter<IncomeState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _incomeRepository.getBalanceYearInfo(
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
          showErrorWidget: true,
          message: response.error?.message ?? '',
          errorCode: '01INCM02',
        ),
      );
    }
  }
}
