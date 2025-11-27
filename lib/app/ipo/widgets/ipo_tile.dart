import 'dart:convert';
import 'dart:typed_data';

import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_model.dart';
import 'package:piapiri_v2/app/ipo/widgets/ipo_last_price_widget.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';

class IpoTile extends StatelessWidget {
  final IpoModel ipo;
  final bool showLastPrice;
  final bool canRequest;
  final VoidCallback? onSuccess;
  final bool fromPastIpo;
  final double dividerTopPadding;
  final bool showDivider;

  const IpoTile({
    super.key,
    required this.ipo,
    required this.showLastPrice,
    required this.canRequest,
    this.onSuccess,
    this.fromPastIpo = false,
    this.dividerTopPadding = 21,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    Uint8List? decodedBytesUint8List = ipo.companyLogo != null ? base64.decode(ipo.companyLogo!) : null;

    return InkWell(
      onTap: () {
        router.push(
          IpoDetailRoute(
            symbolLogo: decodedBytesUint8List,
            ipo: ipo,
            isDemanded: ipo.ipoDemandeds != null,
            canRequest: canRequest,
            id: ipo.id,
            fromPastIpo: fromPastIpo,
            onSuccess: onSuccess ?? () {},
          ),
        );
      },
      child: Column(
        children: [
          SizedBox(
            height: dividerTopPadding,
          ),
          Row(
            spacing: Grid.s,
            children: [
              decodedBytesUint8List != null
                  ? ClipOval(
                      child: Image.memory(
                        decodedBytesUint8List,
                        width: 38,
                        height: 38,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Utils.generateCapitalFallback(
                      context,
                      ipo.symbol ?? 'U',
                      size: 38,
                    ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: Grid.xxs / 2,
                  children: [
                    Text(
                      ipo.symbol ?? '',
                      style: context.pAppStyle.labelReg14textPrimary,
                    ),
                    Text(
                      (ipo.companyName ?? '').toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.pAppStyle.labelMed12textSecondary,
                    ),
                  ],
                ),
              ),
              showLastPrice
                  ? IpoLastPriceWidget(
                      key: ValueKey('last_price_${ipo.symbol ?? ipo.id}'),
                      ipo: ipo,
                      symbol: ipo.symbol ?? '',
                    )
                  : _ipoPriceAndDate(context),
            ],
          ),
          if (showDivider)
            PDivider(
              padding: EdgeInsets.only(
                top: dividerTopPadding,
              ),
            )
        ],
      ),
    );
  }

  Widget _ipoPriceAndDate(BuildContext context) {
    String date = '';
    if (ipo.startPrice != null) {
      if (ipo.endPrice == null) {
        date = '₺${MoneyUtils().readableMoney(ipo.startPrice!)}';
      } else {
        date = '₺${MoneyUtils().readableMoney(ipo.startPrice!)} - ₺${MoneyUtils().readableMoney(ipo.endPrice!)}';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: Grid.xs,
      children: [
        Text(
          date,
          style: context.pAppStyle.labelMed14textPrimary,
        ),
        ipo.startDate != null && ipo.endDate != null
            ? Text(
                '${DateTime.parse(ipo.startDate!).formatDayMonthDot()} - ${DateTime.parse(
                  ipo.endDate ?? DateTime.now().toString(),
                ).formatDayMonthYearDot()}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: context.pAppStyle.labelMed12textSecondary,
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
