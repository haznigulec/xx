import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/dividend/widgets/symbol_dividend_history_header.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/core/model/symbol_dividend_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class SymbolDividendHistoryWidget extends StatelessWidget {
  const SymbolDividendHistoryWidget({
    super.key,
    required this.dividendList,
  });

  final List<SymbolDividendModel>? dividendList;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Grid.s,
      children: [
        SymbolDividendHistoryHeaderWidget(
          title1: L10n.tr('symbol_dividend_history_date'),
          title2: '%${L10n.tr('symbol_dividend_history_rate')}',
          title3: L10n.tr('symbol_dividend_history_net_dividend'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: dividendList?.length ?? 0,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              String formattedDate = '';
              if (dividendList?[index].recordDate != null) {
                var date = DateTime.parse(dividendList![index].recordDate!);
                formattedDate = DateTimeUtils.dateFormat(date);
              }

              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: Grid.s,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: Grid.s,
                  children: [
                    Expanded(
                      child: Text(
                        formattedDate,
                        textAlign: TextAlign.start,
                        style: context.pAppStyle.labelReg14textPrimary,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '%${dividendList?[index].perShare}',
                        textAlign: TextAlign.center,
                        style: context.pAppStyle.labelMed14textPrimary,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '₺${dividendList?[index].perRate}',
                        textAlign: TextAlign.end,
                        style: context.pAppStyle.labelMed14textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
