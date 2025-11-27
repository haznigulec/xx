import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class IpoRepository {
  readCustomerType();
  readAccountList();
  Future<ApiResponse> getIpoList({
    int startIndex = 0,
    int status = 0,
  });

  Future<ApiResponse> getActiveIpoDemands();

  Future<ApiResponse> getTradeLimit({
    required String customerId,
    required String accountId,
  });

  Future<ApiResponse> getCashBalance({
    required String customerId,
    required String accountId,
    String? typeName,
  });

  Future<ApiResponse> getActiveInfo();

  Future<ApiResponse> getCustomerInfo({
    String customerId = '',
    String accountId = '',
  });

  Future<ApiResponse> getBlockageList({
    String customerId = '',
    String accountId = '',
    String ipoId = '',
    int paymentType = 0,
  });

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
  });

  Future<ApiResponse> ipoDemandDelete({
    String customerId = '',
    String accountId = '',
    int functionName = 0,
    String ipoId = '',
    String demandDate = '',
    String demandId = '',
  });

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
  });

  Future<ApiResponse> getIpoDetailsById({
    int ipoId = 0,
  });

  Future<ApiResponse> getIpoDetailsBySymbol({
    String ipoSymbol = '',
    int startIndex = 0,
  });

  Future<ApiResponse> newOrderHE({
    String symbolName = '',
    String quantity = '',
    String orderActionType = '',
    String orderType = '',
    String orderValidity = '',
    String account = '',
    String price = '',
    String orderCompletionType = '',
  });

  Future<String?> getSymbolNameIfExists({
    String symbolName = '',
  });
}
