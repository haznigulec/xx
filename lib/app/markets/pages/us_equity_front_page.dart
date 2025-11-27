import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/markets/widgets/us_symbol_dividend_carousel_widget.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/app/us_equity/pages/us_movers.dart';
import 'package:piapiri_v2/app/us_equity/pages/us_sectors_widget.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

class UsEquityFrontPage extends StatefulWidget {
  const UsEquityFrontPage({super.key});

  @override
  State<UsEquityFrontPage> createState() => _UsEquityFrontPageState();
}

class _UsEquityFrontPageState extends State<UsEquityFrontPage> {
  final UsEquityBloc _usEquityBloc = getIt<UsEquityBloc>();
  final ScrollController _chipScrollController = ScrollController();

  @override
  initState() {
    super.initState();
    _usEquityBloc.add(
      GetLosersGainersEvent(),
    );

    if (_usEquityBloc.state.favoriteIncomingDividends.isEmpty) {
      _usEquityBloc.add(GetUsIncomingDividends(isFavorite: true));
    }

    if (_usEquityBloc.state.allIncomingDividends.isEmpty) {
      _usEquityBloc.add(GetUsIncomingDividends(isFavorite: false));
    }
  }

  @override
  void dispose() {
    _chipScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const UsMovers(),
          const SizedBox(
            height: Grid.l,
          ),
          const UsSectorsWidget(),
          const SizedBox(
            height: Grid.l,
          ),

          /// Yakında Temettü Dağıtacaklar
          BlocBuilder<UsEquityBloc, UsEquityState>(
            bloc: _usEquityBloc,
            builder: (context, state) {
              bool isLoading = state.favoriteIncomingDividendsState == PageState.loading ||
                  state.allIncomingDividendsState == PageState.loading;

              if (isLoading) {
                return const PLoading();
              }

              if (state.allIncomingDividends.isEmpty && state.favoriteIncomingDividends.isEmpty) {
                return const SizedBox.shrink();
              }

              return UsSymbolDividendCarouselWidget(
                title: L10n.tr('symbol_will_be_dist_divident'),
                symbolList: state.favoriteIncomingDividends.isNotEmpty == true
                    ? state.favoriteIncomingDividends
                    : state.allIncomingDividends,
              );
            },
          ),
        ],
      ),
    );
  }
}
