import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';

class MemberService {
  final ApiClient api;

  MemberService(this.api);

  static const String _createMember = '/member/createmember';
  static const String _requestOtpMember = '/member/requestotp';
  static const String _memberInfo = '/member/getbymemberphone';
  static const String _deleteMember = '/member/deletemember';

  Future<ApiResponse> createMember({
    String fullName = '',
    String gsm = '',
    String email = '',
    bool? kvkk = false,
    bool? etk = false,
    String? otp = '',
  }) async {
    return api.post(
      _createMember,
      body: {
        'fullName': fullName,
        'phoneNumber': gsm.replaceAll(' ', ''),
        'email': email,
        'kvkk': kvkk,
        'etk': etk,
        'otp': otp,
      },
    );
  }

  Future<ApiResponse> memberRequestOtp({
    String gsm = '',
  }) async {
    return api.post(
      _requestOtpMember,
      body: {
        'phoneNumber': gsm.replaceAll(' ', ''),
      },
    );
  }

  Future<ApiResponse> memberInfo({
    String gsm = '',
    String? otp = '',
  }) async {
    return api.post(
      _memberInfo,
      body: {
        'phoneNumber': gsm.replaceAll(' ', ''),
      },
    );
  }

  Future<ApiResponse> memberDelete({
    String gsm = '',
  }) async {
    return api.post(
      _deleteMember,
      body: {
        'phoneNumber': gsm.replaceAll(' ', ''),
      },
    );
  }
}
