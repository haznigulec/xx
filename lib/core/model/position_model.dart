import 'package:equatable/equatable.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class PositionModel extends Equatable {
  final String? accountId;
  final String symbolName;
  final num qty;
  final String description;
  final String underlyingName;
  final SymbolTypes symbolType;
  final String? viopSide;
  const PositionModel({
    this.accountId,
    required this.symbolName,
    required this.qty,
    required this.description,
    required this.underlyingName,
    required this.symbolType,
    this.viopSide,
  });

  @override
  List<Object?> get props => [
        accountId,
        symbolName,
        qty,
        description,
        underlyingName,
        symbolType,
        viopSide,
      ];
}
