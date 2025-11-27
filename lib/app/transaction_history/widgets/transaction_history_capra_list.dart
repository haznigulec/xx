import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/transaction_history/model/transaction_history_capra_model.dart';
import 'package:piapiri_v2/app/transaction_history/widgets/transaction_history_abroad_card.dart';

class TransactionHistoryCapraList extends StatelessWidget {
  final List<TransactionHistoryCapraModel> accountActivitiesList;
  const TransactionHistoryCapraList({
    super.key,
    required this.accountActivitiesList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: accountActivitiesList.length,
      shrinkWrap: true,
      separatorBuilder: (context, index) => const Padding(
        padding: EdgeInsets.symmetric(
          vertical: Grid.s,
        ),
        child: PDivider(),
      ),
      itemBuilder: (context, index) {
        TransactionHistoryCapraModel transactionHistory = accountActivitiesList[index];

        return TransactionHistoryAbroadCard(
          transactionHistory: transactionHistory,
          hasDivider: false,
        );
      },
    );
  }
}
