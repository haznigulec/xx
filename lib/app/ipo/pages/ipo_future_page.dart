import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_bloc.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_event.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_state.dart';
import 'package:piapiri_v2/app/ipo/widgets/shimmer_ipo_widget.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class IpoFuturePage extends StatefulWidget {
  const IpoFuturePage({super.key});

  @override
  State<IpoFuturePage> createState() => _IpoFuturePageState();
}

class _IpoFuturePageState extends State<IpoFuturePage> {
  late IpoBloc _ipoBloc;
  late PagingController _pagingController;
  int _pageNumber = 0;

  @override
  void initState() {
    _ipoBloc = getIt<IpoBloc>();

    _pagingController = PagingController<int, Widget>(firstPageKey: 0)
      ..addPageRequestListener(
        (int page) {
          _pageNumber = page;
          _ipoBloc.add(
            GetFutureListEvent(
              pageNumber: _pageNumber,
            ),
          );
        },
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Grid.m,
        right: Grid.m,
        top: Grid.l,
      ),
      child: PBlocConsumer<IpoBloc, IpoState>(
        bloc: _ipoBloc,
        listenWhen: (previous, current) {
          return previous.type != current.type && current.type == PageState.fetched;
        },
        listener: (context, state) {
          if (state.type == PageState.fetched) {
            Utils().appendNewIpos(
              state.futureIpoList,
              _pageNumber,
              _pagingController,
              false,
              false,
              () {
                getIt<IpoBloc>().add(
                  IpoListResetPageNumber(),
                );
                setState(() {
                  _pageNumber = 0;
                  _pagingController.itemList?.clear();
                  _pagingController.refresh();
                });
              },
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              if (state.futureIpoList.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      L10n.tr('hisse'),
                      style: context.pAppStyle.labelMed12textSecondary,
                    ),
                    Text(
                      L10n.tr('ipo_price_and_date'),
                      style: context.pAppStyle.labelMed12textSecondary,
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    top: Grid.s + Grid.xs,
                  ),
                  child: PDivider(),
                ),
              ],
              Expanded(
                child: PagedListView(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<Widget>(
                    itemBuilder: (_, dynamic item, __) => item as Widget,
                    noItemsFoundIndicatorBuilder: (context) => NoDataWidget(
                      message: L10n.tr(
                        'no_found_ipo',
                        args: [
                          L10n.tr('future'),
                        ],
                      ),
                    ),
                    firstPageProgressIndicatorBuilder: (context) => const Shimmerize(
                      enabled: true,
                      child: ShimmerIpoWidget(),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
