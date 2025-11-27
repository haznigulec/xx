import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/assets/model/us_capra_summary_model.dart';
import 'package:piapiri_v2/app/assets/widgets/asset_us_equity_card.dart';
import 'package:piapiri_v2/app/us_symbol_detail/widgets/us_clock.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/us_market_status_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

import '../../../common/utils/utils.dart';

class AssetUsEquityBottomSheet extends StatefulWidget {
  final UsOverallItemModel portfolioSummary;
  final num totalQuantity;
  final double tlExchangeRate;
  final bool isVisible;
  const AssetUsEquityBottomSheet({
    super.key,
    required this.portfolioSummary,
    required this.totalQuantity,
    required this.tlExchangeRate,
    required this.isVisible,
  });

  @override
  State<AssetUsEquityBottomSheet> createState() => _AssetUsEquityBottomSheetState();
}

class _AssetUsEquityBottomSheetState extends State<AssetUsEquityBottomSheet> {
  bool _isUsd = true;
  late final UsMarketStatus _usMarketStatus;
  final ScrollController _scrollController = ScrollController();
  bool _isScrollable = false;

  @override
  void initState() {
    super.initState();
    _usMarketStatus = getMarketStatus();
    _scrollController.addListener(_checkScrollable);
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkScrollable());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_checkScrollable);
    _scrollController.dispose();
    super.dispose();
  }

  void _checkScrollable() {
    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    final isNowScrollable = maxScrollExtent > 0;
    if (_isScrollable != isNowScrollable) {
      setState(() {
        _isScrollable = isNowScrollable;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          focusColor: Colors.transparent,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            setState(() {
              _isUsd = !_isUsd;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                _isUsd ? 'USD' : 'TL',
                style: context.pAppStyle.labelReg14primary,
              ),
              const SizedBox(
                width: Grid.xxs,
              ),
              SvgPicture.asset(
                ImagesPath.chevron_list,
                width: Grid.m,
                colorFilter: ColorFilter.mode(
                  context.pColorScheme.primary,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: Grid.m,
        ),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  L10n.tr('american_stock_exchanges_equity'),
                  style: context.pAppStyle.labelReg14textPrimary,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: L10n.tr('portfolio_ratio'),
                        style: context.pAppStyle.labelMed12textSecondary,
                      ),
                      TextSpan(
                        text: widget.isVisible
                            ? ': %${MoneyUtils().readableMoney(
                                widget.portfolioSummary.ratio ?? 0,
                              )}'
                            : ': %**',
                        style: context.pAppStyle.labelMed12textSecondary,
                      )
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _isUsd
                      ? !widget.isVisible
                          ? '${CurrencyEnum.dollar.symbol}**'
                          : '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(widget.portfolioSummary.totalAmount!)}'
                      : !widget.isVisible
                          ? '${CurrencyEnum.turkishLira.symbol}**'
                          : '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(widget.portfolioSummary.totalAmount! * widget.tlExchangeRate)}',
                  style: context.pAppStyle.labelMed14textPrimary,
                ),
                if (widget.portfolioSummary.totalPotentialProfitLoss != null &&
                    widget.portfolioSummary.totalPotentialProfitLoss != 0)
                  Row(
                    spacing: Grid.xxs,
                    children: [
                      Utils().profitLossPercentWidget(
                        context: context,
                        performance: widget.portfolioSummary.totalPotentialProfitLoss! /
                            (widget.portfolioSummary.totalAmount! - widget.portfolioSummary.totalPotentialProfitLoss!) *
                            100,
                        fontSize: Grid.l / 2,
                        isVisible: widget.isVisible,
                      ),
                      Builder(builder: (context) {
                        double amount = widget.portfolioSummary.totalPotentialProfitLoss!;
                        String amountText = _isUsd
                            ? !widget.isVisible
                                ? '(${CurrencyEnum.dollar.symbol}**)'
                                : '(${(amount < 0 ? '-' : '')}${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(amount.abs())})'
                            : !widget.isVisible
                                ? '(${CurrencyEnum.turkishLira.symbol}**)'
                                : '(${(amount < 0 ? '-' : '')}${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(amount.abs() * widget.tlExchangeRate)})';
                        return Text(
                          amountText,
                          style: context.pAppStyle.interMediumBase.copyWith(
                            color: widget.portfolioSummary.totalPotentialProfitLoss! == 0
                                ? context.pColorScheme.textPrimary
                                : widget.portfolioSummary.totalPotentialProfitLoss! > 0
                                    ? context.pColorScheme.success
                                    : context.pColorScheme.critical,
                            fontSize: Grid.s + Grid.xs,
                          ),
                        );
                      }),
                    ],
                  ),
              ],
            )
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(
            top: Grid.m,
          ),
          child: PDivider(),
        ),
        Flexible(
          child: RawScrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            thumbColor: context.pColorScheme.iconPrimary,
            thickness: 2.0,
            child: Padding(
              padding: EdgeInsets.only(
                right: _isScrollable ? Grid.s : 0,
              ),
              child: ListView.separated(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  vertical: Grid.m,
                ),
                itemCount: widget.portfolioSummary.overallItems?.length ?? 0,
                shrinkWrap: true,
                separatorBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Grid.s + Grid.xs,
                  ),
                  child: PDivider(),
                ),
                itemBuilder: (context, index) {
                  return AssetUsEquityCard(
                    asset: widget.portfolioSummary.overallItems![index],
                    totalQuantity: widget.totalQuantity,
                    isUsd: _isUsd,
                    tlExchangeRate: widget.tlExchangeRate,
                    usMarketStatus: _usMarketStatus,
                    isVisible: widget.isVisible,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
