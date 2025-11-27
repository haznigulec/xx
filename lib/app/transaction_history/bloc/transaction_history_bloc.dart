import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/transaction_history/bloc/transaction_history_event.dart';
import 'package:piapiri_v2/app/transaction_history/bloc/transaction_history_state.dart';
import 'package:piapiri_v2/app/transaction_history/model/transaction_history_capra_model.dart';
import 'package:piapiri_v2/app/transaction_history/model/transaction_history_main_type_enum.dart';
import 'package:piapiri_v2/app/transaction_history/model/transaction_history_type_enum.dart';
import 'package:piapiri_v2/app/transaction_history/repository/transaction_history_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';

class TransactionHistoryBloc extends PBloc<TransactionHistoryState> {
  final TransactionHistoryRepository _transactionHistoryRepository;

  TransactionHistoryBloc({
    required TransactionHistoryRepository transactionHistoryRepository,
  })  : _transactionHistoryRepository = transactionHistoryRepository,
        super(initialState: const TransactionHistoryState()) {
    on<GetTransactionHistoryEvent>(_onGetTransactionHistory);
    on<SetTransactionHistoryFilter>(_onSetTransactionHistoryFilter);
    on<GetCapraTransactionHistoryEvent>(_onGetCapraTransactionHistory);
  }

  FutureOr<void> _onGetTransactionHistory(
    GetTransactionHistoryEvent event,
    Emitter<TransactionHistoryState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
        transactionFilterSide:
            state.transactionHistoryFilter.transactionType?.value ?? TransactionHistoryTypeEnum.all.value,
        transactionHistory: {},
      ),
    );

    final ApiResponse response = await _transactionHistoryRepository.getTransactionHistory(
      listType: state.transactionHistoryFilter.transactionMainType?.listType ?? TransactionMainTypeEnum.all.listType,
      side: state.transactionHistoryFilter.transactionType?.value ?? TransactionHistoryTypeEnum.all.value,
      startDate: state.transactionHistoryFilter.startDate?.formatToJson() ?? DateTime.now().formatToJson(),
      endDate: state.transactionHistoryFilter.endDate?.formatToJson() ?? DateTime.now().formatToJson(),
      finInstName: state.transactionHistoryFilter.finInstName ?? '',
      accountId: state.transactionHistoryFilter.account?.accountId.split('-')[1] ?? 'ALL',
    );

    if (response.success) {
      List<dynamic> dataList = [];

      List<String> responseList = [
        TransactionMainTypeEnum.equity.responseListType,
        TransactionMainTypeEnum.viop.responseListType,
        TransactionMainTypeEnum.fund.responseListType,
        TransactionMainTypeEnum.eurobond.responseListType,
        TransactionMainTypeEnum.cash.responseListType,
        TransactionMainTypeEnum.ipo.responseListType,
        if (state.transactionHistoryFilter.finInstName ==
            null) // Sembole göre filtreleme yapıldığında USD leri göstermemek için eklendi.
          TransactionMainTypeEnum.foreignCurrency.responseListType,
      ];

      for (var i = 0; i < responseList.length; i++) {
        if (response.data[responseList[i]] != null) {
          for (var element in response.data[responseList[i]]) {
            element['list_type'] = responseList[i].toString();
            if ((responseList[i] == TransactionMainTypeEnum.equity.responseListType) ||
                (responseList[i] == TransactionMainTypeEnum.viop.responseListType) ||
                (responseList[i] == TransactionMainTypeEnum.fund.responseListType) ||
                (responseList[i] == TransactionMainTypeEnum.eurobond.responseListType) ||
                (responseList[i] == TransactionMainTypeEnum.cash.responseListType) ||
                (responseList[i] == TransactionMainTypeEnum.ipo.responseListType) ||
                (responseList[i] == TransactionMainTypeEnum.foreignCurrency.responseListType)) {
              dataList.add(element);
            }
          }
        }
      }

      if (state.transactionHistoryFilter.transactionMainType == TransactionMainTypeEnum.equity) {
        dataList.sort((a, b) => b['valorDate'].compareTo(a['valorDate']));
      } else if (state.transactionHistoryFilter.transactionMainType == TransactionMainTypeEnum.fund) {
        dataList.sort((a, b) => b['valueDate'].compareTo(a['valueDate']));
      } else {
        dataList.sort((a, b) => b['orderDate'].compareTo(a['orderDate']));
      }

      Map<String, List<Map<String, dynamic>>> groupedDate = groupBy(
        List<Map<String, dynamic>>.from(dataList),
        (element) => DateTime.parse(
          element['equityGroupCode'] != null
              ? element['valorDate']
              : element['fundFullName'] != null
                  ? element['valueDate']
                  : element['orderDate'],
        ).toLocal().formatDayMonthYearDot(),
      );

      event.callback?.call(groupedDate);

      emit(
        state.copyWith(
          type: PageState.success,
          transactionHistory: groupedDate,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '01TRAN001',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onSetTransactionHistoryFilter(
    SetTransactionHistoryFilter event,
    Emitter<TransactionHistoryState> emit,
  ) async {
    emit(
      state.copyWith(
        transactionHistoryFilter: event.transactionHistoryFilter,
      ),
    );

    if (event.fetchTransactionHistory!) {
      add(
        GetTransactionHistoryEvent(),
      );
    }
  }

  FutureOr<void> _onGetCapraTransactionHistory(
    GetCapraTransactionHistoryEvent event,
    Emitter<TransactionHistoryState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _transactionHistoryRepository.getCapraTransactionHistory(
      side: event.side,
      symbol: event.symbol,
      until: event.until.isEmpty
          ? _formatToUtc(
              DateTime.now()
                  .copyWith(
                    hour: 23,
                    minute: 59,
                    second: 0,
                    millisecond: 0,
                  )
                  .toString(),
            )
          : event.until,
      after: event.after.isEmpty
          ? _formatToUtc(
              DateTime.now()
                  .copyWith(
                    hour: 0,
                    minute: 0,
                    second: 0,
                    millisecond: 0,
                  )
                  .toString(),
            )
          : event.after,
    );

    if (response.success) {
      List<TransactionHistoryCapraModel> accountActivitiesList = response.data['accountActivitiesList']
          .map<TransactionHistoryCapraModel>((element) => TransactionHistoryCapraModel.fromJson(element))
          .toList();

      accountActivitiesList.sort((a, b) {
        final dateA = _handleDateFormat(a.date!);
        final dateB = _handleDateFormat(b.date!);
        return dateA.compareTo(dateB);
      });

      Map<String, List<TransactionHistoryCapraModel>> groupedByDate =
          groupBy(accountActivitiesList.reversed.toList(), (element) {
        return DateFormat('dd.MM.yyyy').format(_handleDateFormat(element.date!));
      });

      Map<String, List<TransactionHistoryCapraModel>> groupedByDateGrouped =
          _calculateGroupedByOrderIdGrouped(groupedByDate);

      emit(
        state.copyWith(
          type: PageState.success,
          accountActivitiesList: accountActivitiesList,
          transactionCapraHistoryFilter: groupedByDate,
          transactionCapraHistoryGrouped: groupedByDateGrouped,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '01TRAN002',
          ),
        ),
      );
    }
  }

  Map<String, List<TransactionHistoryCapraModel>> _calculateGroupedByOrderIdGrouped(
      Map<String, List<TransactionHistoryCapraModel>> groupedByDate) {
    Map<String, List<TransactionHistoryCapraModel>> result = {};

    for (final entry in groupedByDate.entries) {
      final date = entry.key;
      final items = entry.value;

      // orderId'ye göre grupla
      final Map<String, List<TransactionHistoryCapraModel>> groupedByOrderId = {};
      for (final item in items) {
        final key = item.orderId ?? 'unique_${item.id}';
        if (!groupedByOrderId.containsKey(key)) {
          groupedByOrderId[key] = [];
        }
        groupedByOrderId[key]!.add(item);
      }

      // Her bir orderId grubunu işleyip tek TransactionHistoryCapraModel’e indir
      List<TransactionHistoryCapraModel> combinedList = [];

      for (final orderGroup in groupedByOrderId.entries) {
        final groupItems = orderGroup.value;
        if (groupItems.isEmpty) continue;

        final totalQtyPrice = groupItems.fold<double>(0.0, (sum, item) {
          final qty = double.tryParse(item.qty ?? '0') ?? 0.0;
          final price = double.tryParse(item.price ?? '0') ?? 0.0;
          return sum + (qty * price);
        });

        final first = groupItems.first;
        final leaves = double.tryParse(first.leavesQty ?? '0') ?? 0;
        final cum = double.tryParse(first.cumQty ?? '0') ?? 0;
        final totalQty = leaves + cum;

        combinedList.add(TransactionHistoryCapraModel(
          id: first.id,
          accountId: first.accountId,
          activityType: first.activityType,
          date: first.date,
          type: first.type,
          price: first.price,
          orderId: first.orderId,
          qty: first.qty,
          side: first.side,
          symbol: first.symbol,
          leavesQty: first.leavesQty,
          cumQty: first.cumQty,
          netAmount: first.netAmount,
          description: first.description,
          status: first.status,
          groupedPrice: groupItems.length > 1 // groupItems.length > 1  orderId'ye göre gruplanmışsa demek.
              ? totalQty != 0
                  ? (totalQtyPrice / totalQty).toStringAsFixed(2)
                  : '0'
              : null,
          groupedQty: groupItems.length > 1 ? totalQty.toString() : null,
        ));
      }

      // Eğer varsa bu tarihi result'a ekle
      if (combinedList.isNotEmpty) {
        result[date] = combinedList;
      }
    }

    return result;
  }

  DateTime _handleDateFormat(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }

    final formats = [
      'yyyy-MM-dd HH:mm:ss',
      'dd.MM.yyyy HH:mm:ss',
      'dd.MM.yyyy',
      'yyyy-MM-dd',
      'MM/dd/yyyy HH:mm:ss',
    ];

    for (final format in formats) {
      try {
        return DateFormat(format).parse(rawDate).toLocal();
      } catch (_) {
        continue;
      }
    }

    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  String _formatToUtc(String dateTime) {
    final DateTime date = DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS').parse(dateTime);
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(date);
  }
}
