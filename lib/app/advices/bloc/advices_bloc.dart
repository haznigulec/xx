import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:piapiri_v2/app/advices/bloc/advices_event.dart';
import 'package:piapiri_v2/app/advices/bloc/advices_state.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/advices/repository/advices_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/bloc/language/bloc/language_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/advice_history_model.dart';
import 'package:piapiri_v2/core/model/advice_model.dart';
import 'package:piapiri_v2/core/model/robo_signal_model.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class AdvicesBloc extends PBloc<AdvicesState> {
  final AdvicesRepository _advicesRepository;

  AdvicesBloc({
    required AdvicesRepository advicesRepository,
  })  : _advicesRepository = advicesRepository,
        super(initialState: const AdvicesState()) {
    on<GetAdvicesEvent>(_getAdvices);
    on<GetAdviceHistoryEvent>(_onGetAdviceHistory);
  }

  FutureOr<void> _getAdvices(
    GetAdvicesEvent event,
    Emitter<AdvicesState> emit,
  ) async {
    bool comeFromBistAnalysisPage =
        event.fetchRoboSignals && event.mainGroup == MarketTypeEnum.marketBist.value && event.symbolName == null;
    if (comeFromBistAnalysisPage &&
        state.adviceListFetchCustomerId == UserModel.instance.customerId &&
        state.adviceListFetchDate != null &&
        DateTime.now().difference(state.adviceListFetchDate!) < const Duration(minutes: 5)) {
      //Bist Analiz ekranı son güncellemeden 5 dakika geçtiyse güncellenecek
      return;
    }

    emit(
      state.copyWith(
        advicesState: PageState.loading,
      ),
    );

    ApiResponse adviceResponse = await _advicesRepository.getAdvices(
      mainGroup: event.mainGroup,
      languageCode: getIt<LanguageBloc>().state.languageCode,
    );

    if (adviceResponse.success) {
      List<AdviceModel> adviceList =
          adviceResponse.data['mobileAdviceList'].map<AdviceModel>((element) => AdviceModel.fromJson(element)).toList();

      List<AdviceModel> newAdviceList = adviceList;

      if (event.fetchRoboSignals) {
        ApiResponse roboSignalResponse = await _advicesRepository.getRoboSignals();

        if (roboSignalResponse.success) {
          List<RoboSignalModel> roboSignals =
              roboSignalResponse.data['roboSignals'].map<RoboSignalModel>((e) => RoboSignalModel.fromJson(e)).toList();

          for (var element in roboSignals) {
            newAdviceList.add(
              AdviceModel(
                symbolName: '',
                adviceType: '',
                adviceSide: '',
                targetPrice: 0,
                created: '',
                adviceSideId: 0,
                adviceTypeId: 0,
                openingPrice: 0,
                isRoboSignal: true,
                code: element.code,
                date: element.date,
                close: element.close,
                indicators: element.indicators,
              ),
            );
          }
        }
      }

      if (event.symbolName != null) {
        emit(
          state.copyWith(
            advicesState: PageState.success,
            adviceBySymbolNameList: newAdviceList
                .where(
                  (element) => element.symbolName == event.symbolName,
                )
                .toList(),
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          advicesState: PageState.success,
          adviceList: newAdviceList,
          adviceListFetchDate: comeFromBistAnalysisPage ? DateTime.now() : state.adviceListFetchDate,
          adviceListFetchCustomerId:
              comeFromBistAnalysisPage ? UserModel.instance.customerId : state.adviceListFetchCustomerId,
        ),
      );
    } else {
      emit(
        state.copyWith(
          advicesState: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: adviceResponse.error?.message ?? '',
            errorCode: '01ADV001',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetAdviceHistory(
    GetAdviceHistoryEvent event,
    Emitter<AdvicesState> emit,
  ) async {
    emit(
      state.copyWith(
        advicesState: PageState.loading,
      ),
    );

    ApiResponse response = await _advicesRepository.getAdvicesHistory(
      mainGroup: event.mainGroup,
      year: event.year,
    );

    if (response.success) {
      AdviceHistoryModel adviceHistoryModel = AdviceHistoryModel.fromJson(response.data);

      if (event.symbolName != null) {
        emit(
          state.copyWith(
            adviceHistoryModel: adviceHistoryModel.copyWith(
              closedAdvices: (adviceHistoryModel.closedAdvices ?? [])
                  .where((element) => element.symbolName == event.symbolName)
                  .toList(),
            ),
            advicesState: PageState.success,
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          adviceHistoryModel: adviceHistoryModel,
          advicesState: PageState.success,
        ),
      );
    } else {
      emit(
        state.copyWith(
          advicesState: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '01ADV002',
          ),
        ),
      );
    }
  }
}
