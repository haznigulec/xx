import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_bloc.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_event.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class OrderResultPage extends StatelessWidget {
  final String message;
  final bool isSuccess;
  final String? buttonKey;
  final Function()? onButtonPressed;
  const OrderResultPage({
    super.key,
    required this.message,
    required this.isSuccess,
    this.onButtonPressed,
    this.buttonKey,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          InkWell(
              child: SvgPicture.asset(
                ImagesPath.x,
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(
                  context.pColorScheme.textPrimary,
                  BlendMode.srcIn,
                ),
              ),
              onTap: () {
                router.popUntilRoot();
                getIt<TabBloc>().add(
                  const TabChangedEvent(
                    tabIndex: 1,
                  ),
                );
              }),
          const SizedBox(
            width: Grid.m,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Grid.m),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                isSuccess ? ImagesPath.check_circle : ImagesPath.alert_circle,
                width: 80,
                height: 80,
                colorFilter: ColorFilter.mode(
                  isSuccess ? context.pColorScheme.primary : context.pColorScheme.critical,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(
                height: Grid.m,
              ),
              Text(
                message,
                textAlign: TextAlign.center,
                style: context.pAppStyle.labelMed22textPrimary,
              ),
              const SizedBox(
                height: Grid.l,
              ),
              if (isSuccess)
                SizedBox(
                  height: 33,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: context.pColorScheme.primary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Grid.m,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: Grid.m,
                      ),
                    ),
                    onPressed: onButtonPressed ??
                        () {
                          router.popUntilRoot();
                          getIt<TabBloc>().add(
                            const TabChangedEvent(
                              tabIndex: 1,
                            ),
                          );
                        },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          L10n.tr(
                            buttonKey ?? 'go_orders',
                          ),
                          style: context.pAppStyle.labelMed16primary,
                        ),
                        const SizedBox(
                          width: Grid.xs,
                        ),
                        SvgPicture.asset(
                          ImagesPath.arrow_up_right,
                          width: 17,
                          height: 17,
                          colorFilter: ColorFilter.mode(
                            context.pColorScheme.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
