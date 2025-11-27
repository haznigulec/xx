class FilterSortModel {
  String? fundCode;
  String? fundTitle;
  String? subType;
  String? institutionCode;
  String? founder;
  double? performance1D;
  double? performance1W;
  double? performance1M;
  double? performance3M;
  double? performance6M;
  double? performance1Y;
  double? performance3Y;
  double? performance5Y;
  double? portfolioSize;
  double? numberOfPeople;

  FilterSortModel({
    this.fundCode,
    this.fundTitle,
    this.subType,
    this.institutionCode,
    this.founder,
    this.performance1D,
    this.performance1W,
    this.performance1M,
    this.performance3M,
    this.performance6M,
    this.performance1Y,
    this.performance3Y,
    this.performance5Y,
    this.portfolioSize,
    this.numberOfPeople,
  });

  factory FilterSortModel.fromJson(Map<String, dynamic> json) => FilterSortModel(
        fundCode: json['fundCode'] ?? '',
        fundTitle: json['fundTitle'] ?? '',
        subType: json['subType'] ?? '',
        institutionCode: json['institutionCode'] ?? '',
        founder: json['founder'] ?? '',
        performance1D: json['performance1D'] ?? 0.0,
        performance1W: json['performance1W'] ?? 0.0,
        performance1M: json['performance1M'] ?? 0.0,
        performance3M: json['performance3M'] ?? 0.0,
        performance6M: json['performance6M'] ?? 0.0,
        performance1Y: json['performance1Y'] ?? 0.0,
        performance3Y: json['performance3Y'] ?? 0.0,
        performance5Y: json['performance5Y'] ?? 0.0,
        portfolioSize: json['portfolioSize'] ?? 0.0,
        numberOfPeople: json['numberOfPeople'] ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        'fundCode': fundCode,
        'fundTitle': fundTitle,
        'subType': subType,
        'institutionCode': institutionCode,
        'founder': founder,
        'performance1D': performance1D,
        'performance1W': performance1W,
        'performance1M': performance1M,
        'performance3M': performance3M,
        'performance6M': performance6M,
        'performance1Y': performance1Y,
        'performance3Y': performance3Y,
        'performance5Y': performance5Y,
        'portfolioSize': portfolioSize,
        'numberOfPeople': numberOfPeople,
      };
}
