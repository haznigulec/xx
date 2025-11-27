import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/markets/model/market_menu.dart';
import 'package:piapiri_v2/core/model/settings_model.dart';

bool openUygunlukTestiAfterWelcomeScreen = false;

bool isLaunchedNotification = false;

int? dashboardInitialIndex;
MarketMenu? dashboardInitialMarketMenu;
int? dashboardInitialMarketMenuIndex;

const double generalBorderRadius = 8.0;
const double kKeyboardHeight = 280;
const double inputComponentHeight = 71.5;
const double tabPageIconSize = 25;
const double dataGridWidth = 105;

bool homeSpesificListIsExpanded = true;

List<SettingsModel> orderSendingSettingList = [];
List<SettingsModel> securitySettingsList = [];
List<SettingsModel> applicationSettingsList = [];
List<SettingsModel> accountSettingsList = [];
List<SettingsModel> equityOrderSendingChildren = [];
List<SettingsModel> viopOrderSendingChildren = [];
List<SettingsModel> fundOrderSendingChildren = [];

String myReferenceCodeTitle = '';
String enterReferenceCodeTitle = '';
String enterReferenceCodeValue = '';

ValueNotifier<bool> showBuySellFloatingButton = ValueNotifier<bool>(false);

final Map<String, int> favoriteColumnValues = {
  'lists_symbol': 0,
  'lists_buy': 2,
  'lists_sell': 3,
  'lists_last_price_and_difference': 13,
  'lists_difference': 10,
  'graphic': 12,
  'lists_low': 4,
  'lists_high': 5,
  'lists_last_price': 6,
  'lists_difference2': 11,
  'lists_closing': 7,
  'lists_transaction_count': 8,
  'lists_transaction_volume': 9,
  'lists_time': 1,
  'lists_balance': 6,
  'lists_balance2': 6,
};

final Map<String, int> highlightsColumnValues = {};

final Map<String, int> fundColumnValues = {
  'fund_code': 0,
  'fund_last_price': 1,
  'daily_profit': 2,
  'equity_piece': 3,
  'fund_total_value': 4,
  'category': 5,
  'investor_count': 6,
  'fund_market_equity': 7,
  'fund_rank': 8,
  'fund_category_amount': 9,
};

int matriksTokenInvalidateTime = 299;
List<Map<String, String>> cryptoMarketList = [
  {
    'name': 'BTCTURK',
    'market': 'A',
  },
  {
    'name': 'Binance',
    'market': 'B',
  },
  {
    'name': 'BitMEX',
    'market': 'C',
  },
];

final List<String> cryptoSectors = [
  'Metaverse',
  'Memes',
  'Games',
  'Fan Token',
  'Sports',
  'Music',
  'DeFi',
  'AI & Big Data',
  'Solana',
  'Real World Assets',
  'Artificial Intelligence',
  'Layer 1 / Layer 2',
  'AI & Big Data',
  'Solana',
  'Real World Assets',
  'Artificial Intelligence',
  'Layer 1 / Layer 2',
  'AI & Big Data',
  'Solana',
  'Real World Assets',
  'Artificial Intelligence',
  'Layer 1 / Layer 2',
];

final List<Map<String, String>> fundTypes = [
  {
    'Name': 'Tümü',
    'Code': 'ALL',
  },
  {
    'Name': 'Menkul Kıymet Yatırım Fonları',
    'Code': 'YAT',
  },
  {
    'Name': 'Borsa Yatırım Fonları',
    'Code': 'BYF',
  },
];

final List<Map<String, String>> tefasStatuses = [
  {
    'Name': 'Tümü',
    'Code': 'ALL',
  },
  {
    'Name': 'İşlem gören',
    'Code': '1',
  },
  {
    'Name': 'İşlem görmeyen',
    'Code': '0',
  },
];

final Map<String, int> parityColumnValues = {
  'parity': 0,
  'kur': 0,
  'kiymetli_maden': 0,
  'gunluk_degisim': 11,
  'price': 2,
};

final List<String> globalAccountOnboardingList = [
  'personalInformation',
  'financialInformation',
  'onlineContracts',
];

final List<String> enquraOnboardingList = [
  'personalInformation',
  'financialInformation',
  'identityVerification',
  'onlineContracts',
  'enqura_videoCall',
];

final List<String> globalOnboardingEmploymentStatus = [
  'employed',
  'unemployed',
  'retired',
  'student',
];

final List<String> globalOnboardingFundingSource = [
  'employment_income',
  'investments',
  'inheritance',
  'business_income',
  'savings',
  'family',
];

final List<String> globalOnboardingTotalAssets = [
  'onboarding_total_asset_amount1',
  'onboarding_total_asset_amount2',
  'onboarding_total_asset_amount3',
  'onboarding_total_asset_amount4',
  'onboarding_total_asset_amount5',
];

final List<Map<String, String>> contractRiskLevel = [
  {
    'riskName': 'Çok Düşük Riskli Ürünler',
    'description': 'Repo-Ters Repo, BPP, Risk Değeri 1 olan yatırım fonları, vb.',
  },
  {
    'riskName': 'Düşük Riskli Ürünler',
    'description':
        'Hazine Bonosu, Devlet Tahvili, Hazine Kira Sertifikaları, Risk Değeri 2 ve 3 olan yatırım fonları, vb.',
  },
  {
    'riskName': 'Orta Riskli Ürünler',
    'description':
        'Hisse Senedi, Eurobond, Dövizli Tahviller, Özel Sektör Borçlanma Araçları, Kira Sertifikaları, Risk Değeri 4 olan yatırım fonları, vb.',
  },
  {
    'riskName': 'Yüksek Riskli Ürünler',
    'description': 'VİOP Varant, Yatırım Kuruluşu Sertifikası, Risk Değeri 5 ve 6 olan yatırım fonları, vb.',
  },
  {
    'riskName': 'Çok Yüksek Riskli Ürünler',
    'description':
        'FX İşlemleri, Yurt Dışı Borsa İşlemleri, YBA, Tezgahüstü Türev İşlemler, Risk Değeri 7 olan yatırım fonları, vb.',
  },
];
