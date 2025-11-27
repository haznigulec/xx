import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_bloc.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_event.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class CreateAccountWidget extends StatelessWidget {
  final String loginMessage;
  final String memberMessage;
  final Function()? onLogin;
  const CreateAccountWidget({
    super.key,
    required this.loginMessage,
    required this.memberMessage,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        Grid.m,
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              ImagesPath.userSec,
              width: 52,
              height: 52,
              colorFilter: ColorFilter.mode(
                context.pColorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(
              height: Grid.s,
            ),
            Text(
              getIt<AppInfoBloc>().state.loginCount.isEmpty ? memberMessage : loginMessage,
              textAlign: TextAlign.center,
              style: context.pAppStyle.labelReg16textPrimary,
            ),
            const SizedBox(
              height: Grid.m,
            ),
            PButtonWithIcon(
              text: L10n.tr(getIt<AppInfoBloc>().state.loginCount.isEmpty ? 'hesap_ac' : 'giris_yap'),
              sizeType: PButtonSize.small,
              icon: SvgPicture.asset(
                ImagesPath.arrow_up_right,
                width: 17,
                height: 17,
                colorFilter: ColorFilter.mode(
                  context.pColorScheme.lightHigh,
                  BlendMode.srcIn,
                ),
              ),
              onPressed: getIt<AppInfoBloc>().state.loginCount.isEmpty
                  ? () async {
                      getIt<Analytics>().track(
                        AnalyticsEvents.videoCallSignUpClick,
                        taxonomy: [
                          InsiderEventEnum.createAccountPage.value,
                        ],
                      );
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
                    }
                  : onLogin,
            ),
          ],
        ),
      ),
    );
  }
}
