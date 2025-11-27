import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class AssetsService {
  final ApiClient api;

  AssetsService(this.api);

  static const String _getaccountoverallwithsummaryUrl = '/adkcustomer/getaccountoverallwithsummary';
  static const String _getcollateralinfo = '/adkviop/getcollateralinfo';
  static const String _gettradelimit = '/adkcustomer/gettradelimit';
  static const String _getCapraPortfolioSummary = '/Capra/GetPortfolioSummary';
  static const String _getCapraCollateralInfo = '/Capra/GetCollateralInfo';

  Future<ApiResponse> getAccountOverallWithsummary({
    bool isConsolidated = true,
    String selectedAccount = '',
    String date = '',
    required String accountId,
    bool allAccount = false,
    bool getInstant = true,
    String? overallDate,
    bool includeCashFlow = false,
    bool includeCreditDetail = false,
    bool calculateTradeLimit = false,
    bool? includeSummary,
  }) {
    return api.post(
      _getaccountoverallwithsummaryUrl,
      tokenized: true,
      body: {
        'AllAccounts': accountId.isEmpty,
        'GetInstant': getInstant,
        'Consolidate': isConsolidated,
        'IncludeCashFlow': includeCashFlow,
        'IncludeCreditDetail': includeCreditDetail,
        'IncludeSummary': true,
        'CalculateTradeLimit': calculateTradeLimit,
        'IncludePortfolioAccount': true,
        'AccountExtId': accountId,
        'customerExtId': UserModel.instance.customerId,
        if (overallDate != null) 'overallDate': overallDate,
        if (includeSummary != null) 'IncludeSummary': includeSummary,
      },
    );
  }

  Future<ApiResponse> getCashFlow({
    String accountId = '',
    bool allAccounts = false,
  }) {
    return api.post(
      _getaccountoverallwithsummaryUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'accountExtId': accountId,
        'AllAccounts': allAccounts,
        'GetInstant': true,
        'Consolidate': true,
        'IncludeCashFlow': true,
        'IncludeCreditDetail': true,
        'IncludeSummary': true,
        'CalculateTradeLimit': true,
        'IncludePortfolioAccount': true,
      },
    );
  }

  Future<ApiResponse> getCollateralInfo({
    String accountId = '',
  }) {
    return api.post(
      _getcollateralinfo,
      tokenized: true,
      body: {
        'CustomerExtId': UserModel.instance.customerId,
        'AccountExtId': accountId,
        'IncludePassiveOrder': true,
      },
    );
  }

  /// Limit bilgileri çektiğimiz api.
  Future<ApiResponse> getTradeLimit({
    String accountId = '',
    String? typeName,
  }) async {
    return api.post(
      _gettradelimit,
      tokenized: true,
      body: {
        'CustomerExtId': UserModel.instance.customerId,
        'AccountExtId': accountId,
        'EquityName': '',
        'TypeName': typeName ?? 'EQUITY-T2',
      },
    );
  }

  Future<ApiResponse> getCapraPortfolioSummary({
    String accountId = '',
  }) async {
    return api.post(
      _getCapraPortfolioSummary,
      tokenized: true,
      body: {
        'CustomerExtId': UserModel.instance.customerId,
      },
    );
  }

  Future<ApiResponse> getCapraCollateralInfo() async {
    return api.post(
      _getCapraCollateralInfo,
      tokenized: true,
      body: {
        'CustomerExtId': UserModel.instance.customerId,
      },
    );
  }
}
