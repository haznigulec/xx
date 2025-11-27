import 'package:piapiri_v2/common/widgets/chip/chip.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_state.dart';
import 'package:piapiri_v2/app/us_equity/pages/us_listing_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/sort_enum.dart';
import 'package:piapiri_v2/core/model/us_market_movers_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class UsMovers extends StatefulWidget {
  const UsMovers({super.key});

  @override
  State<UsMovers> createState() => _UsMoversState();
}

class _UsMoversState extends State<UsMovers> {
  final UsEquityBloc _usEquityBloc = getIt<UsEquityBloc>();
  final ScrollController _chipScrollController = ScrollController();
  UsMarketMovers _selectedMarketMover = UsMarketMovers.gainers;

  @override
  void dispose() {
    _chipScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: Grid.m,
            right: Grid.m,
            top: Grid.m,
          ),
          child: Text(
            L10n.tr('highlights'),
            style: context.pAppStyle.interMediumBase.copyWith(
              fontSize: Grid.m + Grid.xxs,
            ),
          ),
        ),
        const SizedBox(
          height: Grid.s,
        ),
        Container(
          height: Grid.l + Grid.m,
          alignment: Alignment.center,
          child: ListView.builder(
            controller: _chipScrollController,
            scrollDirection: Axis.horizontal,
            itemCount: UsMarketMovers.values.length,
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            itemBuilder: (context, index) {
              UsMarketMovers marketMover = UsMarketMovers.values[index];
              return Row(
                children: [
                  PChoiceChip(
                    label: L10n.tr(marketMover.localizationKey),
                    selected: _selectedMarketMover == marketMover,
                    chipSize: ChipSize.medium,
                    enabled: true,
                    onSelected: (_) {
                      setState(() {
                        _selectedMarketMover = marketMover;
                      });
                      // Scroll to selected chip
                      _chipScrollController.animateTo(
                        index * 100.0, // yaklaşık genişlik
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                  const SizedBox(width: Grid.xs),
                ],
              );
            },
          ),
        ),
        const SizedBox(
          height: Grid.s,
        ),
        PBlocBuilder<UsEquityBloc, UsEquityState>(
            bloc: _usEquityBloc,
            builder: (context, state) {
              return USListingWidget(
                key: ValueKey('USMOVERS_${_selectedMarketMover.value}_${state.gainers}_${state.losers}'),
                usMarketMovers: _selectedMarketMover,
                limit: 5,
                hasTopDivider: false,
              );
            }),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Grid.m,
          ),
          child: PCustomOutlinedButtonWithIcon(
            text: L10n.tr(
              _selectedMarketMover.localizationShowAllKey,
            ),
            iconSource: ImagesPath.arrow_up_right,
            buttonType: PCustomOutlinedButtonTypes.mediumSecondary,
            onPressed: () {
              router.push(
                UsListingRoute(
                  title: L10n.tr(_selectedMarketMover.localizationListingTitleKey),
                  usMarketMovers: _selectedMarketMover,
                  sortenum: _selectedMarketMover == UsMarketMovers.gainers ? SortEnum.descending : SortEnum.ascending,
                  ignoreUnsubscribeSymbols: [
                    ...(_selectedMarketMover == UsMarketMovers.gainers
                            ? getIt<UsEquityBloc>().state.gainers
                            : getIt<UsEquityBloc>().state.losers)
                        .map((e) => e.symbol!)
                        .take(5),
                    ...getIt<UsEquityBloc>().state.favoriteIncomingDividends,
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
