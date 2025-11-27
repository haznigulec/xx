import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/exchange_overlay/widgets/show_case_view.dart';
import 'package:piapiri_v2/common/widgets/sliding_segment/model/sliding_segment_model.dart';
import 'package:piapiri_v2/common/widgets/sliding_segment/sliding_segment.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/assets/model/portfolio_action_enum.dart';
import 'package:piapiri_v2/app/assets/pages/assets_page.dart';
import 'package:piapiri_v2/app/assets/pages/assets_us_page.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/home/widgets/account_status.dart';
import 'package:piapiri_v2/app/money_transfer/widgets/shortcut_widgets.dart';
import 'package:piapiri_v2/common/utils/show_case_utils.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/create_account_widget.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_bloc.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_event.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:showcaseview/showcaseview.dart';

@RoutePage()
class PortfolioPage extends StatefulWidget {
  final int? initialIndex;
  final List<ShowCaseViewModel>? portfolioShowCaseKeys;

  const PortfolioPage({
    super.key,
    this.initialIndex = 0,
    this.portfolioShowCaseKeys,
  });

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  late AuthBloc _authBloc;
  PortfolioActionEnum _action = PortfolioActionEnum.domestic;
  late bool _isActiveShowCase;
  @override
  void initState() {
    _authBloc = getIt<AuthBloc>();

    if (widget.initialIndex != null) {
      _action = widget.initialIndex == 0
          ? PortfolioActionEnum.domestic
          : PortfolioActionEnum.abroad;
    } else if (getIt<TabBloc>().state.portfolioTabIndex != null) {
      _action = getIt<TabBloc>().state.portfolioTabIndex == 0
          ? PortfolioActionEnum.domestic
          : PortfolioActionEnum.abroad;
      getIt<TabBloc>().add(TabClearEvent());
    }

    _isActiveShowCase =
        ShowCaseUtils.onCheckShowCaseEvent(ShowCaseEnum.portfolioCase) &&
            _authBloc.state.isLoggedIn;
    if (_isActiveShowCase && widget.portfolioShowCaseKeys?.isNotEmpty == true) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          ShowCaseUtils.onAddShowCaseEvent(ShowCaseEnum.portfolioCase);
          ShowcaseView.get().startShowCase(
            widget.portfolioShowCaseKeys!.map((e) => e.globalKey).toList(),
          );
        },
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Grid.m,
        ),
        child: ValueListenableBuilder<bool>(
          valueListenable: UserModel.instance.showTotalAsset,
          builder: (context, isShowing, child) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...!_authBloc.state.isLoggedIn
                  ? [
                      Expanded(
                        child: CreateAccountWidget(
                          memberMessage:
                              L10n.tr('create_account_portfolio_alert'),
                          loginMessage: L10n.tr('login_portfolio_alert'),
                          onLogin: () => router.push(
                            AuthRoute(
                              activeIndex: 3,
                            ),
                          ),
                        ),
                      )
                    ]
                  : [
                      const SizedBox(
                        height: Grid.s + Grid.xxs,
                      ),
                      const AccountStatus(),
                      const SizedBox(
                        height: Grid.m,
                      ),
                      const ShortcutWidgets(),
                      const SizedBox(
                        height: Grid.l,
                      ),
                      if (Utils().canTradeAmericanMarket()) ...[
                        SizedBox(
                          height: 35,
                          width: MediaQuery.sizeOf(context).width,
                          child: SlidingSegment(
                            initialSelectedSegment: widget.initialIndex,
                            backgroundColor: context.pColorScheme.card,
                            segmentList: [
                              PSlidingSegmentModel(
                                segmentTitle: L10n.tr('domestic'),
                                segmentColor: context.pColorScheme.secondary,
                                showCase:
                                    widget.portfolioShowCaseKeys?.isNotEmpty ==
                                            true
                                        ? widget.portfolioShowCaseKeys!.first
                                        : null,
                              ),
                              PSlidingSegmentModel(
                                segmentTitle: L10n.tr('abroad'),
                                segmentColor: context.pColorScheme.secondary,
                                showCase:
                                    widget.portfolioShowCaseKeys?.isNotEmpty ==
                                            true
                                        ? widget.portfolioShowCaseKeys!
                                            .skip(1)
                                            .first
                                        : null,
                              ),
                            ],
                            onValueChanged: (baseType) {
                              setState(() {
                                _action = baseType == 0
                                    ? PortfolioActionEnum.domestic
                                    : PortfolioActionEnum.abroad;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: Grid.m,
                        ),
                      ],
                      Expanded(
                        child: _action == PortfolioActionEnum.domestic
                            ? AssetsPage(
                                action: _action,
                                isVisible: isShowing,
                              )
                            : AssetUsPage(
                                isVisible: isShowing,
                              ),
                      ),
                    ]
            ],
          ),
        ),
      ),
    );
  }
}
