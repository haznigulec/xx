class CalendarItemModel {
  final String? countryCode;
  final String? country;
  final String indicatorId;
  final String? indicatorName;
  final String? indicatorNameEn;
  final String? priority;
  final bool isActive;
  final String concensus;
  final String previous;
  final bool revision;
  final String period;
  final String time;
  final String date;
  final String actual;

  CalendarItemModel({
    this.countryCode,
    this.country,
    required this.indicatorId,
    this.indicatorName,
    this.indicatorNameEn,
    this.priority,
    this.isActive = false,
    required this.concensus,
    required this.previous,
    required this.revision,
    this.period = '',
    required this.time,
    required this.date,
    required this.actual,
  });

  factory CalendarItemModel.fromJson(dynamic json) {
    return CalendarItemModel(
      countryCode: json['c'],
      country: json['cD'],
      indicatorId: json['iiD'],
      indicatorName: json['iDTr'],
      indicatorNameEn: json['iDEn'],
      priority: json['p'],
      isActive: json['a'] ?? false,
      concensus: json['co'] ?? '',
      previous: json['pr'] ?? '',
      revision: json['re'] ?? false,
      period: json['pe'] ?? '',
      time: json['t'],
      date: json['date'],
      actual: json['ac'] ?? '',
    );
  }
}
