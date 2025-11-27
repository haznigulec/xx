abstract class BaseAlarm {
  final String id;
  final String symbol;
  final bool isActive;
  final String expireDate;
  final String note;
  String symbolType;
  String underlyingName;
  String description;

  BaseAlarm({
    required this.id,
    required this.symbol,
    required this.isActive,
    required this.expireDate,
    required this.note,
    this.symbolType = 'EQUITY',
    this.underlyingName = '',
    this.description = '',


  });
}

class NewsAlarm extends BaseAlarm {
  final List<dynamic> sources;

  NewsAlarm({
    required super.id,
    required super.symbol,
    required super.isActive,
    required super.expireDate,
    required super.note,
    super.symbolType,
    super.underlyingName,
    super.description,
    required this.sources,
  });

  factory NewsAlarm.fromJson(dynamic json) {
    String condition = (json['rule']['when'][0] as Map).keys.first;
    List<dynamic> alarmCondition = json['rule']['when'][0][condition] as List;
    return NewsAlarm(
      id: json['rule']['rule_id'],
      symbol: alarmCondition.last.toString(),
      sources: [
        condition,
      ],
      expireDate: json['rule']['expireDate'].toString(),
      note: (json['rule']['note'] ?? '').toString(),
      isActive: json['active'],
    );
  }
}

class PriceAlarm extends BaseAlarm {
  final double price;
  final String condition;

  PriceAlarm({
    required super.id,
    required super.symbol,
    required super.isActive,
    required super.expireDate,
    required super.note,
    super.symbolType,
    super.underlyingName,
    super.description,
    required this.price,
    required this.condition,
  });

  factory PriceAlarm.fromJson(dynamic json) {
    String condition = (json['rule']['when'][0] as Map).keys.first;
    List<dynamic> alarmCondition = json['rule']['when'][0][condition] as List;
    return PriceAlarm(
      id: json['rule']['rule_id'],
      symbol: alarmCondition.first.toString().split('.').first,
      price: double.parse(alarmCondition.last.toString()),
      condition: condition == 'ge' ? '>' : '<',
      expireDate: json['rule']['expireDate'].toString(),
      note: (json['rule']['note'] ?? '').toString(),
      isActive: json['active'],
    );
  }
}
