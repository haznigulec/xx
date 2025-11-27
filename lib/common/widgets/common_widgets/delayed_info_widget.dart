import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_bloc.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_event.dart';
import 'package:piapiri_v2/app/markets/model/market_menu.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/textfields/rich_text.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_state.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class DelayedInfoWidget extends StatelessWidget {
  final List<String> delayedSymbols;
  final int? activeIndex;
  final MarketMenu? marketMenu;
  final int? marketIndex;
  const DelayedInfoWidget({
    super.key,
    this.activeIndex,
    this.marketMenu,
    this.marketIndex,
    required this.delayedSymbols,
  });

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<MatriksBloc, MatriksState>(
      bloc: getIt<MatriksBloc>(),
      builder: (context, state) {
        if (!shouldShow(state)) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Grid.m,
          ),
          child: Column(
            spacing: Grid.m,
            children: [
              const PDivider(),
              GestureDetector(
                onTap: () => router.push(
                  AuthRoute(
                    activeIndex: activeIndex,
                    marketMenu: marketMenu,
                    marketIndex: marketIndex,
                  ),
                ),
                child: getIt<AppInfoBloc>().state.loginCount.isNotEmpty
                    ? Text(
                        L10n.tr('delayed_data_info'),
                        style: context.pAppStyle.labelReg14textPrimary,
                      )
                    : Column(
                        children: [
                          Text(
                            L10n.tr('craete_account_delayed_data_info'),
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                  fontSize: 14,
                                ),
                          ),
                          const SizedBox(
                            height: Grid.m,
                          ),
                          PButtonWithIcon(
                            height: 52,
                            text: L10n.tr('hesap_ac'),
                            iconAlignment: IconAlignment.start,
                            icon: SvgPicture.asset(
                              ImagesPath.arrow_up_right,
                              width: 17,
                              height: 17,
                              colorFilter: ColorFilter.mode(
                                context.pColorScheme.card.shade50,
                                BlendMode.srcIn,
                              ),
                            ),
                            fillParentWidth: true,
                            onPressed: () async {
                              getIt<Analytics>().track(AnalyticsEvents.videoCallSignUpClick, taxonomy: [
                                InsiderEventEnum.controlPanel.value,
                                InsiderEventEnum.marketsPage.value,
                                InsiderEventEnum.istanbulStockExchangeTab.value,
                              ]);
                              getIt<EnquraBloc>().add(
                                CheckActiveProcessEvent(
                                  callback: (isActive) {
                                    if (isActive) {
                                      router.push(EnquraRoute(
                                        isExistDashboard: true,
                                      ));
                                    } else {
                                      getIt<Analytics>().track(
                                        AnalyticsEvents.splashStartButtonClick,
                                      );
                                      router.push(
                                        EnquraRegisterRoute(),
                                      );
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: Grid.m,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GeneralRichText(
                              textSpan1: L10n.tr('account_already_exist_question'),
                              textSpan2: L10n.tr('splash_login'),
                              textStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontSize: 14,
                                  ),
                            ),
                          ),
                        ],
                      ),
              ),
              const PDivider(),
            ],
          ),
        );
      },
    );
  }

  bool shouldShow(MatriksState state) {
    if (delayedSymbols.isEmpty) {
      return true;
    }
    for (var symbol in delayedSymbols) {
      if (state.topics['mqtt']['market'][symbol]['qos'] != 'dl') {
        return false;
      }
    }
    return true;
  }
}
