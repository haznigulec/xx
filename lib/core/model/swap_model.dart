class SwapModel {
  final DateTime date;
  final String symbol;
  final List<AgentQuantity> agentQuantities;
  final double usdtry;
  final double eurtry;
  final double close;
  final double totalQuantity;
  final double totalVolume;
  final double totalVolumeUsd;
  final double totalVolumeEur;
  final String time;

  SwapModel({
    required this.date,
    required this.symbol,
    required this.agentQuantities,
    required this.usdtry,
    required this.eurtry,
    required this.close,
    required this.totalQuantity,
    required this.totalVolume,
    required this.totalVolumeUsd,
    required this.totalVolumeEur,
    required this.time,
  });

  factory SwapModel.fromJson(Map<String, dynamic> json) => SwapModel(
        date: DateTime.parse(json['date']),
        symbol: json['symbol'],
        agentQuantities: List<AgentQuantity>.from(json['agentQuantities'].map((x) => AgentQuantity.fromJson(x)) ?? []),
        usdtry: json['usdtry']?.toDouble(),
        eurtry: json['eurtry']?.toDouble(),
        close: json['close']?.toDouble(),
        totalQuantity: json['totalQuantity']?.toDouble(),
        totalVolume: json['totalVolume']?.toDouble(),
        totalVolumeUsd: json['totalVolumeUSD']?.toDouble(),
        totalVolumeEur: json['totalVolumeEUR']?.toDouble(),
        time: json['time'],
      );

  Map<String, dynamic> toJson() => {
        'date':
            '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
        'symbol': symbol,
        'agentQuantities': List<dynamic>.from(agentQuantities.map((x) => x.toJson())),
        'usdtry': usdtry,
        'eurtry': eurtry,
        'close': close,
        'totalQuantity': totalQuantity,
        'totalVolume': totalVolume,
        'totalVolumeUSD': totalVolumeUsd,
        'totalVolumeEUR': totalVolumeEur,
        'time': time,
      };

  SwapModel copyWith({
    DateTime? date,
    String? symbol,
    List<AgentQuantity>? agentQuantities,
    double? usdtry,
    double? eurtry,
    double? close,
    double? totalQuantity,
    double? totalVolume,
    double? totalVolumeUsd,
    double? totalVolumeEur,
    String? time,
  }) =>
      SwapModel(
        date: date ?? this.date,
        symbol: symbol ?? this.symbol,
        agentQuantities: agentQuantities ?? this.agentQuantities,
        usdtry: usdtry ?? this.usdtry,
        eurtry: eurtry ?? this.eurtry,
        close: close ?? this.close,
        totalQuantity: totalQuantity ?? this.totalQuantity,
        totalVolume: totalVolume ?? this.totalVolume,
        totalVolumeUsd: totalVolumeUsd ?? this.totalVolumeUsd,
        totalVolumeEur: totalVolumeEur ?? this.totalVolumeEur,
        time: time ?? this.time,
      );
}

class AgentQuantity {
  final String agent;
  final int agentId;
  final double quantity;
  final int t0Quantity;
  final int t1Quantity;
  final double cost;
  final double volume;
  final double volumeEur;
  final double volumeUsd;

  AgentQuantity({
    required this.agent,
    required this.agentId,
    required this.quantity,
    required this.t0Quantity,
    required this.t1Quantity,
    required this.cost,
    required this.volume,
    required this.volumeEur,
    required this.volumeUsd,
  });

  factory AgentQuantity.fromJson(Map<String, dynamic> json) => AgentQuantity(
        agent: json['agent'] ?? '',
        agentId: json['agentId'] ?? 0,
        quantity: json['quantity']?.toDouble() ?? 0.0,
        t0Quantity: json['t0_quantity'] ?? 0,
        t1Quantity: json['t1_quantity'] ?? 0,
        cost: json['cost']?.toDouble() ?? 0,
        volume: json['volume']?.toDouble() ?? 0.0,
        volumeEur: json['volumeEUR']?.toDouble() ?? 0.0,
        volumeUsd: json['volumeUSD']?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        'agent': agent,
        'agentId': agentId,
        'quantity': quantity,
        't0_quantity': t0Quantity,
        't1_quantity': t1Quantity,
        'cost': cost,
        'volume': volume,
        'volumeEUR': volumeEur,
        'volumeUSD': volumeUsd,
      };

  AgentQuantity copyWith({
    String? agent,
    int? agentId,
    double? quantity,
    int? t0Quantity,
    int? t1Quantity,
    double? cost,
    double? volume,
    double? volumeEur,
    double? volumeUsd,
  }) =>
      AgentQuantity(
        agent: agent ?? this.agent,
        agentId: agentId ?? this.agentId,
        quantity: quantity ?? this.quantity,
        t0Quantity: t0Quantity ?? this.t0Quantity,
        t1Quantity: t1Quantity ?? this.t1Quantity,
        cost: cost ?? this.cost,
        volume: volume ?? this.volume,
        volumeEur: volumeEur ?? this.volumeEur,
        volumeUsd: volumeUsd ?? this.volumeUsd,
      );
}
