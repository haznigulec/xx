import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class UsdWithdrawalDepositWidget extends StatelessWidget {
  const UsdWithdrawalDepositWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PCustomPrimaryTextButton(
      text: L10n.tr('usd_withdrawal_deposit'),
      iconSource: ImagesPath.arrow_up_right,
      iconAlignment: IconAlignment.end,
      style: context.pAppStyle.labelMed14primary,
      onPressed: () {
        if (UserModel.instance.accounts
            .where((element) => element.currency == CurrencyEnum.dollar)
            .toList()
            .isNotEmpty) {
          router.push(
            const UsBalanceRoute(),
          );
        } else {
          router.push(
            CurrencyBuySellRoute(
              currencyType: CurrencyEnum.dollar,
              accountsByCurrency: UserModel.instance.accounts
                  .where(
                    (element) => element.currency == CurrencyEnum.dollar,
                  )
                  .toList(),
            ),
          );
        }
        router.maybePop();
      },
    );
  }
}
