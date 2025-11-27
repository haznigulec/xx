import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';

class BookletRow extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isStats;
  const BookletRow({
    super.key,
    required this.data,
    this.isStats = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: Row(
        children: [
          Expanded(
            child: Container(
              color: isStats ? context.pColorScheme.success.withValues(alpha: 0.15) : context.pColorScheme.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      minWidth: 50,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      MoneyUtils().readableMoney(
                        data['alis_adet'],
                        pattern: '#,##0',
                      ),
                      style: context.pAppStyle.interMediumBase.copyWith(
                        color: context.pColorScheme.success,
                        fontSize: Grid.m - Grid.xxs,
                        fontWeight: isStats ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      minWidth: 50,
                    ),
                    alignment: Alignment.centerRight,
                    child: Text(
                      MoneyUtils().readableMoney(data['alis']),
                      style: context.pAppStyle.interMediumBase.copyWith(
                        color: context.pColorScheme.success,
                        fontSize: Grid.m - Grid.xxs,
                        backgroundColor: isStats
                            ? context.pColorScheme.transparent
                            : context.pColorScheme.success.withValues(alpha: 0.15),
                        fontWeight: isStats ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: Grid.m,
          ),
          Expanded(
            child: Container(
              color: isStats ? context.pColorScheme.critical.withValues(alpha: 0.15) : context.pColorScheme.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      minWidth: 50,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      MoneyUtils().readableMoney(
                        data['satis'],
                      ),
                      style: context.pAppStyle.interMediumBase.copyWith(
                        fontSize: Grid.m - Grid.xxs,
                        color: context.pColorScheme.critical,
                        backgroundColor: isStats
                            ? context.pColorScheme.transparent
                            : context.pColorScheme.critical.withValues(alpha: 0.15),
                        fontWeight: isStats ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      minWidth: 50,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      MoneyUtils().readableMoney(
                        data['satis_adet'],
                        pattern: '#,##0',
                      ),
                      style: context.pAppStyle.interRegularBase.copyWith(
                        fontSize: Grid.m - Grid.xxs,
                        color: context.pColorScheme.critical,
                        fontWeight: isStats ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
