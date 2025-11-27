import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/profit/model/tax_detail_model.dart';
import 'package:piapiri_v2/app/profit/widgets/profit_loss_row.dart';

class CompletedProfitLossDetailList extends StatelessWidget {
  final List<TaxDetailsInner> taxDetailList;
  const CompletedProfitLossDetailList({
    super.key,
    required this.taxDetailList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: taxDetailList.length,
        separatorBuilder: (context, index) => const PDivider(),
        itemBuilder: (context, index) {
          return ProfitLossRow(
            title: taxDetailList[index].finType == 'Yatırım Fonları'
                ? taxDetailList[index].symbol?.split(' ')[0] ?? ''
                : taxDetailList[index].symbol ?? '',
            value: taxDetailList[index].price ?? 0,
            hasIcon: false,
          );
        });
  }
}
