import 'package:piapiri_v2/app/economic_calender/model/calender_countries_model.dart';
import 'package:piapiri_v2/app/economic_calender/model/economic_calender_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';

abstract class EconomicCalenderEvent extends PEvent {}

class SetCalendarFilterEvent extends EconomicCalenderEvent {
  final CalendarFilterModel calendarFilter;
  final bool? isChangedCountries;
  final bool? isChangedPriority;
  final List<CalenderCountriesSelectModel>? selectedCountries;

  SetCalendarFilterEvent({
    required this.calendarFilter,
    this.isChangedCountries,
    this.selectedCountries,
    this.isChangedPriority,
  });
}

class GetCalendarItemsEvent extends EconomicCalenderEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? isChangedDates;

  GetCalendarItemsEvent({
    this.startDate,
    this.endDate,
    this.isChangedDates,
  });
}
