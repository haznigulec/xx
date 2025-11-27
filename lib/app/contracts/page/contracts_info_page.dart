import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ContractsInfoWidget extends StatelessWidget {
  const ContractsInfoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(
          ImagesPath.info,
          width: 52,
          colorFilter: ColorFilter.mode(
            context.pColorScheme.primary,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(
          height: Grid.m,
        ),
        Text(
          L10n.tr('uygunluk_testi_nedir'),
          style: context.pAppStyle.labelMed16textPrimary,
        ),
        const SizedBox(
          height: Grid.m,
        ),
        Text(
          L10n.tr('uygunluk_test_aciklama'),
          style: context.pAppStyle.labelReg16textPrimary,
        ),
      ],
    );
  }
}
