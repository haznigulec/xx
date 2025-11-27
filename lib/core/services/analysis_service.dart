import 'package:p_core/extensions/extension_wrapper.dart';
import 'package:piapiri_v2/core/api/client/api_client.dart';
import 'package:piapiri_v2/core/api/client/matriks_api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';
import 'package:piapiri_v2/core/extension/string_extension.dart';
import 'package:piapiri_v2/core/model/market_review_model.dart';
import 'package:piapiri_v2/app/review/model/review_filter_model.dart';

class AnalysisService {
  final ApiClient api;
  final MatriksApiClient matriksApiClient;

  AnalysisService(
    this.api,
    this.matriksApiClient,
  );

  Future<ApiResponse> getAllNews({
    required String pageUrl,
    required String searchUrl,
    int page = 0,
    String instrumentName = '',
    ReviewFilterModel? newsFilter,
  }) async {
    String newsId = await newsGetIdForScrollPagination(searchUrl, instrumentName, newsFilter);
    if (newsId != '-1') {
      ApiResponse response = await matriksApiClient.get(
        '$pageUrl?qid=$newsId&page=$page&pageSize=10',
      );
      return response;
    }
    return ApiResponse.mock(
      success: true,
      data: [],
    );
  }

  Future<String> newsGetIdForScrollPagination(
    String searchUrl,
    String instrumentName,
    ReviewFilterModel? newsFilter,
  ) async {
    String url = '';

    if (instrumentName == '') {
      //  Tüm haberler için

      if (newsFilter != null) {
        String startDate = (newsFilter.startDate ??
                DateTime.now().subtract(
                  const Duration(
                    days: 1,
                  ),
                ))
            .formatToJson();
        String endDate = (newsFilter.endDate ?? DateTime.now()).formatToJson();
        List<String> filters = [];

        if (newsFilter.newsCategories.isNotEmpty && newsFilter.newsCategories.length < 14) {
          filters.add('category:${newsFilter.newsCategories.join(',')}');
        }

        if (newsFilter.newsSources.isNotEmpty && newsFilter.newsSources.length < 2) {
          filters.add('source:${newsFilter.newsSources.join(',')}');
        }

        if (newsFilter.symbolName.isNotNullOrEmpty) {
          filters.add('symbol:${newsFilter.symbolName}');
        }

        if (startDate != '') {
          filters.add('after:$startDate');
        }

        if (endDate != '') {
          filters.add('before:$endDate');
        }

        url = '$searchUrl?query=${filters.join(' ')}';
      } else {
        url = searchUrl;
      }
    } else {
      //  Sembol bazlı haberler için
      url = '$searchUrl?query=symbol:$instrumentName';
    }

    ApiResponse response = await matriksApiClient.get(
      url,
    );
    if (response.success) {
      return response.data['id'].toString();
    } else {
      return '';
    }
  }

  Future<ApiResponse> getMarketReviews({
    required String pageUrl,
    required String searchUrl,
    required MarketReviewFilterModel reviewFilters,
    int page = 1,
  }) async {
    String commentsId = await getMarketReviewsId(reviewFilters, searchUrl);
    if (commentsId == '-1') {
      return ApiResponse.mock(
        success: true,
        data: [],
      );
    }
    return matriksApiClient.get(
      '$pageUrl?qid=$commentsId&page=$page&pageSize=10',
    );
  }

  Future<String> getMarketReviewsId(
    MarketReviewFilterModel reviewFilters,
    String searchUrl,
  ) async {
    List<String> filters = [
      'category:YORUM',
      'source:${reviewFilters.source.join(',')}',
    ];
    if (reviewFilters.symbolName.isNotNullOrEmpty) {
      filters.add('symbol:${reviewFilters.symbolName}');
    }
    if (reviewFilters.endDate != null) {
      filters.add(
        'before:${reviewFilters.endDate!.formatToJson()}',
      );
    }
    if (reviewFilters.startDate != null) {
      filters.add(
        'after:${reviewFilters.startDate!.formatToJson()}',
      );
    }
    var response = await matriksApiClient.get(
      '$searchUrl?query=${filters.join(' ')}&withComment=true',
    );
    if (response.success) {
      return response.data['id'].toString();
    } else {
      return '-1';
    }
  }
}
