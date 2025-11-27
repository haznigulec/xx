import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/app/fund/model/fund_brief_model.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_brief_info.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class FundExpansionGrid extends StatelessWidget {
  final List<FundBriefModel> items;

  const FundExpansionGrid({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        mainAxisSpacing: 0,
        crossAxisSpacing: Grid.m,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return SymbolBriefInfo(
          label: item.title,
          value: item.value,
          isShowInfo: item.isShowInfoIcon,
          onTapInfo: item.tooltipText != null
              ? () {
                  PBottomSheet.show(
                    maxHeight: MediaQuery.of(context).size.height * .4,
                    title: item.title,
                    context,
                    child: Padding(
                      padding: const EdgeInsets.only(top: Grid.m, bottom: Grid.l),
                      child: Text(
                        textAlign: TextAlign.center,
                        item.tooltipText!,
                        style: context.pAppStyle.labelReg16textPrimary,
                      ),
                    ),
                  );
                }
              : null,
        );
      },
    );
  }
}
