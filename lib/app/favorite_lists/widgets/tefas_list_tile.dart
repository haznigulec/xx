import 'package:auto_size_text/auto_size_text.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:piapiri_v2/app/data_grid/widgets/slide_option.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_event.dart';
import 'package:piapiri_v2/app/favorite_lists/widgets/favorite_grid_box.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/diff_percentage.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/favorite_list.dart';
import 'package:piapiri_v2/core/model/fund_model.dart';
import 'package:piapiri_v2/core/model/favorite_sorting_enum.dart';

class TefasListTile extends StatefulWidget {
  final SlidableController controller;
  final FavoriteListItem favoriteListItem;
  final FundDetailModel? fundDetailModel;
  final bool showHeatMap;
  const TefasListTile({
    super.key,
    required this.controller,
    required this.favoriteListItem,
    required this.fundDetailModel,
    required this.showHeatMap,
  });

  @override
  State<TefasListTile> createState() => _MatriksListTileState();
}

class _MatriksListTileState extends State<TefasListTile> {
  final FavoriteListBloc _favoriteListBloc = getIt<FavoriteListBloc>();

  @override
  Widget build(BuildContext context) {
    if (widget.fundDetailModel == null) {
      return const SizedBox();
    }

    /// Hetmap gostermek isteniyorsa
    if (widget.showHeatMap) {
      return FavoriteGridBox(
        key: ValueKey(widget.favoriteListItem.symbol),
        symbolName: widget.favoriteListItem.symbol,
        symbolIconName: widget.fundDetailModel!.institutionCode,
        symbolTypes: widget.favoriteListItem.symbolType,
        price: '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(widget.fundDetailModel?.price ?? 0)}',
        diffPercentage: ((widget.fundDetailModel?.performance1D ?? 0) * 100),
        updateDate: DateTime.now().toString(),
        onTapGrid: () => router.push(
          FundDetailRoute(
            fundCode: widget.fundDetailModel!.code,
          ),
        ),
      );
    }

    /// Heatmap gostermek istenmiyorsa
    return InkWell(
      splashColor: context.pColorScheme.transparent,
      highlightColor: context.pColorScheme.transparent,
      onTap: () => router.push(
        FundDetailRoute(
          fundCode: widget.fundDetailModel!.code,
        ),
      ),
      child: Slidable(
        controller: widget.controller,
        enabled: true,
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: .16,
          children: [
            const Spacer(),
            LayoutBuilder(
              builder: (context, constraints) => SlideOptions(
                height: constraints.maxHeight,
                imagePath: ImagesPath.trash,
                backgroundColor: context.pColorScheme.critical,
                iconColor: context.pColorScheme.lightHigh,
                onTap: () {
                  _favoriteListBloc.add(
                    UpdateListEvent(
                      name: _favoriteListBloc.state.selectedList?.name ?? '',
                      favoriteListItems: _favoriteListBloc.state.selectedList?.favoriteListItems
                              .where(
                                (element) => element.symbol != widget.favoriteListItem.symbol,
                              )
                              .toList() ??
                          [],
                      id: _favoriteListBloc.state.selectedList?.id ?? 0,
                      sortingEnum: _favoriteListBloc.state.selectedList?.sortingEnum ?? FavoriteSortingEnum.alphabetic,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        child: Container(
          alignment: Alignment.center,
          color: context.pColorScheme.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: Grid.m,
            vertical: Grid.m - Grid.xs,
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SymbolIcon(
                      symbolName: widget.fundDetailModel?.institutionCode ?? '',
                      symbolType: widget.favoriteListItem.symbolType,
                      size: 28,
                    ),
                    const SizedBox(
                      width: Grid.s,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.favoriteListItem.symbol,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.pAppStyle.labelReg14textPrimary,
                          ),
                          Text(
                            widget.fundDetailModel?.founder ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.pAppStyle.labelMed12textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: DiffPercentageAutoSize(
                        rowMainAxisAlignment: MainAxisAlignment.center,
                        percentage: ((widget.fundDetailModel?.performance1D ?? 0) * 100),
                        minfontSize: Grid.s + Grid.xxs,
                      ),
                    ),
                    Expanded(
                      child: AutoSizeText(
                        '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(widget.fundDetailModel?.price ?? 0)}',
                        style: context.pAppStyle.labelMed14textPrimary,
                        maxLines: 1,
                        minFontSize: Grid.s + Grid.xxs,
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
