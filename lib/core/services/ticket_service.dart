import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/database/db_helper.dart';
import 'package:piapiri_v2/core/model/user_model.dart';

class TicketService {
  final ApiClient api;

  TicketService(this.api);

  static const String _getTickets = '/ticket/gettickets';
  static const String _getTicketMessages = '/ticket/getticketmessagesbyticketid';
  static const String _addTickets = '/ticket/addticket';
  static const String _sendTicketMessage = '/ticket/sendticketmessage';
  static const String _changeTicketStatus = '/ticket/changeticketstatus';
  static const String _evaluateTicket = '/ticket/evaluateticket';
  static const String _messageAttachmentFile = '/ticket/uploadmessageattachmentfile';
  static const String _getRepresentativeInfo = '/adkcustomer/getcustomerrepresentativeinformation';

  Future<ApiResponse> getTickets({
    required String skipCount,
    required String recordCount,
  }) {
    return api.post(
      _getTickets,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'skipCount': skipCount,
        'recordCount': recordCount,
      },
    );
  }

  Future<ApiResponse> getTicketMessages({
    required int ticketId,
  }) {
    return api.post(
      _getTicketMessages,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'ticketId': ticketId,
      },
    );
  }

  Future<ApiResponse> addTicket({
    required String subject,
    required String topic,
  }) async {
    return api.post(
      _addTickets,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'topic': topic,
        'subject': subject,
      },
    );
  }

  Future<ApiResponse> sendTicketMessage({
    required int ticketId,
    required String content,
    List<String>? attachments,
    bool hasLogs = false,
  }) async {
    DatabaseHelper dbhelper = DatabaseHelper();
    List<Map<String, dynamic>> logs = [];

    if (hasLogs) {
      logs = await dbhelper.getLogs();
    }
    return api.post(
      _sendTicketMessage,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'ticketId': ticketId,
        'content': content,
        'attachments': attachments,
        'log': jsonEncode(logs),
      },
    );
  }

  Future<ApiResponse> changeTicketStatus({
    required int ticketId,
    required int ticketStatus,
  }) async {
    return api.post(
      _changeTicketStatus,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'ticketId': ticketId,
        'ticketStatus': ticketStatus,
      },
    );
  }

  Future<ApiResponse> evaluateTicket({
    required int ticketId,
    required int star,
  }) async {
    return api.post(
      _evaluateTicket,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
        'ticketId': ticketId,
        'star': star,
      },
    );
  }

  Future<ApiResponse> messageAttachmentFile({
    required MultipartFile fromFile,
  }) {
    return api.multipartPost(
      _messageAttachmentFile,
      tokenized: true,
      body: {
        'CustomerExtId': UserModel.instance.customerId,
        'FormFile': fromFile,
      },
    );
  }

  Future<ApiResponse> getCustomerRepresentativeInfo() async {
    return api.post(
      _getRepresentativeInfo,
      tokenized: true,
      body: {
        'customerExtId': UserModel.instance.customerId,
      },
    );
  }
}
