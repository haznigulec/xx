import 'dart:ui';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:p_core/keys/navigator_keys.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';

enum TicketStatus {
  waiting,
  answered,
  closed,
}

abstract class TicketStatusHelper {
  // TicketStatus enum değerini int'e çevirir
  static int toValue(TicketStatus status) {
    switch (status) {
      case TicketStatus.waiting:
        return 10;
      case TicketStatus.answered:
        return 20;
      case TicketStatus.closed:
        return 30;
    }
  }

  // Statüye göre renk döndürür
  static Color toColor(int status) {
    switch (status) {
      case 10:
        return NavigatorKeys.navigatorKey.currentContext!.pColorScheme.primary;
      case 20:
        return NavigatorKeys.navigatorKey.currentContext!.pColorScheme.success;
      case 30:
        return NavigatorKeys.navigatorKey.currentContext!.pColorScheme.textTeritary;
      default:
        return NavigatorKeys.navigatorKey.currentContext!.pColorScheme.primary;
    }
  }

  // Statüye göre metin döndürür
  static String toText(int status) {
    switch (status) {
      case 10:
        return 'ticket_waiting';
      case 20:
        return 'ticket_answered';
      case 30:
        return 'closed_ticket';
      default:
        return 'ticket_unknown';
    }
  }

// Statüye göre image döndürür
  static String toImage(int status) {
    switch (status) {
      case 10:
        return ImagesPath.clock;
      case 20:
        return ImagesPath.check_circle;
      case 30:
        return ImagesPath.x;
      default:
        return ImagesPath.x;
    }
  }
}

class GetTicketsModel {
  int? id;
  String? topic;
  String? subject;
  String? customerExtId;
  String? created;
  int? ticketStatus;
  int? operatorId;

  GetTicketsModel({
    this.id,
    this.topic,
    this.subject,
    this.customerExtId,
    this.created,
    this.ticketStatus,
    this.operatorId,
  });

  factory GetTicketsModel.fromJson(Map<String, dynamic> json) => GetTicketsModel(
        id: json['id'],
        topic: json['topic'],
        subject: json['subject'] ?? '',
        customerExtId: json['customerExtId'],
        created: json['created'],
        ticketStatus: json['ticketStatus'],
        operatorId: json['operatorId'] ?? 0,
      );
}
