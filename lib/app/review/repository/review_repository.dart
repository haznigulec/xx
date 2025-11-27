import 'package:piapiri_v2/app/news/model/journal_filter_model.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';

abstract class ReviewRepository {
  Future<ApiResponse> getSearchId(
    String instrumentName,
    JournalFilterModel reviewFilter,
  );
  Future<ApiResponse> getNews(
    String pageUrl,
    int page,
    String searchId,
  );
}
