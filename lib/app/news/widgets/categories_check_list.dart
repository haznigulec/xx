import 'package:piapiri_v2/common/widgets/selection_control/checkbox.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class CategoriesCheckList extends StatefulWidget {
  final List<Map<String, String>> dataList;
  final List<String> selectedList;
  final Function(Set<String>)? onTapBack;

  const CategoriesCheckList({
    super.key,
    required this.dataList,
    required this.selectedList,
    this.onTapBack,
  });

  @override
  State<CategoriesCheckList> createState() => _CategoriesCheckListState();
}

class _CategoriesCheckListState extends State<CategoriesCheckList> {
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

                if (widget.dataList[i]['key'] == 'EKONOMI') {
                  _selectedList.addAll(
                    [
                      'GENEL',
                      'MAKRO_VERILER',
                      'DIS_EKONOMI',
                    ],
                  );
                }
                if (widget.dataList[i]['key'] == 'SIYASI') {
                  _selectedList.add(
                    'GELISMEKTE_OLAN_ULKELER',
                  );
                }
                if (widget.dataList[i]['key'] == 'EMTIA') {
                  _selectedList.addAll([
                    'ENERJI',
                    'METAL' 'FX',
                  ]);
                }
              } else {
                _selectedList.remove(
                  widget.dataList[i]['key'],
                );

                if (widget.dataList[i]['key'] == 'Ekonomi') {
                  _selectedList.removeAll([
                    'GENEL',
                    'MAKRO_VERILER',
                    'DIS_EKONOMI',
                  ]);
                }
                if (widget.dataList[i]['key'] == 'SIYASI') {
                  _selectedList.remove('GELISMEKTE_OLAN_ULKELER');
                }
                if (widget.dataList[i]['key'] == 'EMTIA') {
                  _selectedList.removeAll([
                    'ENERJI',
                    'METAL',
                    'FX',
                  ]);
                }
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
