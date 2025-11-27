import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/profit/bloc/profit_bloc.dart';
import 'package:piapiri_v2/app/profit/bloc/profit_event.dart';
import 'package:piapiri_v2/app/profit/bloc/profit_state.dart';
import 'package:piapiri_v2/app/profit/widgets/enter_target_widget.dart';
import 'package:piapiri_v2/app/profit/widgets/has_target_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/assets_model.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class TargetWidget extends StatefulWidget {
  const TargetWidget({super.key});

  @override
  State<TargetWidget> createState() => _TargetWidgetState();
}

class _TargetWidgetState extends State<TargetWidget> {
  final ProfitBloc _profitBloc = getIt<ProfitBloc>();

  @override
  void initState() {
    super.initState();

    if (UserModel.instance.alpacaAccountStatus) {
      _profitBloc.add(
        GetCapraPortfolioSummaryEvent(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<ProfitBloc, ProfitState>(
      bloc: getIt<ProfitBloc>(),
      builder: (context, state) {
        if (state.customerTarget == null) {
          return _noTargetWidget(context);
        }

        final bool isPortfolioSummaryReady =
            state.usPortfolioState == PageState.success || !UserModel.instance.alpacaAccountStatus;

        double usPortfolioTotalAmount = 0;

        if (!isPortfolioSummaryReady) {
          usPortfolioTotalAmount = 0;
        } else {
          usPortfolioTotalAmount = (state.portfolioSummaryModel == null ||
                  state.portfolioSummaryModel?.overallItemGroups == null ||
                  state.portfolioSummaryModel!.overallItemGroups!.isEmpty
              ? 0
              : state.portfolioSummaryModel!.overallItemGroups!.fold(
                  0,
                  (previousValue, element) =>
                      previousValue +
                      (state.portfolioSummaryModel!.tlExchangeRate == 1
                          ? ((element.totalAmount ?? 0) * (state.consolidatedAssets?.totalUsdOverall ?? 1))
                          : element.exchangeValue ?? 0),
                ));
        }

        return Shimmerize(
          enabled: state.isLoading ||
              state.consolidatedAssets == null ||
              !state.isSuccess && state.customerTarget == null && state.consolidatedAssets?.overallItemGroups == null ||
              !isPortfolioSummaryReady,
          child: HasTargetWidget(
            customerTargetResponse: state.customerTarget!,
            totalAmount: state.consolidatedAssets == null
                ? 0
                : _calculateTotalAmount(
                      state.consolidatedAssets!.overallItemGroups,
                    ) +
                    usPortfolioTotalAmount,
          ),
        );
      },
    );
  }

  Widget _noTargetWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: Grid.l,
        ),
        Text(
          L10n.tr('no_target_info'),
          style: context.pAppStyle.labelReg14textPrimary,
        ),
        const SizedBox(
          height: Grid.s + Grid.xs,
        ),
        InkWell(
          onTap: () {
            PBottomSheet.show(
              context,
              title: L10n.tr('set_a_goal'),
              child: const EnterTargetWidget(),
            );
          },
          child: Row(
            children: [
              SvgPicture.asset(
                ImagesPath.goal,
                width: 17,
                height: 17,
                colorFilter: ColorFilter.mode(context.pColorScheme.primary, BlendMode.srcIn),
              ),
              const SizedBox(
                width: Grid.xs,
              ),
              Text(
                L10n.tr('set_a_goal'),
                style: context.pAppStyle.labelReg16primary,
              ),
            ],
          ),
        )
      ],
    );
  }

  double _calculateTotalAmount(
    List<OverallItemModel> overallItemGroups,
  ) {
    double totalAmount = 0;
    for (var element in overallItemGroups) {
      for (var item in element.overallSubItems) {
        totalAmount += item.amount;
      }
    }

    return totalAmount;
  }
}
