import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/widgets.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/eurobond/model/eurobond_list_model.dart';
import 'package:piapiri_v2/app/search_symbol/widgets/order_approvement_buttons.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/list/symbol_about_tile.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class EurobondOrderDetail extends StatelessWidget {
  final Bonds bond;
  final OrderActionTypeEnum actionType;
  final String accountId;
  final String amount;
  final Function() onPressedApprove;

  const EurobondOrderDetail({
    super.key,
    required this.bond,
    required this.actionType,
    required this.accountId,
    required this.amount,
    required this.onPressedApprove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SymbolAboutTile(
          leading: L10n.tr('sembol'),
          trailing: bond.name ?? '',
        ),
        const PDivider(),
        SymbolAboutTile(
          leading: L10n.tr('islem_turu'),
          trailing: actionType == OrderActionTypeEnum.buy ? L10n.tr('al') : L10n.tr('sat'),
          trailingStyle: context.pAppStyle.interRegularBase.copyWith(
            fontSize: Grid.m,
            color: actionType.color,
          ),
        ),
        const PDivider(),
        SymbolAboutTile(
          leading: L10n.tr('fiyat'),
          trailing: MoneyUtils().readableMoney(
            actionType == OrderActionTypeEnum.buy ? bond.creditPrice ?? 0 : bond.debitPrice ?? 0,
            pattern: '#,##0.000',
          ),
        ),
        const PDivider(),
        SymbolAboutTile(
          leading: L10n.tr('tutar'),
          trailing: amount,
        ),
        const PDivider(),
        SymbolAboutTile(
          leading: L10n.tr('hesap'),
          trailing: accountId,
        ),
        const PDivider(),
        SymbolAboutTile(
          leading: L10n.tr('fund_valor_date'),
          trailing: DateTime.parse(
            bond.valueDate ?? DateTime.now().toString(),
          ).formatDayMonthYearDot(),
        ),
        const SizedBox(
          height: Grid.s + Grid.xxs,
        ),
        OrderApprovementButtons(
          onPressedApprove: onPressedApprove,
        ),
        const SizedBox(
          height: Grid.m,
        ),
      ],
    );
  }
}
