import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_bloc.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_event.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_state.dart';
import 'package:piapiri_v2/app/assets/model/us_capra_summary_model.dart';
import 'package:piapiri_v2/app/assets/widgets/asset_us_collateral_bottom_sheet_row.dart';
import 'package:piapiri_v2/app/assets/widgets/asset_us_collateral_bottom_sheet_top_widget.dart';
import 'package:piapiri_v2/app/assets/widgets/usd_withdrawal_deposit_widget.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AssetUsCollateralBottomSheet extends StatefulWidget {
  final UsOverallItemModel portfolioSummary;
  final bool isVisible;

  const AssetUsCollateralBottomSheet({
    super.key,
    required this.portfolioSummary,
    required this.isVisible,
  });

  @override
  State<AssetUsCollateralBottomSheet> createState() => _AssetUsCollateralBottomSheetState();
}

class _AssetUsCollateralBottomSheetState extends State<AssetUsCollateralBottomSheet> {
  late AssetsBloc _assetBloc;

  @override
  initState() {
    _assetBloc = getIt<AssetsBloc>()
      ..add(
        GetCapraCollateralInfoEvent(),
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<AssetsBloc, AssetsState>(
      bloc: _assetBloc,
      builder: (context, state) {
        if (state.capraCollateralAsset == PageState.loading) {
          return const Padding(
            padding: EdgeInsets.all(
              Grid.m,
            ),
            child: PLoading(),
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AssetUsCollateralBottomSheetTopWidget(
              portfolioSummary: widget.portfolioSummary,
              isVisible: widget.isVisible,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: Grid.m,
              ),
              child: PDivider(),
            ),
            AssetUsCollateralBottomSheetRow(
              title: L10n.tr('withdrawable_cash_balance'),
              description: L10n.tr('instant_available_cash'),
              value: !widget.isVisible
                  ? '${CurrencyEnum.dollar.symbol}**'
                  : '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(state.capraCollateralInfo?.cashWithdrawable ?? 0)}',
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: Grid.s,
              ),
              child: PDivider(),
            ),
            AssetUsCollateralBottomSheetRow(
              title: L10n.tr('available_balance'),
              description: L10n.tr('cash_from_transactions_one_day_previous'),
              value: !widget.isVisible
                  ? '${CurrencyEnum.dollar.symbol}**'
                  : '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(state.capraCollateralInfo?.buyingPower ?? 0)}',
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: Grid.s,
              ),
              child: PDivider(),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Grid.s,
                  ),
                  child: UsdWithdrawalDepositWidget(),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
