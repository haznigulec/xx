import 'package:piapiri_v2/app/news/model/journal_filter_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/news_model.dart';

class ReviewState extends PState {
  final String searchId;
  final List<News> reviews;
  final List<News> newlyFetchedReviews;
  final JournalFilterModel reviewFilter;
  final int pageNumber;

  const ReviewState({
    super.type = PageState.initial,
    super.error,
    this.searchId = '',
    this.reviews = const [],
    this.newlyFetchedReviews = const [],
    this.reviewFilter = const JournalFilterModel(
      newsCategories: [
        'YORUM',
      ],
    ),
    this.pageNumber = 0,
  });

  @override
  ReviewState copyWith({
    PageState? type,
    PBlocError? error,
    String? searchId,
    List<News>? reviews,
    List<News>? newlyFetchedReviews,
    JournalFilterModel? reviewFilter,
    int? pageNumber,
  }) {
    return ReviewState(
      type: type ?? this.type,
      error: error ?? this.error,
      searchId: searchId ?? this.searchId,
      reviews: reviews ?? this.reviews,
      newlyFetchedReviews: newlyFetchedReviews ?? this.newlyFetchedReviews,
      reviewFilter: reviewFilter ?? this.reviewFilter,
      pageNumber: pageNumber ?? this.pageNumber,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        searchId,
        reviews,
        reviewFilter,
        pageNumber,
      ];
}
