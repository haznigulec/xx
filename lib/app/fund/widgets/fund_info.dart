import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/diff_percentage.dart';
import 'package:piapiri_v2/core/model/fund_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class FundInfo extends StatefulWidget implements PreferredSizeWidget {
  final FundDetailModel fund;

  const FundInfo({
    super.key,
    required this.fund,
  });

  @override
  State<FundInfo> createState() => _FundInfoState();

  @override
  Size get preferredSize => const Size.fromHeight(85);
}

class _FundInfoState extends State<FundInfo> {
  late double _performance;
  @override
  void initState() {
    if (widget.fund.performance1D != null) {
      _performance = widget.fund.performance1D!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SymbolIcon(
              symbolName: widget.fund.institutionCode,
              symbolType: SymbolTypes.fund,
              size: 30,
            ),
            const SizedBox(
              width: Grid.s,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.fund.code} • ${widget.fund.founder}',
                  style: context.pAppStyle.labelReg14textPrimary.copyWith(height: 1.2),
                ),
                Text(
                  widget.fund.subType,
                  style: context.pAppStyle.labelMed12textSecondary,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: Grid.s,
        ),
        Text(
          widget.fund.title,
          style: context.pAppStyle.labelMed12textSecondary,
        ),
        const SizedBox(
          height: Grid.xs,
        ),
        Row(
          children: [
            Text(
              '₺${MoneyUtils().readableMoney(widget.fund.price ?? 0, pattern: '#,##0.000000')}',
              style: context.pAppStyle.interSemiBoldBase.copyWith(
                fontSize: Grid.l + Grid.xxs,
                color: context.pColorScheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              width: Grid.s,
            ),
            DiffPercentage(
              percentage: _performance * 100,
              iconSize: Grid.m + Grid.xs,
              fontSize: Grid.m,
            ),
          ],
        ),
      ],
    );
  }
}
