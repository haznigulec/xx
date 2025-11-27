import 'dart:typed_data';

import 'package:piapiri_v2/core/api/model/proto_model/depthstats/depthstats_model.dart';
import 'package:piapiri_v2/core/gen/DepthStats/DepthStats.pb.dart';

DepthStats depthstatsBytesToPiapiri(Uint8List protoBytes) =>
    DepthStatsMessage.fromBuffer(protoBytes.toList()).toPiapiri();

extension DepthStatsProtoParser on DepthStatsMessage {
  DepthStats toPiapiri() => DepthStats(
        timestamp: timestamp.toInt(),
        totalBidWAvg: totalBidWAvg,
        totalAskWAvg: totalAskWAvg,
        totalBidQuantity: totalBidQuantity,
        totalAskQuantity: totalAskQuantity,
      );
}
