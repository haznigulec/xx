import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_bloc.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_state.dart';
import 'package:piapiri_v2/app/assets/widgets/trade_info_tile.dart';
import 'package:piapiri_v2/app/assets/widgets/trade_limit_row.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/language/bloc/language_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/assets_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class TradeInfoCard extends StatelessWidget {
  final bool isVisible;
  const TradeInfoCard({
    required this.isVisible,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<AssetsBloc, AssetsState>(
      bloc: getIt<AssetsBloc>(),
      builder: (context, state) {
        // if (state.isLoading || state.isInitial) {
        //   return const ShimmerTradeInfoWidget();
        // }

        if (state.limitInfos == null) {
          return NoDataWidget(
            message: L10n.tr('no_limit'),
          );
        }

        return Container(
          color: context.pColorScheme.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                L10n.tr('limit_bilgileri'),
                style: context.pAppStyle.labelMed14textPrimary,
              ),
              state.limitInfos != null
                  ? TradeInfoTile(
                      title: L10n.tr('islem_limiti'),
                      value: isVisible
                          ? '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(state.limitInfos!['tradeLimit'])}'
                          : '${CurrencyEnum.turkishLira.symbol}****',
                      onTap: () {
                        PBottomSheet.show(
                          context,
                          title: '',
                          titleWidget: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    L10n.tr('islem_limiti'),
                                    style: context.pAppStyle.interRegularBase.copyWith(
                                      fontSize: Grid.m - Grid.xxs,
                                    ),
                                  ),
                                  Text(
                                    isVisible
                                        ? '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(state.limitInfos!['tradeLimit'])}'
                                        : '${CurrencyEnum.turkishLira.symbol}***',
                                    style: context.pAppStyle.labelMed14textPrimary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          child: _tradeLimitList(
                            context,
                            state.limitInfos!,
                            isVisible,
                          ),
                        );
                      },
                    )
                  : NoDataWidget(
                      message: L10n.tr('no_limit'),
                    ),
              if (state.consolidatedAssets != null &&
                  state.consolidatedAssets?.creditInfo != null &&
                  state.consolidatedAssets!.creditInfo.isNotEmpty) ...[
                TradeInfoTile(
                  title: L10n.tr('credit_status'),
                  value: '',
                  onTap: () {
                    PBottomSheet.show(
                      context,
                      title: L10n.tr('credit_status'),
                      child: _creditInfo(
                        context,
                        state.consolidatedAssets?.creditInfo[0].creditLimitInfo,
                        isVisible,
                      ),
                    );
                  },
                ),
                TradeInfoTile(
                  title: L10n.tr('collateral_sales_limits'),
                  value: '',
                  onTap: () {
                    PBottomSheet.show(
                      context,
                      title: L10n.tr('collateral_sales_limits'),
                      child: _creditInfo(context, state.consolidatedAssets?.creditInfo[0].collateralInfo, isVisible),
                    );
                  },
                ),
                TradeInfoTile(
                  title: L10n.tr('equity_and_liquidity_ratios'),
                  value: '',
                  onTap: () {
                    PBottomSheet.show(
                      context,
                      title: L10n.tr('equity_and_liquidity_ratios'),
                      child: _creditInfo(
                        context,
                        state.consolidatedAssets?.creditInfo[0].riskCapitalInfo,
                        isVisible,
                      ),
                    );
                  },
                ),
              ]
            ],
          ),
        );
      },
    );
  }
}

Widget _creditInfo(
  BuildContext context,
  dynamic creditInfo,
  bool isVisible,
) {
  if (creditInfo == null) return Container();
  String languageCode = getIt<LanguageBloc>().state.languageCode;
  List<Widget> listWidget = [];

  if (creditInfo is CreditLimitInfoLimit) {
    listWidget.add(
      _buildRow(
        context,
        L10n.tr('kullanilan_kredi'),
        isVisible ? '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(creditInfo.usedCredit)}' : '₺**',
      ),
    );

    listWidget.add(
      _buildRow(
        context,
        L10n.tr('kalan_kredi_limiti'),
        isVisible
            ? '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(creditInfo.remainingCredit)}'
            : '₺**',
      ),
    );
  } else if (creditInfo is CollateralInfoLimit) {
    listWidget.add(
      _buildRow(
        context,
        L10n.tr('teminat_bazli_aciga_satıs_limiti'),
        isVisible
            ? '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(creditInfo.availableCollateral)}'
            : '₺**',
      ),
    );
    listWidget.add(
      _buildRow(
        context,
        L10n.tr('aciga_satis_limiti'),
        isVisible
            ? '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(creditInfo.shortFallAmountLimit)}'
            : '₺**',
      ),
    );
  } else if (creditInfo is RiskCapitalInfoLimit) {
    listWidget.add(_buildRow(
        context,
        '${L10n.tr('ozkaynak_orani')} T',
        languageCode != 'en'
            ? '%${MoneyUtils().readableMoney(creditInfo.riskCapitalRate)}'
            : '${MoneyUtils().readableMoney(creditInfo.riskCapitalRate)}%'));
    if (creditInfo.riskCapitalRateT1 != null) {
      listWidget.add(_buildRow(
          context,
          '${L10n.tr('ozkaynak_orani')} T1',
          languageCode != 'en'
              ? '%${MoneyUtils().readableMoney(creditInfo.riskCapitalRateT1!)}'
              : '${MoneyUtils().readableMoney(creditInfo.riskCapitalRateT1!)}%'));
    }
    if (creditInfo.riskCapitalRateT2 != null) {
      listWidget.add(_buildRow(
          context,
          '${L10n.tr('ozkaynak_orani')} T2',
          languageCode != 'en'
              ? '%${MoneyUtils().readableMoney(creditInfo.riskCapitalRateT2!)}'
              : '${MoneyUtils().readableMoney(creditInfo.riskCapitalRateT2!)}%'));
    }
  }

  return Column(
    children: listWidget,
  );
}

Widget _buildRow(BuildContext context, String title, String value) {
  return Padding(
    padding: const EdgeInsets.only(
      bottom: Grid.m,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: context.pAppStyle.labelMed14textSecondary,
            maxLines: 2,
          ),
        ),
        const SizedBox(width: Grid.s),
        Text(
          value,
          style: context.pAppStyle.labelMed14textPrimary,
        ),
      ],
    ),
  );
}

Widget _tradeLimitList(
  BuildContext context,
  Map<String, dynamic> limitInfos,
  bool isVisible,
) {
  List<Widget> listWidget = [];

  for (var element in limitInfos['tradeLimitCalculationDetails'].keys) {
    listWidget.add(
      TradeLimitRow(
        dataKey: element,
        limitInfos: limitInfos,
        isVisible: isVisible,
      ),
    );
  }

  return Column(
    children: listWidget,
  );
}
