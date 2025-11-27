import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:piapiri_v2/app/news/bloc/news_bloc.dart';
import 'package:piapiri_v2/app/news/bloc/news_event.dart';
import 'package:piapiri_v2/app/news/bloc/news_state.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/news_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class JournalSymbolDetailPage extends StatefulWidget {
  final MarketListModel symbol;
  final List<Map<String, dynamic>> dataList;

  const JournalSymbolDetailPage({
    super.key,
    required this.symbol,
    required this.dataList,
  });

  @override
  State<JournalSymbolDetailPage> createState() => _JournalSymbolDetailPageState();
}

class _JournalSymbolDetailPageState extends State<JournalSymbolDetailPage> {
  late final PagingController<int, Widget> _pagingController;
  late NewsBloc _newsBloc;

  @override
  void initState() {
    _newsBloc = getIt<NewsBloc>();
    _pagingController = PagingController<int, Widget>(
      firstPageKey: 0,
    )..addPageRequestListener((int page) {
        _newsBloc.add(
          GetNewsEvent(
            page: page,
            symbolName: widget.symbol.underlying.isNotEmpty ? widget.symbol.underlying : widget.symbol.symbolCode,
          ),
        );
      });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _newsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocConsumer<NewsBloc, NewsState>(
      bloc: _newsBloc,
      listenWhen: (prev, cur) {
        return prev.type != cur.type;
      },
      listener: (context, state) {
        if (state.type == PageState.success) {
          _appendNewPage(
            state.newlyFetchedNews,
            state.pageNumber,
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Grid.s,
          ),
          child: PagedListView(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Widget>(
              itemBuilder: (_, item, __) => item,
              noItemsFoundIndicatorBuilder: (context) => NoDataWidget(message: L10n.tr('no_news_found')),
              newPageErrorIndicatorBuilder: (context) => NoDataWidget(message: L10n.tr('no_news_found')),
            ),
          ),
        );
      },
    );
  }

  void _appendNewPage(
    List<News> news,
    int page,
  ) {
    final List<Widget> newsList = _prepareNews(news);
    final isLastPage = newsList.length < 20;
    if (isLastPage) {
      _pagingController.appendLastPage(newsList);
    } else {
      _pagingController.appendPage(newsList, page + 1);
    }
  }

  List<Widget> _prepareNews(List<News> newsList) {
    return [];
    // return newsList
    //     .map(
    //       (news) => NewsTile(
    //         news: news,
    //         symbol: widget.symbol,
    //       ),
    //     )
    //     .toList();
  }
}
