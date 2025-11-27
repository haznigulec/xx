import 'package:flutter/material.dart';

@immutable
abstract class PEvent {
  const PEvent();
}

@immutable
class ReloadLastEvent extends PEvent {
  const ReloadLastEvent() : super();
}

@immutable
class ResetError extends PEvent {
  const ResetError() : super();
}
