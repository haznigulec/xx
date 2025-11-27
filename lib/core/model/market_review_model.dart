class MarketReviewFilterModel {
  final List<String> source;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? symbolName;

  const MarketReviewFilterModel({
    this.source = const [
      'KAP',
      'MATRIKS',
    ],
    this.startDate,
    this.endDate,
    this.symbolName,
  });

  MarketReviewFilterModel copyWith({
    List<String>? source,
    DateTime? startDate,
    DateTime? endDate,
    String? symbolName,
  }) {
    return MarketReviewFilterModel(
      source: source ?? this.source,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      symbolName: symbolName ?? this.symbolName,
    );
  }
}
