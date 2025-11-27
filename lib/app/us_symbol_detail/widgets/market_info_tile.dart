import 'package:collection/collection.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/app/us_symbol_detail/widgets/extended_trading_hours_info_widget.dart';
import 'package:piapiri_v2/app/us_symbol_detail/widgets/us_clock.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/time/time_bloc.dart';
import 'package:piapiri_v2/core/bloc/time/time_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/us_market_status_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class MarketInfoTile extends StatelessWidget {
  final String symbolName;
  const MarketInfoTile({
    super.key,
    required this.symbolName,
  });

  @override
  Widget build(BuildContext context) {
    final usEquityBloc = getIt<UsEquityBloc>();
    final timeBloc = getIt<TimeBloc>();
    return PBlocBuilder<UsEquityBloc, UsEquityState>(
      bloc: usEquityBloc,
      buildWhen: (previous, current) =>
          current.updatedSymbol?.ticker == symbolName ||
          (!previous.polygonWatchingItems.any((e) => e.ticker == symbolName) &&
              current.polygonWatchingItems.any((e) => e.ticker == symbolName)),
      builder: (context, state) {
        final snapshot = state.polygonWatchingItems.firstWhereOrNull((e) => e.ticker == symbolName);
        final polygonStatus = snapshot?.marketStatus;

        if (polygonStatus == null) {
          return PBlocBuilder<TimeBloc, TimeState>(
            bloc: timeBloc,
            builder: (context, timeState) {
              final usMarketStatus = getMarketStatus();
              return _buildMarketRow(context, usMarketStatus);
            },
          );
        }

        return _buildMarketRow(context, polygonStatus);
      },
    );
  }

  Widget _buildMarketRow(BuildContext context, UsMarketStatus usMarketStatus) {
    return InkWell(
      onTap: () {
        PBottomSheet.show(
          context,
          title: L10n.tr('transaction_hours'),
          child: const ExtendedTradingHoursInfoWidget(),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SvgPicture.asset(
            usMarketStatus.iconPath,
            width: Grid.m,
            height: Grid.m,
          ),
          const SizedBox(width: Grid.xs),
          Text(
            (UsMarketStatus.afterMarket == usMarketStatus || UsMarketStatus.preMarket == usMarketStatus)
                ? '${L10n.tr(usMarketStatus.localizationKey)} • ${L10n.tr('us_market_not_traded')}'
                : UsMarketStatus.closed == usMarketStatus
                    ? '${L10n.tr(usMarketStatus.localizationKey)} • ${L10n.tr('us_market_inactive')}'
                    : '${L10n.tr(usMarketStatus.localizationKey)} • ${L10n.tr('us_market_active')}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.pAppStyle.labelReg12textSecondary,
          ),
          const SizedBox(width: Grid.xs),
          SvgPicture.asset(
            ImagesPath.info,
            width: Grid.m,
            height: Grid.m,
            colorFilter: ColorFilter.mode(
              context.pColorScheme.textSecondary,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}
