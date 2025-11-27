import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:piapiri_v2/app/news/bloc/news_bloc.dart';
import 'package:piapiri_v2/app/news/bloc/news_event.dart';
import 'package:piapiri_v2/app/news/bloc/news_state.dart';
import 'package:piapiri_v2/app/news/model/journal_filter_model.dart';
import 'package:piapiri_v2/app/news/widgets/journal_filter_widget.dart';
import 'package:piapiri_v2/app/news/widgets/journal_tile.dart';
import 'package:piapiri_v2/app/search_symbol/enum/symbol_search_filter_enum.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/buttons/p_custom_outlined_button.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/config/analytics/analytics.dart';
import 'package:piapiri_v2/core/config/analytics/analytics_events.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/insider_event_enum.dart';
import 'package:piapiri_v2/core/model/news_model.dart';
import 'package:piapiri_v2/core/model/symbol_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class NewsTabPage extends StatefulWidget {
  final String symbolName;
  final bool? fromSymbolDetail;
  const NewsTabPage({
    super.key,
    this.symbolName = '',
    this.fromSymbolDetail = false,
  });

  @override
  State<NewsTabPage> createState() => _NewsTabPageState();
}

class _NewsTabPageState extends State<NewsTabPage> {
  late final PagingController<int, Widget> _pagingController;
  late NewsBloc _newsBloc;
  final List<SymbolModel> _filteredSymbolList = [];

  @override
  void initState() {
    _newsBloc = getIt<NewsBloc>();
    _pagingController = PagingController<int, Widget>(firstPageKey: 0)
      ..addPageRequestListener((int page) {
        _newsBloc.add(
          GetNewsEvent(
            page: page,
            symbolName: widget.symbolName,
          ),
        );
      });

    if (_newsBloc.state.newsFilter.symbols?.isNotEmpty == true) {
      _filteredSymbolList.addAll(
        _newsBloc.state.newsFilter.symbols!,
      );
    }

    getIt<Analytics>().track(
      AnalyticsEvents.haberlerTabClick,
      taxonomy: [
        InsiderEventEnum.controlPanel.value,
        InsiderEventEnum.marketsPage.value,
        InsiderEventEnum.journalTab.value,
        InsiderEventEnum.newsTab.value,
      ],
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocConsumer<NewsBloc, NewsState>(
      bloc: _newsBloc,
      listenWhen: (prev, cur) {
        return prev.type != cur.type;
      },
      listener: (context, state) {
        if (state.isSuccess) {
          _appendNewPage(
            state.newlyFetchedNews,
            state.pageNumber,
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Grid.m,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PCustomOutlinedButtonWithIcon(
                    text: L10n.tr('filtrele'),
                    iconSource: ImagesPath.chevron_down,
                    onPressed: () {
                      PBottomSheet.show(
                        context,
                        title: L10n.tr('filtrele'),
                        child: JournalFilterWidget(
                          newsFilter: state.newsFilter,
                          onSetFilter: (JournalFilterModel newsFilter) {
                            _newsBloc.add(
                              SetFilterEvent(
                                newsFilter: newsFilter.copyWith(
                                  symbols: _filteredSymbolList.toList(),
                                ),
                                onSetFilter: () {
                                  _pagingController.refresh();
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  if (_filteredSymbolList.isNotEmpty) ...[
                    const SizedBox(
                      width: Grid.s,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 23,
                        child: ListView.builder(
                          itemCount: _filteredSymbolList.length,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                right: Grid.s,
                              ),
                              child: PCustomOutlinedButtonWithIcon(
                                text: _filteredSymbolList[index].name,
                                icon: Icon(
                                  Icons.close,
                                  size: Grid.m,
                                  color: context.pColorScheme.primary,
                                ),
                                foregroundColorApllyBorder: false,
                                foregroundColor: context.pColorScheme.primary,
                                backgroundColor: context.pColorScheme.secondary,
                                onPressed: () {
                                  setState(() {
                                    _filteredSymbolList.removeAt(index);
                                  });
                                  _newsBloc.add(
                                    SetFilterEvent(
                                      newsFilter: state.newsFilter.copyWith(
                                        symbols: _filteredSymbolList.toList(),
                                      ),
                                      onSetFilter: () {
                                        _pagingController.refresh();
                                      },
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: Grid.s,
                    ),
                  ],
                  if (!widget.fromSymbolDetail!) ...[
                    InkWell(
                      onTap: () {
                        router.push(
                          SymbolSearchRoute(
                            appBarTitle: L10n.tr('search_news'),
                            isCheckbox: true,
                            selectedSymbolList: _filteredSymbolList.toList(),
                            onTapSymbol: (symbolModelList) {
                              setState(() {
                                _filteredSymbolList.clear();
                                _filteredSymbolList.addAll(
                                  symbolModelList.toList(),
                                );
                              });
                              _newsBloc.add(
                                SetFilterEvent(
                                  newsFilter: state.newsFilter.copyWith(
                                    symbols: _filteredSymbolList.toList(),
                                  ),
                                  onSetFilter: () {
                                    _pagingController.refresh();
                                  },
                                ),
                              );
                            },
                            filterList: SymbolSearchFilterEnum.values
                                .where(
                                  (e) =>
                                      e != SymbolSearchFilterEnum.foreign &&
                                      e != SymbolSearchFilterEnum.warrant &&
                                      e != SymbolSearchFilterEnum.option &&
                                      e != SymbolSearchFilterEnum.future &&
                                      e != SymbolSearchFilterEnum.etf,
                                )
                                .toList(),
                          ),
                        );
                      },
                      child: SvgPicture.asset(
                        ImagesPath.search,
                        width: 23,
                        height: 23,
                      ),
                    )
                  ],
                ],
              ),
              Expanded(
                child: PagedListView<int, Widget>.separated(
                  padding: const EdgeInsets.only(
                    bottom: Grid.xl,
                  ),
                  pagingController: _pagingController,
                  separatorBuilder: (context, index) => const PDivider(),
                  builderDelegate: PagedChildBuilderDelegate<Widget>(
                    itemBuilder: (_, item, __) => item,
                    noItemsFoundIndicatorBuilder: (context) => NoDataWidget(
                      message: L10n.tr('no_news_found'),
                    ),
                  ),
                ),
              ),
            ],
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
    return newsList
        .map(
          (news) => JournalTile(
            news: news,
            appBarTitle: L10n.tr('haber_detayi'),
          ),
        )
        .toList();
  }
}
