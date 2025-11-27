import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class PortfolioService {
  final ApiClient api;

  PortfolioService(this.api);

  static const String _getaccountoverallwithsummaryUrl = '/adkcustomer/getaccountoverallwithsummary';
  static const String _getTaxDetail = '/adkcustomer/getTaxDetail';
  static const String _getcollateralinfo = '/adkviop/getcollateralinfo';
  static const String _gettradelimit = '/adkcustomer/gettradelimit';
  static const String _collateralAdministrationData = '/adkviop/collateraladministrationdata';
  static const String _getVirmanInstitutionsUrl = '/adkcash/GetVirmanInstitutions';
  static const String _getCustomerTarget = '/adkcustomer/getcustomertarget';
  static const String _setCustomerTargetUrl = '/adkcustomer/setcustomertarget';

  Future<ApiResponse> getAccountOverallWithsummary({
    bool isConsolidated = true,
    String selectedAccount = '',
    String date = '',
    required String accountId,
    required String customerId,
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

  Future<ApiResponse> getTaxDetailWithModel(
    String fromDate,
    String toDate,
  ) async {
    return api.post(
      _getTaxDetail,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'startDate': fromDate,
        'endDate': toDate,
      },
    );
  }

  Future<ApiResponse> getCashFlow({
    String customerId = '',
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

  Future<ApiResponse> getCustomerTarget({
    String customerId = '',
  }) {
    return api.post(
      _getCustomerTarget,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
      },
    );
  }

  Future<ApiResponse> collateralAdministrationData({
    String customerExtId = '',
    String accountExtId = '',
    double amount = 0,
    String source = '',
    String target = '',
  }) {
    return api.post(
      _collateralAdministrationData,
      tokenized: true,
      body: {
        'CustomerExtId': customerExtId,
        'AccountExtId': accountExtId,
        'Amount': amount,
        'Source': source,
        'Target': target,
      },
    );
  }

  Future<ApiResponse> getCollateralInfo({
    String customerId = '',
    String accountId = '',
  }) {
    return api.post(
      _getcollateralinfo,
      tokenized: true,
      body: {
        'CustomerExtId': customerId,
        'AccountExtId': accountId,
        'IncludePassiveOrder': true,
      },
    );
  }

  /// Limit bilgileri çektiğimiz api.
  Future<ApiResponse> getTradeLimit({
    String customerId = '',
    String accountId = '',
    String typeName = 'EQUITY-T2',
  }) async {
    return api.post(
      _gettradelimit,
      tokenized: true,
      body: {
        'CustomerExtId': customerId,
        'AccountExtId': accountId,
        'EquityName': '',
        'TypeName': typeName,
      },
    );
  }

  /// Virman Kurumları
  Future<ApiResponse> getVirmanInstitutions({
    String customerId = '',
    String accountId = '',
  }) async {
    return api.post(
      _getVirmanInstitutionsUrl,
      tokenized: true,
      body: {
        'CustomerExtId': customerId,
        'AccountExtId': accountId,
      },
    );
  }

  Future<ApiResponse> setCustomerTarget(
    double target,
    DateTime targetDate,
  ) async {
    return api.post(
      _setCustomerTargetUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'target': target,
        'targetDate': targetDate.toString().replaceAll(' ', 'T'),
      },
    );
  }
}
