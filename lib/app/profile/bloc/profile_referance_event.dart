import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';

abstract class ProfileReferanceEvent extends PEvent {}

class GetReferanceCodeEvent extends ProfileReferanceEvent {
  GetReferanceCodeEvent();
}

class GetApplicationSettingsByKeyAndCustomerExtIdEvent extends ProfileReferanceEvent {
  final bool checkBudyReferanceCode;
  final String? budyReferanceCode;
  final Function()? onSuccessCallback;

  GetApplicationSettingsByKeyAndCustomerExtIdEvent({
    this.checkBudyReferanceCode = false,
    this.budyReferanceCode,
    this.onSuccessCallback,
  });
}

class ClearReferanceCodesEvent extends ProfileReferanceEvent {
  ClearReferanceCodesEvent();
}
