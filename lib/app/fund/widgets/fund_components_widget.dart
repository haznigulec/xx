import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class FundComponentsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> keyValueList;
  final double totalValue;
  final bool? isShowAllText;

  const FundComponentsWidget({
    required this.keyValueList,
    required this.totalValue,
    this.isShowAllText,
    super.key,
  });

  @override
  FundComponentsWidgetState createState() => FundComponentsWidgetState();
}

class FundComponentsWidgetState extends State<FundComponentsWidget> {
  bool _showAll = false;
  bool _isShowAllText = false;

  @override
  void initState() {
    _isShowAllText = widget.isShowAllText ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> visibleList =
        !_isShowAllText || _showAll ? widget.keyValueList : widget.keyValueList.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        ListView.separated(
          shrinkWrap: true,
          itemCount: visibleList.length,
          physics: const ScrollPhysics(),
          separatorBuilder: (context, index) => const PDivider(
            padding: EdgeInsets.symmetric(vertical: Grid.l / 2),
          ),
          itemBuilder: (context, index) => _fundComponentsTile(
            index,
            visibleList[index],
            widget.keyValueList.length - 1,
          ),
        ),
        if (_isShowAllText && widget.keyValueList.length > 2)
          PCustomPrimaryTextButton(
            margin: const EdgeInsets.only(
              top: Grid.m,
            ),
            text: _showAll ? L10n.tr('daha_az_göster') : L10n.tr('daha_fazla_goster'),
            onPressed: () {
              setState(() {
                _showAll = !_showAll;
              });
            },
          ),
      ],
    );
  }

  Widget _fundComponentsTile(int i, Map<String, dynamic> keyValueList, int lastIndex) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              height: 30,
              width: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: i == lastIndex ? context.pColorScheme.assetColors.last : context.pColorScheme.assetColors[i],
              ),
            ),
            const SizedBox(width: Grid.s),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    L10n.tr(keyValueList['key']),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.pAppStyle.labelReg14textPrimary,
                  ),
                  Text(
                    '%${MoneyUtils().readableMoney(keyValueList['value'])}',
                    style: context.pAppStyle.labelMed12textSecondary,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: Grid.m,
            ),
            Text(
              '₺${MoneyUtils().compactMoney(keyValueList['value'] * widget.totalValue / 100)}',
              style: context.pAppStyle.labelMed14textPrimary,
            ),
          ],
        ),
      ],
    );
  }
}
