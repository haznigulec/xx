import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/enqura/utils/enqura_helpers.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/widgets/styled_text.dart';

class EnquraAppoinmentSummaryWidget extends StatefulWidget {
  final AppointmentSlotItem appointment;
  final String messageKey;
  final String approvedButtonKey;
  final Future approvedButtonClick;

  const EnquraAppoinmentSummaryWidget({
    required this.appointment,
    required this.messageKey,
    required this.approvedButtonKey,
    required this.approvedButtonClick,
    super.key,
  });

  @override
  State<EnquraAppoinmentSummaryWidget> createState() => _EnquraAppoinmentSummaryWidgetState();
}

class _EnquraAppoinmentSummaryWidgetState extends State<EnquraAppoinmentSummaryWidget> {
  bool _showLoading = false;

  @override
  Widget build(BuildContext context) {
    final date = widget.appointment.date.dateTime.date;
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
            widget.messageKey,
            namedArgs: {
              'date': '<bold>${DateTimeUtils.dateFormat(appointmentDate)}</bold>',
              'time': '<bold>${formatTimeRange(widget.appointment)}</bold>',
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
          text: L10n.tr(widget.approvedButtonKey),
          loading: _showLoading,
          onPressed: _showLoading
              ? null
              : () async {
                  setState(() => _showLoading = true);
                  await widget.approvedButtonClick;
                  setState(() => _showLoading = false);
                },
        ),
      ],
    );
  }
}
