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
import 'package:piapiri_v2/app/warrant/bloc/warrant_bloc.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/diff_percentage.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/language/bloc/language_bloc.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/risk_level_enum.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class WarrantListTile extends StatelessWidget {
  final SlidableController controller;
  final MarketListModel symbol;
  final Function()? onTap;
  final bool enableSwiping;
  final bool showRisk;
  final bool showSymbolIcon;
  final EdgeInsets margin;
  const WarrantListTile({
    super.key,
    required this.controller,
    required this.symbol,
    this.onTap,
    this.enableSwiping = true,
    this.showRisk = true,
    this.showSymbolIcon = false,
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
          extentRatio: 0.32,
          children: [
            const Spacer(),
            SlideOptions(
              height: 72,
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
            PBlocBuilder<FavoriteListBloc, FavoriteListState>(
              bloc: getIt<FavoriteListBloc>(),
              builder: (context, state) {
                bool isFavourite = FavoriteListUtils().isFavorite(symbol.symbolCode, SymbolTypes.warrant);
                return SlideOptions(
                  height: 72,
                  imagePath: isFavourite ? ImagesPath.star_full : ImagesPath.star,
                  backgroundColor: isFavourite ? context.pColorScheme.secondary : context.pColorScheme.primary,
                  iconColor: isFavourite ? context.pColorScheme.primary : context.pColorScheme.stroke,
                  onTap: () async {
                    await FavoriteListUtils().toggleFavorite(
                      context,
                      symbol.symbolCode,
                      SymbolTypes.warrant,
                    );
                    controller.close();
                  },
                );
              },
            ),
          ],
        ),
        child: Container(
          height: 72,
          margin: margin,
          alignment: Alignment.center,
          color: context.pColorScheme.transparent,
          child: Row(
            children: [
              if (showSymbolIcon) ...[
                SymbolIconKeepAliveWidget(
                  symbolName: symbol.underlying,
                  symbolTypes: getIt<WarrantBloc>().state.warrantUsUnderlying.keys.contains(symbol.underlying)
                      ? SymbolTypes.foreign
                      : SymbolTypes.warrant,
                ),
                const SizedBox(
                  width: Grid.s,
                ),
              ],
              SizedBox(
                width: MediaQuery.of(context).size.width * .47 - 32,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      symbol.symbolCode,
                      style: context.pAppStyle.labelReg14textPrimary,
                    ),
                    Text(
                      '${symbol.underlying} ${symbol.type == SymbolTypes.certificate.dbKey ? L10n.tr(SymbolTypes.certificate.localization) : L10n.tr('warrant.filter.${symbol.optionClass}')}',
                      overflow: TextOverflow.ellipsis,
                      style: context.pAppStyle.labelMed12textSecondary,
                    ),
                    if (showRisk)
                      Row(
                        children: [
                          Container(
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
                              color: stringToRiskLevel(symbol.riskLevel).color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(
                            width: Grid.xs,
                          ),
                          Text(
                            L10n.tr(stringToRiskLevel(symbol.riskLevel).text),
                            overflow: TextOverflow.ellipsis,
                            style: context.pAppStyle.labelMed12textSecondary,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(MoneyUtils().getPrice(symbol, null))}',
                    style: context.pAppStyle.labelMed14textPrimary,
                  ),
                  DiffPercentage(
                    percentage: symbol.differencePercent,
                  ),
                  Text(
                    '${L10n.tr('maturity')}: ${symbol.maturity.isEmpty ? '-' : DateTimeUtils.monthAndYear(
                        symbol.maturity,
                        getIt<LanguageBloc>().state.languageCode,
                      )}',
                    style: context.pAppStyle.labelMed12textPrimary,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
