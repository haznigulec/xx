import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/info/model/info_variant.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

@RoutePage()
class FutureInfoPage extends StatelessWidget {
  final String buttonText;
  final Function()? buttonClick;
  final Future<(bool, String)> initialFuture;

  const FutureInfoPage({
    super.key,
    required this.buttonText,
    this.buttonClick,
    required this.initialFuture,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<(bool, String)>(
        future: initialFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: PLoading());
          }
          InfoVariant variant = (snapshot.data?.$1 ?? false) ? InfoVariant.success : InfoVariant.failed;
          String message = snapshot.data?.$2 ?? '';
          return SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: Grid.xs,
                      right: Grid.m,
                    ),
                    child: InkWell(
                      onTap: () => router.maybePop(),
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
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      variant == InfoVariant.success
                          ? SvgPicture.asset(
                              width: 80,
                              height: 80,
                              ImagesPath.checkCircle,
                              colorFilter: ColorFilter.mode(
                                context.pColorScheme.primary,
                                BlendMode.srcIn,
                              ),
                            )
                          : SvgPicture.asset(
                              width: 80,
                              height: 80,
                              ImagesPath.error,
                              colorFilter: null,
                            ),
                      const SizedBox(
                        height: Grid.m,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Grid.m,
                        ),
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: context.pAppStyle.labelMed22textPrimary,
                        ),
                      ),
                      const SizedBox(
                        height: Grid.l,
                      ),
                      PCustomOutlinedButtonWithIcon(
                        text: buttonText,
                        buttonType: PCustomOutlinedButtonTypes.mediumPrimary,
                        iconSource: ImagesPath.arrow_up_right,
                        foregroundColor: context.pColorScheme.primary,
                        onPressed: buttonClick ?? () => router.maybePop(),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
