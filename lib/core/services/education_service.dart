import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class EducationService {
  final ApiClient api;

  EducationService(this.api);

  static const String _getAllEducationsUrl = '/education/getalleducations';
  static const String _addEducationSubjectReaction = '/education/addeducationsubjectreaction';
  static const String _removeEducationSubjectReaction = '/education/removeeducationsubjectreaction';
  static const String _getMyReactions = '/education/getmyreactions';

  Future<ApiResponse> getAllEducations() {
    return api.post(
      _getAllEducationsUrl,
      body: {
        'customerExtId': UserModel.instance.customerId,
      },
      tokenized: true,
    );
  }

  Future<ApiResponse> getMyReactions() {
    return api.post(
      _getMyReactions,
      body: {
        'customerExtId': UserModel.instance.customerId,
      },
      tokenized: true,
    );
  }

  Future<ApiResponse> educationAddReaction({
    required int subjectId,
    required bool isPositive,
  }) async {
    return api.post(
      _addEducationSubjectReaction,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'educationSubjectId': subjectId,
        'isPositive': isPositive,
      },
      tokenized: true,
    );
  }

  Future<ApiResponse> educationRemoveReaction({
    required int subjectId,
  }) async {
    return api.post(
      _removeEducationSubjectReaction,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'educationSubjectId': subjectId,
      },
      tokenized: true,
    );
  }
}
