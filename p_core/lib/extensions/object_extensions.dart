extension ObjectExt<T> on T {
  R let<R>(R Function(T that) op) => op(this);

  R? castOrNull<R>() => this is R ? this as R : null;

  R castOrFallback<R>(R fallback) => this is R ? this as R : fallback;
}
