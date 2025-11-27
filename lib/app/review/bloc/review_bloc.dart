import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:piapiri_v2/app/review/bloc/review_event.dart';
import 'package:piapiri_v2/app/review/bloc/review_state.dart';
import 'package:piapiri_v2/app/review/repository/review_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/bloc/bloc/base_bloc.dart';
import 'package:piapiri_v2/core/bloc/bloc/bloc_error.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/news_model.dart';

class ReviewBloc extends PBloc<ReviewState> {
  final ReviewRepository _reviewRepository;
  ReviewBloc({
    required ReviewRepository reviewRepository,
  })  : _reviewRepository = reviewRepository,
        super(initialState: const ReviewState()) {
    on<GetReviewsEvent>(_onGetReviews);
    on<SetReviewsFilterEvent>(_onSetFilter);
  }

  FutureOr<void> _onGetReviews(
    GetReviewsEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(
      state.copyWith(
        type: PageState.loading,
      ),
    );
    try {
      String searchId = state.searchId;
      if (searchId.isEmpty || event.page == 0) {
        ApiResponse response = await _reviewRepository.getSearchId(
          event.symbolName,
          state.reviewFilter,
        );

        if (response.success) {
          searchId = response.data['id'];
        }
      }
      if (searchId != '-1') {
        ApiResponse response = await _reviewRepository.getNews(
          getIt<MatriksBloc>().state.endpoints!.rest!.news!.page!.url ?? '',
          event.page,
          searchId,
        );
        if (response.success) {
          List<News> reviews = response.data.map<News>((dynamic element) => News.fromJson(element)).toList();
          emit(
            state.copyWith(
              type: PageState.success,
              reviews: event.page == 0 ? reviews : [...state.reviews, ...reviews],
              newlyFetchedReviews: reviews,
              pageNumber: event.page,
              searchId: searchId,
            ),
          );
        } else {
          emit(
            state.copyWith(
              type: PageState.failed,
              error: PBlocError(
                showErrorWidget: true,
                message: response.error?.message ?? '',
                errorCode: '03REVW01',
              ),
            ),
          );
        }
      }
    } catch (e) {
      emit(
        state.copyWith(
          reviews: [],
          newlyFetchedReviews: [],
          type: PageState.success,
        ),
      );
    }
  }

  FutureOr<void> _onSetFilter(
    SetReviewsFilterEvent event,
    Emitter<ReviewState> emit,
  ) {
    if (state.reviewFilter != event.reviewFilter) {
      emit(
        state.copyWith(
          reviewFilter: event.reviewFilter,
          searchId: '',
        ),
      );
      event.onSetFilter();
    }
  }
}
