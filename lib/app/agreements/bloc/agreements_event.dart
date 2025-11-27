import 'dart:ui';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/model/agreements_model.dart';

abstract class AgreementsEvent extends PEvent {}

class GetAgreementsEvent extends AgreementsEvent {
  final String date;
  final Function(Map<String, int>, List<AgreementsModel>)? callback;
  GetAgreementsEvent({
    required this.date,
    this.callback,
  });
}

class SetAgreementsEvent extends AgreementsEvent {
  final String accountId;
  final String agreementPeriodId;
  final String agreementPortfolioDate;
  final VoidCallback? onSuccess;

  SetAgreementsEvent({
    required this.accountId,
    required this.agreementPeriodId,
    required this.agreementPortfolioDate,
    this.onSuccess,
  });
}
