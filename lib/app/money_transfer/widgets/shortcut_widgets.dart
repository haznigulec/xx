import 'package:collection/collection.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/app/advices/enum/market_type_enum.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_bloc.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_state.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_bloc.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_event.dart';
import 'package:piapiri_v2/app/markets/model/market_menu.dart';
import 'package:piapiri_v2/app/money_transfer/model/money_transfer_enum.dart';
import 'package:piapiri_v2/app/money_transfer/widgets/bank_list_widget.dart';
import 'package:piapiri_v2/app/money_transfer/widgets/shortcut_button.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_bloc.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_event.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/account_model.dart';
import 'package:piapiri_v2/core/model/alpaca_account_status_enum.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class ShortcutWidgets extends StatefulWidget {
  final bool? isHomePage;
  const ShortcutWidgets({
    super.key,
    this.isHomePage = false,
  });

  @override
  State<ShortcutWidgets> createState() => _ShortcutWidgetsState();
}

class _ShortcutWidgetsState extends State<ShortcutWidgets> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PBlocBuilder<AssetsBloc, AssetsState>(
            bloc: getIt<AssetsBloc>(),
            builder: (context, state) {
              return ShortcutButton(
                title: L10n.tr('para_transferi'),
                imagePath: ImagesPath.moneytransfer,
                onTap: () => _moneyTransferBottomSheet(
                  context,
                  state.capraCollateralInfo?.cashWithdrawable ?? 0,
                  state.capraCollateralInfo?.equity ?? 0,
                ),
              );
            }),
        ShortcutButton(
          /// euro ve sterlin açıldığı zaman tekrar kullanılacak.
          // title: L10n.tr('currency_exchange'),
          title: L10n.tr('usd_exchange'),
          imagePath: ImagesPath.currencybuysell,
          onTap: () {
            _currencyBuySellBottomSheet(context);
          },
        ),
        if (widget.isHomePage!) ..._buildHomePageShortcuts() else ..._buildOtherPageShortcuts(context),
      ],
    );
  }

  void _moneyTransferBottomSheet(
    BuildContext context,
    double? totalUsdBalance,
    double? totalUsdEquity,
  ) {
    List<MoneyTransferEnum> moneyTransferEnumList = !Utils().canTradeAmericanMarket()
        ? MoneyTransferEnum.values.where((e) => e != MoneyTransferEnum.americanExchangesDepositWithdrawal).toList()
        : MoneyTransferEnum.values.toList();

    PBottomSheet.show(
      context,
      title: L10n.tr('para_transferi'),
      titlePadding: const EdgeInsets.only(
        top: Grid.m,
      ),
      child: Column(
        children: moneyTransferEnumList.map((type) {
          return InkWell(
            onTap: () {
              if (type == MoneyTransferEnum.depositMoneyAccount) {
                PBottomSheet.show(
                  context,
                  title: L10n.tr('choose_bank'),
                  titlePadding: const EdgeInsets.only(
                    top: Grid.m,
                  ),
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.7,
                    child: const BankListWidget(),
                  ),
                );
                return;
              }
              if (type == MoneyTransferEnum.withdrawMoneyAccount) {
                /// Farklı para birimleri eklenene kadar tıklandığında direkt ekrana yönlendirmesi için yorum satırına alındı.
                // PBottomSheet.show(
                //   context,
                //   title: L10n.tr('para_birimi'),
                //   child: const CurrencyWidget(),
                // );
                router.push(
                  WithdrawMoneyFromAccountRoute(
                    currencyType: CurrencyEnum.turkishLira,
                  ),
                );
                return;
              }
              if (type == MoneyTransferEnum.transferMoneyBetweenAccounts) {
                router.push(
                  const MoneyTransferBetweenAccountRoute(),
                );
                return;
              }
              if (type == MoneyTransferEnum.transferOfSharesFromAnotherInstitution) {
                router.push(
                  const VirementRoute(),
                );
                return;
              } else if (type == MoneyTransferEnum.americanExchangesDepositWithdrawal) {
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
                  return;
                }

                _checkCapraAccount(context);

                return;
              } else if (type == MoneyTransferEnum.viopDepositWithdrawalCollateral) {
                router.push(
                  const ViopCollateralRoute(),
                );
                return;
              }
            },
            child: Column(
              children: [
                const SizedBox(
                  height: Grid.m,
                ),
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      padding: const EdgeInsets.all(
                        Grid.xs + Grid.xxs,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(25),
                        ),
                        color: context.pColorScheme.secondary,
                      ),
                      child: SvgPicture.asset(
                        type.imagePath,
                        width: 12,
                        height: 12,
                        colorFilter: ColorFilter.mode(
                          context.pColorScheme.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: Grid.s,
                    ),
                    Text(
                      L10n.tr(type.name),
                      style: context.pAppStyle.labelReg16textPrimary,
                    ),
                    const Spacer(),
                    SvgPicture.asset(
                      ImagesPath.chevron_right,
                      width: 14,
                      height: 14,
                      colorFilter: ColorFilter.mode(
                        context.pColorScheme.textPrimary,
                        BlendMode.srcIn,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: Grid.m,
                ),
                if (type != MoneyTransferEnum.transferOfSharesFromAnotherInstitution) const PDivider(),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void _checkCapraAccount(BuildContext context) {
    AlpacaAccountStatusEnum? alpacaAccountStatus;
    getIt<GlobalAccountOnboardingBloc>().add(
      AccountSettingStatusEvent(
        succesCallback: (accountSettingStatus) {
          setState(() {
            alpacaAccountStatus = AlpacaAccountStatusEnum.values.firstWhereOrNull(
              (e) => e.value == accountSettingStatus.accountStatus,
            );
          });
          if (alpacaAccountStatus != AlpacaAccountStatusEnum.active) {
            PBottomSheet.showError(
              context,
              content: alpacaAccountStatus == null
                  ? L10n.tr('alpaca_account_not_active')
                  : L10n.tr('portfolio.${alpacaAccountStatus!.descriptionKey}'),
              showFilledButton: true,
              showOutlinedButton: true,
              filledButtonText: alpacaAccountStatus == null ? L10n.tr('get_started') : L10n.tr('go_agreements'),
              outlinedButtonText: L10n.tr('afterwards'),
              onOutlinedButtonPressed: () => router.maybePop(),
              onFilledButtonPressed: () async {
                Navigator.of(context).pop();
                router.push(
                  const GlobalAccountOnboardingRoute(),
                );
              },
            );
          } else {
            router.push(
              const UsBalanceRoute(),
            );
          }
        },
      ),
    );
  }

  List<Widget> _buildHomePageShortcuts() {
    return [
      ShortcutButton(
        title: L10n.tr('bist_analysis_portfolio'),
        imagePath: ImagesPath.portfoy,
        onTap: _goBistAnalysis,
      ),
      ShortcutButton(
        title: L10n.tr('fund_portfolios'),
        imagePath: ImagesPath.cash,
        onTap: _goFundPortfolio,
      ),
      ShortcutButton(
        title: L10n.tr('daily_advices'),
        imagePath: ImagesPath.suggestion,
        onTap: _goAdvices,
      ),
    ];
  }

  List<Widget> _buildOtherPageShortcuts(BuildContext context) {
    return [
      ShortcutButton(
        title: L10n.tr('bank_statement'),
        imagePath: ImagesPath.file,
        onTap: _goAccountStatement,
      ),
      ShortcutButton(
        title: L10n.tr('portfolio_transaction_history'),
        imagePath: ImagesPath.history,
        onTap: _goTransactionHistory,
      ),
      ShortcutButton(
        title: L10n.tr('profit_tracking'),
        imagePath: ImagesPath.goal,
        onTap: _goProfitTracking,
      ),
    ];
  }

  void _goFundPortfolio() {
    getIt<TabBloc>().add(
      const TabChangedEvent(
        tabIndex: 2,
        marketMenu: MarketMenu.investmentFund,
        marketMenuTabIndex: 1,
      ),
    );
  }

  void _goBistAnalysis() {
    getIt<TabBloc>().add(
      const TabChangedEvent(
        tabIndex: 2,
        marketMenu: MarketMenu.istanbulStockExchange,
        marketMenuTabIndex: 3,
      ),
    );
  }

  void _goAdvices() {
    router.push(
      BistAnalysisAllAdvicesRoute(
        mainGroup: MarketTypeEnum.marketBist.value,
      ),
    );
  }

  void _goTransactionHistory() {
    router.push(
      const TransactionHistoryGeneralRoute(),
    );
  }

  void _currencyBuySellBottomSheet(
    BuildContext context,
  ) {
    /// İleri ki fazlarda İngiliz Sterlini ve Euro döviz cinsi olarak ekelnebileceğinden,
    ///  şimdilik yorum satırına alınarak uygulama içerisinden kaldırıldı.

    // PBottomSheet.show(
    //   context,
    //   title: L10n.tr('currency_type'),
    //   child: const CurrencyTypeListWidget(),
    // );

    List<AccountModel> accountsByCurrency = [];

    accountsByCurrency = UserModel.instance.accounts
        .where(
          (element) => element.currency == CurrencyEnum.dollar,
        )
        .toList();

    if (accountsByCurrency.isEmpty) {
      Utils().showCustomerServiceCallAlert(
        context,
        L10n.tr(
          'no_usd_account_desc',
          args: ['USD'],
        ),
      );
      return;
    }

    router.push(
      CurrencyBuySellRoute(
        currencyType: CurrencyEnum.dollar,
        accountsByCurrency: accountsByCurrency,
      ),
    );
  }

  void _goAccountStatement() {
    router.push(
      const AccountStatementRoute(),
    );
  }

  void _goProfitTracking() {
    router.push(
      const ProfitRoute(),
    );
  }
}
