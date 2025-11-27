class IpoApproveDataModel {
  final String symbolName;
  final String price;
  final String demandedLot;
  final String amount;
  final String paymentType;
  final String applicationType;
  final String ipoRequestedMinUnit;
  final String kktcCitizen;
  final String account;

  IpoApproveDataModel({
    required this.symbolName,
    required this.price,
    required this.demandedLot,
    required this.amount,
    required this.paymentType,
    required this.applicationType,
    required this.ipoRequestedMinUnit,
    required this.kktcCitizen,
    required this.account,
  });
}
