import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/notifications/model/notification_preferences_model.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class NotificationPreferenceTile extends StatefulWidget {
  final NotificationPreferencesModel preference;
  final List<NotificationPreferencesModel> preferenceList;
  final VoidCallback onTap;
  const NotificationPreferenceTile({
    super.key,
    required this.preference,
    required this.preferenceList,
    required this.onTap,
  });

  @override
  State<NotificationPreferenceTile> createState() => _NotificationPreferenceTileState();
}

class _NotificationPreferenceTileState extends State<NotificationPreferenceTile> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.preference.title,
            style: context.pAppStyle.labelReg14textPrimary,
          ),
        ),
        InkWell(
          splashColor: context.pColorScheme.transparent,
          highlightColor: context.pColorScheme.transparent,
          onTap: widget.onTap,
          child: Row(
            spacing: Grid.xs,
            children: [
              Text(
                widget.preference.children.firstWhere((element) => element.value == widget.preference.value).title ==
                        'Sadece Bildirim Merkezinde Göster'
                    ? L10n.tr('push_notification_off')
                    : widget.preference.children
                        .firstWhere((element) => element.value == widget.preference.value)
                        .title,
                style: context.pAppStyle.labelReg14primary,
              ),
              SvgPicture.asset(
                ImagesPath.chevron_down,
                width: 15,
                height: 15,
                colorFilter: ColorFilter.mode(
                  context.pColorScheme.primary,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
