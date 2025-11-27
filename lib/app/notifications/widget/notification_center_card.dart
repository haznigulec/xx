import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:piapiri_v2/app/notifications/bloc/notifications_bloc.dart';
import 'package:piapiri_v2/app/notifications/bloc/notifications_event.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/notification_model.dart';

class NotificationCenterCard extends StatefulWidget {
  final NotificationModel data;
  final Function() onTap;
  final int categoryId;
  const NotificationCenterCard({
    super.key,
    required this.data,
    required this.onTap,
    required this.categoryId,
  });

  @override
  State<NotificationCenterCard> createState() => _NotificationCenterCardState();
}

class _NotificationCenterCardState extends State<NotificationCenterCard> {
  late NotificationsBloc _notificationsBloc;
  @override
  void initState() {
    _notificationsBloc = getIt<NotificationsBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () => _readNotification(
                widget.data.isRead = !widget.data.isRead,
                true,
              ),
              child: Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(
                  top: Grid.xs,
                ),
                decoration: BoxDecoration(
                  color: !widget.data.isRead ? context.pColorScheme.primary : context.pColorScheme.textTeritary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(
              width: Grid.s,
            ),
            Expanded(
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () => _readNotification(true, false),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.data.title,
                      style: context.pAppStyle.labelMed14textPrimary,
                    ),
                    const SizedBox(
                      height: Grid.xs,
                    ),
                    Text(
                      widget.data.subTitle ?? '',
                      style: context.pAppStyle.labelReg14textSecondary,
                    ),
                    const SizedBox(
                      height: Grid.xs,
                    ),
                    Text(
                      '${DateTimeUtils.dateFormat(
                        DateTime.parse(
                          widget.data.createdDay,
                        ),
                      )}, ${DateTimeUtils.strTimeFromDate(
                        date: DateTime.parse(
                          widget.data.createdTime,
                        ),
                      )}',
                      style: context.pAppStyle.labelMed12textTeritary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            vertical: Grid.s,
          ),
          child: PDivider(),
        ),
      ],
    );
  }

  _readNotification(bool isRead, bool fromLeftSide) async {
    if (fromLeftSide) {
      _notificationsBloc.add(
        NotificationGetCategories(
          callback: (notification) async {
            FlutterAppBadger.updateBadgeCount(
              notification.count,
            );
          },
        ),
      );
      setState(() => widget.data.isRead == !widget.data.isRead);
    } else {
      setState(() => widget.data.isRead = true);
    }

    _notificationsBloc.add(
      NotificationReadEvent(
        notificationId: widget.data.notificationId,
        isRead: widget.data.isRead,
      ),
    );

    if (!fromLeftSide) {
      widget.onTap(); // önceki sayfayı yenilemek için
    }
  }
}
