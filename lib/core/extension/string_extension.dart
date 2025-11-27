import 'package:turkish/turkish.dart';

extension PPStringExtensions on String? {
  bool get isNullOrBlank => this == null || this!.trim().isEmpty;

  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  bool get isNotNullOrBlank => this != null && this!.trim().isNotEmpty;

  String? get asNullIfBlank => isNullOrBlank ? null : this;

  String get toCapitalizeCaseTr => turkish.toLowerCase(this!).split(' ').map((word) {
        if (RegExp(r'^(a\.ş\.?|A\.Ş\.?)$').hasMatch(word)) {
          return 'A.Ş.';
        }
        // Normal kelimeleri title case yap
        return turkish.toTitleCase(word);
      }).join(' ');

  String get toCapitalizeCaseTrAdvanced {
    if (this == null || this!.trim().isEmpty) return this ?? '';
    final input = this!;

    // Separator: boşluk, /, -, _, (, )
    final sepPattern = RegExp(r'([ /\-_()]+)', unicode: true);

    return input.splitMapJoin(
      sepPattern,
      onMatch: (m) => m.group(0)!, // Separator’ları olduğu gibi bırak
      onNonMatch: (segment) {
        if (segment.isEmpty) return segment;

        // A.Ş. gibi özel durumları koru
        if (RegExp(r'^(a\.ş\.?|aş)$', caseSensitive: false, unicode: true).hasMatch(segment)) {
          return 'A.Ş.';
        }

        // Türkçe karakterleri doğru şekilde title case yap
        final lower = turkish.toLowerCase(segment);
        return turkish.toTitleCase(lower);
      },
    );
  }
}
