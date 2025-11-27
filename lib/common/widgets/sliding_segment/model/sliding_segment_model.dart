import 'package:piapiri_v2/common/widgets/exchange_overlay/widgets/show_case_view.dart';
import 'package:flutter/material.dart';

class PSlidingSegmentModel {
  final String segmentTitle;
  final Color segmentColor;
  final ShowCaseViewModel? showCase;
  final String? imagePath;

  PSlidingSegmentModel({
    required this.segmentTitle,
    required this.segmentColor,
    this.showCase,
    this.imagePath,
  });
}
