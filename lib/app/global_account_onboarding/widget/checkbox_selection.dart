import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/widgets/selection_control/checkbox.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class CheckboxSection extends StatefulWidget {
  final bool isAffiliatedFinra;
  final bool isControlPerson;
  final bool isPoliticallyExposed;
  final bool immediateFamilyExposed;

  final ValueChanged<bool?>? onAffiliatedFinraChanged;
  final ValueChanged<bool?>? onControlPersonChanged;
  final ValueChanged<bool?>? onPoliticallyExposedChanged;
  final ValueChanged<bool?>? onImmediateFamilyExposedChanged;

  const CheckboxSection({
    super.key,
    required this.isAffiliatedFinra,
    required this.isControlPerson,
    required this.isPoliticallyExposed,
    required this.immediateFamilyExposed,
    required this.onAffiliatedFinraChanged,
    required this.onControlPersonChanged,
    required this.onPoliticallyExposedChanged,
    required this.onImmediateFamilyExposedChanged,
  });

  @override
  State<CheckboxSection> createState() => _CheckboxSectionState();
}

class _CheckboxSectionState extends State<CheckboxSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCheckbox(
            value: widget.isAffiliatedFinra, onChanged: widget.onAffiliatedFinraChanged, label: 'isAffiliatedFinra'),
        _buildCheckbox(
            value: widget.isControlPerson, onChanged: widget.onControlPersonChanged, label: 'isControlPerson'),
        _buildCheckbox(
            value: widget.isPoliticallyExposed,
            onChanged: widget.onPoliticallyExposedChanged,
            label: 'isPoliticallyExposed'),
        _buildCheckbox(
            value: widget.immediateFamilyExposed,
            onChanged: widget.onImmediateFamilyExposedChanged,
            label: 'immediateFamilyExposed'),
      ],
    );
  }

  Widget _buildCheckbox({
    required bool value,
    required ValueChanged<bool?>? onChanged,
    required String label,
  }) {
    return Column(
      children: [
        PCheckboxRow(
          value: value,
          removeCheckboxPadding: true,
          onChanged: onChanged,
          label: L10n.tr(label),
        ),
        const SizedBox(height: Grid.s + Grid.xs),
      ],
    );
  }
}
