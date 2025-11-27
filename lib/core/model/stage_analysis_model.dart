class StageAnalysisModel {
  double? price;
  int? lastOrderNo;
  int? askQuantity;
  int? bidQuantity;
  int? undirectedQuantity;

  StageAnalysisModel({
    this.price,
    this.lastOrderNo,
    this.askQuantity,
    this.bidQuantity,
    this.undirectedQuantity,
  });

  factory StageAnalysisModel.fromJson(Map<String, dynamic> json) => StageAnalysisModel(
        price: json['price']?.toDouble() ?? 0.0,
        lastOrderNo: json['lastOrderNo'] ?? 0,
        askQuantity: json['askQuantity'] ?? 0,
        bidQuantity: json['bidQuantity'] ?? 0,
        undirectedQuantity: json['undirectedQuantity'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'price': price,
        'lastOrderNo': lastOrderNo,
        'askQuantity': askQuantity,
        'bidQuantity': bidQuantity,
        'undirectedQuantity': undirectedQuantity,
      };
}
