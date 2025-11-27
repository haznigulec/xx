import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class EurobondRepository {
  Future<ApiResponse> getBondList({
    String finInstId = '',
  });
  
  Future<ApiResponse> getBondAssets({
    required String accountId,
  });

  Future<ApiResponse> validateOrder({
    String accountId = '',
    String finInstId = '',
    String side = '',
    double amount = 0,
  });

  Future<ApiResponse> addOrder({
    String accountId = '',
    String finInstName = '',
    String side = '',
    double amount = 0,
    double rate = 0,
    double nominal = 0,
    double unitPrice = 0,
  });

  Future<ApiResponse> deleteOrder({
    String accountId = '',
    String transactionId = '',
  });

  Future<ApiResponse> getBondLimit({
    String accountId = '',
    String finInstName = '',
    String side = '',
  });

  Future<ApiResponse> getBondDescription();

  Future<ApiResponse> getTradeLimit();
}
