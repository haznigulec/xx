import 'package:piapiri_v2/app/economic_calender/model/calendar_item_model.dart';
import 'package:piapiri_v2/app/economic_calender/model/calender_countries_model.dart';
import 'package:piapiri_v2/app/economic_calender/model/economic_calender_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';

class EconomicCalenderState extends PState {
  final CalendarFilterModel calendarFilter;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<CalendarCountryModel> countries;
  final List<CalendarItemModel> filteredCalendarItems;
  final PageState calendarState;
  final List<CalendarItemModel> calendarItems;
  final bool? isChangedCountries;
  final bool? isChangedDates;
  final bool? isChangedPriority;
  final List<CalenderCountriesSelectModel>? selectedCountries;

  const EconomicCalenderState({
    super.type = PageState.initial,
    super.error,
    this.calendarFilter = const CalendarFilterModel(),
    this.startDate,
    this.endDate,
    this.filteredCalendarItems = const [],
    this.countries = const [],
    this.calendarState = PageState.initial,
    this.calendarItems = const [],
    this.isChangedCountries = false,
    this.isChangedDates = false,
    this.isChangedPriority = false,
    this.selectedCountries = const [],
  });

  @override
  EconomicCalenderState copyWith({
    PageState? type,
    PBlocError? error,
    CalendarFilterModel? calendarFilter,
    DateTime? startDate,
    DateTime? endDate,
    List<CalendarItemModel>? filteredCalendarItems,
    List<CalendarCountryModel>? countries,
    PageState? calendarState,
    List<CalendarItemModel>? calendarItems,
    bool? isChangedCountries,
    bool? isChangedDates,
    List<CalenderCountriesSelectModel>? selectedCountries,
    bool? isChangedPriority,
  }) {
    return EconomicCalenderState(
      type: type ?? this.type,
      error: error ?? this.error,
      calendarFilter: calendarFilter ?? this.calendarFilter,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      filteredCalendarItems: filteredCalendarItems ?? this.filteredCalendarItems,
      countries: countries ?? this.countries,
      calendarState: calendarState ?? this.calendarState,
      calendarItems: calendarItems ?? this.calendarItems,
      isChangedCountries: isChangedCountries ?? this.isChangedCountries,
      isChangedDates: isChangedDates ?? this.isChangedDates,
      selectedCountries: selectedCountries ?? this.selectedCountries,
      isChangedPriority: isChangedPriority ?? this.isChangedPriority,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        calendarFilter,
        startDate,
        endDate,
        filteredCalendarItems,
        countries,
        calendarState,
        calendarItems,
        isChangedCountries,
        isChangedDates,
        selectedCountries,
        isChangedPriority,
      ];
}
