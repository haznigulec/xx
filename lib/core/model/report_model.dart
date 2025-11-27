import 'package:piapiri_v2/common/utils/date_time_utils.dart';

class ReportModel {
  final String title;
  final String description;
  final String date;
  final String file;
  final List<dynamic> symbols;
  final Map<String, dynamic>? institutionCodeSymbolMap;
  final String type;
  final int typeId;
  final String icon;
  final String dateTime;
  final String mainGroup;
  final String youtubeEmbedCode;

  const ReportModel({
    required this.title,
    required this.description,
    required this.date,
    required this.file,
    this.symbols = const [],
    this.institutionCodeSymbolMap,
    required this.type,
    required this.typeId,
    required this.icon,
    required this.dateTime,
    required this.mainGroup,
    required this.youtubeEmbedCode,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      file: json['file'] ?? '',
      symbols: json['symbols'] ?? [],
      institutionCodeSymbolMap: json['institutionCodeSymbolMap'],
      type: json['contentType'],
      typeId: json['contentTypeId'],
      icon: json['icon'] ?? '',
      dateTime: DateTimeUtils.parseMultiLangDate(json['dateTime'])?.toString() ?? '',
      mainGroup: json['mainGroup'] ?? '',
      youtubeEmbedCode: json['youtubeEmbedCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'file': file,
      'symbols': symbols,
      'institutionCodeSymbolMap': institutionCodeSymbolMap,
      'contentType': type,
      'contentTypeId': typeId,
      'icon': icon,
      'dateTime': dateTime,
      'mainGroup': mainGroup,
      'youtubeEmbedCode': youtubeEmbedCode,
    };
  }
}

class ReportFilterModel {
  final bool showAnalysis;
  final bool showReports;
  final bool showPodcasts;
  final bool showVideoComments;
  final bool youtubeVideo;
  final DateTime? startDate;
  final DateTime? endDate;

  const ReportFilterModel({
    this.showAnalysis = true,
    this.showReports = true,
    this.showPodcasts = true,
    this.showVideoComments = true,
    this.youtubeVideo = false,
    this.startDate,
    this.endDate,
  });

  ReportFilterModel copyWith({
    bool? showAnalysis,
    bool? showReports,
    bool? showPodcasts,
    bool? showVideoComments,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return ReportFilterModel(
      showAnalysis: showAnalysis ?? this.showAnalysis,
      showReports: showReports ?? this.showReports,
      showPodcasts: showPodcasts ?? this.showPodcasts,
      showVideoComments: showVideoComments ?? this.showVideoComments,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
