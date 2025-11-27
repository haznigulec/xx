import 'package:collection/collection.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/diff_percentage.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/model/us_market_status_enum.dart';
import 'package:piapiri_v2/core/model/us_symbol_snapshot.dart';

class PriceInfoWidget extends StatelessWidget {
  final String symbolName;

  const PriceInfoWidget({
    super.key,
    required this.symbolName,
  });

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<UsEquityBloc, UsEquityState>(
        bloc: getIt<UsEquityBloc>(),
        buildWhen: (previous, current) =>
            current.updatedSymbol?.ticker == symbolName ||
            (!previous.polygonWatchingItems.any((element) => element.ticker == symbolName) &&
                current.polygonWatchingItems.any((element) => element.ticker == symbolName)),
        builder: (context, state) {
          UsSymbolSnapshot? usSymbolSnapshot =
              state.polygonWatchingItems.firstWhereOrNull((e) => e.ticker == symbolName);
          UsMarketStatus? usMarketStatus = usSymbolSnapshot?.marketStatus;
          double differencePercent = usSymbolSnapshot?.session?.regularTradingChangePercent ?? 0;
          double extendedPrice = usSymbolSnapshot?.fmv ?? 0;
          double extendedDifferencePercent = usMarketStatus == UsMarketStatus.afterMarket
              ? usSymbolSnapshot?.session?.lateTradingChangePercent ?? 0
              : usSymbolSnapshot?.session?.earlyTradingChangePercent ?? 0;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
    
            children: [
              _buildPriceRow(
                context,
                price: MoneyUtils().getUsPrice(usSymbolSnapshot),
                differencePercent: differencePercent,
                textStyle: context.pAppStyle.labelMed26textPrimary,
                iconSize: Grid.m + Grid.xs,
              ),
              if (usMarketStatus == UsMarketStatus.afterMarket || usMarketStatus == UsMarketStatus.preMarket) ...[
                const SizedBox(height: Grid.s),
                _buildPriceRow(
                  context,
                  price: MoneyUtils().readableMoney(
                    extendedPrice,
                    pattern: extendedPrice >= 1 ? '#,##0.00' : '#,##0.0000#####',
                  ),
                  differencePercent: extendedDifferencePercent,
                  textStyle: context.pAppStyle.labelMed14textPrimary,
                  iconSize: Grid.s + Grid.s,
                  prefixIcon: SvgPicture.asset(
                    usMarketStatus == UsMarketStatus.preMarket ? ImagesPath.yellowCloud : ImagesPath.cloud,
                    width: Grid.m + Grid.xxs,
                    height: Grid.m + Grid.xxs,
                  ),
                ),
              ],
    
            ],
          );
        }
    );
  }

  Widget _buildPriceRow(
    BuildContext context, {
    required String price,
    required double differencePercent,
    required TextStyle textStyle,
    required double iconSize,
    Widget? prefixIcon,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (prefixIcon != null) ...[
          prefixIcon,
          const SizedBox(width: Grid.xxs),
        ],
        Text(
          '${MoneyUtils().getCurrency(SymbolTypes.foreign)}$price',
          style: textStyle,
        ),
        const SizedBox(
          width: Grid.s,
        ),
        DiffPercentage(
          percentage: differencePercent,
        ),
      ],
    );
  }
}
