import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/model/assets_model.dart';

double calculateTotalAmount(
  List<OverallItemModel>? overallItemGroups,
) {
  double totalAmount = 0;
  for (var element in overallItemGroups ?? []) {
    if (element.instrumentCategory != 'viop') {
      totalAmount += element.totalAmount;
    }
  }
  return totalAmount;
}

double calculateProfitLoss(
  List<OverallItemModel> overallItemGroups,
) {
  double totalProfitLoss = 0;
  for (var element in overallItemGroups) {
    totalProfitLoss += element.totalPotentialProfitLoss;
  }
  return totalProfitLoss;
}

String calculateProfitLossRatio(double profitLoss, double amount) {
  if (amount == 0 || profitLoss == 0) {
    return '';
  }
  return '(${MoneyUtils().ratioFormat((profitLoss / (amount - profitLoss)) * 100)})';
}
