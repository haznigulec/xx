import 'package:piapiri_v2/app/news/model/journal_filter_model.dart';
import 'package:piapiri_v2/app/review/repository/review_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  @override
  Future<ApiResponse> getSearchId(
    String instrumentName,
    JournalFilterModel reviewFilter,
  ) async {
    return getIt<PPApi>().reviewService.getSearchId(
          searchUrl: getIt<MatriksBloc>().state.endpoints!.rest!.news!.search!.url ?? '',
          instrumentName: instrumentName,
          reviewFilter: reviewFilter,
          isComment: true,
        );
  }

  @override
  Future<ApiResponse> getNews(String pageUrl, int page, String searchId) async {
    return getIt<PPApi>().reviewService.getAllNews(
          pageUrl: getIt<MatriksBloc>().state.endpoints!.rest!.news!.page!.url ?? '',
          page: page,
          searchId: searchId,
        );
  }
}
