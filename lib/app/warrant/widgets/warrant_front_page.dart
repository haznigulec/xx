import 'package:piapiri_v2/common/widgets/chip/chip.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/data_grid/pages/bist_symbol_listing.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_bloc.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_event.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/specific_list_bist_type_enum.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/specific_list_widget.dart';
import 'package:piapiri_v2/app/warrant/bloc/warrant_bloc.dart';
import 'package:piapiri_v2/app/warrant/bloc/warrant_event.dart';
import 'package:piapiri_v2/app/warrant/widgets/warrant_list_tile.dart';
import 'package:piapiri_v2/app/warrant/widgets/warrant_market_makers_list.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_event.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_state.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/ranker_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class WarrantFrontPage extends StatefulWidget {
  const WarrantFrontPage({super.key});

  @override
  State<WarrantFrontPage> createState() => _WarrantFrontPageState();
}

class _WarrantFrontPageState extends State<WarrantFrontPage> with AutomaticKeepAliveClientMixin {
  final int _warrantListTileHeight = 73;
  String _subcribeKey = 'high';
  final SymbolBloc _symbolBloc = getIt<SymbolBloc>();
  final QuickPortfolioBloc _quickPortfolioBloc = getIt<QuickPortfolioBloc>();
  final WarrantBloc _warrantBloc = getIt<WarrantBloc>();

  @override
  bool get wantKeepAlive => true; // sayfa bellekte tutulur

  @override
  void initState() {
    _warrantBloc.add(
      InitEvent(),
    );

    _quickPortfolioBloc.add(
      GetSpecificListEvent(
        mainGroup: MarketTypeEnum.marketBist.value,
      ),
    );
    super.initState();
  }

  @override
  dispose() {
    _symbolBloc.add(
      SymbolUnsubcribeRankerListEvent(
        statsKey: _subcribeKey,
        rankerEnum: RankerEnum.warrant,
      ),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: Grid.m,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: Text(
              L10n.tr('warrants.promoted'),
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
            color: context.pColorScheme.transparent,
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: Grid.m,
              ),
              scrollDirection: Axis.horizontal,
              children: [
                PChoiceChip(
                  label: L10n.tr('warrants.high'),
                  selected: _subcribeKey == 'high',
                  chipSize: ChipSize.medium,
                  enabled: true,
                  onSelected: (_) => {
                    setState(() {
                      _subcribeKey = 'high';
                    }),
                  },
                ),
                const SizedBox(
                  width: Grid.xs,
                ),
                PChoiceChip(
                  label: L10n.tr('warrants.low'),
                  selected: _subcribeKey == 'low',
                  chipSize: ChipSize.medium,
                  enabled: true,
                  onSelected: (_) => {
                    setState(() {
                      _subcribeKey = 'low';
                    }),
                  },
                ),
                const SizedBox(
                  width: Grid.xs,
                ),
                PChoiceChip(
                  label: L10n.tr('warrants.volume'),
                  selected: _subcribeKey == 'volume',
                  chipSize: ChipSize.medium,
                  enabled: true,
                  onSelected: (_) => {
                    setState(() {
                      _subcribeKey = 'volume';
                    }),
                  },
                ),
                const SizedBox(
                  width: Grid.xs,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: Grid.s,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: PBlocBuilder<SymbolBloc, SymbolState>(
              bloc: _symbolBloc,
              buildWhen: (previous, current) =>
                  previous.warrantRankerList.length < 5 &&
                  current.warrantRankerList.length != previous.warrantRankerList.length,
              builder: (context, state) {
                int rankerListLength = state.warrantRankerList.length < 5 ? state.warrantRankerList.length : 5;
                return SizedBox(
                  height: rankerListLength == 0 ? 50 : 38 + _warrantListTileHeight * rankerListLength.toDouble(),
                  child: BistSymbolListing(
                    key: ValueKey('WARRANT_$_subcribeKey'),
                    listScrollPhysics: const NeverScrollableScrollPhysics(),
                    symbols: const [],
                    statsKey: _subcribeKey,
                    rankerListLength: rankerListLength,
                    showTopDivider: false,
                    sortEnabled: false,
                    rankerEnum: RankerEnum.warrant,
                    columns: [
                      L10n.tr('warrant'),
                      L10n.tr('last_change_maturity'),
                    ],
                    itemBuilder: (symbol, controller) => WarrantListTile(
                      key: ValueKey(symbol.symbolCode),
                      controller: controller,
                      symbol: symbol,
                      showRisk: true,
                      showSymbolIcon: true,
                      onTap: () => router.push(
                        SymbolDetailRoute(symbol: symbol),
                      ),
                      enableSwiping: false,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: Grid.s,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: Text(
              L10n.tr('warrant.show_all_symbols_message'),
              style: context.pAppStyle.labelReg14textSecondary,
            ),
          ),
          const SizedBox(
            height: Grid.s + Grid.xs,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: PCustomOutlinedButtonWithIcon(
              text: L10n.tr('warrant.show_all_symbols'),
              fillParentWidth: false,
              iconSource: ImagesPath.arrow_up_right,
              buttonType: PCustomOutlinedButtonTypes.mediumSecondary,
              onPressed: () => {
                router.push(WarrantRoute()),
              },
              iconAlignment: IconAlignment.end,
            ),
          ),
          const SizedBox(
            height: Grid.l,
          ),
          SpecificListWidget(
            tab: BistType.warrantBist.type,
            leftPadding: Grid.m,
            rightPadding: Grid.m,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Grid.m,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  L10n.tr('for_warrant_calculator'),
                  style: context.pAppStyle.labelReg14textSecondary,
                ),
                const SizedBox(
                  height: Grid.s + Grid.xs,
                ),
                PCustomOutlinedButtonWithIcon(
                  text: L10n.tr('warrant_calculator'),
                  iconSource: ImagesPath.arrow_up_right,
                  onPressed: () => {
                    router.push(
                      WarrantCalculateRoute(),
                    ),
                  },
                  buttonType: PCustomOutlinedButtonTypes.mediumSecondary,
                ),
              ],
            ),
          ),
          const WarrantMarketMakersList(),
        ],
      ),
    );
  }
}
