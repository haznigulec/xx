import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/news/model/journal_filter_model.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/core/api/client/matriks_api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';

class ReviewService {
  final MatriksApiClient matriksApiClient;

  ReviewService(
    this.matriksApiClient,
  );

  Future<ApiResponse> getSearchId({
    required String searchUrl,
    String instrumentName = '',
    JournalFilterModel? reviewFilter,
    bool isComment = false,
  }) async {
    String url = '';

    if (instrumentName == '') {
      if (reviewFilter != null) {
        String startDate = (reviewFilter.startDate ??
                DateTime.now().subtract(
                  const Duration(
                    days: 1,
                  ),
                ))
            .formatToJson();
        String endDate = DateTimeUtils.serverDate(reviewFilter.endDate ?? DateTime.now());
        List<String> filters = [];

        if (reviewFilter.newsCategories.isNotEmpty && reviewFilter.newsCategories.length < 14) {
          filters.add('category:${reviewFilter.newsCategories.join(',')}');
        }

        if (reviewFilter.newsSources.isNotEmpty && reviewFilter.newsSources.length < 2) {
          filters.add('source:${reviewFilter.newsSources.join(',')}');
        }

        if (reviewFilter.symbols?.isNotEmpty == true && reviewFilter.symbols?.isNotEmpty == true) {
          String symbol = reviewFilter.symbols!.map((e) => e.name.splitMapJoin(',')).join(',');
          filters.add('symbol:$symbol');
        }
        if (startDate != '') {
          filters.add('after:$startDate');
        }

        if (endDate != '') {
          filters.add('before:$endDate');
        }

        url = '$searchUrl?query=${filters.join(' ')}${isComment ? '&withComment=true' : ''}';
      } else {
        url = searchUrl;
      }
    } else {
      url = '$searchUrl?query=symbol:$instrumentName';
    }

    return matriksApiClient.get(
      url,
    );
  }

  Future<ApiResponse> getAllNews({
    required String pageUrl,
    required String searchId,
    int page = 0,
  }) async {
    return matriksApiClient.get(
      '$pageUrl?qid=$searchId&page=$page&pageSize=20',
    );
  }
}
