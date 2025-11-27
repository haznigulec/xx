import 'package:equatable/equatable.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';

class JournalFilterModel extends Equatable {
  final List<String> newsSources;
  final List<String> newsCategories;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<SymbolModel>? symbols;

  const JournalFilterModel({
    this.newsSources = const [
      'KAP',
      'MATRIKS',
    ],
    this.newsCategories = const [
      'GENEL',
      'EKONOMI',
      'SIYASI',
      'MAKRO_VERILER',
      'YORUM',
      'SIRKET',
      'ENERJI',
      'DIS_EKONOMI',
      'GELISMEKTE_OLAN_ULKELER',
      'EMTIA',
      'METAL',
      'FX',
      'TAHVIL_BONO',
      'KRIPTO_PARALAR',
    ],
    this.startDate,
    this.endDate,
    this.symbols,
  });

  JournalFilterModel copyWith({
    List<String>? newsSources,
    List<String>? newsCategories,
    DateTime? startDate,
    DateTime? endDate,
    List<SymbolModel>? symbols,
  }) {
    return JournalFilterModel(
      newsSources: newsSources ?? this.newsSources,
      newsCategories: newsCategories ?? this.newsCategories,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      symbols: symbols ?? this.symbols,
    );
  }

  @override
  List<Object?> get props => [
        newsSources,
        newsCategories,
        startDate,
        endDate,
        symbols,
      ];
}
