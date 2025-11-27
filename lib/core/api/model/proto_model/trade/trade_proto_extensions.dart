import 'dart:typed_data';

import 'package:piapiri_v2/core/api/model/proto_model/trade/trade_model.dart';
import 'package:piapiri_v2/core/gen/Trade/Trade.pb.dart';

Trade tradeBytesToPiapiri(Uint8List protoBytes) => TradeMessage.fromBuffer(protoBytes.toList()).toPiapiri();

extension TradeProtoParser on TradeMessage {
  Trade toPiapiri() => Trade(
        symbol: symbol,
        orderNo: orderNo,
        price: price,
        quantity: int.parse(quantity.toString()),
        activeBidOrAsk: activeBidOrAsk,
        timestamp: timestamp.toInt(),
        buyer: buyer,
        seller: seller,
        isTradeEx: isTradeEx,
      );
}
