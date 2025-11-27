import 'dart:typed_data';

import 'package:piapiri_v2/core/api/model/proto_model/depth/depth_model.dart';
import 'package:piapiri_v2/core/gen/DepthTable/DepthTable.pb.dart';

Depth depthBytesToPiapiri(Uint8List protoBytes) => DepthTableMessage.fromBuffer(protoBytes.toList()).toPiapiri();

extension DepthStatsProtoParser on DepthTableMessage {
  Depth toPiapiri() => Depth(
        action: action,
        actionOrderCount: actionOrderCount.toInt(),
        actionPrice: actionPrice,
        actionQuantity: actionQuantity.toInt(),
        asks: asks,
        bidAsk: bidAsk,
        bids: bids,
        dateSymbol: dateSymbol,
        row: row,
        symbol: symbol,
        timestamp: timestamp.toInt(),
      );
}
