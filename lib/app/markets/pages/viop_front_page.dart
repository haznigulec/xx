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
import 'package:piapiri_v2/app/viop/bloc/viop_bloc.dart';
import 'package:piapiri_v2/app/viop/bloc/viop_event.dart';
import 'package:piapiri_v2/app/viop/bloc/viop_state.dart';
import 'package:piapiri_v2/app/viop/widgets/viop_list_tile.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/sectors_widget.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_state.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/ranker_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ViopFrontPage extends StatefulWidget {
  const ViopFrontPage({super.key});

  @override
  State<ViopFrontPage> createState() => _ViopFrontPageState();
}

class _ViopFrontPageState extends State<ViopFrontPage> with AutomaticKeepAliveClientMixin {
  final int _viopListTileHeight = 73;
  final SymbolBloc _symbolBloc = getIt<SymbolBloc>();
  final QuickPortfolioBloc _quickPortfolioBloc = getIt<QuickPortfolioBloc>();
  final ViopBloc _viopBloc = getIt<ViopBloc>();
  String _subcribeKey = 'high';

  @override
  bool get wantKeepAlive => true; // sayfa bellekte tutulur

  @override
  void initState() {
    _viopBloc.add(
      GetViopListsEvent(),
    );
    _quickPortfolioBloc.add(
      GetSpecificListEvent(
        mainGroup: MarketTypeEnum.marketBist.value,
      ),
    );
    super.initState();
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
              L10n.tr('viop.promoted'),
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
                  label: L10n.tr('viop.high'),
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
                  label: L10n.tr('viop.low'),
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
                  label: L10n.tr('viop.volume'),
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
                  previous.viopRankerList.length < 5 && current.viopRankerList.length != previous.viopRankerList.length,
              builder: (context, state) {
                int rankerListLength = state.viopRankerList.length < 5 ? state.viopRankerList.length : 5;
                return SizedBox(
                  height: rankerListLength == 0 ? 50 : 38 + _viopListTileHeight * rankerListLength.toDouble(),
                  child: BistSymbolListing(
                    key: UniqueKey(),
                    listScrollPhysics: const NeverScrollableScrollPhysics(),
                    symbols: const [],
                    statsKey: _subcribeKey,
                    rankerListLength: rankerListLength,
                    showTopDivider: false,
                    sortEnabled: false,
                    rankerEnum: RankerEnum.future,
                    columns: [
                      L10n.tr('viop'),
                      L10n.tr('last_change_maturity'),
                    ],
                    itemBuilder: (symbol, controller) => ViopListTile(
                      key: ValueKey(symbol.symbolCode),
                      controller: controller,
                      symbol: symbol,
                      showSymbolIcon: true,
                      onTap: () => router.push(
                        SymbolDetailRoute(
                          symbol: symbol,
                        ),
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
              L10n.tr('viop.show_all_symbols_message'),
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
              text: L10n.tr('viop.show_all_symbols'),
              iconSource: ImagesPath.arrow_up_right,
              buttonType: PCustomOutlinedButtonTypes.mediumSecondary,
              onPressed: () => {
                router.push(
                  ViopRoute(),
                ),
              },
            ),
          ),
          const SizedBox(
            height: Grid.m,
          ),
          SpecificListWidget(
            tab: BistType.viopBist.type,
            leftPadding: Grid.m,
            rightPadding: Grid.m,
          ),
          PBlocBuilder<ViopBloc, ViopState>(
            bloc: _viopBloc,
            builder: (context, state) {
              return SectorsWidget(
                title: L10n.tr('viop_lists'),
                sectors: state.subMarketList.map(
                  (e) {
                    return {
                      'name': L10n.tr(e),
                      'code': e,
                    };
                  },
                ).toList(),
                onPressed: (name, key) => router.push(
                  ViopRoute(
                    subMarketCode: key,
                  ),
                ),
                leftPadding: Grid.m,
                rightPadding: Grid.m,
              );
            },
          ),
          const SizedBox(
            height: Grid.l,
          ),
        ],
      ),
    );
  }
}
