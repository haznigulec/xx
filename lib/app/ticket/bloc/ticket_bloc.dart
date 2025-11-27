import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_insider/flutter_insider.dart';
import 'package:piapiri_v2/app/ticket/bloc/ticket_event.dart';
import 'package:piapiri_v2/app/ticket/bloc/ticket_state.dart';
import 'package:piapiri_v2/app/ticket/model/get_ticket_messages_model.dart';
import 'package:piapiri_v2/app/ticket/model/get_tickets_model.dart';
import 'package:piapiri_v2/app/ticket/repository/ticket_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';

class TicketBloc extends PBloc<TicketState> {
  final TicketRepository _ticketRepository;

  TicketBloc({
    required TicketRepository ticketRepository,
  })  : _ticketRepository = ticketRepository,
        super(initialState: const TicketState()) {
    on<GetTicketsEvent>(_onGetTickets);
    on<GetTicketMessagesEvent>(_onGetTicketMessages);
    on<AddTicketsEvent>(_onAddTicket);
    on<SendTicketMessageEvent>(_onSendTicketMessage);
    on<ChangeTicketStatusEvent>(_onChangeTicketStatus);
    on<TicketEvaluateEvent>(_onTicketEvaluate);
    on<TicketMessageAttachmentFile>(_onMessageAttachmentFile);
    on<GetRepresentativeInfoEvent>(_onGetRepresentativeInfo);
  }

  FutureOr<void> _onGetTickets(
    GetTicketsEvent event,
    Emitter<TicketState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    ApiResponse response = await _ticketRepository.getTickets(
      recordCount: event.recordCount,
      skipCount: event.skipCount,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
          tickets: response.data['ticketList'].map<GetTicketsModel>((e) => GetTicketsModel.fromJson(e)).toList(),
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05PROF15',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetTicketMessages(
    GetTicketMessagesEvent event,
    Emitter<TicketState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _ticketRepository.getTicketMessages(
      ticketId: event.ticketId,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
          ticketMessages:
              response.data['messages'].map<GetTicketMessagesModel>((e) => GetTicketMessagesModel.fromJson(e)).toList(),
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05PROF16',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onAddTicket(
    AddTicketsEvent event,
    Emitter<TicketState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _ticketRepository.addTicket(
      topic: event.topic,
      subject: event.subject,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
          ticketId: response.data['ticketId'],
        ),
      );
      event.onSuccess?.call(response.data['ticketId']);
      add(GetTicketsEvent(skipCount: '0', recordCount: '10'));
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05PROF17',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onSendTicketMessage(
    SendTicketMessageEvent event,
    Emitter<TicketState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _ticketRepository.sendTicketMessage(
      ticketId: event.ticketId,
      content: event.content,
      attachments: event.attachments,
      hasLogs: event.hasLogs,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      event.onSuccess?.call(response.success);
      add(GetTicketMessagesEvent(ticketId: event.ticketId));
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05PROF18',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onChangeTicketStatus(
    ChangeTicketStatusEvent event,
    Emitter<TicketState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _ticketRepository.changeTicketStatus(
      ticketId: event.ticketId,
      ticketStatus: event.ticketStatus,
    );

    if (response.success) {
      add(GetTicketsEvent(skipCount: '0', recordCount: '10'));
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05PROF19',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onTicketEvaluate(
    TicketEvaluateEvent event,
    Emitter<TicketState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _ticketRepository.evaluateTicket(
      ticketId: event.ticketId,
      star: event.star,
    );

    if (response.success) {
      add(GetTicketsEvent(skipCount: '0', recordCount: '10'));
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05PROF20',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onMessageAttachmentFile(
    TicketMessageAttachmentFile event,
    Emitter<TicketState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _ticketRepository.messageAttachmentFile(
      fromFile: event.formFile,
    );

    if (response.success) {
      emit(
        state.copyWith(
          type: PageState.success,
        ),
      );
      final String fileUrl = response.data['fileUrl'];
      event.onSuccess?.call(response.success, fileUrl);
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05PROF22',
          ),
        ),
      );
    }
  }

  FutureOr<void> _onGetRepresentativeInfo(
    GetRepresentativeInfoEvent event,
    Emitter<TicketState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );

    ApiResponse response = await _ticketRepository.getCustomerRepresentativeInfo();

    if (response.success) {
      if (response.data['representativeName'] != null) {
        FlutterInsider.Instance.getCurrentUser()
          ?..setCustomAttributeWithString('representative_name', response.data['representativeName'])
          ..setCustomAttributeWithString('representative_email', response.data['contactMail'])
          ..setCustomAttributeWithString('representative_phone', response.data['phoneNumber']);
      }
      emit(
        state.copyWith(
          type: PageState.success,
          representativeInfo: response.data,
        ),
      );
    } else {
      emit(
        state.copyWith(
          type: PageState.failed,
          error: PBlocError(
            showErrorWidget: true,
            message: response.error?.message ?? '',
            errorCode: '05PROF31',
          ),
        ),
      );
    }
  }
}
