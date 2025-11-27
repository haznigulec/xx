import 'package:piapiri_v2/common/widgets/picker/date_pickers.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class DateSelectRow extends StatelessWidget {
  final String leading;
  final String trailing;
  final TextStyle? style;
  final DateTime? selectedDate;
  final DateTime? maximumDate;
  final DateTime? minimumDate;
  final Function(DateTime selectedDate) onDateSelected;

  const DateSelectRow({
    super.key,
    required this.leading,
    required this.trailing,
    this.style,
    this.selectedDate,
    this.maximumDate,
    this.minimumDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showPDatePicker(
          context: context,
          initialDate: selectedDate,
          maximumDate: maximumDate,
          minimumDate: minimumDate,
          cancelTitle: L10n.tr('iptal'),
          doneTitle: L10n.tr('tamam'),
          onChanged: (DateTime? pickedDate) {
            if (pickedDate != null) {
              onDateSelected(pickedDate);
            }
          },
        );
      },
      child: SizedBox(
        height: 46,
        child: Row(
          children: [
            SvgPicture.asset(
              ImagesPath.calendar,
              height: 15,
              width: 15,
              colorFilter: ColorFilter.mode(
                context.pColorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(
              width: Grid.s,
            ),
            Text(
              leading,
              style: style ?? context.pAppStyle.labelReg16textPrimary.copyWith(height: 1.2),
            ),
            const Spacer(),
            Text(
              trailing,
              style: style ?? context.pAppStyle.labelMed16textPrimary.copyWith(height: 1.2),
            ),
          ],
        ),
      ),
    );
  }
}
