import 'dart:ui';

import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/model/warrant_calculation_model.dart';

abstract class MatriksEvent extends PEvent {}

class MatriksGetTopicsEvent extends MatriksEvent {
  final bool isLoggedIn;
  final VoidCallback? callback;

  MatriksGetTopicsEvent({
    this.isLoggedIn = false,
    this.callback,
  });
}

class MatriksGetDiscoEvent extends MatriksEvent {
  final VoidCallback callback;

  MatriksGetDiscoEvent({
    required this.callback,
  });
}

class MatriksWarrantCalculatorEvent extends MatriksEvent {
  final String symbol;
  final Function(WarrantCalculateModel) callback;

  MatriksWarrantCalculatorEvent({
    required this.symbol,
    required this.callback,
  });
}

class MatriksWarrantCalculatorDetailsEvent extends MatriksEvent {
  final String symbol;
  final String referenceDate;
  final double underlyingValue;
  final double volatility;
  final double interestRate;
  final double? currency;
  final Function(WarrantCalculateDetailsModel) callback;

  MatriksWarrantCalculatorDetailsEvent({
    required this.symbol,
    required this.referenceDate,
    required this.underlyingValue,
    required this.volatility,
    required this.interestRate,
    this.currency,
    required this.callback,
  });
}

class MatriksSetTokenEvent extends MatriksEvent {
  final String? token;
  final int? tokenTime;
  final bool isRealTime;

  MatriksSetTokenEvent({
    this.token = '',
    this.tokenTime = 0,
    this.isRealTime = false,
  });
}

class ResetMatriksToken extends MatriksEvent {}
