import 'package:piapiri_v2/core/api/model/proto_model/messenger/messenger.dart';
import 'package:piapiri_v2/core/gen/Messenger/Messenger.pb.dart';

extension MessengerParser on MessengerMessage {
  Messenger toPP() => Messenger(
        code: code,
        from: from,
        timestamp: timestamp.toInt(),
        contentType: contentType,
        subject: subject,
        content: content,
      );
}
