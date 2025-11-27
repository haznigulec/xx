import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/widgets/selection_control/radio_button.dart';
import 'package:piapiri_v2/core/model/dropdown_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class FilterRadioList extends StatefulWidget {
  final List<DropdownModel> dataList;
  final String? selectedValue;
  final String? selectedName;
  final Function(String?, String?)? onTapBack;

  const FilterRadioList({
    super.key,
    required this.dataList,
    this.selectedValue,
    this.selectedName,
    this.onTapBack,
  });

  @override
  State<FilterRadioList> createState() => _FilterRadioListState();
}

class _FilterRadioListState extends State<FilterRadioList> {
  String? _selectedValue;
  @override
  void initState() {
    _selectedValue = widget.selectedValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        widget.dataList.length,
        (index) => PRadioButtonRow(
          text: L10n.tr(widget.dataList[index].name),
          removeCheckboxPadding: true,
          value: widget.dataList[index].value,
          groupValue: _selectedValue,
          onChanged: (value) {
            setState(
              () {
                _selectedValue = value;
                widget.onTapBack?.call(_selectedValue, widget.dataList[index].name);
              },
            );
          },
        ),
      ),
    );
  }
}
