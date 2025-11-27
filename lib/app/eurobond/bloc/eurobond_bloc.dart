import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:piapiri_v2/app/eurobond/bloc/eurobond_event.dart';
import 'package:piapiri_v2/app/eurobond/bloc/eurobond_state.dart';
import 'package:piapiri_v2/app/eurobond/model/eurobond_list_model.dart';
import 'package:piapiri_v2/app/eurobond/model/eurobond_validate_order_model.dart';
import 'package:piapiri_v2/app/eurobond/repository/eurobond_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/assets_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class EuroBondBloc extends PBloc<EuroBondState> {
  final EurobondRepository _eurobondRepository;

  EuroBondBloc({required EurobondRepository eurobondRepository})
      : _eurobondRepository = eurobondRepository,
        super(initialState: const EuroBondState()) {
    on<GetBondListEvent>(_onGetBondList);
    on<GetBondsAssetsEvent>(_onGetBondAssets);
    on<ValidateOrderEvent>(_onValidateOrder);
    on<AddOrderEvent>(_onAddOrder);
    on<DeleteOrderEvent>(_onDeleteOrder);
    on<GetBondLimitEvent>(_onGetBondLimit);
    on<GetDescriptionEvent>(_onGetBondDescription);
    on<GetTradeLimitEvent>(_onGetTradeLimitFlow);
  }

  FutureOr<void> _onGetBondList(
    GetBondListEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    final ApiResponse response = await _eurobondRepository.getBondList(
      finInstId: event.finInstId,
    );

    if (response.success) {
      EuroBondListModel bondListModel = EuroBondListModel.fromJson(response.data);
      event.onSuccess?.call(bondListModel);
      emit(
        state.copyWith(
          type: PageState.success,
          bondListModel: bondListModel,
        ),
      );
      return;
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02EURB01',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetBondAssets(
    GetBondsAssetsEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    final ApiResponse response = await _eurobondRepository.getBondAssets(
      accountId: event.accountId,
    );

    if (response.success) {
      Map<String, dynamic> data =
          response.data['overallItemGroups'].firstWhere((element) => element['instrumentCategory'] == 'sgmk');

      List<OverallSubItemModel> overallSubItemModels = List<OverallSubItemModel>.from(
        data['overallItems'].map(
          (x) => OverallSubItemModel.fromJson(x),
        ),
      );
      OverallSubItemModel? eurobondAssets =
          overallSubItemModels.firstWhereOrNull((element) => element.financialInstrumentId == event.finInstId);
      event.onSuccess?.call(eurobondAssets);
      emit(
        state.copyWith(
          type: PageState.success,
          eurobondAssets: eurobondAssets,
        ),
      );
      return;
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02EURB01',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onValidateOrder(
    ValidateOrderEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    final ApiResponse response = await _eurobondRepository.validateOrder(
      accountId: event.accountId,
      finInstId: event.finInstId,
      side: event.side,
      amount: event.amount,
    );

    if (response.success) {
      EuroBondValidateOrderModel validateOrderModel = EuroBondValidateOrderModel.fromJson(response.data);

      emit(
        state.copyWith(
          type: PageState.success,
          validateOrderModel: validateOrderModel,
        ),
      );
      event.onSuccess?.call(validateOrderModel);
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: false,
            message: 'EUROBOND_ERROR_CODE_${response.error?.message}',
            errorCode: response.error?.message ?? '02EURB02',
          ),
        ),
      );
      event.onError?.call('EUROBOND_ERROR_CODE_${response.error?.message}');
    }
  }

  FutureOr<void> _onAddOrder(
    AddOrderEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    final ApiResponse response = await _eurobondRepository.addOrder(
      accountId: event.accountId,
      finInstName: event.finInstName,
      side: event.side,
      amount: event.amount,
      rate: event.rate,
      nominal: event.nominal,
      unitPrice: event.unitPrice,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      event.onSuccess?.call(response.data.toString());
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: false,
            message: 'EUROBOND_ERROR_CODE_${response.error?.message}',
            errorCode: response.error?.message ?? 'eruobond_add_order_error',
          ),
        ),
      );
      event.onError?.call('EUROBOND_ERROR_CODE_${response.error?.message}');
    }
  }

  FutureOr<void> _onDeleteOrder(
    DeleteOrderEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    final ApiResponse response = await _eurobondRepository.deleteOrder(
      accountId: event.accountId,
      transactionId: event.transactionId,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      event.completedCallBack?.call(true, L10n.tr('EmirOk'));
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: event.completedCallBack == null,
            message: response.error?.message ?? '',
            errorCode: '02EURB03',
          ),
        ),
      );
      event.completedCallBack?.call(
        false,
        L10n.tr(response.error?.message ?? ''),
      );
    }
  }

  FutureOr<void> _onGetBondLimit(
    GetBondLimitEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        tradeLimitType: PageState.loading,
      ),
    );

    final ApiResponse response = await _eurobondRepository.getBondLimit(
      accountId: event.accountId.split('-').last,
      finInstName: event.finInstName,
      side: event.side,
    );

    if (response.success) {
      emit(
        state.copyWith(
          tradeLimitType: PageState.success,
          transactionLimit: response.data['amount'] ?? 0,
        ),
      );
    } else {
      emit(
        state.copyWith(
          tradeLimitType: PageState.failed,
          error: PBlocError(
            showErrorWidget: false,
            message: response.error?.message ?? '',
            errorCode: '02EURB04',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetBondDescription(
    GetDescriptionEvent event,
    Emitter<EuroBondState> emit,
  ) async {
    emit(
      state.copyWith(
        bondDescriptionType: PageState.loading,
      ),
    );

    final ApiResponse response = await _eurobondRepository.getBondDescription();

    if (response.success) {
      emit(
        state.copyWith(
          bondDescriptionType: PageState.success,
          bondDescription: response.data['description'] ?? '',
        ),
      );
    } else {
      emit(
        state.copyWith(
          bondDescriptionType: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02EURB05',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetTradeLimitFlow(
    GetTradeLimitEvent event,
    Emitter<EuroBondState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    final ApiResponse response = await _eurobondRepository.getTradeLimit();

    if (response.success) {
      event.callback?.call(response.data['cashFlowList'][2]['cashValue']);
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
    } else {
      emit(
        state.copyWith(
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02EURB05',
          ),
        ),
      );
    }
  }
}
