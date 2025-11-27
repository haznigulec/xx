import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/sliding_segment/model/sliding_segment_model.dart';
import 'package:piapiri_v2/common/widgets/sliding_segment/sliding_segment.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_bloc.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_event.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_state.dart';
import 'package:piapiri_v2/app/us_balance/pages/us_balance_deposit_page.dart';
import 'package:piapiri_v2/app/us_balance/pages/us_balance_withdraw_page.dart';
import 'package:piapiri_v2/app/us_balance/widgets/shimmer_us_balance_widget.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_event.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';

@RoutePage()
class UsBalancePage extends StatefulWidget {
  const UsBalancePage({
    super.key,
  });

  @override
  State<UsBalancePage> createState() => _UsBalancePageState();
}

class _UsBalancePageState extends State<UsBalancePage> {
  late AssetsBloc _assetsBloc;
  int _selectedSegmentedIndex = 0;
  late AppInfoBloc _appInfoBloc;
  bool _hasFocus = false;
  bool isClickAllSelectLimit = false;

  @override
  void initState() {
    _assetsBloc = getIt<AssetsBloc>();
    _appInfoBloc = getIt<AppInfoBloc>();
    _assetsBloc.add(
      GetCapraCollateralInfoEvent(),
    );
    _appInfoBloc.add(
      GetUSClockEvent(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PInnerAppBar(
        title: L10n.tr('american_stock_exchanges_collateral'),
      ),
      body: PBlocBuilder<AppInfoBloc, AppInfoState>(
        bloc: _appInfoBloc,
        builder: (context, appInfoState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Grid.m,
              ),
              child: appInfoState.isLoading
                  ? const ShimmerUsBalanceWidget()
                  : !DateTimeUtils().isWeekend(
                      date: appInfoState.usTime != null && appInfoState.usTime!.timestamp != null
                          ? DateTime.parse(appInfoState.usTime!.timestamp!).toLocal()
                          : DateTime.now(),
                    )
                      ? Column(
                          children: [
                            const SizedBox(
                              height: Grid.l - Grid.xs,
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              height: 35,
                              child: SlidingSegment(
                                backgroundColor: context.pColorScheme.card,
                                segmentList: [
                                  PSlidingSegmentModel(
                                    segmentTitle: L10n.tr('deposit_balance'),
                                    segmentColor: context.pColorScheme.secondary,
                                  ),
                                  PSlidingSegmentModel(
                                    segmentTitle: L10n.tr('withdraw_balance'),
                                    segmentColor: context.pColorScheme.secondary,
                                  ),
                                ],
                                onValueChanged: (index) {
                                  setState(() {
                                    _selectedSegmentedIndex = index;
                                    _hasFocus = false;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: Grid.l,
                            ),
                            PBlocBuilder<AssetsBloc, AssetsState>(
                              bloc: _assetsBloc,
                              builder: (context, state) {
                                return Expanded(
                                  child: _selectedSegmentedIndex == 0
                                      ? UsBalanceDepositPage(
                                          totalUsdBalance: state.capraCollateralInfo?.equity ?? 0,
                                        )
                                      : UsBalanceWithdrawPage(
                                          totalUsdBalance: state.capraCollateralInfo?.cashWithdrawable ?? 0,
                                          onFocusChanged: (focus) {
                                            setState(() => _hasFocus = focus);
                                          },
                                          isTapAllSelectLimit: isClickAllSelectLimit,
                                        ),
                                );
                              },
                            ),
                          ],
                        )
                      : Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            spacing: Grid.l,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: Grid.s,
                                children: [
                                  Text(
                                    L10n.tr('closed'),
                                    style: context.pAppStyle.labelMed22textPrimary,
                                  ),
                                  SvgPicture.asset(
                                    ImagesPath.moon,
                                    colorFilter: ColorFilter.mode(
                                      context.pColorScheme.critical,
                                      BlendMode.srcIn,
                                    ),
                                    width: 14,
                                    height: 14,
                                  )
                                ],
                              ),
                              Text(
                                L10n.tr('currency_transaction_weekend_info'),
                                textAlign: TextAlign.center,
                                style: context.pAppStyle.labelReg14textPrimary,
                              ),
                            ],
                          ),
                        ),
            ),
          );
        },
      ),
      bottomSheet: _hasFocus
          ? ColoredBox(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: Grid.m,
                    right: Grid.m,
                    bottom: Grid.xxl + Grid.s,
                  ),
                  child: POutlinedButton(
                    text: L10n.tr('allSelectBalance'),
                    fillParentWidth: true,
                    onPressed: () {
                      setState(() {
                        isClickAllSelectLimit = true;
                      });
                      Future.delayed(const Duration(milliseconds: 100), () {
                        if (mounted) {
                          setState(() {
                            isClickAllSelectLimit = false;
                          });
                        }
                      });
                    },
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
