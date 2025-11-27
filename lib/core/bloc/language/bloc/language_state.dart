import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';

class LanguageState extends PState {
  final String languageCode;
  final String countryCode;
  final Map<String, dynamic> keys;

  const LanguageState({
    super.type = PageState.initial,
    super.error,
    this.languageCode = 'tr',
    this.countryCode = 'TR',
    this.keys = const {},
  });

  @override
  LanguageState copyWith({
    PageState? type,
    PBlocError? error,
    String? languageCode,
    String? countryCode,
    Map<String, dynamic>? keys,
  }) {
    return LanguageState(
      type: type ?? this.type,
      error: error ?? this.error,
      languageCode: languageCode ?? this.languageCode,
      countryCode: countryCode ?? this.countryCode,
      keys: keys ?? this.keys,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        languageCode,
        countryCode,
        keys,
      ];
}
