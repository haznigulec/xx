import 'package:dio/dio.dart';
import 'package:piapiri_v2/app/ticket/repository/ticket_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class TicketRepositoryImpl extends TicketRepository {
  @override
  Future<ApiResponse> getTickets({
    required String skipCount,
    required String recordCount,
  }) {
    return getIt<PPApi>().ticketService.getTickets(
          skipCount: skipCount,
          recordCount: recordCount,
        );
  }

  @override
  Future<ApiResponse> getTicketMessages({
    required int ticketId,
  }) {
    return getIt<PPApi>().ticketService.getTicketMessages(
          ticketId: ticketId,
        );
  }

  @override
  Future<ApiResponse> addTicket({
    required String subject,
    required String topic,
  }) async {
    return getIt<PPApi>().ticketService.addTicket(
          subject: subject,
          topic: topic,
        );
  }

  @override
  Future<ApiResponse> sendTicketMessage({
    required int ticketId,
    required String content,
    List<String>? attachments,
    bool hasLogs = false,
  }) async {
    return getIt<PPApi>().ticketService.sendTicketMessage(
          ticketId: ticketId,
          content: content,
          attachments: attachments,
          hasLogs: hasLogs,
        );
  }

  @override
  Future<ApiResponse> changeTicketStatus({
    required int ticketId,
    required int ticketStatus,
  }) async {
    return getIt<PPApi>().ticketService.changeTicketStatus(
          ticketId: ticketId,
          ticketStatus: ticketStatus,
        );
  }

  @override
  Future<ApiResponse> evaluateTicket({
    required int ticketId,
    required int star,
  }) async {
    return getIt<PPApi>().ticketService.evaluateTicket(
          ticketId: ticketId,
          star: star,
        );
  }

  @override
  Future<ApiResponse> messageAttachmentFile({
    required MultipartFile fromFile,
  }) {
    return getIt<PPApi>().ticketService.messageAttachmentFile(
          fromFile: fromFile,
        );
  }

  @override
  Future<ApiResponse> getCustomerRepresentativeInfo() {
    return getIt<PPApi>().ticketService.getCustomerRepresentativeInfo();
  }
}
