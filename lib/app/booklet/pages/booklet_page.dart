import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/booklet/bloc/booklet_bloc.dart';
import 'package:piapiri_v2/app/booklet/bloc/booklet_event.dart';
import 'package:piapiri_v2/app/booklet/bloc/booklet_state.dart';
import 'package:piapiri_v2/app/booklet/widgets/booklet_row.dart';
import 'package:piapiri_v2/app/booklet/widgets/booklet_title.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/api/model/proto_model/booklet/booklet_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class BookletPage extends StatefulWidget {
  final MarketListModel symbol;
  const BookletPage({
    super.key,
    required this.symbol,
  });

  @override
  State<BookletPage> createState() => _BookletPageState();
}

class _BookletPageState extends State<BookletPage> {
  final BookletBloc _bookletBloc = getIt<BookletBloc>();

  @override
  void initState() {
    _bookletBloc.add(
      ConnectEvent(
        symbol: widget.symbol,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<BookletBloc, BookletState>(
      bloc: _bookletBloc,
      builder: (context, state) {
        if (state.isSuccess && (state.booklet == null || state.booklet!.bids.isEmpty)) {
          return Padding(
            padding: const EdgeInsets.only(top: 200),
            child: NoDataWidget(
              message: L10n.tr('no_data'),
            ),
          );
        }
        List<BookletModel> bids = [];
        List<BookletModel> asks = [];
        if (!(state.isLoading || state.isInitial)) {
          bids = state.booklet!.bids;
          asks = state.booklet!.asks;
        }
        return Shimmerize(
          enabled: state.isLoading || state.isInitial,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: Grid.s + Grid.xs,
              ),
              const BookletTitle(),
              const SizedBox(height: Grid.s + Grid.xs),
              const PDivider(),
              const SizedBox(height: Grid.s),
              ListView.builder(
                //key: Key('depth_list_$_selectedStageName'),
                shrinkWrap: true,
                itemCount: 10,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return _generateRowData(
                    index > bids.length - 1
                        ? BookletModel(orderID: 0, timestamp: 0, quantity: 0, price: 0)
                        : bids[index],
                    index > asks.length - 1
                        ? BookletModel(orderID: 0, timestamp: 0, quantity: 0, price: 0)
                        : asks[index],
                  );
                },
              ),
              _bookletSumRow(
                asks,
                bids,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _bookletSumRow(
    List<BookletModel> asks,
    List<BookletModel> bids,
  ) {
    double bidOrderQuantity = 0.0;
    double bidOrderTotal = 0.0;
    double askOrderQuantity = 0.0;
    double askOrderTotal = 0.0;

    for (var ask in asks) {
      askOrderQuantity += ask.quantity.toDouble();
      askOrderTotal += ask.price.toDouble() * ask.quantity.toDouble();
    }

    for (var bid in bids) {
      bidOrderQuantity += bid.quantity.toDouble();
      bidOrderTotal += bid.price.toDouble() * bid.quantity.toDouble();
    }

    Map<String, dynamic> data = {
      'alis_adet': bidOrderQuantity,
      'alis': bidOrderTotal / bidOrderQuantity,
      'satis': askOrderTotal / askOrderQuantity,
      'satis_adet': askOrderQuantity,
    };

    return BookletRow(
      data: data,
      isStats: true,
    );
  }

  Widget _generateRowData(BookletModel? bid, BookletModel? ask) {
    double bidQuantity = double.parse((bid?.quantity ?? 0).toString());
    DateTime bidTime = DateTime.fromMillisecondsSinceEpoch(
      bid?.timestamp != null ? bid!.timestamp.toInt() : 0,
    );
    double bidPrice = bid?.price ?? 0;

    double askQuantity = double.parse((ask?.quantity ?? 0).toString());
    DateTime askTime = DateTime.fromMillisecondsSinceEpoch(
      ask?.timestamp != null ? ask!.timestamp.toInt() : 0,
    );
    double askPrice = ask?.price ?? 0;

    Map<String, dynamic> data = {
      'alis_adet': bidQuantity,
      'alis_time': bidTime,
      'alis': bidPrice,
      'satis': askPrice,
      'satis_adet': askQuantity,
      'satis_time': askTime,
    };

    return BookletRow(
      data: data,
    );
  }
}
