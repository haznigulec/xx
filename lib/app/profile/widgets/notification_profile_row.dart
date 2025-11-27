import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/app/notifications/bloc/notifications_bloc.dart';
import 'package:piapiri_v2/app/notifications/bloc/notifications_state.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/badge/notification_badge_widget.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class NotificationProfileRow extends StatelessWidget {
  const NotificationProfileRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: InkWell(
        splashColor: context.pColorScheme.transparent,
        highlightColor: context.pColorScheme.transparent,
        onTap: () => router.push(NotificationRoute()),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.pColorScheme.card,
              ),
              child: SvgPicture.asset(
                ImagesPath.notification,
                height: 18,
                width: 18,
                colorFilter: ColorFilter.mode(
                  context.pColorScheme.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(
              width: Grid.s,
            ),
            Expanded(
              child: Text(
                L10n.tr('bildirim_merkezi'),
                textAlign: TextAlign.start,
                style: context.pAppStyle.labelReg16textPrimary.copyWith(
                  color: context.pColorScheme.textPrimary,
                ),
              ),
            ),
            const SizedBox(
              width: Grid.s,
            ),
            PBlocBuilder<NotificationsBloc, NotificationsState>(
              bloc: getIt<NotificationsBloc>(),
              builder: (context, state) => NotificationBadgeWidget(
                count: state.notificationUnReadCount ?? 0,
              ),
            ),
            const SizedBox(
              width: Grid.s,
            ),
            SvgPicture.asset(
              ImagesPath.chevron_right,
              width: Grid.m,
              height: Grid.m,
              colorFilter: ColorFilter.mode(
                context.pColorScheme.textPrimary,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
