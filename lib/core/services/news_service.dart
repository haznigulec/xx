import 'package:p_core/extensions/date_time_extensions.dart';
import 'package:piapiri_v2/app/news/model/journal_filter_model.dart';
import 'package:piapiri_v2/core/api/client/matriks_api_client.dart';
import 'package:piapiri_v2/core/api/model/api_response.dart';

class NewsService {
  final MatriksApiClient matriksApiClient;

  NewsService(
    this.matriksApiClient,
  );

  Future<ApiResponse> getSearchId({
    required String searchUrl,
    String instrumentName = '',
    JournalFilterModel? newsFilter,
    bool isComment = false,
  }) async {
    String url = '';

    if (instrumentName == '') {
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

        if (newsFilter.symbols?.isNotEmpty == true && newsFilter.symbols?.isNotEmpty == true) {
          String symbol = newsFilter.symbols!.map((e) => e.name.splitMapJoin(',')).join(',');
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
