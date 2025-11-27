import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/education/widgets/education_video_tile.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/model/education_list_model.dart';

@RoutePage()
class EducationDetailPage extends StatefulWidget {
  final EducationListModel educationList;
  const EducationDetailPage({
    super.key,
    required this.educationList,
  });

  @override
  State<EducationDetailPage> createState() => _EducationDetailPageState();
}

class _EducationDetailPageState extends State<EducationDetailPage> {
  int? _selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: widget.educationList.title ?? '',
      ),
      body: ListView.separated(
        itemCount: widget.educationList.educationSubjects!.length,
        padding: const EdgeInsets.only(
          top: Grid.m,
          left: Grid.m,
          right: Grid.m,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => const PDivider(
            padding: EdgeInsets.symmetric(
              vertical: Grid.m,
          ),
        ),
        itemBuilder: (context, index) {
          EducationVideo educationSubject = widget.educationList.educationSubjects![index];
          return EducationVideoTile(
            educationSubject: educationSubject,
            isExpanded: _selectedIndex == index,
            onTapHeader: () {
              setState(() {
                _selectedIndex = _selectedIndex == index ? null : index;
              });
            },
          );
        },
      ),
    );
  }
}
