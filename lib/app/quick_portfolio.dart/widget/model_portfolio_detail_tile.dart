import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/model/quick_portfolio_asset_model.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/widget/symbol_list_tile.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_state.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/database/db_helper.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';

//model portfolio liste tile
class ModelPortfolioDetailTile extends StatefulWidget {
  final QuickPortfolioAssetModel item;

  final String portfolioKey;
  const ModelPortfolioDetailTile({
    super.key,
    required this.item,
    required this.portfolioKey,
  });

  @override
  State<ModelPortfolioDetailTile> createState() => _ModelPortfolioDetailTileState();
}

class _ModelPortfolioDetailTileState extends State<ModelPortfolioDetailTile> {
  late MarketListModel _symbolData;
  late SymbolBloc _symbolBloc;
  String? _description;

  @override
  void initState() {
    _symbolBloc = getIt<SymbolBloc>();
    _symbolData = MarketListModel(
      symbolCode: widget.item.code,
      updateDate: '',
    );
    super.initState();
    _getSymbolName();
  }

  Future _getSymbolName() async {
    List<Map<String, dynamic>> result = await DatabaseHelper().getDetailsOfSymbol(_symbolData.symbolCode);
    setState(() {
      _description = result.firstOrNull?['Description'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<SymbolBloc, SymbolState>(
      bloc: _symbolBloc,
      builder: (context, state) {
        if (state.isLoading || _symbolBloc.state.selectedItem.symbolCode.isEmpty) {
          return const PLoading();
        }
        return PBlocConsumer<SymbolBloc, SymbolState>(
          bloc: _symbolBloc,
          listenWhen: (previous, current) {
            return current.isUpdated &&
                current.watchingItems.map((e) => e.symbolCode).toList().contains(widget.item.code);
          },
          listener: (BuildContext context, SymbolState state) {
            MarketListModel? newModel = state.watchingItems.firstWhereOrNull(
              (element) => element.symbolCode == widget.item.code,
            );
            if (newModel == null) return;
            setState(() {
              _symbolData = newModel;
            });
          },
          builder: (context, state) {
            return SymbolListTile(
              leadingText: widget.item.code,
              subLeadingText: _description,
              infoText: '%${MoneyUtils().readableMoney(widget.item.ratio)}',
              symbolName: widget.item.code,
              symbolType: SymbolTypes.equity,
              trailingText:
                  '₺${MoneyUtils().readableMoney(_symbolData.last == 0 ? _symbolData.dayClose : _symbolData.last)}',
              subTrailingText: widget.portfolioKey == 'robotik_sepet'
                  ? null
                  : '₺${MoneyUtils().readableMoney(widget.item.targetPrice)}',
              onTap: () {
                router.push(
                  SymbolDetailRoute(
                    symbol: MarketListModel(
                      symbolCode: widget.item.code,
                      updateDate: '',
                    ),
                    ignoreDispose: true,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
