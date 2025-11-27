import 'package:equatable/equatable.dart';

class ReviewFilterModel extends Equatable {
  final List<String> newsSources;
  final List<String> newsCategories;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? symbolName;

  const ReviewFilterModel({
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
    this.symbolName,
  });

  ReviewFilterModel copyWith({
    List<String>? newsSources,
    List<String>? newsCategories,
    DateTime? startDate,
    DateTime? endDate,
    String? symbolName,
  }) {
    return ReviewFilterModel(
      newsSources: newsSources ?? this.newsSources,
      newsCategories: newsCategories ?? this.newsCategories,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      symbolName: symbolName ?? this.symbolName,
    );
  }

  @override
  List<Object?> get props => [
        newsSources,
        newsCategories,
        startDate,
        endDate,
        symbolName,
      ];
}
