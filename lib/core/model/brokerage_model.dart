class BrokerageModel {
  final String startDate;
  final String endDate;
  final TopBrokers tops;
  final TotalSumModel sums;
  final List<AllBrokerageModel> all;

  BrokerageModel({
    required this.startDate,
    required this.endDate,
    required this.tops,
    required this.sums,
    required this.all,
  });

  factory BrokerageModel.fromJson(Map<String, dynamic> json) {
    return BrokerageModel(
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      tops: TopBrokers.fromJson(json['tops']),
      sums: TotalSumModel.fromJson(json['sums']),
      all: json['all'].map<AllBrokerageModel>((e) => AllBrokerageModel.fromJson(e)).toList(),
    );
  }

  BrokerageModel copyWith({
    String? startDate,
    String? endDate,
    TopBrokers? tops,
    TotalSumModel? sums,
    List<AllBrokerageModel>? all,
  }) {
    return BrokerageModel(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      tops: tops ?? this.tops,
      sums: sums ?? this.sums,
      all: all ?? this.all,
    );
  }
}

class TopBrokers {
  final List<MainBrokerageModel> bid;
  final List<MainBrokerageModel> ask;
  final List<MainBrokerageModel> total;
  final MainBrokerageModel rest;

  TopBrokers({
    required this.bid,
    required this.ask,
    required this.total,
    required this.rest,
  });

  factory TopBrokers.fromJson(Map<String, dynamic> json) {
    return TopBrokers(
      bid: json['bid'].map<MainBrokerageModel>((e) => MainBrokerageModel.fromJson(e)).toList(),
      ask: json['ask'].map<MainBrokerageModel>((e) => MainBrokerageModel.fromJson(e)).toList(),
      total: json['total'].map<MainBrokerageModel>((e) => MainBrokerageModel.fromJson(e)).toList(),
      rest: MainBrokerageModel.fromJson(json['rest']),
    );
  }

  TopBrokers copyWith({
    List<MainBrokerageModel>? bid,
    List<MainBrokerageModel>? ask,
    List<MainBrokerageModel>? total,
    MainBrokerageModel? rest,
  }) {
    return TopBrokers(
      bid: bid ?? this.bid,
      ask: ask ?? this.ask,
      total: total ?? this.total,
      rest: rest ?? this.rest,
    );
  }
}

class TotalSumModel {
  final SumModel bid;
  final SumModel ask;
  final int quantity;

  TotalSumModel({
    required this.bid,
    required this.ask,
    required this.quantity,
  });

  factory TotalSumModel.fromJson(Map<String, dynamic> json) {
    return TotalSumModel(
      bid: SumModel.fromJson(json['bid']),
      ask: SumModel.fromJson(json['ask']),
      quantity: json['quantity'],
    );
  }
}

class SumModel {
  final int quantity;
  final int newtQuantity;
  final double volume;

  SumModel({
    required this.quantity,
    required this.newtQuantity,
    required this.volume,
  });

  factory SumModel.fromJson(Map<String, dynamic> json) {
    return SumModel(
      quantity: json['quantity'] ?? 0,
      newtQuantity: json['newtQuantity'] ?? 0,
      volume: double.parse((json['volume'] ?? '0').toString()),
    );
  }
}

class AllBrokerageModel {
  final String agent;
  final int agentId;
  final double swapRt;
  final double netPercent;
  final double cost;
  final int netQuantity;
  final int totalQuantity;
  final double volume;
  final int quantity;
  final MainBrokerageModel bid;
  final MainBrokerageModel ask;

  AllBrokerageModel({
    required this.agent,
    required this.agentId,
    required this.swapRt,
    required this.netPercent,
    required this.cost,
    required this.netQuantity,
    required this.totalQuantity,
    required this.volume,
    required this.quantity,
    required this.bid,
    required this.ask,
  });

  factory AllBrokerageModel.fromJson(Map<String, dynamic> json) {
    return AllBrokerageModel(
      agent: json['agent'] ?? '',
      agentId: json['agentId'] ?? 0,
      swapRt: double.parse((json['swapRT'] ?? 0).toString()),
      netPercent: double.parse(((json['netPercent'] ?? json['percent']) ?? 0).toString()),
      cost: double.parse((json['cost'] ?? 0).toString()),
      netQuantity: json['netQuantity'] ?? 0,
      totalQuantity: json['totalQuantity'] ?? 0,
      volume: double.parse((json['volume'] ?? 0).toString()),
      quantity: json['quantity'] ?? 0,
      bid: MainBrokerageModel.fromJson(json['bid']),
      ask: MainBrokerageModel.fromJson(json['ask']),
    );
  }
}

class MainBrokerageModel {
  final String agent;
  final int agentId;
  final double swapRt;
  final double netPercent;
  final double cost;
  final int netQuantity;
  final int totalQuantity;
  final double volume;
  final int quantity;

  MainBrokerageModel({
    required this.agent,
    required this.agentId,
    required this.swapRt,
    required this.netPercent,
    required this.cost,
    required this.netQuantity,
    required this.totalQuantity,
    required this.volume,
    required this.quantity,
  });

  factory MainBrokerageModel.fromJson(Map<String, dynamic> json) {
    return MainBrokerageModel(
      agent: json['agent'] ?? '',
      agentId: json['agentId'] ?? 0,
      swapRt: double.parse((json['swapRT'] ?? 0).toString()),
      netPercent: double.parse(((json['netPercent'] ?? json['percent']) ?? 0).toString()),
      cost: double.parse((json['cost'] ?? 0).toString()),
      netQuantity: json['netQuantity'] ?? 0,
      totalQuantity: json['totalQuantity'] ?? 0,
      volume: double.parse((json['volume'] ?? 0).toString()),
      quantity: json['quantity'] ?? 0,
    );
  }
}
