import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';

abstract class LanguageEvent extends PEvent {}

class LanguageSetEvent extends LanguageEvent {
  final String languageCode;

  LanguageSetEvent({
    required this.languageCode,
  });
}

class LanguageGetKeysEvent extends LanguageEvent {
  final Function() onSuccess;

  LanguageGetKeysEvent({
    required this.onSuccess,
  });
}
