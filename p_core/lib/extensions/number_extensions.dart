import 'dart:math';

/// https://en.wikipedia.org/wiki/IEEE_754
extension PrecisionExtension on double {
  double precision(int fractionDigits) {
    final num mod = pow(10.0, fractionDigits);
    return (this * mod).round().toDouble() / mod;
  }
}
