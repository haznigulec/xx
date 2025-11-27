import 'package:piapiri_v2/common/widgets/selection_control/checkbox.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/enqura/widget/enqura_info_widget.dart';
import 'package:piapiri_v2/app/global_account_onboarding/widget/custom_progress_bar.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class EnquraIdCardScanWidget extends StatelessWidget {
  const EnquraIdCardScanWidget({
    required this.pageState,
    required this.isCheckedInfo,
    required this.isCheckedInfoChanged,
    super.key,
  });
  final PageState pageState;
  final bool isCheckedInfo;
  final Function(bool) isCheckedInfoChanged;

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
            value: 1 / 3,
            progressText: '1/3',
          ),
          Expanded(
            child: EnquraInfoWidget(
              imageFormatIsSvg: pageState == PageState.failed,
              imagePath: pageState == PageState.failed ? ImagesPath.alert_circle : ImagesPath.tckimlik,
              imageColor: pageState == PageState.failed ? context.pColorScheme.critical : null,
              title: pageState == PageState.failed ? L10n.tr('scan_id_card_failed') : L10n.tr('scan_id_card'),
              subTitle: pageState == PageState.failed
                  ? L10n.tr('scan_id_card_failed_message')
                  : L10n.tr('scan_id_card_instruction'),
            ),
          ),
          if (pageState == PageState.initial) ...[
            PCheckboxRow(
              value: isCheckedInfo,
              removeCheckboxPadding: true,
              padding: EdgeInsets.zero,
              labelWidget: Padding(
                padding: const EdgeInsets.only(
                  left: Grid.s,
                ),
                child: Text(
                  L10n.tr('scan_id_card_checked_text'),
                  style: context.pAppStyle.labelReg14textPrimary,
                  textAlign: TextAlign.justify,
                ),
              ),
              onChanged: (bool? value) {
                isCheckedInfoChanged.call(value ?? false);
              },
            ),
            const SizedBox(
              height: Grid.s,
            ),
          ]
        ],
      ),
    );
  }
}
