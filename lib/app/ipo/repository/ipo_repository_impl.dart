import 'package:piapiri_v2/app/ipo/repository/ipo_repository.dart';
import 'package:piapiri_v2/common/utils/local_keys.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/database/db_helper.dart';
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/storage/local_storage.dart';

class IpoRepositoryImpl extends IpoRepository {
  DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Future<ApiResponse> getActiveInfo() {
    return getIt<PPApi>().ipoService.getActiveInfo();
  }

  @override
  Future<ApiResponse> getActiveIpoDemands() {
    return getIt<PPApi>().ipoService.getActiveIpoDemands();
  }

  @override
  Future<ApiResponse> getBlockageList({
    String customerId = '',
    String accountId = '',
    String ipoId = '',
    int paymentType = 0,
  }) {
    return getIt<PPApi>().ipoService.getBlockageList(
          customerId: customerId,
          accountId: accountId,
          ipoId: ipoId,
          paymentType: paymentType,
        );
  }

  @override
  Future<ApiResponse> getCustomerInfo({
    String customerId = '',
    String accountId = '',
  }) {
    return getIt<PPApi>().ipoService.getCustomerInfo(
          customerId: customerId,
          accountId: accountId,
        );
  }

  @override
  Future<ApiResponse> getIpoDetailsById({
    String customerId = '',
    int ipoId = 0,
  }) {
    return getIt<PPApi>().ipoService.getIpoDetailsById(
          ipoId: ipoId,
        );
  }

  @override
  Future<ApiResponse> getIpoList({
    int startIndex = 0,
    int status = 0,
  }) {
    return getIt<PPApi>().ipoService.getIpoList(
          startIndex: startIndex,
          status: status,
        );
  }

  @override
  Future<ApiResponse> getTradeLimit({
    required String customerId,
    required String accountId,
  }) {
    return getIt<PPApi>().ipoService.getTradeLimit(
          customerId: customerId,
          accountId: accountId,
        );
  }

  @override
  Future<ApiResponse> getCashBalance({
    required String customerId,
    required String accountId,
    String? typeName,
  }) {
    return getIt<PPApi>().ipoService.getTradeLimit(
          customerId: customerId,
          accountId: accountId,
          typeName: typeName,
        );
  }

  @override
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
    return getIt<PPApi>().ipoService.ipoDemandAdd(
          customerId: customerId,
          accountId: accountId,
          functionName: functionName,
          demandDate: demandDate,
          ipoId: ipoId,
          unitsDemanded: unitsDemanded,
          paymentType: paymentType,
          transactionType: transactionType,
          investorTypeId: investorTypeId,
          demandGatheringType: demandGatheringType,
          totalAmount: totalAmount,
          offerPrice: offerPrice,
          minUnits: minUnits,
          customFields: customFields,
          itemsToBlock: itemsToBlock,
        );
  }

  @override
  Future<ApiResponse> ipoDemandDelete({
    String customerId = '',
    String accountId = '',
    int functionName = 0,
    String ipoId = '',
    String demandDate = '',
    String demandId = '',
  }) {
    return getIt<PPApi>().ipoService.ipoDemandDelete(
          customerId: customerId,
          accountId: accountId,
          functionName: functionName,
          ipoId: ipoId,
          demandDate: demandDate,
          demandId: demandId,
        );
  }

  @override
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
    return getIt<PPApi>().ipoService.ipoDemandUpdate(
          customerId: customerId,
          accountId: accountId,
          functionName: functionName,
          demandDate: demandDate,
          ipoId: ipoId,
          demandId: demandId,
          unitsDemanded: unitsDemanded,
          investorTypeId: investorTypeId,
          offerPrice: offerPrice,
          checkLimit: checkLimit,
          demandGatheringType: demandGatheringType,
          demandType: demandType,
          paymentTypeId: paymentTypeId,
          itemsToBlock: itemsToBlock,
        );
  }

  @override
  String readCustomerType() {
    return UserModel.instance.innerType == 'CONTACT' ? '0000-000002-INT' : '0000-000003-INT';
  }

  @override
  List<dynamic> readAccountList() {
    return getIt<LocalStorage>().read(LocalKeys.accountList);
  }

  @override
  Future<ApiResponse> getIpoDetailsBySymbol({
    String ipoSymbol = '',
    int startIndex = 0,
  }) {
    return getIt<PPApi>().ipoService.getIpoDetailsBySymbol(
          ipoSymbol: ipoSymbol,
          startIndex: startIndex,
        );
  }

  @override
  Future<ApiResponse> newOrderHE({
    String symbolName = '',
    String quantity = '',
    String orderActionType = '',
    String orderType = '',
    String orderValidity = '',
    String account = '',
    String price = '',
    String orderCompletionType = '',
  }) {
    return getIt<PPApi>().ipoService.newOrderHE(
          symbolName: symbolName,
          quantity: quantity,
          orderActionType: orderActionType,
          orderType: orderType,
          orderValidity: orderValidity,
          account: account,
          price: price,
          orderCompletionType: orderCompletionType,
        );
  }

  @override
  Future<String?> getSymbolNameIfExists({
    String symbolName = '',
  }) async {
    return await dbHelper.getSymbolNameIfExists(
      symbolName,
    );
  }
}
