class SetSurveyAnswersModel {
  int? score;
  String? riskLevel;
  List<SuitableRisk>? suitableRisks;

  SetSurveyAnswersModel({
    this.score,
    this.riskLevel,
    this.suitableRisks,
  });

  factory SetSurveyAnswersModel.fromJson(Map<String, dynamic> json) => SetSurveyAnswersModel(
        score: json['score'],
        riskLevel: json['riskLevel'],
        suitableRisks: List<SuitableRisk>.from(
          json['suitableRisks'].map((x) => SuitableRisk.fromJson(x)),
        ),
      );
}

class SuitableRisk {
  int? id;
  int? riskLevel;
  String? riskName;
  String? description;

  SuitableRisk({
    this.id,
    this.riskLevel,
    this.riskName,
    this.description,
  });

  factory SuitableRisk.fromJson(Map<String, dynamic> json) => SuitableRisk(
        id: json['id'],
        riskLevel: json['riskLevel'],
        riskName: json['riskName'],
        description: json['description'],
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'riskLevel': riskLevel,
      'riskName': riskName,
      'description': description,
    };
  }
}

class SetAnswersModel {
  String testQuestionId;
  String answer;
  String? description;
  int page;

  SetAnswersModel({
    required this.testQuestionId,
    required this.answer,
    required this.page,
    this.description,
  });
  Map<String, dynamic> toJson() {
    return {
      'testQuestionId': testQuestionId,
      'answer': answer,
      'description': description,
    };
  }
}
