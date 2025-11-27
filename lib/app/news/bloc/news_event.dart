import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/news/model/journal_filter_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';

abstract class NewsEvent extends PEvent {}

class GetNewsEvent extends NewsEvent {
  final String symbolName;
  final int page;

  GetNewsEvent({
    required this.symbolName,
    required this.page,
  });
}

class SetFilterEvent extends NewsEvent {
  final JournalFilterModel newsFilter;
  final VoidCallback onSetFilter;

  SetFilterEvent({
    required this.newsFilter,
    required this.onSetFilter,
  });
}
