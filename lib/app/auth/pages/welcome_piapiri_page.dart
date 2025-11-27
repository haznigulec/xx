import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/keys/navigator_keys.dart';
import 'package:piapiri_v2/app/money_transfer/widgets/bank_list_widget.dart';
import 'package:piapiri_v2/common/utils/constant.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class WelcomePiapiriPage extends StatefulWidget {
  const WelcomePiapiriPage({
    super.key,
  });

  @override
  State<WelcomePiapiriPage> createState() => _WelcomePiapiriPageState();
}

class _WelcomePiapiriPageState extends State<WelcomePiapiriPage> {
  bool _canPop = false;
  void _closePage(BuildContext context) {
    setState(() {
      _canPop = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration.zero);
      router.maybePop();
      await Future.delayed(Duration.zero);
      if (openUygunlukTestiAfterWelcomeScreen) {
        openUygunlukTestiAfterWelcomeScreen = false;
        router.push(
          ContractsSurveyRoute(title: L10n.tr('uygunluk_testi')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _closePage(context);
      },
      child: Scaffold(
        body: SafeArea(
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
                    onTap: () => _closePage(context),
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
                    Image.asset(
                      width: 80,
                      height: 80,
                      ImagesPath.confetti,
                    ),
                    const SizedBox(
                      height: Grid.m,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Grid.m,
                      ),
                      child: Text(
                        L10n.tr('welcome_investment_piapiri'),
                        textAlign: TextAlign.center,
                        style: context.pAppStyle.labelMed22textPrimary,
                      ),
                    ),
                    const SizedBox(
                      height: Grid.m,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Grid.m,
                      ),
                      child: Text(
                        L10n.tr('start_investing_immediately'),
                        textAlign: TextAlign.center,
                        style: context.pAppStyle.labelReg18textPrimary,
                      ),
                    ),
                    const SizedBox(
                      height: Grid.l,
                    ),
                    PCustomOutlinedButtonWithIcon(
                      text: L10n.tr('money_transfer'),
                      buttonType: PCustomOutlinedButtonTypes.mediumPrimary,
                      iconSource: ImagesPath.arrow_up_right,
                      foregroundColor: context.pColorScheme.primary,
                      onPressed: () {
                        setState(() {
                          _canPop = true;
                        });
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) async {
                            await Future.delayed(Duration.zero);
                            router.maybePop();
                            await Future.delayed(Duration.zero);
                            final isSelected = await PBottomSheet.show(
                              NavigatorKeys.navigatorKey.currentContext ?? context,
                              title: L10n.tr('choose_bank'),
                              titlePadding: const EdgeInsets.only(
                                top: Grid.m,
                              ),
                              child: SizedBox(
                                height: MediaQuery.sizeOf(NavigatorKeys.navigatorKey.currentContext ?? context).height *
                                    0.7,
                                child: const BankListWidget(
                                  comeFromWelcomeScreen: true,
                                ),
                              ),
                            );
                            if (isSelected != true && openUygunlukTestiAfterWelcomeScreen) {
                              openUygunlukTestiAfterWelcomeScreen = false;
                              router.push(
                                ContractsSurveyRoute(title: L10n.tr('uygunluk_testi')),
                              );
                            }
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: Grid.l + Grid.xs,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
