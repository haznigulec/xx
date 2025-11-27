import 'package:piapiri_v2/common/widgets/selection_control/checkbox.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class SourcesCheckList extends StatefulWidget {
  final List<Map<String, String>> dataList;
  final List<String> selectedList;
  final Function(Set<String>)? onTapBack;

  const SourcesCheckList({
    super.key,
    required this.dataList,
    required this.selectedList,
    this.onTapBack,
  });

  @override
  State<SourcesCheckList> createState() => _SourcesCheckListState();
}

class _SourcesCheckListState extends State<SourcesCheckList> {
  Set<String> _selectedList = {};

  @override
  void initState() {
    _selectedList = Set.from(widget.selectedList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> checkListWidget = [];

    for (var i = 0; i < widget.dataList.length; i++) {
      checkListWidget.add(
        PCheckboxRow(
          label: L10n.tr(widget.dataList[i]['key']!),
          crossAxisAlignment: CrossAxisAlignment.center,
          padding: EdgeInsets.zero,
          value: _selectedList.contains(
            widget.dataList[i]['key'],
          ),
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                _selectedList.add(
                  widget.dataList[i]['key']!,
                );
              } else {
                _selectedList.remove(
                  widget.dataList[i]['key'],
                );
              }

              widget.onTapBack?.call(_selectedList);
            });
          },
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: checkListWidget,
    );
  }
}
