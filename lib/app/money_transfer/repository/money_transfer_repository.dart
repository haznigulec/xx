import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class MoneyTransferRepository {
  Future<ApiResponse> getCustomerBankAccounts({
    required String accountId,
  });

  Future<ApiResponse> deleteCustomerBankAccount({
    required String accountId,
    required String bankAccountId,
  });

  Future<ApiResponse> getEftInfo({
    required String accountId,
  });

  Future<ApiResponse> getVirementInstitutions();

  Future<ApiResponse> getTradeLimit({
    String accountId = '',
    String typeName = '',
  });

  Future<ApiResponse> getInstantCashAmount({
    required String accountId,
    required String finInstName,
  });

  Future<ApiResponse> requestOTP();

  Future<ApiResponse> addMoneyTransferOrder({
    required String accountId,
    required String bankAccId,
    required double amount,
    required String description,
    required String finInstName,
  });

  Future<ApiResponse> addVirmanOrder({
    required String accountId,
    required String toAccountId,
    required double amount,
    required String description,
  });

  Future<ApiResponse> addCustomerBankAccount({
    required String accountId,
    required String ibanNo,
    required String otpCode,
    required String name,
  });

  Future<ApiResponse> getCashBalance({
    required String accountId,
    String? typeName,
  });

  Future<ApiResponse> getCollateralInfo({
    String accountId = '',
  });

  Future<ApiResponse> collateralAdministrationData({
    String customerExtId = '',
    String accountExtId = '',
    double amount = 0,
    String source = '',
    String target = '',
  });

  Future<ApiResponse> getCustomerT0CreditNetLimits();

  Future<ApiResponse> getT0CreditTransactionExpenseInfo({
    String accountExtId = '',
    required double t1CreditAmount,
    required double t2CreditAmount,
  });

  Future<ApiResponse> addT0CreditTransaction({
    String accountExtId = '',
    required double t1CreditAmount,
    required double t2CreditAmount,
  });
}
