import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/currency_buy_sell/bloc/currency_buy_sell_event.dart';
import 'package:piapiri_v2/app/currency_buy_sell/bloc/currency_buy_sell_state.dart';
import 'package:piapiri_v2/app/currency_buy_sell/model/currency_ratios_model.dart';
import 'package:piapiri_v2/app/currency_buy_sell/model/system_paremeters_model.dart';
import 'package:piapiri_v2/app/currency_buy_sell/repository/currency_buy_sell_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class CurrencyBuySellBloc extends PBloc<CurrencyBuySellState> {
  final CurrencyBuySellRepository _currencyBuySellRepository;

  CurrencyBuySellBloc({
    required CurrencyBuySellRepository currencyBuySellRepository,
  })  : _currencyBuySellRepository = currencyBuySellRepository,
        super(initialState: const CurrencyBuySellState()) {
    on<GetCurrencyRatiosEvent>(_getCurrencyRatios);
    on<GetTradeLimitTLEvent>(_onGetTradeLimitTL);
    on<GetSystemParametersEvent>(_onGetSystemParameters);
    on<GetInstantCashAmountEvent>(_getInstantCashAmount);
    on<FcBuySellEvent>(_onBuySell);
  }

  FutureOr<void> _getCurrencyRatios(
    GetCurrencyRatiosEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _currencyBuySellRepository.getCurrencyRatios(
      currency: event.currency,
    );

    if (response.success) {
      List<CurrenyRatios> currencyRatioList = response.data['result']
          .map<CurrenyRatios>(
            (element) => CurrenyRatios.fromJson(element),
          )
          .toList();

      emit(
        state.copyWith(
          type: PageState.success,
          currencyRatioList: currencyRatioList,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '01CURR001',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetTradeLimitTL(
    GetTradeLimitTLEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _currencyBuySellRepository.getTradeLimit(
      accountId: event.accountId,
      typeName: event.typeName,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
          tlTradeLimit: response.data['tradeLimit'],
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '01CURR002',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetSystemParameters(
    GetSystemParametersEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _currencyBuySellRepository.getSystemParameters();

    if (response.success) {
      SystemParametersModel systemParametersModel = SystemParametersModel.fromJson(
        response.data,
      );

      emit(
        state.copyWith(
          type: PageState.success,
          systemParametersModel: systemParametersModel,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: L10n.tr(response.error?.message ?? ''),
            errorCode: '01CURR003',
          ),
        ),
      );
    }
  }

  FutureOr<void> _getInstantCashAmount(
    GetInstantCashAmountEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _currencyBuySellRepository.getInstantCashAmount(
      accountId: event.accountId,
      finInstName: event.finInstName,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
          tradeLimitByCurrency: double.parse(
            response.data['amount'].toString(),
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: L10n.tr('us_balance.${response.error?.message ?? ''}'),
            errorCode: '01CURR004',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onBuySell(
    FcBuySellEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _currencyBuySellRepository.fcBuySell(
      debitCredit: event.debitCredit,
      tlAccountId: event.tlAccountId,
      accountId: event.accountId,
      finInstName: event.finInstName,
      amount: event.amount,
      exchangeRate: event.exchangeRate,
    );

    if (response.success) {
      event.onSuccess?.call();
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: L10n.tr(
              'us_balance.${response.error?.message ?? ''}',
            ),
            errorCode: '01CURR005',
          ),
        ),
      );
    }
  }
}
