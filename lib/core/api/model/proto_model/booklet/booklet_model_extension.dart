import 'dart:typed_data';

import 'package:piapiri_v2/core/api/model/proto_model/booklet/booklet_model.dart';
import 'package:piapiri_v2/core/gen/Booklet/TopOfTheBook.pb.dart';

TopOfTheBookMessageModel topOfBookBytesToPiapiri(Uint8List protoBytes) =>
    TopOfTheBookMessage.fromBuffer(protoBytes.toList()).toPiapiri();

extension TopOfBookProtoParser on TopOfTheBookMessage {
  TopOfTheBookMessageModel toPiapiri() => TopOfTheBookMessageModel(
        symbol: symbol,
        asks: asks.map((o) => o.toPiapiri()).toList(),
        bids: bids.map((o) => o.toPiapiri()).toList(),
        action: TopOfTheBookAction.values[action.value],
        bidAsk: TopOfTheBookBidAsk.values[bidAsk.value],
        affectedRow: affectedRow,
      );
}

extension OrderProtoParser on Order {
  BookletModel toPiapiri() => BookletModel(
        orderID: orderID.toInt(),
        timestamp: timestamp.toInt(),
        quantity: quantity,
        price: price,
      );
}
