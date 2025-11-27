import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/assets/model/us_capra_summary_model.dart';
import 'package:piapiri_v2/app/profit/bloc/profit_event.dart';
import 'package:piapiri_v2/app/profit/bloc/profit_state.dart';
import 'package:piapiri_v2/app/profit/model/customer_target_model.dart';
import 'package:piapiri_v2/app/profit/model/potential_profit_loss_model.dart';
import 'package:piapiri_v2/app/profit/model/tax_detail_model.dart';
import 'package:piapiri_v2/app/profit/repository/profit_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/assets_model.dart';

class ProfitBloc extends PBloc<ProfitState> {
  final ProfitRepository _profitRepository;

  ProfitBloc({
    required ProfitRepository profitRepository,
  })  : _profitRepository = profitRepository,
        super(initialState: const ProfitState()) {
    on<GetProfitEvent>(_onGetProfit);
    on<GetCustomerTargetEvent>(_onGetCustomerTarget);
    on<SetCustomerTargetEvent>(_onSetCustomerTarget);
    on<GetOverallSummaryEvent>(_onGetOverallSummary);
    on<GetCapraPortfolioSummaryEvent>(_onGetCapraPortfolioSummary);
    on<ClearPotentialProfitLossModel>(_onClearPotentialProfitLossModel);
    on<ClearTaxDetail>(_onClearTaxDetail);
  }

  FutureOr<void> _onGetProfit(
    GetProfitEvent event,
    Emitter<ProfitState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
        profitStartDate: event.profitStartDate,
        profitEndDate: event.profitEndDate,
      ),
    );

    List<ApiResponse> responses = await Future.wait(
      [
        _profitRepository.getTaxDetailWithModel(
          fromDate: event.profitStartDate.toString().split(' ')[0],
          toDate: event.profitEndDate.toString().split(' ')[0],
        ),
        getIt<PPApi>().assetsService.getAccountOverallWithsummary(
              allAccount: true,
              getInstant: true,
              isConsolidated: true,
              includeCashFlow: true,
              includeCreditDetail: true,
              includeSummary: true,
              calculateTradeLimit: true,
              accountId: '',
            ),
      ],
    );

    if (responses.every((element) => element.success)) {
      TaxDetailModel? taxDetailModel = TaxDetailModel.fromJson(
        responses[0].data,
      );

      dynamic response = responses[1].data;

      List<Map<String, dynamic>> overallItemGroups = List.from(response['overallItemGroups']);

      for (Map<String, dynamic> itemGroup in overallItemGroups) {
        if (itemGroup['instrumentCategory'] == 'fund') {
          List<dynamic> overalItems = itemGroup['overallItems'];

          for (var element in overalItems) {
            element['underlying'] = await _profitRepository.getFundFounderCode(
              code: element['financialInstrumentCode'],
            );
          }
        } else if (itemGroup['instrumentCategory'] != 'equity' &&
            itemGroup['instrumentCategory'] != 'currency' &&
            itemGroup['instrumentCategory'] != 'cash' &&
            itemGroup['instrumentCategory'] != 'viop_collateral') {
          for (Map<String, dynamic> item in itemGroup['overallItems']) {
            String code = item['symbol'].split(' ')[0];
            if (itemGroup['instrumentCategory'] == 'warrant') {
              code = '${code}V';
            }
            num multiplier = 1;

            if (itemGroup['instrumentCategory'] == 'viop' &&
                itemGroup['overallItems'] != null &&
                itemGroup['overallItems'].isNotEmpty) {
              double total = 0;

              for (var element in itemGroup['overallItems']) {
                total = total + element['price'] * element['qty'] * multiplier;
              }
              itemGroup['totalAmount'] = total;
            }
          }
        }
      }

      PotentialProfitLossModel? potentialProfitLossModel = PotentialProfitLossModel.fromJson(
        response,
      );

      emit(
        state.copyWith(
          type: PageState.success,
          taxDetailModel: taxDetailModel,
          potentialProfitLossModel: potentialProfitLossModel,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: responses.firstWhere((element) => !element.success).error?.message ?? '',
            errorCode: '01PORT01',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onClearPotentialProfitLossModel(
    ClearPotentialProfitLossModel event,
    Emitter<ProfitState> emit,
  ) {
    emit(
      state.copyWith(
        potentialProfitLossModel: null,
      ),
    );
  }

  FutureOr<void> _onClearTaxDetail(
    ClearTaxDetail event,
    Emitter<ProfitState> emit,
  ) {
    emit(
      state.copyWith(
        taxDetailModel: null,
      ),
    );
  }

  FutureOr<void> _onGetCustomerTarget(
    GetCustomerTargetEvent event,
    Emitter<ProfitState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          type: PageState.loading,
        ),
      );

      final ApiResponse response = await _profitRepository.getCustomerTarget();

      if (response.success) {
        CustomerTargetModel? customerTargetModel;
        if (response.data['customerTargetModel'] != null) {
          customerTargetModel = CustomerTargetModel.fromJson(
            response.data['customerTargetModel'],
          );
        }
        emit(
          state.copyWith(
            type: PageState.success,
            customerTarget: customerTargetModel,
          ),
        );
      } else {
        emit(
          state.copyWith(
            type: PageState.failed,
            error: PBlocError(
              showErrorWidget: true,
              message: response.error?.message ?? '',
              errorCode: '01PORT02',
            ),
          ),
        );
      }
    } catch (e, s) {
      talker.critical(
        e.toString(),
        s.toString(),
      );
    }
  }

  FutureOr<void> _onSetCustomerTarget(
    SetCustomerTargetEvent event,
    Emitter<ProfitState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          type: PageState.loading,
        ),
      );

      final ApiResponse response = await _profitRepository.setCustomerTarget(
        target: event.target,
        targetDate: event.targetDate,
      );

      if (response.success) {
        emit(
          state.copyWith(
            type: PageState.success,
          ),
        );
        event.onSuccess?.call();
      } else {
        emit(
          state.copyWith(
            type: PageState.failed,
            error: PBlocError(
              showErrorWidget: true,
              message: response.error?.message ?? '',
              errorCode: '01PORT03',
            ),
          ),
        );
      }
    } catch (e, s) {
      talker.critical(
        e.toString(),
        s.toString(),
      );
    }
  }

  FutureOr<void> _onGetOverallSummary(
    GetOverallSummaryEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        consolidateAssetState: PageState.loading,
      ),
    );

    final ApiResponse response = await _profitRepository.getAccountOverallWithsummary(
      accountId: event.accountId.isNotEmpty ? event.accountId : '',
      isConsolidated: event.isConsolidated,
      allAccount: event.allAccounts,
      getInstant: event.getInstant,
      overallDate: event.overallDate,
      includeCashFlow: event.includeCashFlow,
      includeCreditDetail: event.includeCreditDetail,
      calculateTradeLimit: event.calculateTradeLimit,
    );

    if (response.success) {
      List<Map<String, dynamic>> overallItemGroups = List.from(response.data['overallItemGroups']);

      for (Map<String, dynamic> itemGroup in overallItemGroups) {
        if (itemGroup['instrumentCategory'] == 'fund') {
          List<dynamic> overalItems = itemGroup['overallItems'];

          for (var element in overalItems) {
            element['underlying'] = await _profitRepository.getFundFounderCode(
              code: element['financialInstrumentCode'],
            );
          }
        } else if (itemGroup['instrumentCategory'] != 'equity' &&
            itemGroup['instrumentCategory'] != 'currency' &&
            itemGroup['instrumentCategory'] != 'cash' &&
            itemGroup['instrumentCategory'] != 'viop_collateral') {
          for (Map<String, dynamic> item in itemGroup['overallItems']) {
            String code = item['symbol'].split(' ')[0];
            if (itemGroup['instrumentCategory'] == 'warrant') {
              code = '${code}V';
            }
            num multiplier = 1;

            if (itemGroup['instrumentCategory'] == 'viop' &&
                itemGroup['overallItems'] != null &&
                itemGroup['overallItems'].isNotEmpty) {
              double total = 0;

              for (var element in itemGroup['overallItems']) {
                total = total + element['price'] * element['qty'] * multiplier;
              }
              itemGroup['totalAmount'] = total;
            }
          }
        }
      }
      response.data['overallItemGroups'] = overallItemGroups;
      AssetModel myAssets = AssetModel.fromJson(response.data);
      event.callback?.call(myAssets);

      emit(
        state.copyWith(
          consolidateAssetState: PageState.success,
          consolidatedAssets: myAssets,
        ),
      );
    } else {
      emit(
        state.copyWith(
          consolidateAssetState: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '01PORT04',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetCapraPortfolioSummary(
    GetCapraPortfolioSummaryEvent event,
    Emitter<ProfitState> emit,
  ) async {
    emit(
      state.copyWith(
        usPortfolioState: PageState.loading,
      ),
    );

    final ApiResponse response = await _profitRepository.getCapraPortfolioSummary();

    if (response.success) {
      UsCapraSummaryModel portfolioSummaryModel = UsCapraSummaryModel.fromJson(response.data);

      emit(
        state.copyWith(
          usPortfolioState: PageState.success,
          portfolioSummaryModel: portfolioSummaryModel,
        ),
      );

      event.onFecthed?.call();
    } else {
      emit(
        state.copyWith(
          usPortfolioState: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '01PORT05',
          ),
        ),
      );
    }
  }
}
