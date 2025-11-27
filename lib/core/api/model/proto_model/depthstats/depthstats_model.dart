class DepthStats {
  int timestamp;
  double totalBidWAvg;
  double totalAskWAvg;
  double totalBidQuantity;
  double totalAskQuantity;

  DepthStats({
    required this.timestamp,
    required this.totalBidWAvg,
    required this.totalAskWAvg,
    required this.totalBidQuantity,
    required this.totalAskQuantity,
  });
}
