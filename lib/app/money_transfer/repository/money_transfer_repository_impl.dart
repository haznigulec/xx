import 'package:piapiri_v2/app/money_transfer/repository/money_transfer_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class MoneyTransferRepositoryImpl implements MoneyTransferRepository {
  @override
  Future<ApiResponse> deleteCustomerBankAccount({
    required String accountId,
    required String bankAccountId,
  }) {
    return getIt<PPApi>().moneyTransferService.deleteCustomerBankAccount(
          accountId: accountId,
          bankAccountId: bankAccountId,
        );
  }

  @override
  Future<ApiResponse> getCustomerBankAccounts({
    required String accountId,
  }) {
    return getIt<PPApi>().moneyTransferService.getCustomerBankAccounts(
          accountId: accountId,
        );
  }

  @override
  Future<ApiResponse> getEftInfo({
    required String accountId,
  }) {
    return getIt<PPApi>().moneyTransferService.getEftInfo();
  }

  @override
  Future<ApiResponse> getVirementInstitutions() {
    return getIt<PPApi>().moneyTransferService.getVirmanInstitutions();
  }

  @override
  Future<ApiResponse> getTradeLimit({
    String accountId = '',
    String typeName = '',
  }) {
    return getIt<PPApi>().assetsService.getTradeLimit(
          accountId: accountId,
          typeName: typeName,
        );
  }

  @override
  Future<ApiResponse> getInstantCashAmount({
    required String accountId,
    required String finInstName,
  }) {
    return getIt<PPApi>().usBalanceService.getInstantCashAmount(
          accountId: accountId,
          finInstName: finInstName,
        );
  }

  @override
  Future<ApiResponse> requestOTP() {
    return getIt<PPApi>().authService.requestOtp(getIt<AppInfoBloc>().state.customerId);
  }

  @override
  Future<ApiResponse> addMoneyTransferOrder({
    required String accountId,
    required String bankAccId,
    required double amount,
    required String description,
    required String finInstName,
  }) {
    return getIt<PPApi>().moneyTransferService.addMoneyTransferOrder(
          accountId: accountId,
          bankAccId: bankAccId,
          amount: amount,
          description: description,
          finInstName: finInstName,
        );
  }

  @override
  Future<ApiResponse> addVirmanOrder({
    required String accountId,
    required String toAccountId,
    required double amount,
    required String description,
  }) {
    return getIt<PPApi>().moneyTransferService.addVirmanOrder(
          accountId: accountId,
          toAccountId: toAccountId,
          amount: amount,
          description: description,
        );
  }

  @override
  Future<ApiResponse> addCustomerBankAccount({
    required String accountId,
    required String ibanNo,
    required String otpCode,
    required String name,
  }) {
    return getIt<PPApi>().moneyTransferService.addCustomerBankAccount(
          accountId,
          ibanNo,
          otpCode,
          name,
        );
  }

  @override
  Future<ApiResponse> getCashBalance({
    required String accountId,
    String? typeName,
  }) {
    return getIt<PPApi>().moneyTransferService.getTradeLimit(
          accountId: accountId,
          typeName: typeName,
        );
  }

  @override
  Future<ApiResponse> getCollateralInfo({
    String accountId = '',
  }) {
    return getIt<PPApi>().moneyTransferService.getCollateralInfo(
          accountId: accountId,
        );
  }

  @override
  Future<ApiResponse> collateralAdministrationData({
    String customerExtId = '',
    String accountExtId = '',
    double amount = 0,
    String source = '',
    String target = '',
  }) {
    return getIt<PPApi>().moneyTransferService.collateralAdministrationData(
          customerExtId: customerExtId,
          accountExtId: accountExtId,
          amount: amount,
          source: source,
          target: target,
        );
  }

  @override
  Future<ApiResponse> getCustomerT0CreditNetLimits() {
    return getIt<PPApi>().moneyTransferService.getCustomerT0CreditNetLimits();
  }

  @override
  Future<ApiResponse> getT0CreditTransactionExpenseInfo({
    String accountExtId = '',
    required double t1CreditAmount,
    required double t2CreditAmount,
  }) {
    return getIt<PPApi>().moneyTransferService.getT0CreditTransactionExpenseInfo(
          accountExtId: accountExtId,
          t1CreditAmount: t1CreditAmount,
          t2CreditAmount: t2CreditAmount,
        );
  }

  @override
  Future<ApiResponse> addT0CreditTransaction({
    String accountExtId = '',
    required double t1CreditAmount,
    required double t2CreditAmount,
  }) {
    return getIt<PPApi>().moneyTransferService.addT0CreditTransaction(
          accountExtId: accountExtId,
          t1CreditAmount: t1CreditAmount,
          t2CreditAmount: t2CreditAmount,
        );
  }
}
