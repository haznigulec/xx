class TransactionExpenseModel {
  final double? t1Expense;
  final double? t2Expense;
  final double? t1Bsmv;
  final double? t2Bsmv;

  TransactionExpenseModel({
    required this.t1Expense,
    required this.t2Expense,
    required this.t1Bsmv,
    required this.t2Bsmv,
  });

  factory TransactionExpenseModel.fromJson(Map<String, dynamic> json) {
    return TransactionExpenseModel(
      t1Expense: json['t1Expense'],
      t2Expense: json['t2Expense'],
      t1Bsmv: json['t1Bsmv'],
      t2Bsmv: json['t2Bsmv'],
    );
  }
}
