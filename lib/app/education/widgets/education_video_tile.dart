import 'dart:convert';

import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/education/widgets/education_video_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/p_expandable_panel.dart';

import '../../../core/model/education_list_model.dart';

class EducationVideoTile extends StatefulWidget {
  final EducationVideo educationSubject;
  final bool isExpanded;
  final Function() onTapHeader;
  const EducationVideoTile({
    super.key,
    required this.educationSubject,
    required this.isExpanded,
    required this.onTapHeader,
  });

  @override
  State<EducationVideoTile> createState() => _EducationVideoTileState();
}

class _EducationVideoTileState extends State<EducationVideoTile> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return PExpandablePanel(
      initialExpanded: widget.isExpanded,
      isExpandedChanged: (_) => widget.onTapHeader(),
      titleBuilder: (_) => _headerWidget(),
      child: widget.isExpanded
          ? EducationVideoWidget(
              videoUrl: widget.educationSubject.videoStreamingPath ?? '',
              isVideoExpanded: widget.isExpanded,
            )
          : const SizedBox.shrink(),
    );
  }

  _headerWidget() {
    return SizedBox(
      height: 48,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(
              Grid.s,
            ),
            child: Image.memory(
              base64.decode(widget.educationSubject.thumbnail!),
              scale: 1,
              height: 48,
              width: 78,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: Grid.s,
          ),
          Text(
            widget.educationSubject.title ?? '',
            style: context.pAppStyle.labelReg16textPrimary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.isExpanded ? context.pColorScheme.primary : context.pColorScheme.secondary,
            ),
            child: AnimatedRotation(
              turns: widget.isExpanded ? 0.25 : 0,
              duration: const Duration(milliseconds: 200),
              child: SvgPicture.asset(
                ImagesPath.player,
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(
                  widget.isExpanded ? context.pColorScheme.lightHigh : context.pColorScheme.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
