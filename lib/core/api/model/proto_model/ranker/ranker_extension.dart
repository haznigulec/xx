import 'dart:typed_data';

import 'package:piapiri_v2/core/api/model/proto_model/ranker/ranker_model.dart';
import 'package:piapiri_v2/core/gen/Ranker/Ranker.pb.dart';

RankerMarket rankerBytesToPiapiri(Uint8List protoBytes) => RankMessage.fromBuffer(protoBytes.toList()).toPiapiri();

extension RankerParser on Symbol {
  Ranker toPP() => Ranker(
        key: key,
        value: value,
        last: last,
        priceChange: priceChange,
        additionalValue: additionalValue,
        ask: ask,
        bid: bid,
      );
}

extension RankMessageParser on RankMessage {
  RankerMarket toPiapiri() => RankerMarket(
        symbols: symbols.map((e) => e.toPP()).toList(),
        bist30: bist30.map((e) => e.toPP()).toList(),
        bist100: bist100.map((e) => e.toPP()).toList(),
      );
}
