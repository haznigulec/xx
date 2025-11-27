import 'package:piapiri_v2/app/news/model/journal_filter_model.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/model/news_model.dart';

class NewsState extends PState {
  final String searchId;
  final List<News> news;
  final List<News> newlyFetchedNews;
  final JournalFilterModel newsFilter;
  final int pageNumber;

  const NewsState({
    super.type = PageState.initial,
    super.error,
    this.searchId = '',
    this.news = const [],
    this.newlyFetchedNews = const [],
    this.newsFilter = const JournalFilterModel(),
    this.pageNumber = 0,
  });

  @override
  NewsState copyWith({
    PageState? type,
    PBlocError? error,
    String? searchId,
    List<News>? news,
    List<News>? newlyFetchedNews,
    JournalFilterModel? newsFilter,
    int? pageNumber,
  }) {
    return NewsState(
      type: type ?? this.type,
      error: error ?? this.error,
      searchId: searchId ?? this.searchId,
      news: news ?? this.news,
      newlyFetchedNews: newlyFetchedNews ?? this.newlyFetchedNews,
      newsFilter: newsFilter ?? this.newsFilter,
      pageNumber: pageNumber ?? this.pageNumber,
    );
  }

  @override
  List<Object?> get props => [
        type,
        error,
        searchId,
        news,
        newsFilter,
        pageNumber,
      ];
}
