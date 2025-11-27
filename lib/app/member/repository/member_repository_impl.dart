import 'package:piapiri_v2/app/member/repository/member_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class MemberRepositoryImpl extends MemberRepository {
  @override
  Future<ApiResponse> createMember({
    String fullName = '',
    String gsm = '',
    String email = '',
    bool? kvkk = false,
    bool? etk = false,
    String? otp = '',
  }) async {
    return getIt<PPApi>().memberService.createMember(
          fullName: fullName,
          gsm: gsm,
          email: email,
          kvkk: kvkk,
          etk: etk,
          otp: otp,
        );
  }

  @override
  Future<ApiResponse> memberRequestOtp({
    String gsm = '',
  }) async {
    return getIt<PPApi>().memberService.memberRequestOtp(
          gsm: gsm,
        );
  }

  @override
  Future<ApiResponse> memberInfo({
    String gsm = '',
    String? otp = '',
  }) async {
    return getIt<PPApi>().memberService.memberInfo(
          gsm: gsm,
          otp: otp,
        );
  }

  @override
  Future<ApiResponse> memberDelete({
    String gsm = '',
  }) async {
    return getIt<PPApi>().memberService.memberDelete(
          gsm: gsm,
        );
  }
}
