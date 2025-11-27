import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_state.dart';
import 'package:piapiri_v2/common/widgets/story/story_view_widget.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_bloc.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_event.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class CreateAccountPage extends StatefulWidget {
  final bool isFirstLaunch;
  const CreateAccountPage({
    this.isFirstLaunch = false,
    super.key,
  });

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  late AppInfoBloc _appInfoBloc;
  late EnquraBloc _enquraBloc;

  @override
  void initState() {
    _appInfoBloc = getIt<AppInfoBloc>();
    _enquraBloc = getIt<EnquraBloc>();
    getIt<Analytics>().track(
      AnalyticsEvents.splashView,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: PBlocBuilder<AppInfoBloc, AppInfoState>(
                  bloc: _appInfoBloc,
                  builder: (context, state) => state.splashStories?.isNotEmpty == true
                      ? StoryViewWidget(
                          stories: state.splashStories ?? [],
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              const SizedBox(
                height: Grid.l - Grid.xs,
              ),
              PBlocBuilder<EnquraBloc, EnquraState>(
                bloc: _enquraBloc,
                builder: (context, state) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Grid.m),
                  child: PButton(
                    fillParentWidth: true,
                    loading: state.isLoading,
                    onPressed: state.isLoading
                        ? null
                        : () {
                            _enquraBloc.add(
                              CheckActiveProcessEvent(
                                callback: (isActive) {
                                  if (isActive) {
                                    router.push(EnquraRoute());
                                  } else {
                                    getIt<Analytics>().track(
                                      AnalyticsEvents.splashStartButtonClick,
                                    );
                                    router.push(
                                      EnquraRegisterRoute(
                                        isFirstLaunch: widget.isFirstLaunch,
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                    text: L10n.tr('hesap_ac'),
                  ),
                ),
              ),
              const SizedBox(
                height: Grid.l - Grid.xs,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Grid.m),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: L10n.tr('account_already_exist_question'),
                        style: context.pAppStyle.labelReg16textPrimary,
                      ),
                      TextSpan(
                        text: ' ${L10n.tr('splash_login')}',
                        style: context.pAppStyle.labelReg16textPrimary.copyWith(
                          color: context.pColorScheme.primary,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            getIt<Analytics>().track(
                              AnalyticsEvents.splashLoginClick,
                            );
                            router.push(
                              AuthRoute(
                                didNotLogin: widget.isFirstLaunch,
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: Grid.l,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
