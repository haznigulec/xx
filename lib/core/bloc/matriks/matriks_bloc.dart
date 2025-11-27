import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_event.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_state.dart';
import 'package:piapiri_v2/core/config/matriks_info.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/warrant_calculation_model.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';

class MatriksBloc extends PBloc<MatriksState> {
  MatriksBloc() : super(initialState: const MatriksState()) {
    on<MatriksGetTopicsEvent>(_onGetTopics);
    on<MatriksGetDiscoEvent>(_onGetDisco);
    on<MatriksWarrantCalculatorEvent>(_onGetWarrantCalculator);
    on<MatriksWarrantCalculatorDetailsEvent>(_onGetWarrantCalculatorDetails);
    on<MatriksSetTokenEvent>(_onSetToken);
    on<ResetMatriksToken>(_onResetToken);
  }

  FutureOr<void> _onGetTopics(MatriksGetTopicsEvent event, Emitter<MatriksState> emit) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse topicsResponse = await getIt<PPApi>().matriksService.getTopics(
          state.endpoints!.rest!.topach!.url ?? '',
        );
    Map<String, dynamic> decodedTopics;
    if (topicsResponse.success) {
      try {
        decodedTopics = jsonDecode(topicsResponse.data);
      } catch (e) {
        decodedTopics = topicsResponse.data;
      }
      emit(
        state.copyWith(
          type: PageState.success,
          topics: decodedTopics,
        ),
      );
      event.callback?.call();
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: const PBlocError(
            message: 'error',
            errorCode: '06MTRX01',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetDisco(MatriksGetDiscoEvent event, Emitter<MatriksState> emit) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse discoveryResponse = await getIt<PPApi>().matriksService.getDiscovery();
    if (discoveryResponse.success) {
      MatriksInfo info = MatriksInfo.fromJson(discoveryResponse.data);
      emit(
        state.copyWith(
          type: PageState.success,
          endpoints: info,
        ),
      );
      event.callback();
    }
  }

  FutureOr<void> _onGetWarrantCalculator(
    MatriksWarrantCalculatorEvent event,
    Emitter<MatriksState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse calculateResponse = await getIt<PPApi>().matriksService.warrantCalculate(
          symbol: event.symbol,
        );
    if (calculateResponse.success) {
      WarrantCalculateModel warrantCalculate = WarrantCalculateModel.fromJson(
        calculateResponse.data,
      );
      emit(
        state.copyWith(
          type: PageState.success,
          warrantCalculate: warrantCalculate,
        ),
      );
      event.callback(warrantCalculate);
    } else {
      String errorMsg = calculateResponse.dioResponse?.data['error']['message'];
      Map<String, dynamic> errorMessage = jsonDecode(errorMsg);

      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            message: 'warrant.calculate.${errorMessage['error']['code'] ?? 'error'}',
            errorCode: '06MTRX02',
            showErrorWidget: true,
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetWarrantCalculatorDetails(
    MatriksWarrantCalculatorDetailsEvent event,
    Emitter<MatriksState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse calculateDetailsResponse = await getIt<PPApi>().matriksService.warrantCalculateDetails(
          symbol: event.symbol,
          underlyingValue: event.underlyingValue,
          volatility: event.volatility,
          interestRate: event.interestRate,
          referenceDate: event.referenceDate,
        );
    if (calculateDetailsResponse.success) {
      WarrantCalculateDetailsModel warrantCalculateDetails =
          WarrantCalculateDetailsModel.fromJson(calculateDetailsResponse.data);
      emit(
        state.copyWith(
          type: PageState.success,
          warrantCalculateDetails: warrantCalculateDetails,
        ),
      );
      event.callback(warrantCalculateDetails);
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: const PBlocError(
            message: 'error',
            errorCode: '06MTRX03',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onSetToken(MatriksSetTokenEvent event, Emitter<MatriksState> emit) {
    emit(
      state.copyWith(
        token: event.token ?? '',
        tokenTime: event.tokenTime ?? 0,
      ),
    );
    getIt<LocalStorage>().write('MatriksToken', state.token);
    getIt<LocalStorage>().write('MatriksTokenTime', state.tokenTime);
  }

  FutureOr<void> _onResetToken(ResetMatriksToken event, Emitter<MatriksState> emit) {
    emit(
      state.copyWith(
        token: '',
        tokenTime: 0,
      ),
    );
    getIt<LocalStorage>().delete('MatriksToken');
    getIt<LocalStorage>().delete('MatriksTokenTime');
  }
}
