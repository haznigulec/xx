import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class NoTicketWidget extends StatelessWidget {
  final VoidCallback onCreateTicket;

  const NoTicketWidget({
    super.key,
    required this.onCreateTicket,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: Grid.m,
      children: [
        SvgPicture.asset(
          ImagesPath.messageOff,
          width: 32,
        ),
        Text(
          L10n.tr('no_ticket'),
          textAlign: TextAlign.center,
          style: context.pAppStyle.labelMed18textPrimary,
        ),
        Text(
          L10n.tr('no_ticket_description'),
          textAlign: TextAlign.center,
          style: context.pAppStyle.labelReg14textPrimary,
        ),
        PButtonWithIcon(
          sizeType: PButtonSize.small,
          text: L10n.tr('create_ticket'),
          iconAlignment: IconAlignment.start,
          icon: SvgPicture.asset(
            ImagesPath.plus,
            width: 17,
            colorFilter: ColorFilter.mode(
              context.pColorScheme.line.shade50,
              BlendMode.srcIn,
            ),
          ),
          onPressed: onCreateTicket,
        ),
      ],
    );
  }
}
