import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_bloc.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_state.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/specific_list_model.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/p_expandable_panel.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/shimmer_specific_list_widget.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/specific_list_card.dart';
import 'package:piapiri_v2/common/utils/constant.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

//Hazır listelerin ana kart ve başlık widgetı
class HomeSpesificListWidget extends StatelessWidget {
  final double? leftPadding;
  final double? rightPadding;

  const HomeSpesificListWidget({
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

        if (state.homeSpecificList.isEmpty) {
          return const SizedBox.shrink();
        }

        List<SpecificListModel> homeSpecificList =
            state.homeSpecificList.length > 1 ? state.homeSpecificList.skip(1).toList() : [];

        return PExpandablePanel(
          initialExpanded: homeSpesificListIsExpanded,
          isExpandedChanged: (isExpanded) {
            homeSpesificListIsExpanded = isExpanded;
          },
          titleBuilder: (isExpanded) => Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: leftPadding ?? 0,
                  right: rightPadding ?? 0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        L10n.tr('homepage_specific_list'),
                        style: context.pAppStyle.interMediumBase.copyWith(
                          fontSize: Grid.m + Grid.xxs,
                        ),
                      ),
                    ),
                    if (state.homeSpecificList.length > 1) ...[
                      IgnorePointer(
                        child: PCustomPrimaryTextButton(
                          mainAxisAlignment: MainAxisAlignment.end,
                          text: isExpanded ? L10n.tr('daha_az_göster') : L10n.tr('show_all'),
                          onPressed: () {},
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ],
          ),
          titleSubChild: SpecificListCard(
            leftPadding: leftPadding,
            rightPadding: rightPadding,
            specificListItem: state.homeSpecificList[0],
          ),
          child: homeSpecificList.isEmpty
              ? const SizedBox.shrink()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 1,
                      child: PDivider(
                        padding: EdgeInsets.only(
                          left: leftPadding ?? 0,
                          right: rightPadding ?? 0,
                        ),
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: homeSpecificList.length,
                      separatorBuilder: (context, index) => PDivider(
                        padding: EdgeInsets.only(
                          left: leftPadding ?? 0,
                          right: rightPadding ?? 0,
                        ),
                      ),
                      itemBuilder: (context, index) => SpecificListCard(
                        leftPadding: leftPadding,
                        rightPadding: rightPadding,
                        specificListItem: homeSpecificList[index],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
