import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/avatar/pages/profile_picture.dart';
import 'package:piapiri_v2/app/market_carousel/market_carousel_vertical_widget.dart';
import 'package:piapiri_v2/app/notifications/bloc/notifications_bloc.dart';
import 'package:piapiri_v2/app/notifications/bloc/notifications_state.dart';
import 'package:piapiri_v2/app/search_symbol/symbol_search_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/badge/notification_badge_widget.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class HeaderButtons extends StatelessWidget {
  const HeaderButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
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
        const SizedBox(
          width: Grid.m,
        ),
        const Expanded(
          child: MarketCarouselVerticalWidget(),
        ),
        PIconButton(
          type: PIconButtonType.standard,
          svgPath: ImagesPath.alarm,
          sizeType: PIconButtonSize.xl,
          onPressed: () {
            router.push(
              MyAlarmsRoute(),
            );
          },
        ),
        const SizedBox(
          width: Grid.xs,
        ),
        PIconButton(
          type: PIconButtonType.standard,
          svgPath: ImagesPath.search,
          sizeType: PIconButtonSize.xl,
          onPressed: () => SymbolSearchUtils.goSymbolDetail(),
        ),
      ],
    );
  }
}
