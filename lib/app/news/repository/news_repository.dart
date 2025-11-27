import 'package:piapiri_v2/app/news/model/journal_filter_model.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class NewsRepository {
  Future<ApiResponse> getSearchId({
    required String searchUrl,
    String instrumentName = '',
    JournalFilterModel newsFilter,
    bool isComment = false,
  });

  Future<ApiResponse> getAllNews({
    required String pageUrl,
    required String searchId,
    int page = 0,
  });
}
