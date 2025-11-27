import 'package:piapiri_v2/common/utils/images_path.dart';

enum MoneyTransferEnum {
  depositMoneyAccount(ImagesPath.arrow_down),
  withdrawMoneyAccount(ImagesPath.arrow_up),
  americanExchangesDepositWithdrawal(ImagesPath.coinUsd),
  viopDepositWithdrawalCollateral(ImagesPath.wallet),
  transferMoneyBetweenAccounts(ImagesPath.arrows_right_left2),
  transferOfSharesFromAnotherInstitution(ImagesPath.transfer);

  final String imagePath;
  const MoneyTransferEnum(this.imagePath);
}
