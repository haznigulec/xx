import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/dividend/bloc/dividend_event.dart';
import 'package:piapiri_v2/app/dividend/bloc/dividend_state.dart';
import 'package:piapiri_v2/app/dividend/repository/dividend_repository.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/symbol_dividend_model.dart';

class DividendBloc extends PBloc<DividendState> {
  final DividendRepository _dividendRepository;

  DividendBloc({required DividendRepository dividendRepository})
      : _dividendRepository = dividendRepository,
        super(initialState: const DividendState()) {
    on<GetSymbolDividentEvent>(_onGetSymbolDividentEvent);
    on<GetSymbolDividentHistoryEvent>(_onGetSymbolDividentHistoryEvent);
    on<GetIncomingDividentEvent>(_onGetIncomingDividentEvent);
  }

  FutureOr<void> _onGetSymbolDividentEvent(
    GetSymbolDividentEvent event,
    Emitter<DividendState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
        symbolDividend: null,
      ),
    );
    var response = await _dividendRepository.getBySymbolName(symbolName: event.symbolName);
    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
          symbolDividend: SymbolDividendModel.fromJson(response.data),
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02DIVD01',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetSymbolDividentHistoryEvent(
    GetSymbolDividentHistoryEvent event,
    Emitter<DividendState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
        symbolDividendHistories: null,
      ),
    );
    var response = await _dividendRepository.getDividendHistoryBySymbolName(symbolName: event.symbolName);
    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
          symbolDividendHistories: response.data?['dividendHistoryList']
              .map<SymbolDividendModel>((element) => SymbolDividendModel.fromJson(element))
              ?.toList(),
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02DIVD02',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetIncomingDividentEvent(
    GetIncomingDividentEvent event,
    Emitter<DividendState> emit,
  ) async {
    emit(
      state.copyWith(
        incomingDividendsState: PageState.loading,
      ),
    );
    var response = await _dividendRepository.getAllDividends();
    if (response.success) {
      emit(
        state.copyWith(
          incomingDividendsState: PageState.success,
          incomingDividends:
              response.data?['symbolNames'].map<String>((element) => element.toString())?.toSet()?.toList(),
        ),
      );
    } else {
      emit(
        state.copyWith(
          incomingDividendsState: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02DIVD03',
          ),
        ),
      );
    }
  }
}
