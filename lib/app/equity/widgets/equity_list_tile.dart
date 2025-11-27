import 'package:auto_size_text/auto_size_text.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:piapiri_v2/app/alarm/bloc/alarm_bloc.dart';
import 'package:piapiri_v2/app/data_grid/widgets/slide_option.dart';
import 'package:piapiri_v2/app/equity/widgets/symbol_icon_keep_alive_widget.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_state.dart';
import 'package:piapiri_v2/app/favorite_lists/favorite_list_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/diff_percentage.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class EquityListTile extends StatelessWidget {
  final SlidableController controller;
  final MarketListModel symbol;
  final Function()? onTap;
  final bool enableSwiping;
  final EdgeInsets margin;
  const EquityListTile({
    super.key,
    required this.controller,
    required this.symbol,
    this.onTap,
    this.enableSwiping = true,
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Slidable(
        controller: controller,
        enabled: enableSwiping,
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: .32,
          children: [
            const Spacer(),
            LayoutBuilder(
              builder: (context, constraints) => SlideOptions(
                height: constraints.maxHeight,
                imagePath: ImagesPath.alarm,
                backgroundColor: context.pColorScheme.card,
                iconColor: context.pColorScheme.primary,
                onTap: () {
                  if (getIt<AlarmBloc>().state.priceAlarms.length + getIt<AlarmBloc>().state.newsAlarms.length >= 90) {
                    PBottomSheet.showError(
                      context,
                      content: L10n.tr('max_alarm_limit_reached'),
                    );
                    return;
                  }

                  router.push(
                  CreatePriceNewsAlarmRoute(
                    symbol: SymbolModel.fromMarketListModel(symbol),
                  ),
                  );
                },
              ),
            ),

            /// Anlik olarak gorebilmemiz icin bloc a sarildi
            PBlocBuilder<FavoriteListBloc, FavoriteListState>(
              bloc: getIt<FavoriteListBloc>(),
              builder: (context, state) {
                bool isFavourite = FavoriteListUtils().isFavorite(symbol.symbolCode, SymbolTypes.equity);
                return LayoutBuilder(
                  builder: (context, constraints) => SlideOptions(
                    height: constraints.maxHeight,
                    imagePath: isFavourite ? ImagesPath.star_full : ImagesPath.star,
                    backgroundColor: isFavourite ? context.pColorScheme.secondary : context.pColorScheme.primary,
                    iconColor: isFavourite ? context.pColorScheme.primary : context.pColorScheme.stroke,
                    onTap: () async {
                      await FavoriteListUtils().toggleFavorite(
                        context,
                        symbol.symbolCode,
                        SymbolTypes.equity,
                      );
                      controller.close();
                    },
                  ),
                );
              },
            ),
          ],
        ),
        child: Container(
          margin: margin,
          padding: const EdgeInsets.symmetric(
            vertical: Grid.m - Grid.xs,
          ),
          alignment: Alignment.center,
          color: context.pColorScheme.transparent,
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SymbolIconKeepAliveWidget(
                      symbolName: symbol.symbolCode,
                      symbolTypes: SymbolTypes.equity,
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
                            symbol.symbolCode,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.pAppStyle.labelReg14textPrimary,
                          ),
                          Text(
                            symbol.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.pAppStyle.labelMed12textSecondary,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: DiffPercentageAutoSize(
                        rowMainAxisAlignment: MainAxisAlignment.center,
                        percentage: symbol.differencePercent,
                        minfontSize: Grid.s + Grid.xxs,
                      ),
                    ),
                    Expanded(
                      child: AutoSizeText(
                        '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(MoneyUtils().getPrice(symbol, null))}',
                        style: context.pAppStyle.labelMed14textPrimary,
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
