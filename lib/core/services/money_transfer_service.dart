import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class MoneyTransferService {
  final ApiClient api;

  MoneyTransferService(this.api);
  static const String _getCustomerBankAccounts = '/AdkCash/getcustomerbankaccounts';
  static const String _deleteCustomerBankCccount = '/AdkCash/deletecustomerbankaccount';
  static const String _getVirmanInstitutionsUrl = '/adkcash/GetVirmanInstitutions';
  static const String _getSystemParameters = '/AdkCustomer/getsystemparameters';
  static const String _addVirmanOrderUrl = '/AdkCash/addvirmanorder';
  static const String _addCustomerBankAccountUrl = '/AdkCash/addcustomerbankaccount';
  static const String _addMoneyTransferOrderUrl = '/AdkCash/addmoneytransferorder';
  static const String _getTradelimitUrl = '/adkcustomer/gettradelimit';
  static const String _getCollateralInfo = '/adkviop/getcollateralinfo';
  static const String _collateralAdministrationData = '/adkviop/collateraladministrationdata';
  static const String _getCustomerT0CreditNetLimits = '/AdkCash/getcustomerT0creditnetlimits';
  static const String _getT0creditTransactionExpenseInfo = '/AdkCash/getT0credittransactionexpenseinfo';
  static const String _addT0CreditTransaction = '/AdkCash/addT0credittransaction';

  Future<ApiResponse> getCustomerBankAccounts({
    String accountId = '',
  }) {
    return api.post(
      _getCustomerBankAccounts,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'accountExtId': '',
      },
    );
  }

  Future<ApiResponse> getEftInfo() {
    return api.post(
      _getSystemParameters,
      body: {
        'customerExtId': UserModel.instance.customerId,
      },
    );
  }

  /// Virman Kurumları
  Future<ApiResponse> getVirmanInstitutions() async {
    return api.post(
      _getVirmanInstitutionsUrl,
      tokenized: true,
      body: {
        'CustomerExtId': UserModel.instance.customerId,
        'AccountExtId': UserModel.instance.accountId,
      },
    );
  }

  Future<ApiResponse> deleteCustomerBankAccount({
    String accountId = '',
    String bankAccountId = '',
  }) async {
    return api.post(
      _deleteCustomerBankCccount,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'accountExtId': accountId,
        'bankAccountId': bankAccountId,
      },
    );
  }

  Future<ApiResponse> addCustomerBankAccount(
    String accountId,
    String ibanNo,
    String otpCode,
    String name,
  ) async {
    return api.post(
      _addCustomerBankAccountUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'accountExtId': accountId,
        'ibanNo': 'TR$ibanNo',
        'otpCode': otpCode,
        'name': name,
      },
    );
  }

  Future<ApiResponse> addMoneyTransferOrder({
    required String accountId,
    required String bankAccId,
    required double amount,
    required String description,
    required String finInstName,
  }) async {
    return api.post(
      _addMoneyTransferOrderUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'accountExtId': accountId,
        'transactionDate': DateTime.now().toString().replaceAll(' ', 'T'),
        'finInstName': finInstName,
        'bankAccId': bankAccId,
        'amount': amount,
        'description': description,
        'ibanAffirmance': false,
        'paymentType': 6,
      },
    );
  }

  Future<ApiResponse> addVirmanOrder({
    required String accountId,
    required String toAccountId,
    required double amount,
    required String description,
  }) async {
    return api.post(
      _addVirmanOrderUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'accountExtId': accountId,
        'toCustomerExtId': UserModel.instance.customerId,
        'toAccountExtId': toAccountId,
        'valueDate': DateTime.now().toString().replaceAll(' ', 'T'),
        'amount': amount,
        'description': description,
      },
    );
  }

  Future<ApiResponse> getTradeLimit({
    required String accountId,
    String? typeName,
  }) async {
    return api.post(
      _getTradelimitUrl,
      tokenized: true,
      body: {
        'CustomerExtId': UserModel.instance.customerId,
        'AccountExtId': accountId,
        'EquityName': '',
        'TypeName': typeName ?? 'CASH-T2',
      },
    );
  }

  Future<ApiResponse> getCollateralInfo({
    String accountId = '',
  }) {
    return api.post(
      _getCollateralInfo,
      tokenized: true,
      body: {
        'CustomerExtId': UserModel.instance.customerId,
        'AccountExtId': accountId,
        'IncludePassiveOrder': true,
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

  Future<ApiResponse> getCustomerT0CreditNetLimits() {
    return api.post(
      _getCustomerT0CreditNetLimits,
      tokenized: true,
      body: {
        'CustomerExtId': UserModel.instance.customerId ?? '',
      },
    );
  }

  Future<ApiResponse> getT0CreditTransactionExpenseInfo({
    String accountExtId = '',
    required double t1CreditAmount,
    required double t2CreditAmount,
  }) {
    return api.post(
      _getT0creditTransactionExpenseInfo,
      tokenized: true,
      body: {
        'CustomerExtId': UserModel.instance.customerId ?? '',
        'AccountExtId': accountExtId,
        't1CreditAmount': t1CreditAmount,
        't2CreditAmount': t2CreditAmount,
      },
    );
  }

  Future<ApiResponse> addT0CreditTransaction({
    String accountExtId = '',
    required double t1CreditAmount,
    required double t2CreditAmount,
  }) {
    return api.post(
      _addT0CreditTransaction,
      tokenized: true,
      body: {
        'CustomerExtId': UserModel.instance.customerId ?? '',
        'AccountExtId': accountExtId,
        't1CreditAmount': t1CreditAmount,
        't2CreditAmount': t2CreditAmount,
      },
    );
  }
}
