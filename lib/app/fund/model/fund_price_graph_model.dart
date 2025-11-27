class FundPriceGraphModel {
  String fundCode;
  double price;
  DateTime date;

  FundPriceGraphModel({
    required this.fundCode,
    required this.price,
    required this.date,
  });

  factory FundPriceGraphModel.fromJson(Map<String, dynamic> json) => FundPriceGraphModel(
        fundCode: json['fundCode'].toString(),
        price: double.parse(json['price'].toString()),
        date: DateTime.parse(json['date'].toString()),
      );
}
