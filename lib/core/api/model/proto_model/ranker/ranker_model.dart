class Ranker {
  final String? key;
  final double? value;
  final double? last;
  final double? priceChange;
  final double? additionalValue;
  final double? ask;
  final double? bid;

  Ranker({
    this.key,
    this.value,
    this.last,
    this.priceChange,
    this.additionalValue,
    this.ask,
    this.bid,
  });
}

class RankerMarket {
  final List<Ranker> symbols;
  final List<Ranker> bist30;
  final List<Ranker> bist100;

  RankerMarket({
    required this.symbols,
    required this.bist30,
    required this.bist100,
  });
}
