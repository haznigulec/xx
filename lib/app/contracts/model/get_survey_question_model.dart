class GetSurveyQuestionModel {
  String? description;
  List<Question>? questions;
  List<GetSurveyQuestionModel>? subgroup;

  GetSurveyQuestionModel({
    this.description,
    this.questions,
    this.subgroup,
  });

  factory GetSurveyQuestionModel.fromJson(Map<String, dynamic> json) {
    var subGroupJson = json['subGroup'];

    return GetSurveyQuestionModel(
      description: json['description'],
      questions: List<Question>.from(
        json['questions'].map(
          (x) => Question.fromJson(x),
        ),
      ),
      subgroup: (subGroupJson != null && subGroupJson.isNotEmpty)
          ? List<GetSurveyQuestionModel>.from(
              subGroupJson.map(
                (x) => GetSurveyQuestionModel.fromJson(x),
              ),
            )
          : [GetSurveyQuestionModel(subgroup: [])],
    );
  }
}

class Question {
  String? questionId;
  String? question;
  int? sequence;
  int? page;
  String? testTypeCode;
  String? answerType;
  List<AnswerOption>? answerOptions;

  Question({
    this.questionId,
    this.question,
    this.sequence,
    this.page,
    this.testTypeCode,
    this.answerType,
    this.answerOptions,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        questionId: json['questionId'],
        question: json['question'],
        sequence: json['sequence'],
        page: json['page'],
        testTypeCode: json['testTypeCode'],
        answerType: json['answerType'],
        answerOptions: List<AnswerOption>.from(
          json['answerOptions'].map(
            (x) => AnswerOption.fromJson(x),
          ),
        ),
      );
}

class AnswerOption {
  String? answerOptionCode;
  String? answerCode;
  String? description;
  String? enumCode;

  AnswerOption({
    this.answerOptionCode,
    this.answerCode,
    this.description,
    this.enumCode,
  });

  factory AnswerOption.fromJson(Map<String, dynamic> json) => AnswerOption(
        answerOptionCode: json['answerOptionCode'],
        answerCode: json['answerCode'],
        description: json['description'],
        enumCode: json['enumCode'],
      );
}
