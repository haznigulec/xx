class WorkingHourModel {
  final DateTime startTime;
  final DateTime endTime;

  WorkingHourModel({
    required this.startTime,
    required this.endTime,
  });

  factory WorkingHourModel.fromJson(Map<String, dynamic> json) {
    return WorkingHourModel(
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
    };
  }
}
