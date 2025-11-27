import 'package:piapiri_v2/core/model/symbol_types.dart';

enum SymbolSourceEnum {
  matriks('MATRIKS', [
    SymbolTypes.equity,
    SymbolTypes.warrant,
    SymbolTypes.future,
    SymbolTypes.option,
    SymbolTypes.bond,
    SymbolTypes.parity,
    SymbolTypes.crypto,
    SymbolTypes.commodity,
    SymbolTypes.certificate,
    SymbolTypes.indexType,
    SymbolTypes.etf,
    SymbolTypes.right,
    SymbolTypes.libor,
    SymbolTypes.undefined,
  ]),
  alpaca('ALPACA', [SymbolTypes.foreign]),
  tefas('TEFAS', [SymbolTypes.fund]);

  final String value;
  final List<SymbolTypes> symbolTypes;
  const SymbolSourceEnum(
    this.value,
    this.symbolTypes,
  );
}
