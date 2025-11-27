import 'package:piapiri_v2/common/widgets/common_widgets/ink_wrapper.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class EquraContractCheckWidget extends StatefulWidget {
  const EquraContractCheckWidget({
    super.key,
    required this.isActive,
    required this.isChecked,
    required this.contratName,
    required this.onClick,
    required this.onChange,
  });

  final bool isActive;
  final bool isChecked;
  final String contratName;
  final Function() onClick;
  final Function() onChange;

  @override
  State<EquraContractCheckWidget> createState() => _EquraContractCheckWidgetState();
}

class _EquraContractCheckWidgetState extends State<EquraContractCheckWidget> {
  late TapGestureRecognizer _contractNameTapRecognizer;
  late TapGestureRecognizer _readUnderstoodTapRecognizer;

  @override
  void initState() {
    super.initState();
    _contractNameTapRecognizer = TapGestureRecognizer()..onTap = widget.onClick;
    _readUnderstoodTapRecognizer = TapGestureRecognizer()..onTap = widget.isActive ? widget.onChange : widget.onClick;
  }

  @override
  void dispose() {
    _contractNameTapRecognizer.dispose();
    _readUnderstoodTapRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        InkWrapper(
          onTap: widget.isActive ? widget.onChange : widget.onClick,
          child: SizedBox(
            height: Grid.m,
            width: Grid.m,
            child: Theme(
              data: Theme.of(context).copyWith(
                checkboxTheme: CheckboxThemeData(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      Grid.xs,
                    ),
                  ),
                  side: WidgetStateBorderSide.resolveWith(
                    (_) => BorderSide(
                      color: context.pColorScheme.primary,
                      width: 1.25,
                    ),
                  ),
                ),
              ),
              child: IgnorePointer(
                child: Checkbox(
                  value: widget.isChecked,
                  activeColor: context.pColorScheme.primary,
                  onChanged: (_) {},
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: Grid.s,
        ),
        Expanded(
          child: RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              children: [
                TextSpan(
                  text: widget.contratName,
                  style: context.pAppStyle.labelMed14primary,
                  recognizer: _contractNameTapRecognizer,
                ),
                TextSpan(
                  text: "'${L10n.tr('read_and_understood')}",
                  style: context.pAppStyle.labelReg14textPrimary,
                  recognizer: _readUnderstoodTapRecognizer,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
