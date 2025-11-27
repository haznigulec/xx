import 'package:piapiri_v2/core/api/model/proto_model/computed_values/computed_values.dart';
import 'package:piapiri_v2/core/gen/ComputedValues/ComputedValues.pb.dart';

extension ComputedValuesParser on ComputedValuesMessage {
  ComputedValues toPP() => ComputedValues(
        symbol: symbol,
        updateDate: updateDate,
        optionClass: optionClass,
        strikePrice: strikePrice,
        impliedVolatility: impliedVolatility,
        instrinsicValue: instrinsicValue,
        timeValue: timeValue,
        leverage: leverage,
        delta: delta,
        gamma: gamma,
        theta: theta,
        vega: vega,
        rho: rho,
        breakEven: breakEven,
        omega: omega,
        sensitivity: sensitivity,
      );
}
