class StopLossTakeProfit {
  double? stopLossPrice;
  double? takeProfitPrice;
  DateTime validityDate;

  StopLossTakeProfit({
    this.stopLossPrice,
    this.takeProfitPrice,
    required this.validityDate,
  });
}
