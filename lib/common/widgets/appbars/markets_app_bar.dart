import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/avatar/pages/profile_picture.dart';
import 'package:piapiri_v2/app/notifications/bloc/notifications_bloc.dart';
import 'package:piapiri_v2/app/notifications/bloc/notifications_state.dart';
import 'package:piapiri_v2/common/widgets/badge/notification_badge_widget.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class MarketsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MarketsAppBar({
    required this.titleWidget,
    required this.actionsWidget,
    this.backgroundColor,
    super.key,
  });

  final Widget titleWidget;
  final List<Widget> actionsWidget;
  final Color? backgroundColor;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? context.pColorScheme.transparent,
      child: SafeArea(
        child: Container(
          color: context.pColorScheme.transparent,
          padding: const EdgeInsets.symmetric(horizontal: Grid.m),
          width: double.infinity,
          height: preferredSize.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                customBorder: const CircleBorder(),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const ProfilePicture(
                      size: Grid.m + Grid.m + Grid.xs,
                      showEditButton: false,
                    ),
                    PBlocBuilder<NotificationsBloc, NotificationsState>(
                      bloc: getIt<NotificationsBloc>(),
                      builder: (context, state) => Positioned(
                        top: -Grid.m / 2,
                        right: -Grid.l / 2,
                        child: NotificationBadgeWidget(
                          count: state.notificationUnReadCount ?? 0,
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: () => router.push(
                  const ProfileRoute(),
                ),
              ),
              if (actionsWidget.isNotEmpty && actionsWidget.length > 1) ...[
                ...actionsWidget.skip(1).map(
                      (e) => const SizedBox(
                        width: Grid.l + Grid.s,
                      ),
                    ),
              ],
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: titleWidget,
                    ),
                  ],
                ),
              ),
              if (actionsWidget.isNotEmpty) ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: Grid.xs,
                  children: [
                    ...actionsWidget,
                  ],
                )
              ] else ...[
                const SizedBox(
                  width: Grid.m + Grid.m,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
