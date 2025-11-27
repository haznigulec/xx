import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:piapiri_v2/app/brokerage_distribution/bloc/brokerage_event.dart';
import 'package:piapiri_v2/app/brokerage_distribution/bloc/brokerage_state.dart';
import 'package:piapiri_v2/app/brokerage_distribution/repository/brokerage_repository.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/brokerage_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class BrokerageBloc extends PBloc<BrokerageState> {
  final BrokerageRepository _brokerageRepository;

  BrokerageBloc({
    required BrokerageRepository brokerageRepository,
  })  : _brokerageRepository = brokerageRepository,
        super(
          initialState: const BrokerageState(),
        ) {
    on<BrokerageFetchEvent>(_onFetch);
  }

  FutureOr<void> _onFetch(
    BrokerageFetchEvent event,
    Emitter<BrokerageState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    String dateFilter = '';
    if (event.startDate != null && event.endDate != null) {
      dateFilter =
          '&start=${DateTimeUtils.serverDate(event.startDate!)}&end=${DateTimeUtils.serverDate(event.endDate!)}';
    }
    ApiResponse response = await _brokerageRepository.getBrokerageDistribution(
      symbol: event.symbol,
      top: event.top,
      dateFilter: dateFilter,
      url: getIt<MatriksBloc>().state.endpoints!.rest!.akd!.url ?? '',
    );
    if (response.success) {
      int topBuyers = 0;
      double topBuyersPercentage = 0;
      int topSellers = 0;
      double topSellersPercentage = 0;
      final BrokerageModel brokerageData = BrokerageModel.fromJson(response.data);
      for (var element in brokerageData.tops.ask) {
        topBuyers += element.netQuantity;
        topBuyersPercentage += element.netPercent;
      }
      for (var element in brokerageData.tops.bid) {
        topSellers += element.netQuantity;
        topSellersPercentage += element.netPercent;
      }
      List<MainBrokerageModel> topsBid = List.from(brokerageData.tops.bid);
      List<MainBrokerageModel> topsAsk = List.from(brokerageData.tops.ask);
      topsBid.add(
        MainBrokerageModel(
          agent: L10n.tr('others'),
          agentId: 0,
          swapRt: 0,
          netPercent: 100 - topSellersPercentage,
          cost: 0,
          netQuantity: brokerageData.sums.quantity - topSellers,
          totalQuantity: 0,
          volume: 0,
          quantity: 0,
        ),
      );
      topsAsk.add(
        MainBrokerageModel(
          agent: L10n.tr('others'),
          agentId: 0,
          swapRt: 0,
          netPercent: 100 - topBuyersPercentage,
          cost: 0,
          netQuantity: brokerageData.sums.quantity - topBuyers,
          totalQuantity: 0,
          volume: 0,
          quantity: 0,
        ),
      );
      TopBrokers tops = brokerageData.tops.copyWith(
        bid: topsBid,
        ask: topsAsk,
      );

      BrokerageModel data = brokerageData.copyWith(
        tops: tops,
      );

      emit(
        state.copyWith(
          type: PageState.success,
          data: data,
          topSellers: topSellers,
          topBuyers: topBuyers,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            message: L10n.tr('error'),
            errorCode: '06MBRK01',
          ),
        ),
      );
    }
  }
}
