import 'package:piapiri_v2/common/widgets/list/selection_list_item.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class CategoryFilterWidget extends StatefulWidget {
  final bool showAnalysis;
  final bool showReports;
  final bool showPodcasts;
  final bool showVideoComments;
  final Function(bool) onChangedAnalysis;
  final Function(bool) onChangedReports;
  final Function(bool) onChangedPodcasts;
  final Function(bool) onChangedVideoComments;
  const CategoryFilterWidget({
    super.key,
    required this.onChangedAnalysis,
    required this.onChangedReports,
    required this.onChangedPodcasts,
    required this.onChangedVideoComments,
    required this.showAnalysis,
    required this.showReports,
    required this.showPodcasts,
    required this.showVideoComments,
  });

  @override
  State<CategoryFilterWidget> createState() => _CategoryFilterWidgetState();
}

class _CategoryFilterWidgetState extends State<CategoryFilterWidget> {
  late bool _showAnalysis;
  late bool _showReports;
  late bool _showPodcasts;
  late bool _showVideoComments;

  @override
  void initState() {
    _showAnalysis = widget.showAnalysis;
    _showReports = widget.showReports;
    _showPodcasts = widget.showPodcasts;
    _showVideoComments = widget.showVideoComments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PCheckboxListItem(
          title: L10n.tr('reports_video_podcast_analysis'),
          value: _showAnalysis,
          leadingWidth: 0,
          leadingWidgetSize: const Size(25, 25),
          onChanged: (bool? newVal) => setState(() {
            _showAnalysis = newVal!;
            widget.onChangedAnalysis(_showAnalysis);
          }),
        ),
        PCheckboxListItem(
          title: L10n.tr('reports_video_podcast_reports'),
          value: _showReports,
          leadingWidth: 0,
          leadingWidgetSize: const Size(25, 25),
          onChanged: (bool? newVal) => setState(() {
            _showReports = newVal!;
            widget.onChangedReports(_showReports);
          }),
        ),
        PCheckboxListItem(
          title: L10n.tr('reports_video_podcast_podcasts'),
          value: _showPodcasts,
          leadingWidth: 0,
          leadingWidgetSize: const Size(25, 25),
          onChanged: (bool? newVal) => setState(() {
            _showPodcasts = newVal!;
            widget.onChangedPodcasts(_showPodcasts);
          }),
        ),
        PCheckboxListItem(
          title: L10n.tr('reports_video_podcasts_video_comments'),
          value: _showVideoComments,
          leadingWidth: 0,
          leadingWidgetSize: const Size(25, 25),
          onChanged: (bool? newVal) => setState(() {
            _showVideoComments = newVal!;
            widget.onChangedVideoComments(_showVideoComments);
          }),
        ),
      ],
    );
  }
}
