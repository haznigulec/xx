import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/assets/model/us_capra_summary_model.dart';
import 'package:piapiri_v2/app/create_us_order/bloc/create_us_orders_event.dart';
import 'package:piapiri_v2/app/create_us_order/bloc/create_us_orders_state.dart';
import 'package:piapiri_v2/app/create_us_order/repository/create_us_orders_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class CreateUsOrdersBloc extends PBloc<CreateUsOrdersState> {
  final CreateUsOrdersRepository _createUsOrdersRepository;

  CreateUsOrdersBloc({required CreateUsOrdersRepository createUsOrdersRepository})
      : _createUsOrdersRepository = createUsOrdersRepository,
        super(initialState: const CreateUsOrdersState()) {
    on<GetTradeLimitEvent>(_onGetTradeLimit);
    on<CreateOrderEvent>(_onCreateOrder);
    on<DeleteOrderEvent>(_onDeleteOrder);
    on<GetPositionListEvent>(_onGetPositionList);
    on<GetComissionEvent>(_onGetComission);
  }

  FutureOr<void> _onGetTradeLimit(
    GetTradeLimitEvent event,
    Emitter<CreateUsOrdersState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse tradeLimit = await _createUsOrdersRepository.getTradeLimit();

    if (tradeLimit.success) {
      event.callback?.call(double.parse(tradeLimit.data['buying_power']));
      emit(
        state.copyWith(
          type: PageState.success,
          tradeLimit: double.parse(tradeLimit.data['buying_power']),
          cashLimit: double.parse(tradeLimit.data['cash']),
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(showErrorWidget: true, message: tradeLimit.error?.message ?? '', errorCode: '01GTRD12'),
        ),
      );
    }
  }

  FutureOr<void> _onCreateOrder(
    CreateOrderEvent event,
    Emitter<CreateUsOrdersState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _createUsOrdersRepository.createOrder(
      symbolName: event.symbolName,
      quantity: event.quantity,
      amount: event.amount,
      limitPrice: event.limitPrice,
      stopPrice: event.stopPrice,
      equityPrice: event.equityPrice,
      orderActionType: event.orderActionType,
      orderType: event.orderType,
      extendedHours: event.extendedHours,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      event.callback?.call(true, null);
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: false,
            message: 'american.create.order.${response.dioResponse?.data['errorCode']}',
            errorCode: '01GORD12',
          ),
        ),
      );
      event.callback?.call(false, 'american.create.order.${response.dioResponse?.data['errorCode']}');
    }
  }

  FutureOr<void> _onDeleteOrder(
    DeleteOrderEvent event,
    Emitter<CreateUsOrdersState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse response = await _createUsOrdersRepository.deleteUsOrder(
      id: event.id,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      event.callback?.call(true, null);
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: false,
            message: response.error?.message ?? '',
            errorCode: '01GORD13',
          ),
        ),
      );
      event.callback?.call(false, 'american.delete.order.${response.dioResponse?.data['errorCode']}');
    }
  }

  FutureOr<void> _onGetPositionList(
    GetPositionListEvent event,
    Emitter<CreateUsOrdersState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _createUsOrdersRepository.getPositionList();

    if (response.success) {
      List<UsOverallSubItem> positionList = [];

      Map<String, dynamic>? equityOverall = response.data['overallItemGroups'].firstWhere(
        (element) => element['instrumentCategory'] == 'equity',
        orElse: () => null,
      );

      if (equityOverall != null) {
        positionList =
            equityOverall['overallItems'].map<UsOverallSubItem>((e) => UsOverallSubItem.fromJson(e)).toList();
        positionList.sort((a, b) => a.symbol!.compareTo(b.symbol!));
      }
      emit(
        state.copyWith(
          type: PageState.success,
          positionList: positionList,
        ),
      );
      event.callback?.call(positionList);
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '01GPOS04',
          ),
        ),
      );
    }
  }

  // Komisyon bilgilerini Firebase remoteConfigden alır
  FutureOr<void> _onGetComission(
    GetComissionEvent event,
    Emitter<CreateUsOrdersState> emit,
  ) async {
    Map<String, dynamic> commissionJson = jsonDecode(remoteConfig.getString('commission'));
    //Minimum komisyon tutari
    double minCommission = commissionJson['min_commission'];
    //Komisyon tipi
    String commissionType = commissionJson['commission_type'];
    //Lot basi uygulanacak komisyon tutari
    double commssionPerUnit = commissionJson['commission_per_unit'];

    emit(
      state.copyWith(
        minCommission: minCommission,
        comissionType: commissionType,
        commissionPerUnit: commssionPerUnit,
      ),
    );
  }
}
