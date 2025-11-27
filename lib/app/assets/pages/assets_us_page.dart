import 'package:collection/collection.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/charts/stacked_bar_chart.dart';
import 'package:piapiri_v2/common/widgets/charts/model/stacked_bar_model.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_bloc.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_event.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_state.dart';
import 'package:piapiri_v2/app/assets/model/us_capra_summary_model.dart';
import 'package:piapiri_v2/app/assets/widgets/asset_us_collateral_bottom_sheet.dart';
import 'package:piapiri_v2/app/assets/widgets/asset_us_equity_bottom_sheet.dart';
import 'package:piapiri_v2/app/assets/widgets/shimmer_asset_us_widget.dart';
import 'package:piapiri_v2/app/create_us_order/widgets/daily_transaction_info_widget.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_bloc.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_event.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_state.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_event.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/info_widget.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/alpaca_account_status_enum.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

import '../../../common/utils/utils.dart';

class AssetUsPage extends StatefulWidget {
  final bool isVisible;
  const AssetUsPage({
    super.key,
    required this.isVisible,
  });

  @override
  State<AssetUsPage> createState() => _AssetUsPageState();
}

class _AssetUsPageState extends State<AssetUsPage> {
  final AssetsBloc _assetsBloc = getIt<AssetsBloc>();
  final UsEquityBloc _usEquityBloc = getIt<UsEquityBloc>();
  final GlobalAccountOnboardingBloc _globalOnboardingBloc = getIt<GlobalAccountOnboardingBloc>();

  num _totalQuantity = 0;
  double _totalAmount = 0;
  double _exchangeValue = 0;
  AlpacaAccountStatusEnum? _alpacaAccountStatus;
  late UserModel _userModel;
  bool _isAlpacaStatusInitialized = false;
  bool _hasDailyTransactionLimit = true;
  int _dailyTransactionLimit = 0;

  @override
  void initState() {
    _userModel = UserModel.instance;
    _calculateCapraAssets();
    if (_alpacaAccountStatus != AlpacaAccountStatusEnum.active) {
      _globalOnboardingBloc.add(
        AccountSettingStatusEvent(
          succesCallback: (accountSettingStatus) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) {
                setState(() {
                  _isAlpacaStatusInitialized = true;
                  _alpacaAccountStatus = AlpacaAccountStatusEnum.values.firstWhereOrNull(
                    (e) => e.value == accountSettingStatus.accountStatus,
                  );
                });
                if (_alpacaAccountStatus == AlpacaAccountStatusEnum.active) {
                  _assetsBloc.add(
                    GetCapraCollateralInfoEvent(),
                  );
                }
              },
            );
          },
          errorCallback: () {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) {
                setState(() {
                  _isAlpacaStatusInitialized = true;
                });
              },
            );
          },
        ),
      );
    }

    if (_userModel.alpacaAccountStatus) {
      _assetsBloc.add(
        GetCapraPortfolioSummaryEvent(),
      );
      _assetsBloc.add(
        GetCapraCollateralInfoEvent(),
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<GlobalAccountOnboardingBloc, GlobalAccountOnboardingState>(
      bloc: _globalOnboardingBloc,
      builder: (context, globalAccountOnboardingState) {
        return PBlocBuilder<AssetsBloc, AssetsState>(
          bloc: _assetsBloc,
          builder: (context, assetsState) {
            if (!_isAlpacaStatusInitialized || globalAccountOnboardingState.isLoading) {
              return const ShimmerAssetUsWidget();
            }

            if (_alpacaAccountStatus == AlpacaAccountStatusEnum.active) {
              if (assetsState.portfolioSummaryModel != null &&
                  assetsState.portfolioSummaryModel?.overallItemGroups != null) {
                _totalQuantity = assetsState.portfolioSummaryModel!.overallItemGroups![0].overallItems?.fold(
                      0,
                      (previousValue, element) => previousValue! + (element.qty ?? 0),
                    ) ??
                    0;

                _totalAmount = (assetsState.portfolioSummaryModel!.overallItemGroups!)
                        .fold(0, (previousValue, element) => previousValue! + (element.totalAmount!)) ??
                    0;
              }

              _exchangeValue = (assetsState.portfolioSummaryModel?.overallItemGroups ?? [])
                  .fold(0, (previousValue, element) => previousValue + (element.exchangeValue ?? 0));

              final List<UsOverallItemModel> overallItemGroups = [];
              final List<UsOverallItemModel> commingOverallItemGroups =
                  assetsState.portfolioSummaryModel?.overallItemGroups ?? [];
              if (commingOverallItemGroups.isNotEmpty) {
                for (var group in commingOverallItemGroups) {
                  if (group.ratio?.abs() != 0 || group.instrumentCategory != 'equity') {
                    overallItemGroups.add(group);
                  }
                }
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          L10n.tr('total_asset_us'),
                          style: context.pAppStyle.labelReg14textSecondary,
                        ),
                        Expanded(
                          child: RichText(
                            textAlign: TextAlign.end,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: widget.isVisible
                                      ? '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(_totalAmount)}'
                                      : '${CurrencyEnum.dollar.symbol}****',
                                  style: context.pAppStyle.labelMed14textPrimary,
                                ),
                                TextSpan(
                                  text: widget.isVisible
                                      ? ' ≈${CurrencyEnum.turkishLira.symbol}${MoneyUtils().readableMoney(_exchangeValue)}'
                                      : '${CurrencyEnum.turkishLira.symbol}****',
                                  style: context.pAppStyle.labelMed14textTeritary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: Grid.s + Grid.xs,
                    ),
                    StackedBarChart(
                      charDataList: _generateChartModel(
                        overallItemGroups.reversed.toList(),
                      ),
                    ),
                    const SizedBox(
                      height: Grid.l,
                    ),
                    ListView.separated(
                      itemCount: overallItemGroups.length,
                      separatorBuilder: (context, index) => const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: Grid.s + Grid.xs,
                        ),
                        child: Divider(),
                      ),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        UsOverallItemModel portfolioSummary = overallItemGroups.reversed.toList()[index];
                        bool isEquity = portfolioSummary.instrumentCategory == 'equity';
                        return InkWell(
                          onTap: () {
                            if (isEquity) {
                              PBottomSheet.show(
                                context,
                                titlePadding: const EdgeInsets.only(
                                  top: Grid.m,
                                ),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight: MediaQuery.sizeOf(context).height * 0.7,
                                  ),
                                  child: AssetUsEquityBottomSheet(
                                    portfolioSummary: portfolioSummary,
                                    totalQuantity:
                                        _alpacaAccountStatus == AlpacaAccountStatusEnum.active ? _totalQuantity : 1,
                                    tlExchangeRate: assetsState.portfolioSummaryModel!.tlExchangeRate ?? 0,
                                    isVisible: widget.isVisible,
                                  ),
                                ),
                              );
                              return;
                            } else {
                              if (portfolioSummary.totalAmount == null || portfolioSummary.totalAmount == 0) {
                                if (UserModel.instance.accounts
                                    .where((element) => element.currency == CurrencyEnum.dollar)
                                    .toList()
                                    .isEmpty) {
                                  Utils().showCustomerServiceCallAlert(
                                    context,
                                    L10n.tr(
                                      'no_usd_account_desc',
                                      args: ['USD'],
                                    ),
                                  );
                                } else {
                                  router.push(
                                    const UsBalanceRoute(),
                                  );
                                }
                                return;
                              } else {
                                PBottomSheet.show(
                                  context,
                                  child: AssetUsCollateralBottomSheet(
                                    portfolioSummary: portfolioSummary,
                                    isVisible: widget.isVisible,
                                  ),
                                );

                                return;
                              }
                            }
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 30,
                                width: 5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: overallItemGroups.length == 1 && !(portfolioSummary.ratio != 0)
                                      ? context.pColorScheme.assetColors.last
                                      : context.pColorScheme.assetColors.skip(index).first,
                                ),
                              ),
                              const SizedBox(
                                width: Grid.s,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    L10n.tr('american_stock_exchanges_${portfolioSummary.instrumentCategory ?? ''}'),
                                    style: context.pAppStyle.labelReg14textPrimary,
                                  ),
                                  Text(
                                    widget.isVisible
                                        ? '%${MoneyUtils().readableMoney(
                                            portfolioSummary.ratio ?? 0,
                                          )}'
                                        : '%****',
                                    style: context.pAppStyle.labelMed12textSecondary,
                                  ),
                                ],
                              ),
                              const Spacer(),
                              if (!isEquity &&
                                  (portfolioSummary.totalAmount == null || portfolioSummary.totalAmount == 0))
                                _transferUsdWidget()
                              else
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          widget.isVisible
                                              ? '${CurrencyEnum.dollar.symbol}${MoneyUtils().readableMoney(portfolioSummary.totalAmount!)}'
                                              : '${CurrencyEnum.dollar.symbol}****',
                                          style: context.pAppStyle.labelMed14textPrimary,
                                        ),
                                        const SizedBox(
                                          width: Grid.xs,
                                        ),
                                        SvgPicture.asset(
                                          ImagesPath.chevron_down,
                                          width: Grid.m - Grid.xxs,
                                          height: Grid.m - Grid.xxs,
                                          colorFilter: ColorFilter.mode(
                                            context.pColorScheme.textPrimary,
                                            BlendMode.srcIn,
                                          ),
                                        )
                                      ],
                                    ),
                                    if (portfolioSummary.totalPotentialProfitLoss != null &&
                                        portfolioSummary.totalPotentialProfitLoss != 0)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: Grid.m,
                                        ),
                                        child: Row(
                                          children: [
                                            Utils().profitLossPercentWidget(
                                              context: context,
                                              performance: portfolioSummary.totalPotentialProfitLoss! /
                                                  (portfolioSummary.totalAmount! -
                                                      portfolioSummary.totalPotentialProfitLoss!) *
                                                  100,
                                              fontSize: Grid.l / 2,
                                              isVisible: widget.isVisible,
                                            ),
                                            Builder(builder: (context) {
                                              double amount = portfolioSummary.totalPotentialProfitLoss!;
                                              String amountTxt = MoneyUtils().readableMoney(amount.abs());
                                              return Text(
                                                  widget.isVisible
                                                      ? ' (${amount < 0 ? '-' : ''}${CurrencyEnum.dollar.symbol}$amountTxt)'
                                                      : '(${CurrencyEnum.dollar.symbol}****)',
                                                  style: context.pAppStyle.interMediumBase.copyWith(
                                                    color: portfolioSummary.totalPotentialProfitLoss! == 0
                                                        ? context.pColorScheme.textPrimary
                                                        : portfolioSummary.totalPotentialProfitLoss! > 0
                                                            ? context.pColorScheme.success
                                                            : context.pColorScheme.critical,
                                                    fontSize: Grid.s + Grid.xs,
                                                  ));
                                            }),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                    if (_hasDailyTransactionLimit) ...[
                      const SizedBox(
                        height: Grid.l,
                      ),
                      InkWell(
                        child: PInfoWidget(
                          leadingIcon: false,
                          iconColor: context.pColorScheme.textSecondary,
                          iconPath: ImagesPath.info,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          textWidget: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: L10n.tr(
                                      'us_daily_transaction_limit_info',
                                    ),
                                    style: context.pAppStyle.labelReg12textPrimary,
                                  ),
                                  TextSpan(
                                    text: ' $_dailyTransactionLimit/3',
                                    style: context.pAppStyle.labelMed12textPrimary,
                                  ),
                                ],
                              )),
                          infoText: '',
                        ),
                        onTap: () {
                          PBottomSheet.show(
                            context,
                            child: const DailyTransactionInfoWidget(),
                          );
                        },
                      ),
                      const SizedBox(
                        height: Grid.s + Grid.xs,
                      ),
                    ],
                  ],
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  L10n.tr('welcome_American_exchange'),
                  style: context.pAppStyle.labelMed18textPrimary,
                ),
                const SizedBox(
                  height: Grid.s,
                ),
                Text(
                  _alpacaAccountStatus == null
                      ? L10n.tr('start_trading_American_exchange')
                      : L10n.tr('portfolio.${_alpacaAccountStatus!.descriptionKey}'),
                  style: context.pAppStyle.labelReg16textPrimary,
                ),
                const SizedBox(
                  height: Grid.m,
                ),
                SizedBox(
                  height: 33,
                  child: PButtonWithIcon(
                    text: _alpacaAccountStatus == null ? L10n.tr('get_started') : L10n.tr('go_agreements'),
                    sizeType: PButtonSize.small,
                    icon: SvgPicture.asset(
                      ImagesPath.arrow_up_right,
                      width: 17,
                      height: 17,
                      colorFilter: ColorFilter.mode(
                        context.pColorScheme.lightHigh,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () async {
                      await router.push(const GlobalAccountOnboardingRoute());
                      if (_alpacaAccountStatus != AlpacaAccountStatusEnum.active) {
                        _globalOnboardingBloc.add(
                          AccountSettingStatusEvent(
                            succesCallback: (accountSettingStatus) {
                              setState(() {
                                _alpacaAccountStatus = AlpacaAccountStatusEnum.values.firstWhereOrNull(
                                  (e) => e.value == accountSettingStatus.accountStatus,
                                );
                              });
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: Grid.xl),
              ],
            );
          },
        );
      },
    );
  }

  List<StackedBarModel> _generateChartModel(List<UsOverallItemModel> data) {
    List<StackedBarModel> chartData = [];

    for (var i = 0; i < data.length; i++) {
      if (data[i].ratio?.abs() != 0) {
        chartData.add(
          StackedBarModel(
            percent: data[i].ratio!.abs(),
            color: context.pColorScheme.assetColors.skip(i).first,
          ),
        );
      }
    }

    return chartData;
  }

  Widget _transferUsdWidget() {
    if (Utils().canTradeAmericanMarket()) {
      return PCustomPrimaryTextButton(
        text: L10n.tr('transfer_usd'),
        iconSource: ImagesPath.arrow_up_right,
        iconAlignment: IconAlignment.end,
        style: context.pAppStyle.labelMed14primary,
        onPressed: () {
          if (UserModel.instance.accounts
              .where((element) => element.currency == CurrencyEnum.dollar)
              .toList()
              .isEmpty) {
            Utils().showCustomerServiceCallAlert(
              context,
              L10n.tr(
                'no_usd_account_desc',
                args: ['USD'],
              ),
            );
          } else {
            router.push(
              const UsBalanceRoute(),
            );
          }
        },
      );
    } else {
      return const SizedBox();
    }
  }

  void _calculateCapraAssets() {
    double totalAssets = 0;
    if (_assetsBloc.state.portfolioSummaryModel?.overallItemGroups == null) return;
    for (UsOverallItemModel asset in _assetsBloc.state.portfolioSummaryModel!.overallItemGroups!) {
      totalAssets += asset.totalAmount ?? 0;
    }

    _hasDailyTransactionLimit = totalAssets < 25000;

    if (_hasDailyTransactionLimit) {
      _usEquityBloc.add(GetDailyTransactionEvent(
        callback: (int dailyTransaction) => setState(() {
          _dailyTransactionLimit = dailyTransaction;
        }),
      ));
    }
  }
}
