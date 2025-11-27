import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:piapiri_v2/app/news/model/journal_filter_model.dart';
import 'package:piapiri_v2/app/news/widgets/journal_filter_widget.dart';
import 'package:piapiri_v2/app/news/widgets/journal_tile.dart';
import 'package:piapiri_v2/app/review/bloc/review_bloc.dart';
import 'package:piapiri_v2/app/review/bloc/review_event.dart';
import 'package:piapiri_v2/app/review/bloc/review_state.dart';
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

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({super.key});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  late final PagingController<int, Widget> _pagingController;
  late ReviewBloc _reviewsBloc;
  final List<SymbolModel> _filteredSymbolList = [];

  @override
  void initState() {
    _reviewsBloc = getIt<ReviewBloc>();
    _pagingController = PagingController<int, Widget>(firstPageKey: 0)
      ..addPageRequestListener((int page) {
        _reviewsBloc.add(
          GetReviewsEvent(
            symbolName: '',
            page: page,
          ),
        );
      });
    if (_reviewsBloc.state.reviewFilter.symbols?.isNotEmpty == true) {
      _filteredSymbolList.addAll(
        _reviewsBloc.state.reviewFilter.symbols!,
      );
    }
    getIt<Analytics>().track(
      AnalyticsEvents.piyasaYorumlariTabClick,
      taxonomy: [
        InsiderEventEnum.controlPanel.value,
        InsiderEventEnum.marketsPage.value,
        InsiderEventEnum.journalTab.value,
        InsiderEventEnum.marketCommentTab.value,
      ],
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocConsumer<ReviewBloc, ReviewState>(
      bloc: _reviewsBloc,
      listenWhen: (prev, cur) {
        return prev.type != cur.type;
      },
      listener: (context, state) {
        if (state.isSuccess) {
          _appendNewPage(
            state.newlyFetchedReviews,
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
                          newsFilter: state.reviewFilter,
                          isReview: true,
                          onSetFilter: (JournalFilterModel reviewFilter) {
                            _reviewsBloc.add(
                              SetReviewsFilterEvent(
                                reviewFilter: reviewFilter.copyWith(
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
                                  _reviewsBloc.add(
                                    SetReviewsFilterEvent(
                                      reviewFilter: state.reviewFilter.copyWith(
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
                  InkWell(
                    onTap: () {
                      router.push(
                        SymbolSearchRoute(
                          appBarTitle: L10n.tr('search_reviews'),
                          selectedSymbolList: _filteredSymbolList.toList(),
                          isCheckbox: true,
                          onTapSymbol: (symbolModelList) {
                            setState(() {
                              _filteredSymbolList.clear();
                              _filteredSymbolList.addAll(
                                symbolModelList.toList(),
                              );
                            });
                            _reviewsBloc.add(
                              SetReviewsFilterEvent(
                                reviewFilter: state.reviewFilter.copyWith(
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
              ),
              Expanded(
                child: PagedListView<int, Widget>.separated(
                  padding: const EdgeInsets.only(bottom: Grid.xl),
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<Widget>(
                    itemBuilder: (_, item, __) => item,
                    noItemsFoundIndicatorBuilder: (context) => Center(
                      child: NoDataWidget(
                        message: L10n.tr('no_data'),
                      ),
                    ),
                  ),
                  separatorBuilder: (context, index) => const PDivider(),
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
    final isLastPage = newsList.length < 10;
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
            appBarTitle: L10n.tr('market_comment_detail'),
          ),
        )
        .toList();
  }
}
