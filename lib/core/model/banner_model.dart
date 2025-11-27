import 'dart:ui';

import 'package:piapiri_v2/core/extension/color_extension.dart';

class BannerModel {
  final int? id;
  final String guid;
  final String? title;
  final Color? backgroundColor;
  final String? headerText;
  final Color? headerTextColor;
  final String? destination;
  final bool? isActive;

  BannerModel({
    required this.id,
    required this.guid,
    required this.title,
    required this.backgroundColor,
    required this.headerText,
    required this.headerTextColor,
    required this.destination,
    required this.isActive,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      guid: json['guid'],
      title: json['title'],
      backgroundColor: json['backgroundColor'] != null ? HexColor.fromHex(json['backgroundColor'] ?? '') : null,
      headerText: json['headerText'],
      headerTextColor: json['headerTextColor'] != null ? HexColor.fromHex(json['headerTextColor'] ?? '') : null,
      destination: json['destination'],
      isActive: json['isActive'],
    );
  }
}
