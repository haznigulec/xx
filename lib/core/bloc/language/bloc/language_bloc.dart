import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/bloc/language/bloc/language_event.dart';
import 'package:piapiri_v2/core/bloc/language/bloc/language_state.dart';
import 'package:piapiri_v2/core/bloc/language/repository/language_repository.dart';

class LanguageBloc extends PBloc<LanguageState> {
  final LanguageRepository _languageRepository;
  LanguageBloc({required LanguageRepository languageRepository})
      : _languageRepository = languageRepository,
        super(initialState: const LanguageState()) {
    on<LanguageSetEvent>(_onSetLanguage);
    on<LanguageGetKeysEvent>(getKeys);
  }

  Future<void> _onSetLanguage(
    LanguageSetEvent event,
    Emitter<LanguageState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.updating,
      ),
    );
    Intl.defaultLocale = event.languageCode;
    emit(
      state.copyWith(
        type: PageState.updated,
        languageCode: event.languageCode,
        countryCode: event.languageCode == 'tr' ? 'TR' : 'US',
      ),
    );
  }

  Future<void> getKeys(
    LanguageGetKeysEvent event,
    Emitter<LanguageState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.updating,
      ),
    );
    ApiResponse response = await _languageRepository.getDictionary();
    if (response.success) {
      event.onSuccess();
      emit(
        state.copyWith(
          type: PageState.updated,
          keys: response.data,
        ),
      );
    }
  }
}
