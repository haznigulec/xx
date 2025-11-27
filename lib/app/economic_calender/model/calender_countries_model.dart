import 'package:equatable/equatable.dart';

class CalenderCountriesSelectModel extends Equatable {
  final String name;
  final String code;
  final dynamic value;

  const CalenderCountriesSelectModel({
    required this.name,
    required this.code,
    this.value,
  });

  factory CalenderCountriesSelectModel.fromJson(Map<String, dynamic> json) {
    return CalenderCountriesSelectModel(
      name: json['name'],
      code: json['code'],
      value: json['value'],
    );
  }

  @override
  List<Object?> get props => [
        name,
        code,
        value,
      ];
}
