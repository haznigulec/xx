import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:piapiri_v2/app/news/bloc/news_event.dart';
import 'package:piapiri_v2/app/news/bloc/news_state.dart';
import 'package:piapiri_v2/app/news/repository/news_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/news_model.dart';

class NewsBloc extends PBloc<NewsState> {
  final NewsRepository _newsRepository;
  NewsBloc({
    required NewsRepository newsRepository,
  })  : _newsRepository = newsRepository,
        super(initialState: const NewsState()) {
    on<GetNewsEvent>(_onGetNews);
    on<SetFilterEvent>(_onSetFilter);
  }

  FutureOr<void> _onGetNews(
    GetNewsEvent event,
    Emitter<NewsState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    try {
      String searchId = state.searchId;
      if (searchId.isEmpty || event.page == 0) {
        ApiResponse response = await _newsRepository.getSearchId(
          searchUrl: getIt<MatriksBloc>().state.endpoints!.rest!.news!.search!.url ?? '',
          instrumentName: event.symbolName,
          newsFilter: state.newsFilter,
        );

        if (response.success) {
          searchId = response.data['id'];
        }
      }
      if (searchId != '-1') {
        ApiResponse response = await _newsRepository.getAllNews(
          pageUrl: getIt<MatriksBloc>().state.endpoints!.rest!.news!.page!.url ?? '',
          page: event.page,
          searchId: searchId,
        );
        if (response.success) {
          List<News> news = response.data.map<News>((dynamic element) => News.fromJson(element)).toList();
          emit(
            state.copyWith(
              type: PageState.success,
              news: event.page == 0 ? news : [...state.news, ...news],
              newlyFetchedNews: news,
              pageNumber: event.page,
              searchId: searchId,
            ),
          );
        } else {
          emit(
            state.copyWith(
              type: PageState.failed,
              error: PBlocError(
                showErrorWidget: false,
                message: response.error?.message ?? '',
                errorCode: '03NEWS001',
              ),
            ),
          );
        }
      }
    } catch (e) {
      emit(
        state.copyWith(
          news: [],
          newlyFetchedNews: [],
          type: PageState.success,
        ),
      );
    }
  }

  FutureOr<void> _onSetFilter(
    SetFilterEvent event,
    Emitter<NewsState> emit,
  ) {
    if (state.newsFilter != event.newsFilter) {
      emit(
        state.copyWith(
          newsFilter: event.newsFilter,
          searchId: '',
        ),
      );
      event.onSetFilter();
    }
  }
}
