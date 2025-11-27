import 'dart:convert';

import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_bloc.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/quick_portfolio_asset_model.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/robotic_and_fund_basket_model.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/quick_portfolio_buttons_widget.dart.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

//Fon Sepetleri kart widgetı
class QuickPortfolioFundCard extends StatefulWidget {
  final RoboticAndFundBasketModel item;
  final String portfolioKey;
  const QuickPortfolioFundCard({
    super.key,
    required this.item,
    required this.portfolioKey,
  });

  @override
  State<QuickPortfolioFundCard> createState() => _QuickPortfolioFundCardState();
}

class _QuickPortfolioFundCardState extends State<QuickPortfolioFundCard> {
  late List<QuickPortfolioAssetModel> funds;
  late QuickPortfolioBloc _quickPortfolioBloc;
  late AppInfo _appInfo;
  @override
  void initState() {
    _appInfo = getIt<AppInfo>();
    _quickPortfolioBloc = getIt<QuickPortfolioBloc>();
    funds = widget.portfolioKey == 'fon_sepeti' || widget.portfolioKey == 'us_sepet'
        ? json
            .decode(widget.item.funds!)
            .map<QuickPortfolioAssetModel>((e) => QuickPortfolioAssetModel.fromJson(e))
            .toList()
        : [];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        return _buttonAction();
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            width: Grid.s,
          ),
          Padding(
            padding: const EdgeInsets.all(
              Grid.s + Grid.xxs,
            ),
            child: CardImage(
              imageUrl: '${_appInfo.cdnUrl}Portfolio/${widget.item.iconFile}',
              size: 40,
            ),
          ),
          const SizedBox(
            width: Grid.s,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: Grid.m,
                  ),
                  child: Text(
                    widget.item.header,
                    style: context.pAppStyle.labelReg14textPrimary,
                  ),
                ),
                const SizedBox(
                  height: Grid.xs,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: Grid.m,
                  ),
                  child: Text(
                    widget.item.description,
                    maxLines: 3,
                    style: context.pAppStyle.labelMed12textSecondary,
                  ),
                ),
                const SizedBox(
                  height: Grid.s,
                ),
                QuickPortfolioButtonsWidget(
                  symbols: widget.portfolioKey == 'fon_sepeti' || widget.portfolioKey == 'us_sepet'
                      ? funds
                      : _quickPortfolioBloc.state.roboticPortfolios
                          .where((e) => e.portfolioId == widget.item.id)
                          .toList(),
                  portfolioKey: widget.portfolioKey,
                  buyButtonOnPressed: () {
                    return _buttonAction();
                  },
                  listSymbolType: widget.portfolioKey == 'fon_sepeti'
                      ? SymbolTypes.fund.dbKey
                      : widget.portfolioKey == 'us_sepet'
                          ? SymbolTypes.foreign.dbKey
                          : SymbolTypes.equity.dbKey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _buttonAction() {
    widget.portfolioKey == 'fon_sepeti'
        ? router.push(
            FundPortfolioRoute(
              funds: funds,
              title: widget.item.header,
              description: widget.item.description,
              suitable: widget.item.suitable,
              basketKey: widget.item.key,
            ),
          )
        : widget.portfolioKey == 'us_sepet'
            ? router.push(
                UsPortfolioRoute(
                  usPortfoio: funds,
                  title: widget.item.header,
                  description: widget.item.description,
                  suitable: widget.item.suitable,
                ),
              )
            : router.push(
                RoboticBasketRoute(
                  portfolioKey: widget.portfolioKey,
                  title: widget.item.header,
                  portfolioId: widget.item.id ?? 0,
                  description: widget.item.description,
                  suitable: widget.item.suitable,
                  basketKey: widget.item.key,
                ),
              );
  }
}
