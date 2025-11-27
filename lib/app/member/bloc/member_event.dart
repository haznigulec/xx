import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';

abstract class MemberEvent extends PEvent {
  final Function(String)? onError;

  const MemberEvent({
    this.onError,
  });
}

class CreateMemberEvent extends MemberEvent {
  final String fullName;
  final String gsm;
  final String? email;
  final bool kvkk;
  final bool etk;
  final String otp;
  final Function(ApiResponse) callback;

  const CreateMemberEvent({
    required this.fullName,
    required this.gsm,
    this.email,
    required this.kvkk,
    required this.etk,
    required this.otp,
    required this.callback,
  });
}

class MemberRequestOtpEvent extends MemberEvent {
  final String gsm;
  final Function(ApiResponse) onSuccess;

  const MemberRequestOtpEvent({
    required this.gsm,
    required this.onSuccess,
  });
}

class MemberInfoEvent extends MemberEvent {
  final String gsm;

  const MemberInfoEvent({
    required this.gsm,
  });
}

class DeleteMemberEvent extends MemberEvent {
  final String gsm;

  final Function(dynamic) onSuccess;

  const DeleteMemberEvent({
    required this.gsm,
    required this.onSuccess,
  });
}
