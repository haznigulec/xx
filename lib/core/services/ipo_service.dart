import 'package:piapiri_v2/app/ipo/utils/ipo_constant.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/order_action_type_enum.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class IpoService {
  final ApiClient api;

  IpoService(this.api);

  static const String _getIpoListUrl = '/ipo/getiposbyindex';
  static const String _getIpoDetailsByIdUrl = '/ipo/getipodetailsbyid';
  static const String _getActiveIpoDemandsUrl = '/adkipo/getactiveipodemands';
  static const String _getActiveInfoUrl = '/adkipo/getactiveinfo';
  static const String _getIpoBlockageListUrl = '/adkipo/getipoaccountoverallforblockagelist';
  static const String _ipoAddUpdateDeleteUrl = '/adkipo/addupdatedeletedemand';
  static const String _gettradelimitUrl = '/adkcustomer/gettradelimit';
  static const String _getCustomerInfo = '/adkcustomer/getcustomerinfo';
  static const String _getIpoDetailsBySymbol = '/ipo/getipodetailsbysymbol';
  static const String _newOrderUrl = '/adkequity/neworder';

  Future<ApiResponse> getIpoList({
    int startIndex = 0,
    int status = 0,
  }) {
    return api.post(
      _getIpoListUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'startIndex': startIndex,
        'count': IpoConstant.ipoPaginationListLength,
        'status': status,
      },
    );
  }

  Future<ApiResponse> getIpoDetailsById({
    int ipoId = 0,
  }) {
    return api.post(
      _getIpoDetailsByIdUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'ipoId': ipoId,
      },
    );
  }

  Future<ApiResponse> getActiveIpoDemands() {
    return api.post(
      _getActiveIpoDemandsUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
      },
    );
  }

  Future<ApiResponse> getTradeLimit({
    required String customerId,
    required String accountId,
    String? typeName,
  }) async {
    return api.post(
      _gettradelimitUrl,
      tokenized: true,
      body: {
        'CustomerExtId': UserModel.instance.customerId,
        'AccountExtId': accountId,
        'EquityName': '',
        'TypeName': typeName ?? 'IPO-T',
      },
    );
  }

  Future<ApiResponse> getActiveInfo() {
    return api.post(
      _getActiveInfoUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'functionName': 0,
        'parametre1': 0,
        'value1': '',
        'parametre2': 0,
        'value2': '',
      },
    );
  }

  Future<ApiResponse> getCustomerInfo({
    String customerId = '',
    String accountId = '',
  }) {
    return api.post(
      _getCustomerInfo,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'accountExtId': accountId,
      },
    );
  }

  Future<ApiResponse> getBlockageList({
    String customerId = '',
    String accountId = '',
    String ipoId = '',
    int paymentType = 0,
  }) {
    return api.post(
      _getIpoBlockageListUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'accountExtId': accountId,
        'ipoID': ipoId,
        'paymentType': paymentType,
      },
    );
  }

  Future<ApiResponse> ipoDemandAdd({
    String customerId = '',
    String accountId = '',
    int functionName = 0,
    String demandDate = '',
    String ipoId = '',
    int unitsDemanded = 0,
    int paymentType = 0,
    String transactionType = '',
    String investorTypeId = '',
    String demandGatheringType = '',
    double totalAmount = 0,
    double offerPrice = 0,
    int minUnits = 1,
    String customFields = 'H',
    required List<Map<String, dynamic>> itemsToBlock,
  }) {
    return api.post(
      _ipoAddUpdateDeleteUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'accountExtId': accountId,
        'functionName': functionName, // 0(Add), 1(Update), 2(Delete)
        'ipoId': ipoId,
        'demandDate': demandDate,
        'unitsDemanded': unitsDemanded,
        'paymentType': paymentType, // 0(Nakit) , 5(Fon Blokajlı), 4(Döviz Blokajlı), 10(Bist Hisse Blokajlı)
        'transactionType': 'TRANSACTION',
        'investorTypeId': investorTypeId,
        'demandGatheringType': demandGatheringType,
        'totalAmount': totalAmount,
        'offerPrice': offerPrice,
        'demandType': 'DEFINITE',
        'minUnits': minUnits,
        'chkLimit': true,
        'customFields': customFields,
        if (itemsToBlock.isNotEmpty) 'itemsToBlock': itemsToBlock,
      },
    );
  }

  Future<ApiResponse> ipoDemandDelete({
    String customerId = '',
    String accountId = '',
    int functionName = 0,
    String ipoId = '',
    String demandDate = '',
    String demandId = '',
  }) {
    return api.post(
      _ipoAddUpdateDeleteUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'accountExtId': accountId,
        'functionName': functionName, // 0(Add), 1(Update), 2(Delete)
        'ipoId': ipoId,
        'demandDate': demandDate,
        'demandId': demandId,
      },
    );
  }

  Future<ApiResponse> ipoDemandUpdate({
    String customerId = '',
    String accountId = '',
    int functionName = 0,
    String demandDate = '',
    String ipoId = '',
    String demandId = '',
    double unitsDemanded = 0,
    String investorTypeId = '',
    double offerPrice = 0,
    bool checkLimit = true,
    String demandGatheringType = 'M',
    String demandType = '',
    int? paymentTypeId,
    List<Map<String, dynamic>>? itemsToBlock,
  }) {
    return api.post(
      _ipoAddUpdateDeleteUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'accountExtId': accountId,
        'functionName': functionName, // 0(Add), 1(Update), 2(Delete)
        'ipoId': ipoId,
        'demandDate': demandDate,
        'demandId': demandId,
        'unitsDemanded': unitsDemanded.toInt(),
        'offerPrice': offerPrice,
        'investorTypeId': investorTypeId,
        'ChkLimit': checkLimit,
        'demandGatheringType': demandGatheringType,
        'demandType': demandType,
        'transactionType': 'TRANSACTION',
        if (paymentTypeId != null) 'paymentType': paymentTypeId,
        if (itemsToBlock != null) 'itemsToBlock': itemsToBlock,
      },
    );
  }

  Future<ApiResponse> getIpoDetailsBySymbol({
    String ipoSymbol = '',
    int startIndex = 0,
  }) {
    return api.post(
      _getIpoDetailsBySymbol,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'ipoSymbol': ipoSymbol,
        'startIndex': startIndex,
        'count': IpoConstant.ipoPaginationListLength,
      },
    );
  }

  Future<ApiResponse> newOrderHE({
    required String symbolName,
    required String quantity,
    required String orderActionType,
    required String orderType,
    required String orderValidity,
    required String account,
    required String price,
    required String orderCompletionType,
  }) async {
    Map<String, dynamic> body = {
      'customerExtId': UserModel.instance.customerId,
      'accountExtId': account,
      'Side': orderActionType,
      'Name': getIt<AppInfoBloc>().state.symbolSuffixList.any((e) => e.nameWithSuffix == symbolName)
          ? getIt<AppInfoBloc>().state.symbolSuffixList.firstWhere((e) => e.nameWithSuffix == symbolName).name
          : symbolName,
      'Units': quantity,
      'Price': price,
      'OrderDate': DateTimeUtils.serverDate(DateTime.now()),
      'OrderSession': 0,
      'AmountType': orderType,
      'timeInForce': orderValidity,
      'smsFillNotification': orderCompletionType == '1',
      'emailFillNotification': orderCompletionType == '2',
      'pushFillNotification': orderCompletionType == '3',
      'shortfall': orderActionType == OrderActionTypeEnum.shortSell.value ? 1 : 0,
    };

    return api.post(
      _newOrderUrl,
      tokenized: true,
      body: body,
    );
  }
}
