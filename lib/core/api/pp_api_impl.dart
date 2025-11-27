import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/client/enqura_api_client.dart';
import 'package:piapiri_v2/core/api/client/generic_api_client.dart';
import 'package:piapiri_v2/core/api/client/matriks_api_client.dart';
import 'package:piapiri_v2/core/api/client/polygon_api_client.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/core/services/account_closure_service.dart';
import 'package:piapiri_v2/core/services/account_statement_service.dart';
import 'package:piapiri_v2/core/services/advices_service.dart';
import 'package:piapiri_v2/core/services/agreements_service.dart';
import 'package:piapiri_v2/core/services/alarm_service.dart';
import 'package:piapiri_v2/core/services/analysis_service.dart';
import 'package:piapiri_v2/core/services/app_info_service.dart';
import 'package:piapiri_v2/core/services/assets_service.dart';
import 'package:piapiri_v2/core/services/auth_service.dart';
import 'package:piapiri_v2/core/services/avatar_service.dart';
import 'package:piapiri_v2/core/services/balance_service.dart';
import 'package:piapiri_v2/core/services/banner_service.dart';
import 'package:piapiri_v2/core/services/brokerage_service.dart';
import 'package:piapiri_v2/core/services/campaigns_service.dart';
import 'package:piapiri_v2/core/services/contracts_service.dart';
import 'package:piapiri_v2/core/services/currency_buy_sell_service.dart';
import 'package:piapiri_v2/core/services/dividend_service.dart';
import 'package:piapiri_v2/core/services/education_service.dart';
import 'package:piapiri_v2/core/services/enqura_service.dart';
import 'package:piapiri_v2/core/services/eurobond_service.dart';
import 'package:piapiri_v2/core/services/favorite_list_service.dart';
import 'package:piapiri_v2/core/services/fund_service.dart';
import 'package:piapiri_v2/core/services/global_account_onboarding_service.dart';
import 'package:piapiri_v2/core/services/home_service.dart';
import 'package:piapiri_v2/core/services/income_service.dart';
import 'package:piapiri_v2/core/services/ipo_service.dart';
import 'package:piapiri_v2/core/services/language_service.dart';
import 'package:piapiri_v2/core/services/licenses_service.dart';
import 'package:piapiri_v2/core/services/market_service.dart';
import 'package:piapiri_v2/core/services/matriks_service.dart';
import 'package:piapiri_v2/core/services/member_service.dart';
import 'package:piapiri_v2/core/services/money_transfer_service.dart';
import 'package:piapiri_v2/core/services/news_service.dart';
import 'package:piapiri_v2/core/services/notification_service.dart';
import 'package:piapiri_v2/core/services/orders_service.dart';
import 'package:piapiri_v2/core/services/pivot_analysis_service.dart';
import 'package:piapiri_v2/core/services/polygon_service.dart';
import 'package:piapiri_v2/core/services/portfolio_service.dart';
import 'package:piapiri_v2/core/services/profile_referance_service.dart';
import 'package:piapiri_v2/core/services/profile_service.dart';
import 'package:piapiri_v2/core/services/profit_service.dart';
import 'package:piapiri_v2/core/services/quick_portfolio_service.dart';
import 'package:piapiri_v2/core/services/reports_service.dart';
import 'package:piapiri_v2/core/services/review_service.dart';
import 'package:piapiri_v2/core/services/robo_signal_service.dart';
import 'package:piapiri_v2/core/services/settings_service.dart';
import 'package:piapiri_v2/core/services/stage_analysis_service.dart';
import 'package:piapiri_v2/core/services/symbol_search_service.dart';
import 'package:piapiri_v2/core/services/ticket_service.dart';
import 'package:piapiri_v2/core/services/trade_service.dart';
import 'package:piapiri_v2/core/services/transaction_history_service.dart';
import 'package:piapiri_v2/core/services/twitter_service.dart';
import 'package:piapiri_v2/core/services/us_balance_service.dart';
import 'package:piapiri_v2/core/services/us_create_order_service.dart';
import 'package:piapiri_v2/core/services/us_equity_service.dart';

class PPApiImpl extends PPApi {
  @override
  late ApiClient client;

  @override
  late ApiClient usClient;

  @override
  late EnquraApiClient enquraClient;

  @override
  late MatriksApiClient matriksApiClient;

  @override
  late PolygonApiClient polygonApiClient;

  @override
  late GenericApiClient genericApiClient;

  PPApiImpl() {
    client = ApiClient(AppConfig.instance.baseUrl);
    usClient = ApiClient(AppConfig.instance.usCapraUrl);
    enquraClient = EnquraApiClient(AppConfig.instance.enquraBaseUrl);
    matriksApiClient = MatriksApiClient();
    genericApiClient = GenericApiClient();
    polygonApiClient = PolygonApiClient();
  }

  @override
  late AuthService authService;

  @override
  late AlarmService alarmService;

  @override
  late AnalysisService analysisService;

  @override
  late AppInfoService appInfoService;

  @override
  late MarketService marketService;

  @override
  late OrdersService ordersService;

  @override
  late PortfolioService portfolioService;

  @override
  late IpoService ipoService;

  @override
  late EuroBondService euroBondService;

  @override
  late ProfileService profileService;

  @override
  late FundService fundService;

  @override
  late MatriksService matriksService;

  @override
  late PolygonService polygonService;

  @override
  late HomeService homeService;

  @override
  late BrokerageService brokerageService;

  @override
  late NewsService newsService;

  @override
  late ReviewService reviewService;

  @override
  late NotificationService notificationService;

  @override
  late CampaignsService campaignsService;

  @override
  late MemberService memberService;

  @override
  late LanguageService languageService;

  @override
  late ContractsService contractsService;

  @override
  late QuickPortfolioService quickPortfolioService;

  @override
  late EducationService educationService;

  @override
  late AgreementsService agreementsService;

  @override
  late ProfitService profitService;

  @override
  late AssetsService assetsService;

  @override
  late MoneyTransferService moneyTransferService;

  @override
  late FavoriteListService favoriteListsService;

  @override
  late AdvicesService advicesService;

  @override
  late ReportsService reportsService;

  @override
  late RoboSignalService roboSignalService;

  @override
  late LicensesService licensesService;

  @override
  late TransactionHistoryService transactionHistoryService;

  @override
  late AccountStatementService accountStatementService;

  @override
  late TicketService ticketService;

  @override
  late TwitterService twitterService;

  @override
  late TradeService tradeService;

  @override
  late PivotAnalysisService pivotAnalysisService;

  @override
  late BalanceService balanceService;

  @override
  late IncomeService incomeService;

  @override
  late StageAnalysisService stageAnalysisService;

  @override
  late SettingsService settingsService;

  @override
  late BannerService bannerService;

  @override
  late AvatarService avatarService;

  @override
  late AccountClosureService accountClosureService;

  @override
  late GlobalAccountOnboardingService globalAccountOnboardingService;

  @override
  late UsEquityService usEquityService;

  @override
  late UsCreateOrderService usCreateOrderService;
  @override
  late UsBalanceService usBalanceService;

  @override
  late SymbolSearchService symbolSearchService;

  @override
  late CurrencyBuySellService currencyBuySellService;

  @override
  late DividendService dividendService;

  @override
  late EnquraService enquraService;

  @override
  late ProfileReferanceService profileReferanceService;

  @override
  void init() {
    authService = AuthService(client);
    alarmService = AlarmService(client, matriksApiClient);
    analysisService = AnalysisService(client, matriksApiClient);
    appInfoService = AppInfoService(
      client,
      matriksApiClient,
      genericApiClient,
    );
    marketService = MarketService(client, matriksApiClient);
    ordersService = OrdersService(
      client,
      matriksApiClient,
    );
    portfolioService = PortfolioService(client);
    ipoService = IpoService(client);
    euroBondService = EuroBondService(client);
    profileService = ProfileService(client);
    fundService = FundService(client);
    matriksService = MatriksService(
      matriksApiClient,
      client,
    );
    polygonService = PolygonService(
      polygonApiClient,
    );
    homeService = HomeService(client);
    brokerageService = BrokerageService(matriksApiClient);
    newsService = NewsService(matriksApiClient);
    notificationService = NotificationService(client);
    campaignsService = CampaignsService(client);
    memberService = MemberService(client);
    languageService = LanguageService(client);
    contractsService = ContractsService(client);
    quickPortfolioService = QuickPortfolioService(client);
    reviewService = ReviewService(matriksApiClient);
    educationService = EducationService(client);
    agreementsService = AgreementsService(client);
    profitService = ProfitService(client);
    assetsService = AssetsService(client);
    moneyTransferService = MoneyTransferService(client);
    favoriteListsService = FavoriteListService(client, matriksApiClient);
    advicesService = AdvicesService(client);
    reportsService = ReportsService(client);
    roboSignalService = RoboSignalService(client);
    licensesService = LicensesService(client);
    transactionHistoryService = TransactionHistoryService(client);
    accountStatementService = AccountStatementService(client);
    ticketService = TicketService(client);
    twitterService = TwitterService(matriksApiClient);
    tradeService = TradeService(matriksApiClient);
    pivotAnalysisService = PivotAnalysisService(matriksApiClient);
    balanceService = BalanceService(matriksApiClient);
    incomeService = IncomeService(matriksApiClient);
    stageAnalysisService = StageAnalysisService(matriksApiClient);
    settingsService = SettingsService(client);
    bannerService = BannerService(client);
    avatarService = AvatarService(client);
    accountClosureService = AccountClosureService(client);
    globalAccountOnboardingService = GlobalAccountOnboardingService(client);
    usEquityService = UsEquityService(client, genericApiClient, usClient, polygonApiClient);
    usCreateOrderService = UsCreateOrderService(client);
    usBalanceService = UsBalanceService(client);
    symbolSearchService = SymbolSearchService(polygonApiClient);
    currencyBuySellService = CurrencyBuySellService(client);
    dividendService = DividendService(client);
    enquraService = EnquraService(enquraClient, client);
    profileReferanceService = ProfileReferanceService(client);
  }
}
