import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/account_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class CurrencyWidget extends StatelessWidget {
  const CurrencyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: CurrencyEnum.values.length,
      // separatorBuilder: (context, index) => const PDivider(),
      itemBuilder: (context, index) {
        final currency = CurrencyEnum.values[index];
        if (currency == CurrencyEnum.japaneseYen ||
            currency == CurrencyEnum.other ||
            currency == CurrencyEnum.euro ||
            currency == CurrencyEnum.dollar ||
            currency == CurrencyEnum.pound) {
          return const SizedBox.shrink();
        }

        return InkWell(
          onTap: () {
            List<AccountModel> accountsByCurrency = [];

            if (currency == CurrencyEnum.turkishLira) {
              accountsByCurrency = UserModel.instance.accounts
                  .where(
                    (element) => element.currency == CurrencyEnum.turkishLira,
                  )
                  .toList();
            }
            // else if (currency == CurrencyEnum.dollar) {
            //   accountsByCurrency = UserModel.instance.accounts
            //       .where(
            //         (element) => element.currency == CurrencyEnum.dollar,
            //       )
            //       .toList();
            // } else if (currency == CurrencyEnum.euro) {
            //   accountsByCurrency = UserModel.instance.accounts
            //       .where(
            //         (element) => element.currency == CurrencyEnum.euro,
            //       )
            //       .toList();
            // } else if (currency == CurrencyEnum.pound) {
            //   accountsByCurrency = UserModel.instance.accounts
            //       .where(
            //         (element) => element.currency == CurrencyEnum.pound,
            //       )
            //       .toList();
            // }

            if (accountsByCurrency.isEmpty) {
              Utils().showCustomerServiceCallAlert(
                context,
                L10n.tr(
                  'no_withdraw_account_desc',
                  args: [
                    currency.shortName.toUpperCase(),
                  ],
                ),
              );
              return;
            }

            router.push(
              WithdrawMoneyFromAccountRoute(
                currencyType: currency,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Grid.m,
            ),
            child: Text(
              L10n.tr(currency.shortName),
              style: context.pAppStyle.labelReg16textPrimary,
            ),
          ),
        );
      },
    );
  }
}
