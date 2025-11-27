class InterestData {
  final DateTime? startDate;
  final DateTime? endDate;
  final double annualRate; // yıllık faiz oranı (%)

  InterestData({
    this.startDate,
    this.endDate,
    required this.annualRate,
  });
}
