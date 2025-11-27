import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/news/model/journal_filter_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_event.dart';

abstract class ReviewEvent extends PEvent {}

class GetReviewsEvent extends ReviewEvent {
  final String symbolName;
  final int page;

  GetReviewsEvent({
    required this.symbolName,
    required this.page,
  });
}

class SetReviewsFilterEvent extends ReviewEvent {
  final JournalFilterModel reviewFilter;
  final VoidCallback onSetFilter;

  SetReviewsFilterEvent({
    required this.reviewFilter,
    required this.onSetFilter,
  });
}
