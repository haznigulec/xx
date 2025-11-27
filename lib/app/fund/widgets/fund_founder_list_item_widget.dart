import 'package:piapiri_v2/common/widgets/charts/risk_bar.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/list/p_symbol_tile.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/extension/string_extension.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/fund_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class FundFounderListItemWidget extends StatelessWidget {
  final FundModel fund;
  final String filterCategory;
  final String filterPeriod;

  const FundFounderListItemWidget({
    super.key,
    required this.fund,
    required this.filterCategory,
    required this.filterPeriod,
  });

  @override
  Widget build(BuildContext context) {
    final isPerformanceCategory = filterCategory == L10n.tr('performance');
    final PSymbolVariant variant = (filterCategory == L10n.tr('fundPortfolioSize') ||
            filterCategory == L10n.tr('numberOfPeople') ||
            filterCategory == L10n.tr('risk_level'))
        ? PSymbolVariant.fundTabRisk
        : PSymbolVariant.fundTab;

    final trailingTitle = _getTrailingTitle(context, variant);
    final trailingWidget = _getTrailingWidget(context);

    return SizedBox(
      height: 64,
      child: PSymbolTile(
        variant: variant,
        titleWidget: SymbolIcon(
          size: 30,
          symbolName: fund.institutionCode.toString(),
          symbolType: SymbolTypes.fund,
        ),
        title: fund.subType,
        titleStyle: context.pAppStyle.labelMed14textPrimary,
        subTitle: '${fund.code} • ${(fund.institutionName ?? '').toCapitalizeCaseTr}',
        subTitleStyle: context.pAppStyle.labelReg12textPrimary,
        isProfit: isPerformanceCategory && checkCategoryPeriod(filterPeriod, fund) != 0
            ? checkCategoryPeriod(filterPeriod, fund) > 0
            : null,
        info: isPerformanceCategory
            ? '%${MoneyUtils().readableMoney((checkCategoryPeriod(filterPeriod, fund) * 100))}'
            : null,
        trailingTitle: trailingTitle,
        trailingWidget: trailingWidget,
        onTap: () => router.push(
          FundDetailRoute(
            fundCode: fund.code.toString(),
          ),
        ),
      ),
    );
  }

  String? _getTrailingTitle(BuildContext context, PSymbolVariant variant) {
    if (filterCategory == L10n.tr('fundPortfolioSize')) {
      return CurrencyEnum.turkishLira.symbol + MoneyUtils().compactMoney(fund.portfolioSize);
    } else if (filterCategory == L10n.tr('numberOfPeople')) {
      return fund.numberOfPeople == 0 ? '-' : '${fund.numberOfPeople.toInt()} ${L10n.tr('people')}';
    } else if (filterCategory == L10n.tr('performance') || filterCategory == L10n.tr('risk_level')) {
      return null;
    } else {
      return MoneyUtils().readableMoney(
        checkCategoryPeriod(filterPeriod, fund),
      );
    }
  }

  Widget? _getTrailingWidget(BuildContext context) {
    if (filterCategory == L10n.tr('risk_level') && fund.riskLevel != null && fund.riskLevel != 0) {
      return RiskBar(riskLevel: fund.riskLevel!);
    }
    return filterCategory == L10n.tr('risk_level')
        ? Text(
            '-',
            style: context.pAppStyle.interRegularBase.copyWith(
              fontSize: Grid.m - Grid.xxs,
            ),
          )
        : null;
  }
}

double checkCategoryPeriod(String categoryPeriod, FundModel fund) {
  if (fund.performance1D != null && categoryPeriod == L10n.tr('1D')) {
    return fund.performance1D!;
  } else if (categoryPeriod == L10n.tr('1W')) {
    return fund.performance1W;
  } else if (categoryPeriod == L10n.tr('1M')) {
    return fund.performance1M;
  } else if (categoryPeriod == L10n.tr('3M')) {
    return fund.performance3M;
  } else if (categoryPeriod == L10n.tr('6M')) {
    return fund.performance6M;
  } else if (categoryPeriod == L10n.tr('1Y')) {
    return fund.performance1Y;
  } else if (categoryPeriod == L10n.tr('3Y')) {
    return fund.performance3Y;
  } else if (categoryPeriod == L10n.tr('5Y')) {
    return fund.performance5Y;
  } else {
    return 0;
  }
}
