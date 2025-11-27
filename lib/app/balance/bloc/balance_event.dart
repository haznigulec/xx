import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/model/conolidate_enum.dart';

abstract class BalanceEvent extends PEvent {}

class GetYearInfoEvent extends BalanceEvent {
  final String symbolName;
  final Function(Map yearMonthList, List<ConsolidateEnum> consolidateList)? callback;
  GetYearInfoEvent({
    required this.symbolName,
    this.callback,
  });
}

class GetBalanceEvent extends BalanceEvent {
  final String symbolName;
  final String month;
  final String year;
  final bool isConsolidate;
  final Function(Map balanceList)? callback;
  GetBalanceEvent({
    required this.symbolName,
    required this.month,
    required this.year,
    required this.isConsolidate,
    this.callback,
  });
}
