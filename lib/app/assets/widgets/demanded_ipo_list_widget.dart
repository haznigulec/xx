import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_bloc.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_state.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/list/p_symbol_tile.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class PortfolioIpoDetailWidget extends StatelessWidget {
  final String customerId;
  const PortfolioIpoDetailWidget({
    super.key,
    required this.customerId,
  });

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<IpoBloc, IpoState>(
        bloc: getIt<IpoBloc>(),
        builder: (context, state) {
          if (state.isLoading) {
            return const PLoading();
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.ipoDemandList!.length,
            itemBuilder: (context, index) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: Grid.m,
                  ),
                  child: PSymbolTile(
                    variant: PSymbolVariant.portfolioBuy,
                    titleWidget: Row(
                      children: [
                        SymbolIcon(
                          symbolName: state.ipoDemandList![index].name.toString(),
                          symbolType: SymbolTypes.equity,
                          size: 30,
                        ),
                        const SizedBox(width: Grid.s),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.ipoDemandList![index].name.toString(),
                              style: context.pAppStyle.labelReg14textPrimary,
                            ),
                            Text(
                              '₺${MoneyUtils().readableMoney(state.ipoDemandList![index].offerPrice?.toDouble() ?? 1)}',
                              style: context.pAppStyle.labelMed14textSecondary,
                            ),
                            Text(
                              DateTimeUtils.dateFormat(
                                DateTime.parse(
                                  state.ipoDemandList![index].demandDate ?? DateTime.now().toString(),
                                ),
                              ),
                              style: context.pAppStyle.labelMed12textSecondary,
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailingWidget: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${state.ipoDemandList![index].unitsDemanded?.toInt() ?? 1} ${L10n.tr('adet')}',
                          style: context.pAppStyle.labelMed12textPrimary,
                        ),
                        Text(
                          '${L10n.tr('toplam')}: ${MoneyUtils().readableMoney(state.ipoDemandList![index].unitsDemanded!.toInt() * state.ipoDemandList![index].offerPrice!.toDouble())}',
                          style: context.pAppStyle.labelMed12textPrimary,
                        ),
                        Row(
                          children: [
                            Text(
                              _detailValue(state.ipoDemandList![index].detail),
                              style: context.pAppStyle.interMediumBase.copyWith(
                                color: context.pColorScheme.textPrimary,
                                fontSize: Grid.s + (Grid.xxs / 2) + Grid.xxs,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (index != state.ipoDemandList!.length - 1) const PDivider(),
              ],
            ),
          );
        });
  }

  String _detailValue(key) {
    switch (key) {
      case 'Cash':
      case 'Nakit':
        return L10n.tr('ipo_cash');
      case 'Fon Blokajı':
      case 'Fund Blockage':
        return L10n.tr('ipo_fund_blockage');
      case 'Hisse Blokajı':
      case 'Equity Blockage':
        return L10n.tr('ipo_equity_blockage');
      default:
        return L10n.tr('ipo_cash');
    }
  }
}
