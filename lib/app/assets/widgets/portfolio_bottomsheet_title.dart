import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:p_core/extensions/string_extensions.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_state.dart';
import 'package:piapiri_v2/app/assets/widgets/collateral_info_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/model/assets_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class PortfolioBottomsheetTitle extends StatefulWidget {
  final bool hasViop;
  final bool isVisible;
  final Function(bool) onDefaultParity;
  final OverallItemModel assets;
  final double totalUsdOverall;
  final AssetsState assetsState;
  final bool? isAgreementPage;

  const PortfolioBottomsheetTitle({
    super.key,
    required this.hasViop,
    required this.isVisible,
    required this.onDefaultParity,
    required this.assets,
    required this.totalUsdOverall,
    required this.assetsState,
    this.isAgreementPage = false,
  });

  @override
  PortfolioBottomsheetTitleState createState() => PortfolioBottomsheetTitleState();
}

class PortfolioBottomsheetTitleState extends State<PortfolioBottomsheetTitle> {
  bool _isDefaultParity = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isDefaultParity = !_isDefaultParity;
              widget.onDefaultParity(_isDefaultParity);
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                _isDefaultParity ? 'TL' : 'USD',
                style: context.pAppStyle.labelReg14primary,
              ),
              const SizedBox(
                width: Grid.xxs,
              ),
              SvgPicture.asset(
                ImagesPath.chevron_list,
                width: 15,
                colorFilter: ColorFilter.mode(
                  context.pColorScheme.primary,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
        widget.hasViop && widget.assets.instrumentCategory == 'viop_collateral'
            ? viopCardDetail(widget.assets, widget.assetsState)
            : titleCardDetail(widget.assets),
      ],
    );
  }

  Widget titleCardDetail(
    OverallItemModel assets,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Grid.m,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                //fonlar, yatırım fonları. hisse, Bist hisse gözükmesi için koşul.
                L10n.tr(widget.assets.instrumentCategory == 'fund'
                    ? 'investment_fund'
                    : widget.assets.instrumentCategory == 'sgmk'
                        ? 'sgmk_portfolio'
                        : widget.assets.instrumentCategory == 'equity'
                            ? 'bist_equity'
                            : widget.assets.instrumentCategory == 'viop_collateral'
                                ? 'portfolio.viop_collateral'
                                : widget.assets.instrumentCategory),
                style: context.pAppStyle.labelReg14textPrimary,
              ),
              const SizedBox(
                height: Grid.xxs,
              ),
              if (assets.ratio != 0)
                Text(
                  '${L10n.tr('portfolio_ratio')}: %${MoneyUtils().readableMoney(
                    assets.ratio,
                  )}',
                  style: context.pAppStyle.labelReg12textSecondary,
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              (assets.instrumentCategory == 'viop_collateral')
                  ? InkWell(
                      onTap: widget.isAgreementPage!
                          ? null
                          : () {
                              PBottomSheet.show(
                                context,
                                title: '${L10n.tr('portfolio.viop_collateral')}: ₺${MoneyUtils().readableMoney(
                                  assets.totalAmount,
                                )}',
                                child: CollateralInfoWidget(
                                  isAgreementPage: widget.isAgreementPage,
                                ),
                              );
                            },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _isDefaultParity
                                ? widget.isVisible
                                    ? '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(assets.totalAmount)}'
                                    : '${CurrencyEnum.turkishLira.symbol}**'
                                : widget.isVisible
                                    ? '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(assets.totalAmount / widget.totalUsdOverall)}'
                                    : '${CurrencyEnum.dollar.symbol}**',
                            style: context.pAppStyle.labelMed16textPrimary,
                          ),
                          if (!widget.isAgreementPage!) ...[
                            const SizedBox(
                              width: Grid.xxs,
                            ),
                            SvgPicture.asset(
                              ImagesPath.chevron_right,
                              width: 15,
                              colorFilter: ColorFilter.mode(
                                context.pColorScheme.textPrimary,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                        ],
                      ),
                    )
                  : Text(
                      widget.assets.instrumentCategory == 'sgmk'
                          ? MoneyUtils().fromReadableMoney(MoneyUtils().readableMoney(
                                      widget.assets.overallSubItems.fold(0, (sum, e) => sum + e.amount))) ==
                                  0
                              ? '-'
                              : '${MoneyUtils().readableMoney(widget.assets.overallSubItems.fold(0, (sum, e) => sum + e.amount))} ${CurrencyEnum.turkishLira.symbol}'
                          : _isDefaultParity
                              ? widget.isVisible
                                  ? assets.totalAmount == 0
                                      ? '-'
                                      : '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(assets.totalAmount)}'
                                  : '${CurrencyEnum.turkishLira.symbol}**'
                              : widget.isVisible
                                  ? (assets.totalAmount / widget.totalUsdOverall) == 0
                                      ? '-'
                                      : '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(assets.totalAmount / widget.totalUsdOverall)}'
                                  : '${CurrencyEnum.dollar.symbol}**',
                      style: context.pAppStyle.labelMed14textPrimary,
                    ),
              if (assets.totalPotentialProfitLoss != 0 &&
                  assets.totalAmount != 0 &&
                  assets.instrumentCategory != 'cash') ...[
                const SizedBox(
                  height: Grid.xxs,
                ),
                Row(
                  children: [
                    if (assets.instrumentCategory != 'viop')
                      Utils().profitLossPercentWidget(
                        context: context,
                        isVisible: widget.isVisible,
                        performance: widget.assets.totalAmount - widget.assets.totalPotentialProfitLoss == 0
                            ? 0
                            : assets.totalPotentialProfitLoss /
                                (assets.totalAmount - assets.totalPotentialProfitLoss) *
                                100,
                        fontSize: Grid.l / 2,
                      ),
                    Text(
                      _isDefaultParity
                          ? widget.isVisible
                              ? ' (${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(assets.totalPotentialProfitLoss)})'
                                  .formatNegativePriceAndPercentage()
                              : ' (${CurrencyEnum.turkishLira.symbol}**)'
                          : widget.isVisible
                              ? ' (${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(assets.totalPotentialProfitLoss / widget.totalUsdOverall)})'
                                  .formatNegativePriceAndPercentage()
                              : ' (${CurrencyEnum.dollar.symbol}**)',
                      style: context.pAppStyle.labelMed12textPrimary.copyWith(
                        color: assets.totalPotentialProfitLoss == 0
                            ? context.pColorScheme.textPrimary
                            : assets.totalPotentialProfitLoss > 0
                                ? context.pColorScheme.success
                                : context.pColorScheme.critical,
                      ),
                    ),
                  ],
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }

  Widget viopCardDetail(
    OverallItemModel assets,
    AssetsState state,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Grid.m),
          child:
              //1.satır
              Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    L10n.tr('portfolio.viop_collateral'),
                    style: context.pAppStyle.labelReg14textPrimary,
                  ),
                  if (widget.assets.instrumentCategory != 'sgmk') ...[
                    const SizedBox(
                      height: Grid.xxs,
                    ),
                    if (assets.ratio != 0)
                      Padding(
                        padding: const EdgeInsets.only(top: Grid.xxs),
                        child: Text(
                          '${L10n.tr('portfolio_ratio')}: %${MoneyUtils().readableMoney(
                            assets.ratio,
                          )}',
                          style: context.pAppStyle.labelReg12textSecondary,
                        ),
                      ),
                  ],
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _isDefaultParity
                            ? widget.isVisible
                                ? '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(assets.totalAmount)}'
                                : '${CurrencyEnum.turkishLira.symbol}**'
                            : widget.isVisible
                                ? '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(assets.totalAmount / widget.totalUsdOverall)}'
                                : '${CurrencyEnum.dollar.symbol}**',
                        style: context.pAppStyle.labelMed14textPrimary,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        if (!widget.isAgreementPage!) ...[
          const PDivider(),
          //2.satır
          Padding(
            padding: const EdgeInsets.only(
              top: Grid.l,
              bottom: Grid.s,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      L10n.tr('usable_collateral'),
                      style: context.pAppStyle.labelReg14textSecondary,
                    ),
                    InkWell(
                      onTap: () {
                        PBottomSheet.show(
                          context,
                          title:
                              '${L10n.tr('usable_collateral')}: ₺${MoneyUtils().readableMoney(state.collateralInfo?.usableColl ?? 0)}',
                          child: const CollateralInfoWidget(),
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _isDefaultParity
                                ? widget.isVisible
                                    ? state.collateralInfo?.usableColl == 0
                                        ? '-'
                                        : '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(state.collateralInfo?.usableColl ?? 0)}'
                                    : '${CurrencyEnum.turkishLira.symbol}**'
                                : widget.isVisible
                                    ? ((state.collateralInfo?.usableColl ?? 0) / widget.totalUsdOverall == 0)
                                        ? '-'
                                        : '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney((state.collateralInfo?.usableColl ?? 0) / widget.totalUsdOverall)}'
                                    : '${CurrencyEnum.dollar.symbol}**',
                            style: context.pAppStyle.labelMed14textPrimary,
                          ),
                          const SizedBox(
                            width: Grid.xxs,
                          ),
                          SvgPicture.asset(
                            ImagesPath.chevron_right,
                            width: 15,
                            colorFilter: ColorFilter.mode(
                              context.pColorScheme.textPrimary,
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: PTextButtonWithIcon(
                    text: L10n.tr('teminat_cek_yatir'),
                    iconAlignment: IconAlignment.end,
                    sizeType: PButtonSize.small,
                    padding: EdgeInsets.zero,
                    icon: SvgPicture.asset(
                      ImagesPath.arrow_up_right,
                      width: Grid.m - Grid.xxs,
                      colorFilter: ColorFilter.mode(
                        context.pColorScheme.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () {
                      router.push(
                        const ViopCollateralRoute(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],

        const PDivider(),
        //3.satır
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Grid.m,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                L10n.tr('viop_total_open_position'),
                style: context.pAppStyle.labelReg14textSecondary,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _isDefaultParity
                        ? widget.isVisible
                            ? ' ${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(state.portfolioViop?.totalAmount ?? 0)}'
                                .formatNegativePriceAndPercentage()
                            : ' ${CurrencyEnum.turkishLira.symbol}**'
                        : widget.isVisible
                            ? ' ${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney((state.portfolioViop?.totalAmount ?? 0) / widget.totalUsdOverall)}'
                                .formatNegativePriceAndPercentage()
                            : ' ${CurrencyEnum.dollar.symbol}**',
                    style: context.pAppStyle.labelMed14textPrimary.copyWith(color: context.pColorScheme.textPrimary),
                  ),
                  const SizedBox(
                    height: Grid.xxs,
                  ),
                  Text(
                    _isDefaultParity
                        ? widget.isVisible
                            ? L10n.tr('totalProfitLoss') +
                                ': ${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(state.portfolioViop?.totalPotentialProfitLoss ?? 0)}'
                                    .formatNegativePriceAndPercentage()
                            : '${L10n.tr('totalProfitLoss')}: ${CurrencyEnum.turkishLira.symbol}**'
                        : widget.isVisible
                            ? L10n.tr('totalProfitLoss') +
                                ': ${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney((state.portfolioViop?.totalPotentialProfitLoss ?? 0) / widget.totalUsdOverall)}'
                                    .formatNegativePriceAndPercentage()
                            : '${L10n.tr('totalProfitLoss')}: ${CurrencyEnum.dollar.symbol}**',
                    style: context.pAppStyle.labelMed12textPrimary.copyWith(
                      fontSize: Grid.l / 2 - Grid.xxs / 2,
                      color: (state.portfolioViop?.totalPotentialProfitLoss ?? 0) == 0
                          ? context.pColorScheme.textPrimary
                          : (state.portfolioViop?.totalPotentialProfitLoss ?? 0) > 0
                              ? context.pColorScheme.success
                              : context.pColorScheme.critical,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const PDivider(),
      ],
    );
  }
}
