abstract class MarketOverlayModel {
  final int index;
  final String label;
  final String assetPath;

  MarketOverlayModel({
    required this.label,
    required this.index,
    required this.assetPath,
  });
}

class TopMarketOverlayModel extends MarketOverlayModel {
  TopMarketOverlayModel({
    required super.index,
    required super.label,
    required super.assetPath,
  });
}

class BottomMarketOverlayModel extends MarketOverlayModel {
  BottomMarketOverlayModel({
    required super.index,
    required super.label,
    required super.assetPath,
  });
}
