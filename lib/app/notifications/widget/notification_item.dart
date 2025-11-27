import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:piapiri_v2/app/notifications/widget/notification_center_card.dart';
import 'package:piapiri_v2/core/config/notification_handler.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/notification_model.dart';

class NotificationItem extends StatefulWidget {
  final NotificationModel notification;
  final Function(List<int>) deletedNotification;
  final Function makeAsRead;
  final int categoryId;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.deletedNotification,
    required this.makeAsRead,
    required this.categoryId,
  });

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> with TickerProviderStateMixin {
  late SlidableController _slidableController;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _slidableController = SlidableController(this);
    }
  }

  @override
  void dispose() {
    _slidableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(
        widget.notification.notificationId,
      ),
      controller: _slidableController,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.10,
        children: [
          InkWell(
            onTap: () async {
              widget.deletedNotification(widget.notification.notificationId);

              _slidableController.close();
            },
            child: Center(
              child: Icon(
                Icons.delete_forever_outlined,
                color: context.pColorScheme.primary,
                size: 25,
              ),
            ),
          ),
        ],
      ),
      child: NotificationCenterCard(
        data: widget.notification,
        categoryId: widget.categoryId,
        onTap: () {
          widget.makeAsRead();
          getIt<NotificationHandler>().performNotificationAction(
            action: widget.notification.notificationActionType ?? '',
            params: widget.notification.notificationActionParams ?? '',
            tags: widget.notification.tags.join(','),
            externalLink: widget.notification.externalLink,
            fileUrl: widget.notification.fileUrl,
            notificationModel: widget.notification,
          );
        },
      ),
    );
  }
}
