import 'package:collection/collection.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_bloc.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/quick_portfolio_asset_model.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/robotic_and_fund_basket_model.dart';
import 'package:piapiri_v2/app/sectors/bloc/sectors_bloc.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/sector_model.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class SymbolSectors extends StatefulWidget {
  final MarketListModel symbol;
  const SymbolSectors({
    super.key,
    required this.symbol,
  });

  @override
  State<SymbolSectors> createState() => _SymbolSectorsState();
}

class _SymbolSectorsState extends State<SymbolSectors> {
  final SectorsBloc _sectorsBloc = getIt<SectorsBloc>();
  final QuickPortfolioBloc _quickPortfolioBloc = getIt<QuickPortfolioBloc>();
  SectorModel? _sectorModel;
  QuickPortfolioAssetModel? _modelPortfolio;
  final List<RoboticAndFundBasketModel> _roboticBaskets = [];
  @override
  initState() {
    // sembolun sektoru cekilir
    if (widget.symbol.sectorCode != null) {
      _sectorModel = _sectorsBloc.state.bistSectors.firstWhereOrNull(
        (element) => element.sectors.contains(
          widget.symbol.sectorCode,
        ),
      );
    }
    // sembolun model portfoyde olup olmadigi kontrol edilir
    _modelPortfolio = _quickPortfolioBloc.state.modelPortfolios.first.items
        .firstWhereOrNull((element) => element.code == widget.symbol.symbolCode);
    // sembolun robotik sepetlerde olup olmadigi kontrol edilir
    List<QuickPortfolioAssetModel> roboticItems = _quickPortfolioBloc.state.roboticPortfolios
        .where((element) => element.code == widget.symbol.symbolCode)
        .toList();
    for (var item in roboticItems) {
      RoboticAndFundBasketModel? basket = _quickPortfolioBloc.state.fundPortfolios['robotik_sepet']!
          .firstWhereOrNull((element) => element.id == item.portfolioId);
      if (basket != null) {
        _roboticBaskets.add(basket);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            L10n.tr('sectors'),
            style: context.pAppStyle.labelMed18textPrimary,
          ),
          const SizedBox(height: Grid.s + Grid.xs),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: Grid.xs,
            runSpacing: Grid.s,
            children: [
              // sembolun sektoru varsa
              if (_sectorModel != null)
                OutlinedButton(
                  style: context.pAppStyle.oulinedMediumPrimaryStyle,
                  onPressed: () {
                    router.push(
                      SectorsRoute(
                        sectorModel: _sectorModel!,
                        selectedFilterKeys: [widget.symbol.sectorCode!],
                        ignoreUnsubList: [widget.symbol.symbolCode],
                      ),
                    );
                  },
                  child: Text(
                    L10n.tr(
                      'bist.sector.${widget.symbol.sectorCode}',
                    ),
                  ),
                ),
              // sembol model portfoyde varsa
              if (_modelPortfolio != null)
                OutlinedButton(
                  style: context.pAppStyle.oulinedMediumPrimaryStyle,
                  onPressed: () {
                    router.push(
                      ModelPorfolioRoute(
                        portfolioKey: 'model_portfoy',
                        title: _quickPortfolioBloc.state.modelPortfolios.first.title,
                        description: _quickPortfolioBloc.state.modelPortfolios.first.detail,
                        ignoreUnsubList: [widget.symbol.symbolCode],
                      ),
                    );
                  },
                  child: Text(L10n.tr(_quickPortfolioBloc.state.modelPortfolios.first.title)),
                ),
              // sembol robotik sepetlerde varsa
              ..._roboticBaskets.map(
                (e) => OutlinedButton(
                  style: context.pAppStyle.oulinedMediumPrimaryStyle,
                  onPressed: () {
                    router.push(
                      RoboticBasketRoute(
                        portfolioKey: 'robotik_sepet',
                        title: e.header,
                        portfolioId: e.id ?? 0,
                        description: e.description,
                        suitable: e.suitable,
                        ignoreUnsubList: [widget.symbol.symbolCode],
                      ),
                    );
                  },
                  child: Text(
                    L10n.tr(
                      e.header,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
