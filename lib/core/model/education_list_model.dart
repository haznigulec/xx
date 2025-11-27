class EducationListModel {
  int id;
  String? title;
  String? description;
  String? thumbnail;
  List<EducationVideo>? educationSubjects;

  EducationListModel({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.educationSubjects,
  });

  factory EducationListModel.fromJson(Map<String, dynamic> json) => EducationListModel(
        id: json['id'],
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        thumbnail: json['thumbnail'] ?? '',
        educationSubjects:
            List<EducationVideo>.from(json['educationSubjects'].map((x) => EducationVideo.fromJson(x))),
      );
}

class EducationVideo {
  int id;
  int educationId;
  String? title;
  String? videoFileName;
  String? fileNameGuid;
  String? thumbnail;
  String? videoStreamingPath;

  EducationVideo({
    required this.id,
    required this.educationId,
    required this.title,
    required this.videoFileName,
    required this.fileNameGuid,
    required this.thumbnail,
    required this.videoStreamingPath,
  });

  factory EducationVideo.fromJson(Map<String, dynamic> json) => EducationVideo(
        id: json['id'],
        educationId: json['educationId'],
        title: json['title'] ?? '',
        videoFileName: json['videoFileName'] ?? '',
        fileNameGuid: json['fileNameGuid'] ?? '',
        thumbnail: json['thumbnail'] ?? '',
        videoStreamingPath: json['videoStreamingPath'] ?? '',
      );
}
