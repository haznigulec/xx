class SectorModel {
  String groupName;
  List<String> sectors;

  SectorModel({
    required this.groupName,
    required this.sectors,
  });

  factory SectorModel.fromJson(Map<String, dynamic> json) {
    return SectorModel(
      groupName: json['groupName'] as String,
      sectors: List<String>.from(json['sectors'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupName': groupName,
      'sectors': sectors,
    };
  }
}
