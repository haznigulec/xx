import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:piapiri_v2/app/economic_calender/bloc/economic_calender_event.dart';
import 'package:piapiri_v2/app/economic_calender/bloc/economic_calender_state.dart';
import 'package:piapiri_v2/app/economic_calender/model/calendar_item_model.dart';
import 'package:piapiri_v2/app/economic_calender/model/economic_calender_model.dart';
import 'package:piapiri_v2/app/economic_calender/repository/economic_calender_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class EconomicCalenderBloc extends PBloc<EconomicCalenderState> {
  final EconomicCalenderRepository _economicCalenderRepository;

  EconomicCalenderBloc({
    required EconomicCalenderRepository economicCalenderRepository,
  })  : _economicCalenderRepository = economicCalenderRepository,
        super(initialState: const EconomicCalenderState()) {
    on<GetCalendarItemsEvent>(_onGetCalendarItems);
    on<SetCalendarFilterEvent>(_onSetCalendarFilter);
  }

  FutureOr<void> _onGetCalendarItems(
    GetCalendarItemsEvent event,
    Emitter<EconomicCalenderState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          calendarState: PageState.loading,
          calendarItems: [],
          filteredCalendarItems: [],
        ),
      );

      DateTime startDate = (event.startDate ?? state.startDate) ?? DateTime.now().subtract(const Duration(days: 1));
      DateTime endDate = (event.endDate ?? state.endDate) ?? DateTime.now();

      ApiResponse response = await _economicCalenderRepository.getEconomicCalendar(
        startDate: startDate.toString().split(' ')[0],
        endDate: endDate.toString().split(' ')[0],
        url: getIt<MatriksBloc>().state.endpoints!.rest!.economicCalendar!.calendar!.url ?? '',
      );

      if (response.success) {
        List<CalendarItemModel> items = response.data
            .map<CalendarItemModel>(
              (dynamic item) => CalendarItemModel.fromJson(item),
            )
            .toList();
        List<CalendarItemModel> filteredItems = _filterItems(items, state.calendarFilter);
        List<CalendarCountryModel>? countries;
        if (state.countries.isEmpty) {
          ApiResponse countriesResponse = await _economicCalenderRepository.getEconomicCalendarCountries(
            getIt<MatriksBloc>().state.endpoints!.rest!.economicCalendar!.country!.url ?? '',
          );
          countries = countriesResponse.data
              .map<CalendarCountryModel>(
                (dynamic item) => CalendarCountryModel.fromJson(item),
              )
              .toList();
          countries!.sort((a, b) => a.code.compareTo(b.code));
        }

        emit(
          state.copyWith(
            countries: countries,
            calendarItems: items,
            filteredCalendarItems: filteredItems,
            calendarState: PageState.success,
            startDate: startDate,
            endDate: endDate,
            isChangedDates: event.isChangedDates,
          ),
        );
      } else {
        emit(
          state.copyWith(
            calendarState: PageState.failed,
            error: PBlocError(
              showErrorWidget: true,
              message: response.error?.message ?? '',
              errorCode: '03ANLY03',
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          calendarState: PageState.failed,
        ),
      );
    }
  }

  FutureOr<void> _onSetCalendarFilter(
    SetCalendarFilterEvent event,
    Emitter<EconomicCalenderState> emit,
  ) async {
    List<CalendarItemModel> filteredItems = _filterItems(state.calendarItems, event.calendarFilter);
    emit(
      state.copyWith(
        calendarFilter: event.calendarFilter,
        filteredCalendarItems: filteredItems,
        isChangedCountries: event.isChangedCountries,
        selectedCountries: event.selectedCountries,
        isChangedPriority: event.isChangedPriority,
      ),
    );
  }

  List<CalendarItemModel> _filterItems(
    List<CalendarItemModel> items,
    CalendarFilterModel filter,
  ) {
    List<CalendarItemModel> filteredItems = List.from(items);
    if (filter.country.isNotEmpty) {
      List<String> countryCodes = filter.country.map((e) => e.code.toString()).toList();
      filteredItems = items.where((element) => countryCodes.contains(element.countryCode)).toList();
      if (countryCodes.contains('All')) {
        return filteredItems = items;
      }
    }
    switch (filter.sort) {
      case CalendarSortEnum.priorityAsc:
        filteredItems.sort(
          (a, b) => int.parse(b.priority ?? '1').compareTo(int.parse(a.priority ?? '1')),
        );
      case CalendarSortEnum.priorityDesc:
        filteredItems.sort(
          (a, b) => int.parse(a.priority ?? '1').compareTo(int.parse(b.priority ?? '1')),
        );
      case CalendarSortEnum.dateAsc:
        filteredItems.sort(
          (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)),
        );
      case CalendarSortEnum.dateDesc:
        filteredItems.sort(
          (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)),
        );
    }
    return filteredItems;
  }
}
