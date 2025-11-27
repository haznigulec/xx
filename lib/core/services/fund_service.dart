import 'package:piapiri_v2/app/app_settings/bloc/app_settings_bloc.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/fund_order_action.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class FundService {
  final ApiClient api;

  FundService(this.api);

  static const String _fundsByFilterUrl = '/Fund/getFundsByFilter';
  static const String _fundDetailUrl = '/Fund/getFundDetailsByFundCode';
  static const String _fundInfoUrl = '/Fund/getFundInfo';
  static const String _fundOrderUrl = '/Fund/neworder';
  static const String _fundGetByProfitUrl = '/Fund/getFundsByProfit';
  static const String _fundGetByManagementFeeUrl = '/Fund/getFundsByManagementFee';
  static const String _fundGetByPortfolioSizeUrl = '/Fund/getFundsByPortfolioSize';
  static const String _fundNewBulkOrderUrl = '/fund/newbulkorder';
  static const String _fundGetFinancialFounderList = '/Fund/getfinancialinstitutionlist';
  static const String _fundGetFilterAndSortFunds = '/Fund/getFilterAndSortFunds';
  static const String _fundPerformanceRanking = '/Fund/getFundPerformanceRanking';
  static const String _fundGetPriceGraph = '/Fund/getFundPriceGraph';
  static const String _getFundVolumeHistory = '/Fund/getFundVolumeHistory';
  static const String _getFundApplicationCategories = '/Fund/getFundApplicationCategories';
  static const String _getFundPrice = '/Fund/getfundprice';
  static const String _getAllFundThemes = '/Fund/getallfundthemes';

  Future<ApiResponse> getFundPerformanceRanking() async {
    return api.post(
      _fundPerformanceRanking,
    );
  }

  Future<ApiResponse> getFundPriceGraph({
    String? fundCode = '',
    String? startDate = '',
    String? endDate = '',
    String? period = '',
  }) async {
    return api.post(
      _fundGetPriceGraph,
      body: {
        'fundCode': fundCode,
        'startDate': startDate,
        'endDate': endDate,
        'period': period,
      },
      tokenized: false,
    );
  }

  Future<ApiResponse> getFundVolumeHistory({
    String? fundCode = '',
  }) async {
    return api.post(_getFundVolumeHistory,
        body: {
          'fundCode': fundCode,
        },
        tokenized: false);
  }

  Future<ApiResponse> getFilterAndSortFunds({
    String? institutionCode,
    int? startIndex = 1,
    int? count = 50,
  }) async {
    return api.post(
      _fundGetFilterAndSortFunds,
      body: {
        'institutionCode': institutionCode,
        'startIndex': startIndex,
        'count': count,
      },
    );
  }

  Future<ApiResponse> getFinancialInstutionList({
    String? founderCode,
    String? subTypeCode,
    int? fundTitleTypeCode,
    int? tefasStatus,
    String? mainTypeCode,
    int? applicationCategoryId,
    int? themeId,
  }) async {
    return api.post(
      _fundsByFilterUrl,
      tokenized: getIt<AuthBloc>().state.isLoggedIn,
      body: {
        'founderCode': founderCode,
        'subTypeCode': subTypeCode,
        'fundTitleTypeCode': fundTitleTypeCode,
        'tefasStatus': tefasStatus,
        'mainTypeCode': mainTypeCode,
        'applicationCategoryId': applicationCategoryId,
        'themeId': themeId,
      },
    );
  }

  Future<ApiResponse> getFinancialFounderList({
    String? institutionCode = '',
  }) async {
    return api.post(
      _fundGetFinancialFounderList,
      body: {
        'institutionCode': institutionCode,
      },
    );
  }

  Future<ApiResponse> getFundDetails({
    required String fundCode,
  }) async {
    return api.post(
      _fundDetailUrl,
      tokenized: getIt<AuthBloc>().state.isLoggedIn,
      body: {
        'code': fundCode,
      },
    );
  }

  Future<ApiResponse> getFundInfo({
    required String accountId,
    required String fundCode,
    required String buySell,
  }) async {
    return api.post(
      _fundInfoUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'accountExtId': accountId,
        'fundCode': fundCode,
        'buySell': buySell,
      },
    );
  }

  Future<ApiResponse> newOrder({
    required String accountId,
    required String fundCode,
    required double price,
    required int unit,
    required double amount,
    required FundOrderActionEnum orderActionType,
    required String valorDate,
    required String baseType,
  }) async {
    return api.post(
      _fundOrderUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'accountExtId': accountId,
        'finInstName': fundCode,
        'price': price,
        'unit': unit,
        'amount': amount,
        'baseType': baseType,
        'side': orderActionType.value,
        'transactionType': 'T',
        'valueDate': valorDate,
      },
    );
  }

  Future<ApiResponse> getFundsByProfit({
    String startDate = '',
    String endDate = '',
  }) async {
    return api.post(
      _fundGetByProfitUrl,
      tokenized: getIt<AuthBloc>().state.isLoggedIn,
      body: {
        'startDate': startDate,
        'endDate': endDate,
      },
    );
  }

  Future<ApiResponse> getFundsByManagementFee() async {
    return api.post(
      _fundGetByManagementFeeUrl,
      tokenized: getIt<AuthBloc>().state.isLoggedIn,
      body: {},
    );
  }

  Future<ApiResponse> getFundsByPortfolioSize() async {
    return api.post(
      _fundGetByPortfolioSizeUrl,
      tokenized: getIt<AuthBloc>().state.isLoggedIn,
      body: {},
    );
  }

  Future<ApiResponse> newBulkOrder({
    required List<Map<String, dynamic>> funds,
    required String account,
  }) async {
    return api.post(
      _fundNewBulkOrderUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'accountExtId': account,
        'items': funds,
      },
    );
  }

  Future<ApiResponse> getFundApplicationCategories() async {
    return api.post(
      _getFundApplicationCategories,
      body: {
        'language': getIt<AppSettingsBloc>().state.generalSettings.language.value,
      },
    );
  }

  Future<ApiResponse> getFundPrice({
    required String fundCode,
  }) async {
    return api.post(
      _getFundPrice,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'fundCode': fundCode,
      },
    );
  }

  Future<ApiResponse> getAllFundThemes() async {
    return api.post(
      _getAllFundThemes,
      body: {
        'language': getIt<AppSettingsBloc>().state.generalSettings.language.value,
      },
    );
  }
}
