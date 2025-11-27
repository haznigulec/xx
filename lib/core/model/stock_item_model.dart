class StockItemModel {
  final String name;
  final String description;
  final int balance;
  final double price;
  final double amount;
  final double low;
  final double high;
  final double step;
  final String groupCode;

  StockItemModel({
    required this.name,
    required this.description,
    required this.balance,
    required this.price,
    required this.amount,
    required this.low,
    required this.high,
    required this.step,
    this.groupCode = 'E',
  });

  factory StockItemModel.fromJson(Map<String, dynamic> json) {
    return StockItemModel(
      name: json['name'],
      description: json['description'] ?? '',
      balance: (json['balance']).toInt() ?? 0,
      price: json['price'] ?? 0,
      amount: json['amount'] ?? 0,
      low: json['low'] ?? 0,
      high: json['high'] ?? 0,
      step: json['step'] ?? 0,
      groupCode: json['groupCode'] ?? 'E',
    );
  }
}
