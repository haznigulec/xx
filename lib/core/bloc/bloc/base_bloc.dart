import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
// import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';

abstract class PBloc<S extends PState> extends Bloc<PEvent, S> {
  PBloc({
    required S initialState,
  }) : super(initialState) {
    /// In case of emergency, uncomment the following line
    // Bloc.observer = TalkerBlocObserver(talker: talker);
    on<ReloadLastEvent>((_, __) {
      if (_lastHandledEvent == null) {
        throw Exception('cannot add [ReloadLastEvent] as first event!');
      }

      emitEvent(_lastHandledEvent!);
    });
    on<ResetError>(_onResetError);
  }

  late PEvent? _lastHandledEvent;

  void onPEvent<E extends PEvent>(
    EventHandler<E, S> handler, {
    EventTransformer<E>? transformer,
  }) {
    on<E>(
      (event, emit) async {
        try {
          if (event is! ReloadLastEvent) {
            _lastHandledEvent = event;
          }
          await handler(event, emit);
        } catch (e, stackTrace) {
          talker.critical(
            'Unhandled error caught in the $runtimeType!',
            'MethodName: ${event.runtimeType.toString()},\nClassName: $runtimeType \nError: $e',
            stackTrace,
          );
          emit(
            state.copyWith(
              type: PageState.failed,
              error: PBlocError(message: e.toString(), errorCode: ''),
            ) as S,
          );
        }
      },
      transformer: transformer,
    );
  }

  void Function(PEvent) get emitEvent => add;

  FutureOr<void> _onResetError(ResetError event, Emitter emit) {
    emit(
      state.copyWith(
        type: PageState.initial,
        error: const PBlocError(
          message: '',
          showErrorWidget: false,
          errorCode: '',
        ),
      ) as S,
    );
  }
}
