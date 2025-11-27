import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/enqura/widget/enqura_info_widget.dart';
import 'package:piapiri_v2/app/global_account_onboarding/widget/custom_progress_bar.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/animated_progress_image.dart.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class EnquraIdCardNfcScanWidget extends StatelessWidget {
  const EnquraIdCardNfcScanWidget({
    super.key,
    required this.pageState,
    required this.nfcScanningProgressNotifier,
  });

  final PageState pageState;
  final ValueNotifier<double> nfcScanningProgressNotifier;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Grid.m,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: Grid.m,
          ),
          const CustomProgressBar(
            value: 2 / 3,
            progressText: '2/3',
          ),
          const Spacer(),
          if (pageState == PageState.loading) ...[
            EnquraInfoWidget(
              imageWidget: ValueListenableBuilder<double>(
                valueListenable: nfcScanningProgressNotifier,
                builder: (context, value, child) => AnimatedProgressImage(
                  progress: nfcScanningProgressNotifier.value,
                  imageWidget: Container(
                    color: context.pColorScheme.card,
                    child: Image.asset(
                      ImagesPath.nfc,
                    ),
                  ),
                ),
              ),
              title: L10n.tr('nfc_scaning'),
              subTitle: L10n.tr('nfc_scaning_instruction'),
            ),
          ] else if (pageState == PageState.success) ...[
            EnquraInfoWidget(
              imageWidget: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: Grid.xl + Grid.xl,
                    height: Grid.xl + Grid.xl,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.pColorScheme.card,
                    ),
                  ),
                  SvgPicture.asset(
                    ImagesPath.checkCircle,
                    width: Grid.xl + Grid.xl + Grid.m,
                    height: Grid.xl + Grid.xl + Grid.m,
                    colorFilter: ColorFilter.mode(
                      context.pColorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  )
                ],
              ),
              title: L10n.tr('nfc_scan_is_success'),
            )
          ] else if (pageState == PageState.failed) ...[
            EnquraInfoWidget(
              imageWidget: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: Grid.xl + Grid.xl,
                    height: Grid.xl + Grid.xl,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.pColorScheme.card,
                    ),
                  ),
                  SvgPicture.asset(
                    ImagesPath.alert_circle,
                    width: Grid.xl + Grid.xl + Grid.m,
                    height: Grid.xl + Grid.xl + Grid.m,
                    colorFilter: ColorFilter.mode(
                      context.pColorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  )
                ],
              ),
              title: L10n.tr('nfc_scan_is_error'),
            )
          ] else ...[
            EnquraInfoWidget(
              imageFormatIsSvg: false,
              imagePath: ImagesPath.nfc,
              title: L10n.tr('nfc_scan_id_card'),
              subTitle: L10n.tr('nfc_scan_id_card_instruction'),
            ),
          ],
          const Spacer(),
        ],
      ),
    );
  }
}
