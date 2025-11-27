import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';
import 'package:piapiri_v2/core/model/filter_category_model.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';

abstract class EquityEvent extends PEvent {}

class SelectListEvent extends EquityEvent {
  final FilterCategoryItemModel selectedList;
  final Function(List<MarketListModel>)? callback;
  final Function(List<MarketListModel>)? unsubscribeCallback;

  SelectListEvent({
    required this.selectedList,
    this.callback,
    this.unsubscribeCallback,
  });
}

class SelectIndexListEvent extends EquityEvent {
  final FilterCategoryItemModel selectedIndexList;
  final Function(List<MarketListModel>)? callback;
  final Function(List<MarketListModel>)? unsubscribeCallback;

  SelectIndexListEvent({
    required this.selectedIndexList,
    this.callback,
    this.unsubscribeCallback,
  });
}

class InitEvent extends EquityEvent {
  final Function(List<MarketListModel>) callback;

  InitEvent({
    required this.callback,
  });
}
