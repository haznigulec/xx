import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class MemberRepository {
  Future<ApiResponse> createMember({
    String fullName = '',
    String gsm = '',
    String email = '',
    bool? kvkk = false,
    bool? etk = false,
    String? otp = '',
  });

  Future<ApiResponse> memberRequestOtp({
    String gsm = '',
  });

  Future<ApiResponse> memberInfo({
    String gsm = '',
    String? otp = '',
  });

  Future<ApiResponse> memberDelete({
    String gsm = '',
  });
}
