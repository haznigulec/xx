class ComputedValues {
  String symbol;
  String updateDate;
  String optionClass;
  double strikePrice;
  double impliedVolatility;
  double instrinsicValue;
  double timeValue;
  double leverage;
  double delta;
  double gamma;
  double theta;
  double vega;
  double rho;
  double breakEven;
  double omega;
  double sensitivity;

  ComputedValues({
    required this.symbol,
    required this.updateDate,
    required this.optionClass,
    required this.strikePrice,
    required this.impliedVolatility,
    required this.instrinsicValue,
    required this.timeValue,
    required this.leverage,
    required this.delta,
    required this.gamma,
    required this.theta,
    required this.vega,
    required this.rho,
    required this.breakEven,
    required this.omega,
    required this.sensitivity,
  });
}
