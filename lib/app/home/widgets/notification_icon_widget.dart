import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/notifications/bloc/notifications_bloc.dart';
import 'package:piapiri_v2/app/notifications/bloc/notifications_event.dart';
import 'package:piapiri_v2/app/notifications/bloc/notifications_state.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

class NotificationIconWidget extends StatefulWidget {
  const NotificationIconWidget({super.key});

  @override
  State<NotificationIconWidget> createState() => _NotificationIconWidgetState();
}

class _NotificationIconWidgetState extends State<NotificationIconWidget> {
  late NotificationsBloc _notificationBloc;
  late AuthBloc _authBloc;

  @override
  void initState() {
    _notificationBloc = getIt<NotificationsBloc>();
    _authBloc = getIt<AuthBloc>();
    if (_authBloc.state.isLoggedIn) {
      _notificationBloc.add(
        NotificationGetCategories(),
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PIconButton(
          type: PIconButtonType.standard,
          svgPath: ImagesPath.notification,
          color: context.pColorScheme.transparent,
          sizeType: PIconButtonSize.xl,
          onPressed: () {
            router.push(
              NotificationRoute(),
            );
          },
        ),
        if (getIt<AuthBloc>().state.isLoggedIn)
          Positioned(
            top: Grid.xs,
            right: Grid.xs,
            child: PBlocBuilder<NotificationsBloc, NotificationsState>(
              bloc: _notificationBloc,
              builder: (context, state) {
                if (state.isLoading) return const PLoading();
                if (state.notificationUnReadCount == null || state.notificationUnReadCount == 0) {
                  return const SizedBox.shrink();
                }

                return InkWell(
                  splashColor: context.pColorScheme.transparent,
                  highlightColor: context.pColorScheme.transparent,
                  onTap: () {
                    router.push(NotificationRoute());
                  },
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: context.pColorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
