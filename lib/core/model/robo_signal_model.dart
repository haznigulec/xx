class RoboSignalModel {
  final String code;
  final String date;
  final double close;
  final List<IndicatorModel> indicators;

  RoboSignalModel({
    required this.code,
    required this.date,
    required this.close,
    required this.indicators,
  });

  factory RoboSignalModel.fromJson(dynamic json) {
    return RoboSignalModel(
      code: json['kod'],
      date: json['tarih'],
      close: double.parse(json['kapanis'].toString()),
      indicators: json['sinyalVeriListe'].map<IndicatorModel>((e) => IndicatorModel.fromJson(e)).toList(),
    );
  }
}

class IndicatorModel {
  final String title;
  final String code;
  final double? value;
  final String status;
  final int type;
  final String? description;

  IndicatorModel({
    required this.title,
    required this.code,
    this.value,
    required this.status,
    required this.type,
    this.description,
  });

  factory IndicatorModel.fromJson(dynamic json) {
    return IndicatorModel(
      title: json['indBaslik'],
      code: json['indKod'],
      value: double.parse(json['deger'].toString()),
      status: json['sinyalDurum'],
      type: json['signalType'],
      description: json['signalDurumDesc'],
    );
  }
}
