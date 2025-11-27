import 'package:piapiri_v2/app/economic_calender/model/economic_calender_model.dart';
import 'package:piapiri_v2/core/model/dropdown_model.dart';

class EconomicConstants {
  List<DropdownModel> economicSort = [
    const DropdownModel(
      name: 'increasing_by_importance',
      value: CalendarSortEnum.priorityAsc,
    ),
    const DropdownModel(
      name: 'decreasing_by_importance',
      value: CalendarSortEnum.priorityDesc,
    ),
    const DropdownModel(
      name: 'Increasing_by_date',
      value: CalendarSortEnum.dateAsc,
    ),
    const DropdownModel(
      name: 'decreasing_by_date',
      value: CalendarSortEnum.dateDesc,
    ),
  ];
}
