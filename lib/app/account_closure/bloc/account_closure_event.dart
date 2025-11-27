import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';

abstract class AccountClosureEvent extends PEvent {}

class ClosureEvent extends AccountClosureEvent {
  final String customerId;
  final Function() onSuccess;
  final Function() onFailed;

  ClosureEvent({
    required this.customerId,
    required this.onSuccess,
    required this.onFailed,
  });
}

class GetAccountClosureStatusEvent extends AccountClosureEvent {}

class SetAccountClosureStatus extends AccountClosureEvent {}
