import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:p_core/extensions/string_extensions.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_bloc.dart';
import 'package:piapiri_v2/app/assets/widgets/demanded_ipo_list_widget.dart';
import 'package:piapiri_v2/app/assets/widgets/portfolio_detail_bottomsheet.dart';
import 'package:piapiri_v2/app/money_transfer/widgets/bank_list_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/assets_model.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class AssetsComponentsWidget extends StatefulWidget {
  final OverallItemModel assets;
  final double totalValue;
  final int lastIndex;
  final int index;
  final double totalUsdOverall;
  final bool isVisible;
  final bool hasViop;
  final String selectedAccount;
  final bool? isAgreementPage;
  const AssetsComponentsWidget({
    required this.assets,
    required this.totalValue,
    required this.lastIndex,
    required this.index,
    required this.totalUsdOverall,
    required this.isVisible,
    required this.selectedAccount,
    required this.hasViop,
    this.isAgreementPage = false,
    super.key,
  });

  @override
  AssetsComponentsWidgetState createState() => AssetsComponentsWidgetState();
}

class AssetsComponentsWidgetState extends State<AssetsComponentsWidget> {
  bool _isDefaultParity = true;
  late AssetsBloc _assetsBloc;

  @override
  initState() {
    _assetsBloc = getIt<AssetsBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (widget.assets.instrumentCategory == 'ipo') ||
              (widget.assets.totalAmount == 0 && widget.assets.instrumentCategory == 'viop_collateral') ||
              (widget.assets.totalAmount == 0 && widget.assets.instrumentCategory == 'cash') ||
              (widget.isAgreementPage! && widget.assets.instrumentCategory == 'cash')
          ? null
          : () {
              PBottomSheet.show(
                context,
                child: PortfolioDetailBottomSheet(
                  isAgreementPage: widget.isAgreementPage,
                  hasViop: widget.hasViop,
                  isVisible: widget.isVisible,
                  isDefaultParity: _isDefaultParity,
                  totalUsdOverall: widget.totalUsdOverall,
                  assets: widget.assets,
                  onDefaultParity: (isDefaulrParity) {
                    setState(() {
                      _isDefaultParity = isDefaulrParity;
                    });
                  },
                ),
              );
            },
      child: SizedBox(
        height: 62,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Grid.l / 2,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 30,
                width: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: (widget.assets.instrumentCategory == 'ipo') ||
                          (widget.assets.totalAmount == 0 && widget.assets.instrumentCategory == 'viop_collateral') ||
                          (widget.assets.totalAmount == 0 && widget.assets.instrumentCategory == 'cash')
                      ? context.pColorScheme.assetColors.last
                      : context.pColorScheme.assetColors[widget.index],
                ),
              ),
              const SizedBox(width: Grid.s),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    //fonlar, yatırım fonları. hisse, Bist hisse gözükmesi için koşul.
                    L10n.tr(
                      widget.assets.instrumentCategory == 'fund'
                          ? 'investment_fund'
                          : widget.assets.instrumentCategory == 'sgmk'
                              ? 'sgmk_portfolio'
                              : widget.assets.instrumentCategory == 'equity'
                                  ? 'bist_equity'
                                  : widget.assets.instrumentCategory == 'viop_collateral'
                                      ? 'portfolio.viop_collateral'
                                      : widget.assets.instrumentCategory,
                    ),
                    style: context.pAppStyle.labelMed14textPrimary,
                  ),
                  if (widget.assets.instrumentCategory != 'ipo' && widget.assets.instrumentCategory != 'viop')
                    Text(
                      widget.assets.ratio == 0 ? '-' : '%${MoneyUtils().readableMoney(widget.assets.ratio)}',
                      style: context.pAppStyle.labelMed12textSecondary,
                    ),
                ],
              ),
              const Spacer(),
              (widget.assets.totalAmount == 0) &&
                      (widget.assets.instrumentCategory == 'cash' ||
                          widget.assets.instrumentCategory == 'ipo' ||
                          widget.assets.instrumentCategory == 'viop_collateral')
                  ? PTextButtonWithIcon(
                      text: widget.assets.instrumentCategory == 'cash'
                          ? L10n.tr('money_transfer')
                          : widget.assets.instrumentCategory == 'ipo'
                              ? L10n.tr('demand_detail')
                              : L10n.tr('deposit_collateral'),
                      padding: EdgeInsets.zero,
                      variant: PButtonVariant.brand,
                      icon: SvgPicture.asset(
                        ImagesPath.arrow_up_right,
                        width: Grid.m,
                        colorFilter: ColorFilter.mode(
                          context.pColorScheme.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                      iconAlignment: IconAlignment.end,
                      onPressed: () {
                        if (widget.assets.instrumentCategory == 'cash') {
                          PBottomSheet.show(
                            context,
                            title: L10n.tr('choose_bank'),
                            child: SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.7,
                              child: const BankListWidget(),
                            ),
                          );
                          return;
                        }
                        if (widget.assets.instrumentCategory == 'ipo') {
                          PBottomSheet.show(
                            context,
                            child: PortfolioIpoDetailWidget(
                              customerId: widget.selectedAccount,
                            ),
                          );
                          return;
                        }
                        if (widget.assets.instrumentCategory == 'viop_collateral') {
                          router.push(
                            const ViopCollateralRoute(),
                          );
                        }
                        return;
                      },
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.assets.instrumentCategory == 'sgmk'
                                  ? MoneyUtils().fromReadableMoney(MoneyUtils().readableMoney(
                                              widget.assets.overallSubItems.fold(0, (sum, e) => sum + e.amount))) ==
                                          0
                                      ? '-'
                                      : '${MoneyUtils().readableMoney(widget.assets.overallSubItems.fold(0, (sum, e) => sum + e.amount))} ${CurrencyEnum.turkishLira.symbol}'
                                  : widget.isVisible
                                      ? widget.assets.totalAmount == 0
                                          ? '-'
                                          : '${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(widget.assets.totalAmount)}'
                                      : '${CurrencyEnum.turkishLira.symbol}***',
                              style: context.pAppStyle.labelMed14textPrimary,
                            ),
                            const SizedBox(
                              width: Grid.xs,
                            ),
                            widget.isAgreementPage! && widget.assets.instrumentCategory == 'cash'
                                ? const SizedBox(
                                    width: Grid.m,
                                  )
                                : SvgPicture.asset(
                                    ImagesPath.chevron_down,
                                    colorFilter: ColorFilter.mode(
                                      context.pColorScheme.textPrimary,
                                      BlendMode.srcIn,
                                    ),
                                    height: Grid.m,
                                  )
                          ],
                        ),
                        if (widget.assets.instrumentCategory != 'cash' &&
                            widget.assets.instrumentCategory != 'Mevduat' &&
                            widget.assets.instrumentCategory != 'viop_collateral' &&
                            widget.assets.instrumentCategory != 'currency')
                          Padding(
                            padding: const EdgeInsets.only(
                              right: Grid.m + Grid.xxs,
                            ),
                            child: Row(
                              children: [
                                Utils().profitLossPercentWidget(
                                  context: context,
                                  performance: widget.assets.totalAmount - widget.assets.totalPotentialProfitLoss == 0
                                      ? 0
                                      : widget.assets.totalPotentialProfitLoss /
                                          (widget.assets.totalAmount - widget.assets.totalPotentialProfitLoss) *
                                          100,
                                  fontSize: Grid.l / 2,
                                  isVisible: widget.isVisible,
                                ),
                                Text(
                                    widget.isVisible
                                        ? ' (${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(widget.assets.totalPotentialProfitLoss)})'
                                            .formatNegativePriceAndPercentage()
                                        : ' (${CurrencyEnum.turkishLira.symbol}**)',
                                    style: context.pAppStyle.interMediumBase.copyWith(
                                      color: widget.assets.totalPotentialProfitLoss == 0
                                          ? context.pColorScheme.textPrimary
                                          : widget.assets.totalPotentialProfitLoss > 0
                                              ? context.pColorScheme.success
                                              : context.pColorScheme.critical,
                                      fontSize: Grid.s + Grid.xs,
                                    )),
                              ],
                            ),
                          ),
                        if (widget.hasViop && widget.assets.instrumentCategory == 'viop_collateral') ...[
                          Padding(
                            padding: const EdgeInsets.only(
                              right: Grid.m + Grid.xxs,
                            ),
                            child: Text(
                                widget.isVisible
                                    ? ' (${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(_assetsBloc.state.portfolioViop?.totalPotentialProfitLoss ?? 0)})'
                                        .formatNegativePriceAndPercentage()
                                    : ' (${CurrencyEnum.turkishLira.symbol}**)',
                                style: context.pAppStyle.interMediumBase.copyWith(
                                  color: (_assetsBloc.state.portfolioViop?.totalPotentialProfitLoss ?? 0) == 0
                                      ? context.pColorScheme.textPrimary
                                      : (_assetsBloc.state.portfolioViop?.totalPotentialProfitLoss ?? 0) > 0
                                          ? context.pColorScheme.success
                                          : context.pColorScheme.critical,
                                  fontSize: Grid.s + Grid.xs,
                                )),
                          ),
                        ],
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
