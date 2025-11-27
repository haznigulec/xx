import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/enqura/utils/enqura_helpers.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/widgets/styled_text.dart';

class EnquraAppoinmentApproveWidget extends StatelessWidget {
  final AppointmentSlotItem appointment;
  final String callType;
  final Function()? onApproved;

  const EnquraAppoinmentApproveWidget({
    required this.appointment,
    required this.callType,
    required this.onApproved,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final date = appointment.date.dateTime.date;
    final appointmentDate = DateTime(date.year, date.month, date.day);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SvgPicture.asset(
          ImagesPath.alert_circle,
          width: 52,
          package: 'design_system',
          colorFilter: ColorFilter.mode(
            context.pColorScheme.primary,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(
          height: Grid.m,
        ),
        StyledText(
          text: L10n.tr(
            'create_appointment_info',
            namedArgs: {
              'date': '<bold>${DateTimeUtils.dateFormat(appointmentDate)}</bold>',
              'time': '<bold>${formatTimeRange(appointment)}</bold>',
            },
          ),
          textAlign: TextAlign.center,
          style: context.pAppStyle.labelReg16textPrimary,
          tags: {
            'bold': StyledTextTag(style: context.pAppStyle.labelMed16textPrimary),
          },
        ),
        const SizedBox(
          height: Grid.m,
        ),
        PButton(
          fillParentWidth: true,
          text: L10n.tr('onayla'),
          onPressed: () {
            Navigator.of(context).pop();
            onApproved?.call();
          },
        ),
      ],
    );
  }
}
