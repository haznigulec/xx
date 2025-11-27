import 'package:piapiri_v2/app/economic_calender/model/calender_countries_model.dart';

class CalendarFilterModel {
  final List<CalenderCountriesSelectModel> country;
  final CalendarSortEnum sort;

  const CalendarFilterModel({
    this.country = const [],
    this.sort = CalendarSortEnum.dateDesc,
  });

  CalendarFilterModel copyWith({
    List<CalenderCountriesSelectModel>? country,
    CalendarSortEnum? sort,
  }) {
    return CalendarFilterModel(
      country: country ?? this.country,
      sort: sort ?? this.sort,
    );
  }
}

class CalendarCountryModel {
  final String code;
  final String trName;
  final String enName;
  final bool value;

  const CalendarCountryModel({
    required this.code,
    required this.trName,
    required this.enName,
    required this.value,
  });

  factory CalendarCountryModel.fromJson(dynamic json) {
    return CalendarCountryModel(
      code: json['c'],
      trName: json['nT'],
      enName: json['nE'],
      value: json['value'] ?? false,
    );
  }
}

enum CalendarSortEnum {
  priorityAsc,
  priorityDesc,
  dateAsc,
  dateDesc,
}
