import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/core/model/notification_model.dart';

class LocalNotification extends StatefulWidget {
  final RemoteMessage remoteMessage;
  final NotificationModel remoteNotificationModel;
  final NotificationDetail remoteNotificationDetail;
  final VoidCallback onClose;
  const LocalNotification({
    super.key,
    required this.remoteMessage,
    required this.remoteNotificationModel,
    required this.remoteNotificationDetail,
    required this.onClose,
  });

  @override
  State<LocalNotification> createState() => _LocalNotificationState();
}

class _LocalNotificationState extends State<LocalNotification> {
  bool _isOpened = false;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.pColorScheme.transparent,
      child: InkWell(
        onTap: getIt<AuthBloc>().state.isLoggedIn && !_isOpened
            ? () {
                if (router.routeNames.last == NotificationRoute.name) {
                  router.replace(
                    NotificationRoute(
                      remoteNotificationModel: widget.remoteNotificationModel,
                      remoteNotificationDetail: widget.remoteNotificationDetail,
                    ),
                  );
                } else {
                  router.push(
                    NotificationRoute(
                      remoteNotificationModel: widget.remoteNotificationModel,
                      remoteNotificationDetail: widget.remoteNotificationDetail,
                    ),
                  );
                }
                setState(() => _isOpened = true);
              }
            : null,
        child: Padding(
          padding: EdgeInsets.only(
            left: Grid.s,
            right: Grid.s,
            top: MediaQuery.of(context).padding.top + Grid.s,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: Grid.l,
              horizontal: Grid.m,
            ),
            decoration: BoxDecoration(
              color: context.pColorScheme.card,
              borderRadius: const BorderRadius.all(
                Radius.circular(
                  Grid.m,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: context.pColorScheme.primary.shade300,
                  offset: const Offset(0, 4), // Gölgeyi aşağı kaydır
                  blurRadius: 6, // Bulanıklık
                  spreadRadius: -3, // Üstte gölge olmaması için negatif değer
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: widget.onClose,
                    child: SvgPicture.asset(
                      ImagesPath.x,
                      colorFilter: ColorFilter.mode(
                        context.pColorScheme.primary,
                        BlendMode.srcIn,
                      ),
                      width: 15,
                      height: 15,
                    ),
                  ),
                ),
                const SizedBox(
                  height: Grid.xs,
                ),
                Text(
                  widget.remoteMessage.notification!.title ?? '',
                  style: context.pAppStyle.labelMed14primary,
                ),
                const SizedBox(
                  height: Grid.s,
                ),
                Text(
                  widget.remoteMessage.notification!.body ?? '',
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: context.pAppStyle.labelReg12textPrimary,
                ),
                const SizedBox(
                  height: Grid.m,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
