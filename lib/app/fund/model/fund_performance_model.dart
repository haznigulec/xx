class FundPerformanceModel {
  List<PerformanceDetail> topByPerformance;
  List<PerformanceDetail> lowestByPerformance;
  List<PerformanceDetail> withMostPeople;

  FundPerformanceModel({
    required this.topByPerformance,
    required this.lowestByPerformance,
    required this.withMostPeople,
  });

  factory FundPerformanceModel.fromJson(Map<String, dynamic> json) => FundPerformanceModel(
        topByPerformance:
            List<PerformanceDetail>.from(json['topByPerformance'].map((x) => PerformanceDetail.fromJson(x))),
        lowestByPerformance:
            List<PerformanceDetail>.from(json['lowestByPerformance'].map((x) => PerformanceDetail.fromJson(x))),
        withMostPeople: List<PerformanceDetail>.from(json['withMostPeople'].map((x) => PerformanceDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'topByPerformance': List<dynamic>.from(topByPerformance.map((x) => x.toJson())),
        'lowestByPerformance': List<dynamic>.from(lowestByPerformance.map((x) => x.toJson())),
        'withMostPeople': List<dynamic>.from(withMostPeople.map((x) => x.toJson())),
      };
}

class PerformanceDetail {
  String? fundCode;
  String? instutionCode;
  String? instutionName;
  String? subType;
  double? performance1M;
  double? numberOfPeople;

  PerformanceDetail({
    required this.fundCode,
    required this.instutionCode,
    required this.instutionName,
    required this.subType,
    required this.performance1M,
    required this.numberOfPeople,
  });

  factory PerformanceDetail.fromJson(Map<String, dynamic> json) => PerformanceDetail(
        fundCode: json['fundCode'] ?? '',
        instutionCode: json['instutionCode'] ?? '',
        instutionName: json['instutionName'] != null
            ? json['instutionName'].toString().replaceAll(
                RegExp(r'YÖNET[İI]M[İI]\s(?:A\.Ş\.?|ANONİM ŞİRKETİ|ANONİM SIRKETI)', caseSensitive: false), '')
            : '',
        subType: json['subType'] ?? '',
        performance1M: json['performance1M']?.toDouble() ?? 0.0,
        numberOfPeople: json['numberOfPeople'] ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        'fundCode': fundCode,
        'instutionCode': instutionCode,
        'instutionName': instutionName,
        'subType': subType,
        'performance1M': performance1M,
        'numberOfPeople': numberOfPeople,
      };
}
