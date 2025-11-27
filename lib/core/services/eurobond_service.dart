import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class EuroBondService {
  final ApiClient api;

  EuroBondService(this.api);

  static const String _getBondListUrl = '/AdkBond/getbondlist';
  static const String _validateOrderUrl = '/AdkBond/validateorder';
  static const String _addOrderUrl = '/AdkBond/addorder';
  static const String _deleteOrderUrl = '/AdkBond/deleteorder';
  static const String _getbondlimitUrl = '/AdkBond/getbondlimit';
  static const String _getBondDescriptionUrl = '/AdkBond/getbonddescription';

  Future<ApiResponse> getBondList({
    String finInstId = '',
  }) {
    return api.post(
      _getBondListUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'finInstId': finInstId,
      },
    );
  }

  Future<ApiResponse> validateOrder({
    String accountId = '',
    String finInstId = '',
    String side = '',
    double amount = 0,
  }) {
    return api.post(
      _validateOrderUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'accountExtId': accountId,
        'finInstId': finInstId,
        'side': side,
        'amount': amount,
      },
    );
  }

  Future<ApiResponse> addOrder({
    String accountId = '',
    String finInstName = '',
    String side = '',
    double amount = 0,
    double rate = 0,
    double nominal = 0,
    double unitPrice = 0,
  }) {
    return api.post(
      _addOrderUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'accountExtId': accountId,
        'finInstName': finInstName,
        'side': side,
        'amount': amount,
        'rate': rate,
        'nominal': nominal,
        'unitPrice': unitPrice,
      },
    );
  }

  Future<ApiResponse> deleteOrder({
    String accountId = '',
    String transactionId = '',
  }) {
    return api.post(
      _deleteOrderUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'accountExtId': accountId,
        'transactionId': transactionId,
      },
    );
  }

  Future<ApiResponse> getBondLimit({
    String accountId = '',
    String finInstName = '',
    String side = '',
  }) {
    return api.post(
      _getbondlimitUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'accountExtId': accountId,
        'finInstName': finInstName,
        'side': side,
      },
    );
  }

  Future<ApiResponse> getBondDescription() {
    return api.post(
      _getBondDescriptionUrl,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
      },
    );
  }
}
