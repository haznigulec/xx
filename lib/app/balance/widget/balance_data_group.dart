import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/app/balance/widget/balance_data_sub_row.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/p_expandable_panel.dart';

class BalanceDataGroup extends StatefulWidget {
  final String title;
  final double value;
  final List contentList;
  const BalanceDataGroup({
    super.key,
    required this.title,
    required this.value,
    required this.contentList,
  });

  @override
  State<BalanceDataGroup> createState() => _BalanceDataGroupState();
}

class _BalanceDataGroupState extends State<BalanceDataGroup> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return PExpandablePanel(
      initialExpanded: _isExpanded,
      isExpandedChanged: (isExpanded) => setState(() {
        _isExpanded = isExpanded;
      }),
      titleBuilder: (_) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Text(
              widget.title,
              style: context.pAppStyle.labelReg14textPrimary,
            ),
          ),
          const Spacer(),
          Text(
            '₺${MoneyUtils().compactMoney(widget.value)}'.trim(),
            style: context.pAppStyle.labelMed14textPrimary,
          ),
          const SizedBox(
            width: Grid.xs,
          ),
          SvgPicture.asset(
            _isExpanded ? ImagesPath.chevron_up : ImagesPath.chevron_down,
            height: 12,
            width: 12,
            colorFilter: ColorFilter.mode(
              context.pColorScheme.textPrimary,
              BlendMode.srcIn,
            ),
          )
        ],
      ),
      child: Column(
        children: widget.contentList
            .map((e) => Column(
                  children: [
                    BalanceDataSubRow(
                      title: e['description'],
                      value: e['value'].toDouble(),
                    ),
                    const SizedBox(
                      height: Grid.xxs,
                    ),
                  ],
                ))
            .toList(),
      ),
    );
  }
}
