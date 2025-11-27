import 'package:piapiri_v2/app/news/model/journal_filter_model.dart';
import 'package:piapiri_v2/app/news/repository/news_repository.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/api/pp_api.dart';
import 'package:piapiri_v2/core/bloc/matriks/matriks_bloc.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';

class NewsRepositoryImpl implements NewsRepository {
  @override
  Future<ApiResponse> getSearchId({
    required String searchUrl,
    String instrumentName = '',
    JournalFilterModel? newsFilter,
    bool isComment = false,
  }) async {
    return getIt<PPApi>().newsService.getSearchId(
          searchUrl: getIt<MatriksBloc>().state.endpoints!.rest!.news!.search!.url ?? '',
          instrumentName: instrumentName,
          newsFilter: newsFilter,
        );
  }

  @override
  Future<ApiResponse> getAllNews({
    required String pageUrl,
    required String searchId,
    int page = 0,
  }) async {
    return getIt<PPApi>().newsService.getAllNews(
          pageUrl: pageUrl,
          page: page,
          searchId: searchId,
        );
  }
}
