import 'package:piapiri_v2/app/avatar/model/generate_avatar_model.dart';
import 'package:piapiri_v2/app/avatar/model/validate_avatar_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';

abstract class AvatarEvent extends PEvent {}

class GetAvatarAndLimitEvent extends AvatarEvent {
  final String refCode;
  final Function(LimitData)? callback;

  GetAvatarAndLimitEvent({
    this.refCode = '',
    this.callback,
  });
}

class UploadAvatarEvent extends AvatarEvent {
  final String image;
  final Function()? callback;

  UploadAvatarEvent({
    required this.image,
    this.callback,
  });
}

class GenerateAvatarEvent extends AvatarEvent {
  final String descriptionText;
  final Function(GenerateAvatarModel) callback;
  final Function()? errorCallback;

  GenerateAvatarEvent({
    required this.descriptionText,
    required this.callback,
    this.errorCallback,
  });
}

class SetAvatarEvent extends AvatarEvent {
  final String refCode;
  final Function(bool) callback;

  SetAvatarEvent({
    required this.refCode,
    required this.callback,
  });
}

class LogoutAvatarEvent extends AvatarEvent {}

