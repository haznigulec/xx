import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/app/eurobond/model/eurobond_list_model.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class EurobondListTile extends StatelessWidget {
  final Bonds bond;
  final String transactionStartTime;
  final String transactionEndTime;
  const EurobondListTile({
    super.key,
    required this.bond,
    required this.transactionStartTime,
    required this.transactionEndTime,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        router.push(
          EuroBondDetailRoute(
            selectedEuroBond: bond,
            transactionStartTime: transactionStartTime,
            transactionEndTime: transactionEndTime,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Grid.s,
        ),
        child: SizedBox(
          height: 48,
          child: Row(
            children: [
              SvgPicture.asset(
                ImagesPath.yurt_disi,
                width: 28,
                height: 28,
              ),
              const SizedBox(
                width: Grid.s,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    bond.name ?? '',
                    style: context.pAppStyle.labelReg14textPrimary,
                  ),
                  Text(
                    '${L10n.tr('maturity')}: ${DateTimeUtils.dateFormat(DateTime.parse(bond.maturityDate ?? ''))}',
                    style: context.pAppStyle.labelMed12textSecondary,
                  ),
                ],
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${L10n.tr('alis')}: \$${MoneyUtils().readableMoney(bond.debitPrice ?? 0)}',
                    style: context.pAppStyle.labelReg14textPrimary,
                  ),
                  Text(
                    '${L10n.tr('satis')}: \$${MoneyUtils().readableMoney(bond.creditPrice ?? 0)}',
                    style: context.pAppStyle.labelReg14textPrimary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
