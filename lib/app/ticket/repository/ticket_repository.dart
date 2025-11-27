import 'package:dio/dio.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class TicketRepository {
  Future<ApiResponse> getTickets({
    required String skipCount,
    required String recordCount,
  });

  Future<ApiResponse> getTicketMessages({
    required int ticketId,
  });

  Future<ApiResponse> addTicket({
    required String subject,
    required String topic,
  });

  Future<ApiResponse> sendTicketMessage({
    required int ticketId,
    required String content,
    List<String>? attachments,
    bool hasLogs = false,
  });

  Future<ApiResponse> changeTicketStatus({
    required int ticketId,
    required int ticketStatus,
  });

  Future<ApiResponse> evaluateTicket({
    required int ticketId,
    required int star,
  });

  Future<ApiResponse> messageAttachmentFile({
    required MultipartFile fromFile,
  });

  Future<ApiResponse> getCustomerRepresentativeInfo();
}
