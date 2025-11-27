import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_bloc.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_state.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/specific_list_bist_type_enum.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/specific_list_model.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/shimmer_specific_list_widget.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/specific_list_card.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

//Hazır listelerin ana kart ve başlık widgetı
class SpecificListWidget extends StatelessWidget {
  final String? tab;
  final double? leftPadding;
  final double? rightPadding;

  const SpecificListWidget({
    this.tab = '',
    this.leftPadding,
    this.rightPadding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<QuickPortfolioBloc, QuickPortfolioState>(
      bloc: getIt<QuickPortfolioBloc>(),
      builder: (context, state) {
        if (state.isLoading) {
          return const Shimmerize(
            enabled: true,
            child: ShimmerSpecificListWidget(),
          );
        }

        if (state.specificList.isEmpty) {
          return const SizedBox.shrink();
        }

        final bool isHome = tab == BistType.home.type;
        final List<SpecificListModel> list = isHome
            ? state.homeSpecificList
            : (tab != null && tab!.isNotEmpty)
                ? state.specificList.where((item) => item.tab == tab).toList()
                : state.specificList;

        if (!isHome && list.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: leftPadding ?? 0,
                right: rightPadding ?? 0,
              ),
              child: Text(
                L10n.tr(isHome ? 'homepage_specific_list' : 'specific_list'),
                style: context.pAppStyle.interMediumBase.copyWith(
                  fontSize: Grid.m + Grid.xxs,
                ),
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (context, index) => PDivider(
                padding: EdgeInsets.only(
                  left: leftPadding ?? 0,
                  right: rightPadding ?? 0,
                ),
              ),
              itemBuilder: (context, index) => SpecificListCard(
                leftPadding: leftPadding,
                rightPadding: rightPadding,
                specificListItem: list[index],
              ),
            ),
          ],
        );
      },
    );
  }
}
