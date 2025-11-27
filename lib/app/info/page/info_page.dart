import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/info/model/info_variant.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';

@RoutePage()
class InfoPage extends StatelessWidget {
  final InfoVariant variant;
  final String message;
  final String? subMessage;
  final TextStyle? subMessageStyle;
  final String? buttonText;
  //Online contract ekranları için eklenmiştir.Kullanıcıya tekrar deneme işlemleri sırasında loading gösterilmiştir.
  //Tanımlandığı ekranda route akışına göre dispose edilmiştir.
  final ValueNotifier<bool>? buttonLoadingNotifier;
  final VoidCallback? onTapButton;
  final bool? fromGlobalOnboarding;
  final Function()? onPressedCloseIcon;
  final bool? showCloseIcon;
  final ValueNotifier<bool>? infoPageCloseableNotifier;

  const InfoPage({
    super.key,
    required this.variant,
    required this.message,
    this.subMessage,
    this.subMessageStyle,
    this.buttonText,
    this.buttonLoadingNotifier,
    this.onTapButton,
    this.fromGlobalOnboarding = false,
    this.onPressedCloseIcon,
    this.showCloseIcon = true,
    this.infoPageCloseableNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: infoPageCloseableNotifier ?? ValueNotifier(true),
      builder: (BuildContext context, bool canPop, Widget? child) => PopScope(
        canPop: canPop,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                if (showCloseIcon!) ...[
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: Grid.xs,
                        right: Grid.m,
                      ),
                      child: InkWell(
                        onTap: onPressedCloseIcon ?? () => router.maybePop(),
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
                ],
                Expanded(
                  child: Center(
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
                            : variant == InfoVariant.warning
                                ? SvgPicture.asset(
                                    width: 80,
                                    height: 80,
                                    ImagesPath.info,
                                    colorFilter: ColorFilter.mode(
                                      context.pColorScheme.primary,
                                      BlendMode.srcIn,
                                    ),
                                  )
                                : SvgPicture.asset(
                                    width: 80,
                                    height: 80,
                                    fromGlobalOnboarding! ? ImagesPath.alert_circle : ImagesPath.error,
                                    colorFilter: fromGlobalOnboarding!
                                        ? ColorFilter.mode(
                                            context.pColorScheme.primary,
                                            BlendMode.srcIn,
                                          )
                                        : null,
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
                        if (subMessage != null) ...[
                          const SizedBox(
                            height: Grid.m,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Grid.m,
                            ),
                            child: Text(
                              subMessage!,
                              textAlign: TextAlign.center,
                              style: subMessageStyle ?? context.pAppStyle.labelMed18textPrimary,
                            ),
                          ),
                        ],
                        const SizedBox(
                          height: Grid.l,
                        ),
                        if (buttonText != null)
                          fromGlobalOnboarding!
                              ? (variant == InfoVariant.success)
                                  ? PCustomPrimaryTextButton(
                                      text: buttonText!,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      iconAlignment: IconAlignment.end,
                                      icon: SvgPicture.asset(
                                        ImagesPath.arrow_up_right,
                                        width: Grid.m,
                                        height: Grid.m,
                                        colorFilter: ColorFilter.mode(
                                          context.pColorScheme.primary,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      onPressed: onTapButton,
                                    )
                                  : buttonLoadingNotifier == null
                                      ? SizedBox(
                                          height: fromGlobalOnboarding! ? 33 : null,
                                          child: PButtonWithIcon(
                                            text: buttonText!,
                                            sizeType: PButtonSize.small,
                                            icon: SvgPicture.asset(
                                              ImagesPath.arrows_refresh,
                                              width: Grid.m,
                                              height: Grid.m,
                                              colorFilter: ColorFilter.mode(
                                                context.pColorScheme.lightHigh,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            onPressed: onTapButton,
                                          ),
                                        )
                                      : ValueListenableBuilder<bool>(
                                          valueListenable: buttonLoadingNotifier!,
                                          builder: (BuildContext context, loading, Widget? child) => SizedBox(
                                            height: fromGlobalOnboarding! ? 33 : null,
                                            child: PButtonWithIcon(
                                              text: buttonText!,
                                              loading: loading,
                                              sizeType: PButtonSize.small,
                                              icon: SvgPicture.asset(
                                                ImagesPath.arrows_refresh,
                                                width: Grid.m,
                                                height: Grid.m,
                                                colorFilter: ColorFilter.mode(
                                                  context.pColorScheme.lightHigh,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                              onPressed: loading ? null : onTapButton,
                                            ),
                                          ),
                                        )
                              : PCustomOutlinedButtonWithIcon(
                                  text: buttonText!,
                                  buttonType: PCustomOutlinedButtonTypes.mediumPrimary,
                                  iconSource: ImagesPath.arrow_up_right,
                                  foregroundColor: context.pColorScheme.primary,
                                  onPressed: onTapButton,
                                ),
                      ],
                    ),
                  ),
                ),
                if (showCloseIcon!) ...[
                  const SizedBox(
                    height: Grid.l + Grid.xs,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
