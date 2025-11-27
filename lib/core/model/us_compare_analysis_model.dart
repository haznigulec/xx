class UsCompareAnalysisModel {
  final String symbolName;
  double? marketCap;
  double? fk;
  double? pdDd;
  double? price;
  String? exchange;
  String? sector;
  bool isDataLoaded;

  UsCompareAnalysisModel({
    required this.symbolName,
    this.marketCap,
    this.fk,
    this.pdDd,
    this.price,
    this.exchange,
    this.sector,
    this.isDataLoaded = true,
  });

  //copyWith method
  UsCompareAnalysisModel copyWith({
    String? symbolName,
    double? marketCap,
    double? fk,
    double? pdDd,
    double? price,
    String? exchange,
    String? sector,
    bool? isDataLoaded,
  }) {
    return UsCompareAnalysisModel(
      symbolName: symbolName ?? this.symbolName,
      marketCap: marketCap ?? this.marketCap,
      fk: fk ?? this.fk,
      pdDd: pdDd ?? this.pdDd,
      price: price ?? this.price,
      exchange: exchange ?? this.exchange,
      sector: sector ?? this.sector,
      isDataLoaded: isDataLoaded ?? this.isDataLoaded,
    );
  }
}
