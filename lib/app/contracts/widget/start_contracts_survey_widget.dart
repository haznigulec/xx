import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/contracts/page/contracts_info_page.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class StartContractsSurveyWidget extends StatelessWidget {
  const StartContractsSurveyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Grid.m,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: Grid.m,
          ),
          Text(
            L10n.tr('uygunluk_testi_description'),
            style: context.pAppStyle.labelReg16textPrimary,
          ),
          const SizedBox(
            height: Grid.m + Grid.xs,
          ),
          PTextButtonWithIcon(
            text: L10n.tr('uygunluk_testi_nedir'),
            iconAlignment: IconAlignment.end,
            padding: EdgeInsets.zero,
            icon: SvgPicture.asset(
              ImagesPath.info,
              width: 17,
              colorFilter: ColorFilter.mode(
                context.pColorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () => PBottomSheet.show(
              context,
              child: const ContractsInfoWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
