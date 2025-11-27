import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class AlarmSuccessPage extends StatelessWidget {
  const AlarmSuccessPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(
            Grid.m,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    if (router.routeNames.contains(MyAlarmsRoute.name)) {
                      router.popUntilRouteWithName(
                        MyAlarmsRoute.name,
                      );
                    } else {
                      router.popUntilRoot();
                    }
                  },
                  child: SvgPicture.asset(
                    ImagesPath.x,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      context.pColorScheme.textPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      ImagesPath.checkCircle,
                      width: 80,
                      height: 80,
                      colorFilter: ColorFilter.mode(
                        context.pColorScheme.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(
                      height: Grid.l + Grid.xxs,
                    ),
                    Text(
                      L10n.tr('price_alarm_success'),
                      style: context.pAppStyle.labelMed22textPrimary,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
