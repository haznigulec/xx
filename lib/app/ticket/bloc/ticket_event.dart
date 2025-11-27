import 'package:dio/dio.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';

abstract class TicketEvent extends PEvent {}

class GetTicketsEvent extends TicketEvent {
  final String recordCount;
  final String skipCount;

  GetTicketsEvent({
    required this.recordCount,
    required this.skipCount,
  });
}

class AddTicketsEvent extends TicketEvent {
  final String subject;
  final String topic;

  final Function(int)? onSuccess;

  AddTicketsEvent({
    required this.subject,
    required this.topic,
    this.onSuccess,
  });
}

class SendTicketMessageEvent extends TicketEvent {
  final String content;
  final int ticketId;
  final List<String>? attachments;
  final Function(bool)? onSuccess;
  final bool hasLogs;

  SendTicketMessageEvent({
    required this.content,
    required this.ticketId,
    this.attachments,
    this.onSuccess,
    required this.hasLogs,
  });
}

class ChangeTicketStatusEvent extends TicketEvent {
  final String content;
  final int ticketId;
  final int ticketStatus;

  ChangeTicketStatusEvent({
    required this.content,
    required this.ticketId,
    required this.ticketStatus,
  });
}

class TicketEvaluateEvent extends TicketEvent {
  final int ticketId;
  final int star;

  TicketEvaluateEvent({
    required this.ticketId,
    required this.star,
  });
}

class GetTicketMessagesEvent extends TicketEvent {
  final int ticketId;

  GetTicketMessagesEvent({
    required this.ticketId,
  });
}

class TicketMessageAttachmentFile extends TicketEvent {
  final MultipartFile formFile;
  final Function(bool, String)? onSuccess;

  TicketMessageAttachmentFile({
    required this.formFile,
    this.onSuccess,
  });
}

class GetRepresentativeInfoEvent extends TicketEvent {}
