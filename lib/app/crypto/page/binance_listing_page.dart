import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:piapiri_v2/app/crypto/bloc/crypto_bloc.dart';
import 'package:piapiri_v2/app/crypto/bloc/crypto_event.dart';
import 'package:piapiri_v2/app/crypto/bloc/crypto_state.dart';
import 'package:piapiri_v2/app/crypto/widgets/crypto_list_tile.dart';
import 'package:piapiri_v2/app/crypto/widgets/shimmer_crpyto_widget.dart';
import 'package:piapiri_v2/app/data_grid/pages/bist_symbol_listing.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/crypto_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class BinanceListingPage extends StatefulWidget {
  const BinanceListingPage({super.key});

  @override
  State<BinanceListingPage> createState() => _EmtiaPageState();
}

class _EmtiaPageState extends State<BinanceListingPage> {
  final CryptoBloc _cryptoBloc = getIt<CryptoBloc>();
  @override
  void initState() {
    _cryptoBloc.add(
      CryptoSetMarketEvent(
        selectedMarket: CryptoEnum.binance,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<CryptoBloc, CryptoState>(
      bloc: _cryptoBloc,
      builder: (context, state) {
        if (state.isLoading) {
          return const Shimmerize(
            enabled: true,
            child: ShimmerCryptoWidget(),
          );
        }

        return SlidableAutoCloseBehavior(
          child: Padding(
            padding: const EdgeInsets.only(
              top: Grid.s + Grid.xs,
            ),
            child: BistSymbolListing(
              key: ValueKey('BINANCE_${state.binanceSymbolList.map((e) => e.symbolCode).join('_')}'),
              listBottomPadding: const EdgeInsets.only(bottom: Grid.xl),
              showTopDivider: false,
              symbols: state.binanceSymbolList,
              outPadding: const EdgeInsets.symmetric(
                horizontal: Grid.m,
              ),
              columns: [
                L10n.tr('crypto'),
                L10n.tr('equity_column_difference'),
                L10n.tr('equity_column_last_price'),
              ],
              columnsSpacingIsEqual: true,
              itemBuilder: (symbol, controller) => CryptoListTile(
                key: ValueKey(symbol.symbolCode),
                controller: controller,
                symbol: symbol,
                marketEnum: CryptoEnum.binance,
                onTap: () => router.push(
                  SymbolDetailRoute(
                    symbol: symbol,
                    ignoreDispose: true,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
