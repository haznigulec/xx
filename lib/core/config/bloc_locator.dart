import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piapiri_v2/app/account_closure/bloc/account_closure_bloc.dart';
import 'package:piapiri_v2/app/account_closure/repository/account_closure_repository_impl.dart';
import 'package:piapiri_v2/app/account_statement/bloc/account_statement_bloc.dart';
import 'package:piapiri_v2/app/account_statement/repository/account_statement_repository_impl.dart';
import 'package:piapiri_v2/app/advices/bloc/advices_bloc.dart';
import 'package:piapiri_v2/app/advices/repository/advices_repository_impl.dart';
import 'package:piapiri_v2/app/agreements/bloc/agreements_bloc.dart';
import 'package:piapiri_v2/app/agreements/repository/agreements_repository_impl.dart';
import 'package:piapiri_v2/app/alarm/bloc/alarm_bloc.dart';
import 'package:piapiri_v2/app/alarm/repository/alarm_repository_impl.dart';
import 'package:piapiri_v2/app/app_settings/bloc/app_settings_bloc.dart';
import 'package:piapiri_v2/app/app_settings/repository/settings_repository_impl.dart';
import 'package:piapiri_v2/app/assets/bloc/assets_bloc.dart';
import 'package:piapiri_v2/app/assets/repository/assets_repository_impl.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/app/auth/repository/auth_repository_impl.dart';
import 'package:piapiri_v2/app/avatar/bloc/avatar_bloc.dart';
import 'package:piapiri_v2/app/avatar/repository/avatar_repository_impl.dart';
import 'package:piapiri_v2/app/balance/bloc/balance_bloc.dart';
import 'package:piapiri_v2/app/balance/repository/balance_repository_impl.dart';
import 'package:piapiri_v2/app/banner/bloc/banner_bloc.dart';
import 'package:piapiri_v2/app/banner/repository/banner_repository_impl.dart';
import 'package:piapiri_v2/app/booklet/bloc/booklet_bloc.dart';
import 'package:piapiri_v2/app/brokerage_distribution/bloc/brokerage_bloc.dart';
import 'package:piapiri_v2/app/brokerage_distribution/repository/brokerage_repository_impl.dart';
import 'package:piapiri_v2/app/campaigns/bloc/campaigns_bloc.dart';
import 'package:piapiri_v2/app/campaigns/repository/campaigns_repository_impl.dart';
import 'package:piapiri_v2/app/contracts/bloc/contracts_bloc.dart';
import 'package:piapiri_v2/app/contracts/repository/contracts_repository_impl.dart';
import 'package:piapiri_v2/app/create_order/bloc/create_orders_bloc.dart';
import 'package:piapiri_v2/app/create_order/repository/create_orders_repository_impl.dart';
import 'package:piapiri_v2/app/create_us_order/bloc/create_us_orders_bloc.dart';
import 'package:piapiri_v2/app/create_us_order/repository/create_us_orders_repository_impl.dart';
import 'package:piapiri_v2/app/crypto/bloc/crypto_bloc.dart';
import 'package:piapiri_v2/app/crypto/repository/crypto_repository_impl.dart';
import 'package:piapiri_v2/app/currency_buy_sell/bloc/currency_buy_sell_bloc.dart';
import 'package:piapiri_v2/app/currency_buy_sell/repository/currency_buy_sell_repository_impl.dart';
import 'package:piapiri_v2/app/depth/bloc/depth_bloc.dart';
import 'package:piapiri_v2/app/dividend/bloc/dividend_bloc.dart';
import 'package:piapiri_v2/app/dividend/repository/dividend_repository_impl.dart';
import 'package:piapiri_v2/app/economic_calender/bloc/economic_calender_bloc.dart';
import 'package:piapiri_v2/app/economic_calender/repository/economic_calender_repository_impl.dart';
import 'package:piapiri_v2/app/education/bloc/education_bloc.dart';
import 'package:piapiri_v2/app/education/repository/education_repository_impl.dart';
import 'package:piapiri_v2/app/enqura/bloc/enqura_bloc.dart';
import 'package:piapiri_v2/app/enqura/repository/enqura_repository_impl.dart';
import 'package:piapiri_v2/app/equity/bloc/equity_bloc.dart';
import 'package:piapiri_v2/app/equity/repository/equity_repository_impl.dart';
import 'package:piapiri_v2/app/eurobond/bloc/eurobond_bloc.dart';
import 'package:piapiri_v2/app/eurobond/repository/eurobond_repository_impl.dart';
import 'package:piapiri_v2/app/favorite_lists/bloc/favorite_list_bloc.dart';
import 'package:piapiri_v2/app/favorite_lists/repository/favorite_list_repository_impl.dart';
import 'package:piapiri_v2/app/fund/bloc/fund_bloc.dart';
import 'package:piapiri_v2/app/fund/repository/fund_repository_impl.dart';
import 'package:piapiri_v2/app/global_account_onboarding/bloc/global_account_onboarding_bloc.dart';
import 'package:piapiri_v2/app/global_account_onboarding/repository/global_account_onboarding_repository_impl.dart';
import 'package:piapiri_v2/app/income/bloc/income_bloc.dart';
import 'package:piapiri_v2/app/income/repository/income_repository_impl.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_bloc.dart';
import 'package:piapiri_v2/app/ipo/repository/ipo_repository_impl.dart';
import 'package:piapiri_v2/app/license/bloc/license_bloc.dart';
import 'package:piapiri_v2/app/license/repository/license_repository_impl.dart';
import 'package:piapiri_v2/app/market_reviews/bloc/reports_bloc.dart';
import 'package:piapiri_v2/app/market_reviews/repository/reports_repository_impl.dart';
import 'package:piapiri_v2/app/member/bloc/member_bloc.dart';
import 'package:piapiri_v2/app/member/repository/member_repository_impl.dart';
import 'package:piapiri_v2/app/money_transfer/bloc/money_transfer_bloc.dart';
import 'package:piapiri_v2/app/money_transfer/repository/money_transfer_repository_impl.dart';
import 'package:piapiri_v2/app/news/bloc/news_bloc.dart';
import 'package:piapiri_v2/app/news/repository/news_repository_impl.dart';
import 'package:piapiri_v2/app/notifications/bloc/notifications_bloc.dart';
import 'package:piapiri_v2/app/notifications/repository/notification_repository_impl.dart';
import 'package:piapiri_v2/app/orders/bloc/orders_bloc.dart';
import 'package:piapiri_v2/app/orders/repository/orders_repository_impl.dart';
import 'package:piapiri_v2/app/paride_devices/bloc/paired_devices_bloc.dart';
import 'package:piapiri_v2/app/paride_devices/repository/paired_devices_repository_impl.dart';
import 'package:piapiri_v2/app/parity/bloc/parity_bloc.dart';
import 'package:piapiri_v2/app/parity/repository/parity_repository_impl.dart';
import 'package:piapiri_v2/app/pivot_analysis/bloc/pivot_bloc.dart';
import 'package:piapiri_v2/app/pivot_analysis/repository/pivot_repository_impl.dart';
import 'package:piapiri_v2/app/profile/bloc/profile_referance_bloc.dart';
import 'package:piapiri_v2/app/profile/repository/profile_referance_repository_impl.dart';
import 'package:piapiri_v2/app/profit/bloc/profit_bloc.dart';
import 'package:piapiri_v2/app/profit/repository/profit_repository_impl.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/bloc/quick_portfolio_bloc.dart';
import 'package:piapiri_v2/app/quick_portfolio.dart/repository/quick_portfolio_repository_impl.dart';
import 'package:piapiri_v2/app/review/bloc/review_bloc.dart';
import 'package:piapiri_v2/app/review/repository/review_repository_impl.dart';
import 'package:piapiri_v2/app/robo_signal/bloc/robo_signal_bloc.dart';
import 'package:piapiri_v2/app/robo_signal/repository/robo_signal_repository_impl.dart';
import 'package:piapiri_v2/app/search_symbol/bloc/symbol_search_bloc.dart';
import 'package:piapiri_v2/app/search_symbol/repository/symbol_search_repository_impl.dart';
import 'package:piapiri_v2/app/sectors/bloc/sectors_bloc.dart';
import 'package:piapiri_v2/app/sectors/repository/sectors_repository_impl.dart';
import 'package:piapiri_v2/app/stage_analysis/bloc/stage_analysis_bloc.dart';
import 'package:piapiri_v2/app/stage_analysis/repository/stage_analysis_repository_impl.dart';
import 'package:piapiri_v2/app/symbol_chart/bloc/symbol_chart_bloc.dart';
import 'package:piapiri_v2/app/symbol_chart/repository/symbol_chart_repository_impl.dart';
import 'package:piapiri_v2/app/ticket/bloc/ticket_bloc.dart';
import 'package:piapiri_v2/app/ticket/repository/ticket_repository_impl.dart';
import 'package:piapiri_v2/app/transaction_history/bloc/transaction_history_bloc.dart';
import 'package:piapiri_v2/app/transaction_history/repository/transaction_history_repository_impl.dart';
import 'package:piapiri_v2/app/twitter/bloc/twitter_bloc.dart';
import 'package:piapiri_v2/app/twitter/repository/twitter_repository_impl.dart';
import 'package:piapiri_v2/app/us_balance/bloc/us_balance_bloc.dart';
import 'package:piapiri_v2/app/us_balance/repository/us_balance_repository_impl.dart';
import 'package:piapiri_v2/app/us_equity/bloc/us_equity_bloc.dart';
import 'package:piapiri_v2/app/us_equity/repository/us_equity_repository_impl.dart';
import 'package:piapiri_v2/app/viop/bloc/viop_bloc.dart';
import 'package:piapiri_v2/app/viop/repository/viop_repository_impl.dart';
import 'package:piapiri_v2/app/warrant/bloc/warrant_bloc.dart';
import 'package:piapiri_v2/app/warrant/repository/warrant_repository_impl.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/app_info/repository/app_info_respository_impl.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/bloc/language/bloc/language_bloc.dart';
import 'package:piapiri_v2/core/bloc/language/repository/language_respository_impl.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/tab/tab_bloc.dart';
import 'package:piapiri_v2/core/bloc/time/time_bloc.dart';
import 'package:piapiri_v2/core/config/notification_handler.dart';
import 'package:piapiri_v2/core/config/notification_handler_impl.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class BlocLocator {
  static void init() async {
    getIt.registerLazySingleton<TabBloc>(
      () => TabBloc(),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<SymbolBloc>(
      () => SymbolBloc(),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<AppInfoBloc>(
      () => AppInfoBloc(
        appInfoRepository: AppInfoRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<MatriksBloc>(
      () => MatriksBloc(),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<NotificationHandler>(
      () => NotificationHandlerImpl(),
    );
    getIt.registerLazySingleton<TimeBloc>(
      () => TimeBloc(),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<ReviewBloc>(
      () => ReviewBloc(
        reviewRepository: ReviewRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<NewsBloc>(
      () => NewsBloc(
        newsRepository: NewsRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<EducationBloc>(
      () => EducationBloc(
        educationRepository: EducationRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<CryptoBloc>(
      () => CryptoBloc(
        cryptoRepository: CryptoRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        authRepository: AuthRepositoryImpl(),
        appInfoRepository: AppInfoRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<EconomicCalenderBloc>(
      () => EconomicCalenderBloc(
        economicCalenderRepository: EconomicCalenderRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<AgreementsBloc>(
      () => AgreementsBloc(
        agreementsRepository: AgreementsRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<AlarmBloc>(
      () => AlarmBloc(
        alarmRepository: AlarmRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<AdvicesBloc>(
      () => AdvicesBloc(
        advicesRepository: AdvicesRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<RoboSignalBloc>(
      () => RoboSignalBloc(
        robosignalRepository: RoboSignalRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<ProfitBloc>(
      () => ProfitBloc(
        profitRepository: ProfitRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<QuickPortfolioBloc>(
      () => QuickPortfolioBloc(
        quickPortfolioRepository: QuickPortfolioRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<NotificationsBloc>(
      () => NotificationsBloc(
        notificationsRepository: NotificationRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<IpoBloc>(
      () => IpoBloc(
        ipoRepository: IpoRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<TicketBloc>(
      () => TicketBloc(
        ticketRepository: TicketRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<TransactionHistoryBloc>(
      () => TransactionHistoryBloc(
        transactionHistoryRepository: TransactionHistoryRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<LicenseBloc>(
      () => LicenseBloc(
        licensesRepository: LicensesRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<CampaignsBloc>(
      () => CampaignsBloc(
        campaignsRepository: CampaignsRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<AssetsBloc>(
      () => AssetsBloc(
        assetsRepository: AssetsRepositoryImpl(),
        ordersRepository: OrdersRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<ParityBloc>(
      () => ParityBloc(
        parityRepository: ParityRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<AccountStatementBloc>(
      () => AccountStatementBloc(
        accountStatementRepository: AccountStatementRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<MoneyTransferBloc>(
      () => MoneyTransferBloc(
        moneyTransferRepository: MoneyTransferRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<EquityBloc>(
      () => EquityBloc(
        equityRepository: EquityRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<EuroBondBloc>(
      () => EuroBondBloc(
        eurobondRepository: EurobondRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<ViopBloc>(
      () => ViopBloc(
        viopRepository: ViopRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );

    getIt.registerLazySingleton<TwitterBloc>(
      () => TwitterBloc(
        twitterRepository: TwitterRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<FavoriteListBloc>(
      () => FavoriteListBloc(
        favoriteListRepository: FavoriteListRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<WarrantBloc>(
      () => WarrantBloc(
        warrantRepository: WarrantRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<MemberBloc>(
      () => MemberBloc(
        memberRepository: MemberRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<PivotBloc>(
      () => PivotBloc(
        pivotRepository: PivotRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<BalanceBloc>(
      () => BalanceBloc(
        balanceRepository: BalanceRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<IncomeBloc>(
      () => IncomeBloc(
        incomeRepository: IncomeRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );

    getIt.registerLazySingleton<StageAnalysisBloc>(
      () => StageAnalysisBloc(
        stageAnalysisRepository: StageAnalysisRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );

    getIt.registerLazySingleton<FundBloc>(
      () => FundBloc(
        fundRepository: FundRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );

    getIt.registerLazySingleton<AvatarBloc>(
      () => AvatarBloc(
        avatarRepository: AvatarRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );

    getIt.registerLazySingleton<OrdersBloc>(
      () => OrdersBloc(
        ordersRepository: OrdersRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );

    getIt.registerLazySingleton<CreateOrdersBloc>(
      () => CreateOrdersBloc(
        createOrdersRepository: CreateOrdersRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<CreateUsOrdersBloc>(
      () => CreateUsOrdersBloc(
        createUsOrdersRepository: CreateUsOrdersRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );

    getIt.registerLazySingleton<AccountClosureBloc>(
      () => AccountClosureBloc(
        accountClosureRepository: AccountClosureRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );

    getIt.registerLazySingleton<SymbolSearchBloc>(
      () => SymbolSearchBloc(
        symbolSearchRepository: SymbolSearchRepositoryImpl(),
        ordersRepository: OrdersRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );

    getIt.registerLazySingleton<ContractsBloc>(
      () => ContractsBloc(
        contractsRepository: ContractsRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );

    getIt.registerLazySingleton<BrokerageBloc>(
      () => BrokerageBloc(
        brokerageRepository: BrokerageRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );

    getIt.registerLazySingleton<AppSettingsBloc>(
      () => AppSettingsBloc(
        settingsRepository: SettingsRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );

    getIt.registerLazySingleton<GlobalAccountOnboardingBloc>(
      () => GlobalAccountOnboardingBloc(
        globalAccountOnboardingRepository: GlobalAccountOnboardingRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<LanguageBloc>(
      () => LanguageBloc(
        languageRepository: LanguageRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<BannerBloc>(
      () => BannerBloc(
        bannerRepository: BannerRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<UsEquityBloc>(
      () => UsEquityBloc(
        usEquityRepository: UsEquityRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<UsBalanceBloc>(
      () => UsBalanceBloc(
        usBalanceRepository: UsBalanceRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<CurrencyBuySellBloc>(
      () => CurrencyBuySellBloc(
        currencyBuySellRepository: CurrencyBuySellRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<SectorsBloc>(
      () => SectorsBloc(
        sectorsRepository: SectorsRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<ReportsBloc>(
      () => ReportsBloc(
        reportsRepository: ReportsRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<SymbolChartBloc>(
      () => SymbolChartBloc(
        symbolChartRepository: SymbolChartRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<DividendBloc>(
      () => DividendBloc(
        dividendRepository: DividendRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<EnquraBloc>(
      () => EnquraBloc(
        enquraRepository: EnquraRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<ProfileReferanceBloc>(
      () => ProfileReferanceBloc(
        profileReferanceRepository: ProfileReferanceRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<DepthBloc>(
      () => DepthBloc(),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<BookletBloc>(
      () => BookletBloc(),
      dispose: _closeBloc,
    );
    getIt.registerLazySingleton<PairedDevicesBloc>(
      () => PairedDevicesBloc(
        pairedDevicesRepository: PairedDevicesRepositoryImpl(),
      ),
      dispose: _closeBloc,
    );
  }

  static Future<dynamic> reset() async {
    getIt<TabBloc>().add(const ResetError());
    getIt<SymbolBloc>().add(const ResetError());
    getIt<AppInfoBloc>().add(const ResetError());
    getIt<MatriksBloc>().add(const ResetError());
    getIt<ParityBloc>().add(const ResetError());
    getIt<CryptoBloc>().add(const ResetError());
    getIt<NotificationsBloc>().add(const ResetError());
    getIt<TimeBloc>().add(const ResetError());
    getIt<AuthBloc>().add(const ResetError());
    getIt<EconomicCalenderBloc>().add(const ResetError());
    getIt<AgreementsBloc>().add(const ResetError());
    getIt<AlarmBloc>().add(const ResetError());
    getIt<AdvicesBloc>().add(const ResetError());
    getIt<RoboSignalBloc>().add(const ResetError());
    getIt<ProfitBloc>().add(const ResetError());
    getIt<QuickPortfolioBloc>().add(const ResetError());
    getIt<TicketBloc>().add(const ResetError());
    getIt<LicenseBloc>().add(const ResetError());
    getIt<IpoBloc>().add(const ResetError());
    getIt<AssetsBloc>().add(const ResetError());
    getIt<NewsBloc>().add(const ResetError());
    getIt<ReviewBloc>().add(const ResetError());
    getIt<EducationBloc>().add(const ResetError());
    getIt<AccountStatementBloc>().add(const ResetError());
    getIt<MoneyTransferBloc>().add(const ResetError());
    getIt<CampaignsBloc>().add(const ResetError());
    getIt<EquityBloc>().add(const ResetError());
    getIt<EuroBondBloc>().add(const ResetError());
    getIt<ViopBloc>().add(const ResetError());
    getIt<TwitterBloc>().add(const ResetError());
    getIt<TransactionHistoryBloc>().add(const ResetError());
    getIt<FavoriteListBloc>().add(const ResetError());
    getIt<WarrantBloc>().add(const ResetError());
    getIt<MemberBloc>().add(const ResetError());
    getIt<PivotBloc>().add(const ResetError());
    getIt<BalanceBloc>().add(const ResetError());
    getIt<StageAnalysisBloc>().add(const ResetError());
    getIt<FundBloc>().add(const ResetError());
    getIt<AvatarBloc>().add(const ResetError());
    getIt<OrdersBloc>().add(const ResetError());
    getIt<CreateOrdersBloc>().add(const ResetError());
    getIt<CreateUsOrdersBloc>().add(const ResetError());
    getIt<AccountClosureBloc>().add(const ResetError());
    getIt<SymbolSearchBloc>().add(const ResetError());
    getIt<ContractsBloc>().add(const ResetError());
    getIt<BrokerageBloc>().add(const ResetError());
    getIt<AppSettingsBloc>().add(const ResetError());
    getIt<GlobalAccountOnboardingBloc>().add(const ResetError());
    getIt<UsEquityBloc>().add(const ResetError());
    getIt<IncomeBloc>().add(const ResetError());
    getIt<BannerBloc>().add(const ResetError());
    getIt<LanguageBloc>().add(const ResetError());
    getIt<UsBalanceBloc>().add(const ResetError());
    getIt<CurrencyBuySellBloc>().add(const ResetError());
    getIt<SectorsBloc>().add(const ResetError());
    getIt<ReportsBloc>().add(const ResetError());
    getIt<SymbolChartBloc>().add(const ResetError());
    getIt<DividendBloc>().add(const ResetError());
    getIt<DepthBloc>().add(const ResetError());
    getIt<BookletBloc>().add(const ResetError());
    getIt<EnquraBloc>().add(const ResetError());
    getIt<ProfileReferanceBloc>().add(const ResetError());
    getIt<PairedDevicesBloc>().add(const ResetError());
  }

  static Future<dynamic> unregister() async {
    await Future.wait<dynamic>(
      [
        getIt.unregister<TabBloc>(),
        getIt.unregister<SymbolBloc>(),
        getIt.unregister<AppInfoBloc>(),
        getIt.unregister<MatriksBloc>(),
        getIt.unregister<NotificationHandler>(),
        getIt.unregister<TimeBloc>(),
        getIt.unregister<AuthBloc>(),
        getIt.unregister<ParityBloc>(),
        getIt.unregister<CryptoBloc>(),
        getIt.unregister<NotificationsBloc>(),
        getIt.unregister<CampaignsBloc>(),
        getIt.unregister<EconomicCalenderBloc>(),
        getIt.unregister<AgreementsBloc>(),
        getIt.unregister<AlarmBloc>(),
        getIt.unregister<AdvicesBloc>(),
        getIt.unregister<NewsBloc>(),
        getIt.unregister<RoboSignalBloc>(),
        getIt.unregister<ProfitBloc>(),
        getIt.unregister<QuickPortfolioBloc>(),
        getIt.unregister<TicketBloc>(),
        getIt.unregister<LicenseBloc>(),
        getIt.unregister<TransactionHistoryBloc>(),
        getIt.unregister<IpoBloc>(),
        getIt.unregister<AssetsBloc>(),
        getIt.unregister<ReviewBloc>(),
        getIt.unregister<EducationBloc>(),
        getIt.unregister<AccountStatementBloc>(),
        getIt.unregister<MoneyTransferBloc>(),
        getIt.unregister<EquityBloc>(),
        getIt.unregister<EuroBondBloc>(),
        getIt.unregister<ViopBloc>(),
        getIt.unregister<TwitterBloc>(),
        getIt.unregister<FavoriteListBloc>(),
        getIt.unregister<WarrantBloc>(),
        getIt.unregister<MemberBloc>(),
        getIt.unregister<PivotBloc>(),
        getIt.unregister<BalanceBloc>(),
        getIt.unregister<StageAnalysisBloc>(),
        getIt.unregister<FundBloc>(),
        getIt.unregister<AvatarBloc>(),
        getIt.unregister<OrdersBloc>(),
        getIt.unregister<CreateOrdersBloc>(),
        getIt.unregister<CreateUsOrdersBloc>(),
        getIt.unregister<AccountClosureBloc>(),
        getIt.unregister<SymbolSearchBloc>(),
        getIt.unregister<ContractsBloc>(),
        getIt.unregister<BrokerageBloc>(),
        getIt.unregister<AppSettingsBloc>(),
        getIt.unregister<GlobalAccountOnboardingBloc>(),
        getIt.unregister<UsEquityBloc>(),
        getIt.unregister<IncomeBloc>(),
        getIt.unregister<BannerBloc>(),
        getIt.unregister<LanguageBloc>(),
        getIt.unregister<UsBalanceBloc>(),
        getIt.unregister<CurrencyBuySellBloc>(),
        getIt.unregister<SectorsBloc>(),
        getIt.unregister<ReportsBloc>(),
        getIt.unregister<SymbolChartBloc>(),
        getIt.unregister<DividendBloc>(),
        getIt.unregister<DepthBloc>(),
        getIt.unregister<BookletBloc>(),
        getIt.unregister<EnquraBloc>(),
        getIt.unregister<ProfileReferanceBloc>(),
        getIt.unregister<PairedDevicesBloc>(),
      ].cast<Future<dynamic>>(),
    );
  }

  static Future<void> _closeBloc(Bloc bloc) {
    return bloc.close();
  }
}
