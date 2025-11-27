import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/profit/model/potential_profit_loss_model.dart';
import 'package:piapiri_v2/app/profit/widgets/profit_loss_row.dart';

class PotentialProfitLossDetailList extends StatelessWidget {
  final List<OverallItems>? overallItemList;
  final String type;
  const PotentialProfitLossDetailList({
    super.key,
    this.overallItemList,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: overallItemList?.length ?? 0,
      separatorBuilder: (context, index) => const PDivider(),
      itemBuilder: (context, index) {
        return ProfitLossRow(
          title: type == 'fund'
              ? overallItemList![index].financialInstrumentCode ?? ''
              : overallItemList![index].symbol ?? '',
          value: overallItemList![index].potentialProfitLoss?.toDouble() ?? 0.0,
          hasIcon: false,
        );
      },
    );
  }
}
