import 'package:piapiri_v2/app/ticket/model/get_ticket_messages_model.dart';
import 'package:piapiri_v2/app/ticket/model/get_tickets_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';

class TicketState extends PState {
  final List<GetTicketsModel> tickets;
  final List<GetTicketMessagesModel> ticketMessages;
  final String? ticketFile;
  final int? ticketId;
  final Map<String, dynamic>? representativeInfo;

  const TicketState({
    super.type = PageState.initial,
    super.error,
    this.tickets = const [],
    this.ticketMessages = const [],
    this.ticketFile,
    this.ticketId,
    this.representativeInfo,
  });

  @override
  TicketState copyWith({
    PageState? type,
    PBlocError? error,
    List<GetTicketsModel>? tickets,
    List<GetTicketMessagesModel>? ticketMessages,
    String? ticketFile,
    int? ticketId,
    Map<String, dynamic>? representativeInfo,
  }) {
    return TicketState(
      type: type ?? this.type,
      error: error ?? this.error,
      tickets: tickets ?? this.tickets,
      ticketMessages: ticketMessages ?? this.ticketMessages,
      ticketFile: ticketFile ?? this.ticketFile,
      ticketId: ticketId ?? this.ticketId,
      representativeInfo: representativeInfo ?? this.representativeInfo,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        tickets,
        ticketMessages,
        ticketFile,
        ticketId,
        representativeInfo,
      ];
}
