extension BzIterableExtensions<T> on Iterable<T> {
  T firstWhereOrDefault(bool Function(T element) comparator, T defaultValue) {
    try {
      return firstWhere(comparator);
    } on StateError catch (_) {
      return defaultValue;
    }
  }
}
