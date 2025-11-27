class IpoAddDataModel {
  final String customerId;
  final String accountId;
  final int functionName;
  final String demandDate;
  final String ipoId;
  final int unitsDemanded;
  final int paymentType;
  final String transactionType;
  final String investorTypeId;
  final String demandGatheringType;
  final double totalAmount;
  final double offerPrice;
  final int minUnits;
  final String customFields;
  final String symbol;
  final int demandedUnit;
  List<Map<String, dynamic>>? itemsToBlock;

  IpoAddDataModel({
    required this.customerId,
    required this.accountId,
    required this.functionName,
    required this.demandDate,
    required this.ipoId,
    required this.unitsDemanded,
    required this.paymentType,
    required this.transactionType,
    required this.investorTypeId,
    required this.demandGatheringType,
    required this.totalAmount,
    required this.offerPrice,
    required this.minUnits,
    required this.customFields,
    required this.symbol,
    required this.demandedUnit,
    this.itemsToBlock,
  });
}
