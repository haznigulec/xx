class AccountSummaryModel {
  final String instrument;
  final String valueDate;
  final String transactionType;
  final String transactionDetail;
  final double debitAmount;
  final double creditAmount;
  final double balanceAmount;
  final String description;
  final String valueDateString;

  AccountSummaryModel({
    required this.instrument,
    required this.valueDate,
    required this.transactionType,
    required this.transactionDetail,
    required this.debitAmount,
    required this.creditAmount,
    required this.balanceAmount,
    required this.description,
    required this.valueDateString,
  });

  factory AccountSummaryModel.fromJson(Map<String, dynamic> json) {
    return AccountSummaryModel(
      instrument: json['instrument'],
      valueDate: json['valueDate'],
      transactionType: json['transactionType'],
      transactionDetail: json['transactionDetail'],
      debitAmount: json['debitAmount'],
      creditAmount: json['creditAmount'],
      balanceAmount: json['balanceAmount'],
      description: json['description'],
      valueDateString: json['valueDateString'],
    );
  }
}
