class GetCustomerAnswersModel {
  int? score;
  String? riskLevel;
  List<SuitableRisk>? suitableRisks;
  List<Answer>? answers;

  GetCustomerAnswersModel({
    this.score,
    this.riskLevel,
    this.suitableRisks,
    this.answers,
  });

  factory GetCustomerAnswersModel.fromJson(Map<String, dynamic> json) => GetCustomerAnswersModel(
        score: json['score'],
        riskLevel: json['riskLevel'],
        suitableRisks: List<SuitableRisk>.from(json['suitableRisks'].map((x) => SuitableRisk.fromJson(x))),
        answers: List<Answer>.from(json['answers'].map((x) => Answer.fromJson(x))),
      );
}

class Answer {
  int? testId;
  String? questionId;
  String? question;
  String? testTypeCode;
  String? answerOptionCode;
  String? description;
  String? answer;

  Answer({
    this.testId,
    this.questionId,
    this.question,
    this.testTypeCode,
    this.answerOptionCode,
    this.description,
    this.answer,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        testId: json['testId'],
        questionId: json['questionId'],
        question: json['question'],
        testTypeCode: json['testTypeCode'],
        answerOptionCode: json['answerOptionCode'],
        description: json['description'],
        answer: json['answer'],
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
}
