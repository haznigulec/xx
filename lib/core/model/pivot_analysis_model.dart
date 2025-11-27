class PivotAnalysisModel {
  final String symbol;
  final double pivot;
  final double support1;
  final double support2;
  final double support3;
  final double resistance1;
  final double resistance2;
  final double resistance3;

  PivotAnalysisModel({
    this.symbol = '',
    required this.pivot,
    required this.support1,
    required this.support2,
    required this.support3,
    required this.resistance1,
    required this.resistance2,
    required this.resistance3,
  });

  factory PivotAnalysisModel.fromJson(Map<String, dynamic> json) {
    return PivotAnalysisModel(
      symbol: '',
      pivot: double.parse(json['pivotValue'].toString()),
      support1: double.parse(json['Support1'].toString()),
      support2: double.parse(json['Support2'].toString()),
      support3: double.parse(json['Support3'].toString()),
      resistance1: double.parse(json['resistance1'].toString()),
      resistance2: double.parse(json['resistance2'].toString()),
      resistance3: double.parse(json['resistance3'].toString()),
    );
  }

  factory PivotAnalysisModel.notFound() {
    return PivotAnalysisModel(
      symbol: 'ENOTFOUND',
      pivot: 0.0,
      support1: 0.0,
      support2: 0.0,
      support3: 0.0,
      resistance1: 0.0,
      resistance2: 0.0,
      resistance3: 0.0,
    );
  }

  PivotAnalysisModel copyWith({
    String? symbol,
  }) {
    return PivotAnalysisModel(
      symbol: symbol ?? this.symbol,
      pivot: pivot,
      support1: support1,
      support2: support2,
      support3: support3,
      resistance1: resistance1,
      resistance2: resistance2,
      resistance3: resistance3,
    );
  }
}

enum PivotLevels {
  above,
  below,
}
