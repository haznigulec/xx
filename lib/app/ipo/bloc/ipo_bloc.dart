import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_event.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_state.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_active_info_model.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_blockage_model.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_customer_info_model.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_detail_model.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_model.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_status_enum.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_trade_limit_model.dart';
import 'package:piapiri_v2/app/ipo/repository/ipo_repository.dart';
import 'package:piapiri_v2/app/ipo/utils/ipo_constant.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class IpoBloc extends PBloc<IpoState> {
  final IpoRepository _ipoRepository;

  IpoBloc({
    required IpoRepository ipoRepository,
  })  : _ipoRepository = ipoRepository,
        super(initialState: const IpoState()) {
    on<GetActiveListEvent>(_onGetActiveIpoList);
    on<GetFutureListEvent>(_onGetFutureIpoList);
    on<GetPastListEvent>(_onGetPastIpoList);
    on<GetActiveDemandsEvent>(_onGetActiveIpoDemands);
    on<GetTradeLimitEvent>(_onGetTradeLimit);
    on<GetActiveInfoEvent>(_onGetActiveInfo);
    on<GetCustomerInfoEvent>(_onGetCustomerInfo);
    on<GetBlockageEvent>(_onGetBlockageList);
    on<DemandAddEvent>(_onIpoDemandAdd);
    on<DemandDeleteEvent>(_onIpoDemandDelete);
    on<DemandUpdateEvent>(_onIpoDemandUpdate);
    on<GetJustActiveInfoEvent>(_onGetJustActiveInfo);
    on<SetStateSuccessEvent>(_onSetSuccessState);
    on<GetIpoDetailsByIdEvent>(_onGetIpoDetailsById);
    on<IpoListResetPageNumber>(_onResetPageNumber);
    on<GetIpoDetailsForSearch>(_onGetIpoDetailsForSearch);
    on<GetCashBalanceEvent>(_onGetCashBalance);
    on<NewOrderHEEvent>(_onNewOrderHE);
    on<GetSymbolNameIsExistEvent>(_onGetSymbolNameIsExist);
  }

  FutureOr<void> _onGetIpoDetailsForSearch(
    GetIpoDetailsForSearch event,
    Emitter<IpoState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.fetching,
      ),
    );

    final ApiResponse response = await _ipoRepository.getIpoDetailsBySymbol(
      ipoSymbol: event.ipoSymbol,
      startIndex: event.pageNumber * IpoConstant.ipoPaginationListLength,
    );

    if (response.success) {
      List<IpoModel> ipoDetailsBySymbolList = response.data['ipos'].map<IpoModel>((e) => IpoModel.fromJson(e)).toList();

      emit(
        state.copyWith(
          type: PageState.fetched,
          ipoDetailsBySymbolListForSearch: ipoDetailsBySymbolList,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02IPO012',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetActiveIpoList(
    GetActiveListEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.fetching,
        currentIpoList: [],
      ),
    );

    final ApiResponse response = await _ipoRepository.getIpoList(
      startIndex: event.pageNumber * IpoConstant.ipoPaginationListLength,
      status: IpoStatusEnum.active.value,
    );

    if (response.success) {
      if (response.data['ipoList'] != null) {
        List<IpoModel> ipoList = response.data['ipoList'].map<IpoModel>((e) => IpoModel.fromJson(e)).toList();

        ipoList.sort((a, b) => a.endDate!.compareTo(b.endDate!));

        event.callback?.call();
        emit(
          state.copyWith(
            type: PageState.fetched,
            ipoList: ipoList,
            currentIpoList: ipoList,
            pageNumber: event.pageNumber,
          ),
        );
      } else {
        event.callback?.call();
        emit(
          state.copyWith(
            type: PageState.fetched,
            currentIpoList: [],
            futureIpoList: [],
            pastIpoList: [],
            pageNumber: event.pageNumber,
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02IPO001',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetFutureIpoList(
    GetFutureListEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.fetching,
      ),
    );

    final ApiResponse response = await _ipoRepository.getIpoList(
      startIndex: event.pageNumber * IpoConstant.ipoPaginationListLength,
      status: IpoStatusEnum.future.value,
    );

    if (response.success) {
      if (response.data['ipoList'] != null) {
        List<IpoModel> futureIpoList = [];
        futureIpoList = response.data['ipoList'].map<IpoModel>((e) => IpoModel.fromJson(e)).toList();

        if (futureIpoList.isNotEmpty) {
          futureIpoList.sort((a, b) => a.startDate!.compareTo(b.startDate!));
        }

        event.callback?.call();
        emit(
          state.copyWith(
            type: PageState.fetched,
            futureIpoList: futureIpoList,
            pageNumber: event.pageNumber,
          ),
        );
      } else {
        event.callback?.call();
        emit(
          state.copyWith(
            type: PageState.fetched,
            currentIpoList: [],
            futureIpoList: [],
            pastIpoList: [],
            pageNumber: event.pageNumber,
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02IPO001',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetPastIpoList(
    GetPastListEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.fetching,
      ),
    );

    final ApiResponse response = await _ipoRepository.getIpoList(
      startIndex: state.pageNumber * IpoConstant.ipoPaginationListLength,
      status: IpoStatusEnum.past.value,
    );

    if (response.success) {
      if (response.data['ipoList'] != null) {
        List<IpoModel> pastIpoList = response.data['ipoList'].map<IpoModel>((e) => IpoModel.fromJson(e)).toList();
        DateTime now = DateTime.now();
        Map<String, List<IpoModel>> ipoDateGroup = {
          'sixMonths': List.from(state.ipoDateGroup['sixMonths'] ?? []),
          'oneYear': List.from(state.ipoDateGroup['oneYear'] ?? []),
          'more': List.from(state.ipoDateGroup['more'] ?? []),
        };

        if (pastIpoList.isNotEmpty) {
          pastIpoList.sort((a, b) => b.startDate!.compareTo(a.startDate!));
        }

        for (var element in pastIpoList) {
          DateTime startDate = DateTime.parse(element.startDate!);
          int diffDays = now.difference(startDate).inDays;

          if (diffDays < 180) {
            if (!ipoDateGroup['sixMonths']!.contains(element)) {
              ipoDateGroup['sixMonths']?.add(element);
            }
          } else if (diffDays < 365) {
            if (!ipoDateGroup['oneYear']!.contains(element)) {
              ipoDateGroup['oneYear']?.add(element);
            }
          } else {
            if (!ipoDateGroup['more']!.contains(element)) {
              ipoDateGroup['more']?.add(element);
            }
          }
        }

        event.callback?.call();

        emit(
          state.copyWith(
            type: PageState.fetched,
            pastIpoList: [
              ...state.pastIpoList,
              ...pastIpoList,
            ],
            ipoDateGroup: ipoDateGroup,
            pageNumber: state.pageNumber + 1,
            hasMorePastIpo: pastIpoList.length == IpoConstant.ipoPaginationListLength,
          ),
        );
      } else {
        event.callback?.call();
        emit(
          state.copyWith(
            type: PageState.fetched,
            currentIpoList: [],
            futureIpoList: [],
            pastIpoList: [],
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02IPO001',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetTradeLimit(
    GetTradeLimitEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    final ApiResponse response = await _ipoRepository.getTradeLimit(
      customerId: event.customerId,
      accountId: event.accountId,
    );

    if (response.success) {
      IpoTradeLimitModel ipoTradeLimitModel = IpoTradeLimitModel.fromJson(response.data);

      emit(
        state.copyWith(
          type: PageState.success,
          ipoTradeLimitModel: ipoTradeLimitModel,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02IPO002',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetActiveInfo(
    GetActiveInfoEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    List<ApiResponse> responses = await Future.wait(
      [
        _ipoRepository.getActiveInfo(),
        _ipoRepository.getCustomerInfo(
          customerId: event.customerId,
          accountId: event.accountId,
        ),
        _ipoRepository.getTradeLimit(
          customerId: event.customerId,
          accountId: event.accountId,
        ),
      ],
    );

    if (responses.every((element) => element.success)) {
      IpoActiveInfoModel ipoActiveInfoModel = IpoActiveInfoModel.fromJson(responses[0].data);
      IpoCustomerInfoModel customerInfoModel = IpoCustomerInfoModel.fromJson(responses[1].data);
      IpoTradeLimitModel ipoTradeLimitModel = IpoTradeLimitModel.fromJson(responses[2].data);

      emit(
        state.copyWith(
          type: PageState.success,
          ipoActiveInfoModel: ipoActiveInfoModel,
          ipoCustomerInfoModel: customerInfoModel,
          ipoTradeLimitModel: ipoTradeLimitModel,
        ),
      );
      String deputyName = '';

      if (state.ipoCustomerInfoModel != null) {
        if (state.ipoCustomerInfoModel!.customerInfo != null && state.ipoCustomerInfoModel!.customerInfo!.isNotEmpty) {
          for (var element in state.ipoCustomerInfoModel!.customerInfo!) {
            deputyName = element.fullName ?? '';
          }
        }
      }

      event.callback(deputyName, ipoActiveInfoModel);
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: responses.firstWhere((element) => !element.success).error?.message ?? '',
            errorCode: '02IPO003',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetJustActiveInfo(
    GetJustActiveInfoEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _ipoRepository.getActiveInfo();

    if (response.success) {
      IpoActiveInfoModel ipoActiveInfoModel = IpoActiveInfoModel.fromJson(response.data);

      emit(
        state.copyWith(
          type: PageState.success,
          ipoActiveInfoModel: ipoActiveInfoModel,
        ),
      );

      event.callback(ipoActiveInfoModel);
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02IPO004',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetCustomerInfo(
    GetCustomerInfoEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    final ApiResponse response = await _ipoRepository.getCustomerInfo(
      customerId: event.customerId,
      accountId: event.accountId,
    );

    if (response.success) {
      IpoCustomerInfoModel customerInfoModel = IpoCustomerInfoModel.fromJson(response.data);

      emit(
        state.copyWith(
          type: PageState.success,
          ipoCustomerInfoModel: customerInfoModel,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02IPO005',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetBlockageList(
    GetBlockageEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    final ApiResponse response = await _ipoRepository.getBlockageList(
      customerId: event.customerId,
      accountId: event.accountId,
      ipoId: event.ipoId,
      paymentType: event.paymentType,
    );

    if (response.success) {
      IpoBlockageModel blockageModel = IpoBlockageModel.fromJson(response.data);

      event.isEmpty?.call(
        blockageModel.financialInstrument?.isEmpty == true,
      );

      emit(
        state.copyWith(
          type: PageState.success,
          ipoBlockageModel: blockageModel,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02IPO006',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onIpoDemandAdd(
    DemandAddEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    final ApiResponse response = await _ipoRepository.ipoDemandAdd(
      customerId: event.customerId,
      accountId: event.accountId,
      functionName: event.functionName,
      demandDate: event.demandDate,
      ipoId: event.ipoId,
      unitsDemanded: event.unitsDemanded,
      paymentType: event.paymentType,
      transactionType: event.transactionType,
      investorTypeId: event.investorTypeId,
      demandGatheringType: event.demandGatheringType,
      totalAmount: event.totalAmount,
      itemsToBlock: event.itemsToBlock,
      offerPrice: event.offerPrice,
      minUnits: event.minUnits,
      customFields: event.customFields,
    );

    if (response.success) {
      event.callback();

      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
    } else {
      String errorMessage = response.error?.message ?? '';
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message:
                L10n.tr(errorMessage.contains('Fiş tarihi iş günü') ? errorMessage : 'ipo.demand.add.$errorMessage'),
            errorCode: '02IPO007',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onIpoDemandDelete(
    DemandDeleteEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    final ApiResponse response = await _ipoRepository.ipoDemandDelete(
      customerId: event.customerId,
      accountId: event.accountId,
      functionName: event.functionName,
      ipoId: event.ipoId,
      demandDate: event.demandDate,
      demandId: event.demandId,
    );

    if (response.success) {
      event.callback();
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
            message: L10n.tr('ipo.demand.detail.${response.error?.message ?? ''}'),
            errorCode: '02IPO008',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onIpoDemandUpdate(
    DemandUpdateEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    String investorTypeId = _ipoRepository.readCustomerType();

    final ApiResponse response = await _ipoRepository.ipoDemandUpdate(
      customerId: event.customerId,
      accountId: event.accountId,
      functionName: event.functionName,
      demandDate: event.demandDate,
      ipoId: event.ipoId,
      demandId: event.demandId,
      unitsDemanded: event.unitsDemanded,
      investorTypeId: investorTypeId,
      offerPrice: event.offerPrice,
      checkLimit: event.checkLimit,
      demandGatheringType: event.demandGatheringType,
      demandType: event.demandType,
      paymentTypeId: event.paymentTypeId,
      itemsToBlock: event.itemsToBlock,
    );

    if (response.success) {
      event.callback();
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
            // message: Utils.tr('ipo.demand.update.${response.error?.message ?? ''}'),
            message: L10n.tr('ipo.demand.update.${response.error?.message ?? ''}'),
            errorCode: '02IPO009',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetActiveIpoDemands(
    GetActiveDemandsEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    final ApiResponse response = await _ipoRepository.getActiveIpoDemands();

    if (response.success) {
      List<IpoDemandModel> ipoDemandList =
          response.data['ipoList'].map<IpoDemandModel>((e) => IpoDemandModel.fromJson(e)).toList();

      if (response.data['ipoList'] != null) {
        emit(
          state.copyWith(
            type: PageState.success,
            ipoDemandList: ipoDemandList,
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02IPO010',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onSetSuccessState(SetStateSuccessEvent event, Emitter<IpoState> emit) {
    emit(
      state.copyWith(
        type: PageState.success,
      ),
    );
  }

  FutureOr<void> _onGetIpoDetailsById(
    GetIpoDetailsByIdEvent event,
    Emitter<IpoState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _ipoRepository.getIpoDetailsById(
      ipoId: event.ipoId,
    );

    if (response.success) {
      if (response.data['ipo'] != null) {
        IpoDetailModel ipoDetail = IpoDetailModel.fromJson(response.data['ipo']);
        IpoModel ipo = IpoModel.fromJson(response.data['ipo']);

        event.callback?.call(ipo);
        emit(
          state.copyWith(
            type: PageState.success,
            ipoDetailModel: ipoDetail,
          ),
        );
      }
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02IPO011',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onResetPageNumber(
    IpoListResetPageNumber event,
    Emitter<IpoState> emit,
  ) {
    emit(
      state.copyWith(
        pageNumber: 0,
        currentIpoList: [],
        futureIpoList: [],
        pastIpoList: [],
        ipoDetailsBySymbolListForSearch: [],
      ),
    );
  }

  FutureOr<void> _onGetCashBalance(
    GetCashBalanceEvent event,
    Emitter emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    final ApiResponse response = await _ipoRepository.getCashBalance(
      customerId: event.customerId,
      accountId: event.accountId,
      typeName: event.typeName,
    );

    if (response.success) {
      IpoTradeLimitModel ipoTradeLimitModel = IpoTradeLimitModel.fromJson(response.data);

      emit(
        state.copyWith(
          type: PageState.success,
          cashBalance: ipoTradeLimitModel.tradeLimit,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '02IPO002',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onNewOrderHE(
    NewOrderHEEvent event,
    Emitter<IpoState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    final ApiResponse response = await _ipoRepository.newOrderHE(
      symbolName: event.symbolName,
      quantity: event.quantity,
      orderActionType: event.orderActionType,
      orderType: event.orderType,
      price: event.price,
      orderValidity: event.orderValidity,
      account: event.account,
      orderCompletionType: event.orderCompletionType,
    );

    if (response.success) {
      event.callback();

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
            message: L10n.tr('ipo.demand.add.${response.error?.message ?? ''}'),
            errorCode: '02IPO007',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetSymbolNameIsExist(
    GetSymbolNameIsExistEvent event,
    Emitter<IpoState> emit,
  ) async {
    emit(
      state.copyWith(
        symbolName: null,
      ),
    );
    String? symbol = await _ipoRepository.getSymbolNameIfExists(
      symbolName: event.symbolName,
    );

    emit(
      state.copyWith(
        symbolName: symbol,
      ),
    );
  }
}
