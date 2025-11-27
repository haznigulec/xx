import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:piapiri_v2/app/ticket/bloc/ticket_bloc.dart';
import 'package:piapiri_v2/app/ticket/bloc/ticket_event.dart';
import 'package:piapiri_v2/app/ticket/model/get_tickets_model.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

//Mesaj gönderme butonu
class SendMessageButton extends StatelessWidget {
  final GetTicketsModel tickets;
  final TextEditingController textController;
  final List<File>? files;
  final Function(List<String>) onSendMessage;
  final TicketBloc ticketBloc;

  const SendMessageButton({
    super.key,
    required this.tickets,
    required this.textController,
    required this.files,
    required this.onSendMessage,
    required this.ticketBloc,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: context.pColorScheme.transparent,
      focusColor: context.pColorScheme.transparent,
      highlightColor: context.pColorScheme.transparent,
      onTap: () async {
        List<String> fileUrlList = [];
        if (files != null && files!.isNotEmpty) {
          for (File file in files!) {
            ticketBloc.add(
              TicketMessageAttachmentFile(
                formFile: await MultipartFile.fromFile(
                  file.path,
                  filename: basename(file.path),
                ),
                onSuccess: (bool success, dynamic fileUrl) {
                  if (success && fileUrl != null) {
                    fileUrlList.add(fileUrl);
                    _sendMessage(fileUrlList);
                  }
                },
              ),
            );
          }
        } else {
          _sendMessage([]);
        }
      },
      child: Transform.scale(
        scale: 0.5,
        child: SvgPicture.asset(
          ImagesPath.send,
          width: 17,
          colorFilter: ColorFilter.mode(
            context.pColorScheme.primary,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  void _sendMessage(List<String> fileUrlList) {
    if (textController.text.isNotEmpty || fileUrlList.isNotEmpty) {
      ticketBloc.add(
        SendTicketMessageEvent(
          content: textController.text,
          ticketId: tickets.id!,
          attachments: fileUrlList,
          onSuccess: (_) {
            textController.clear();
            onSendMessage(fileUrlList);
          },
          hasLogs: false,
        ),
      );
    }
  }
}
