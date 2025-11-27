import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_bloc.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_event.dart';
import 'package:piapiri_v2/app/ipo/bloc/ipo_state.dart';
import 'package:piapiri_v2/app/ipo/model/ipo_model.dart';
import 'package:piapiri_v2/app/ipo/utils/ipo_constant.dart';
import 'package:piapiri_v2/app/ipo/widgets/ipo_last_price_widget.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/common/widgets/list/p_symbol_tile.dart';
import 'package:piapiri_v2/common/widgets/textfields/keyboard_done_action.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/bloc/bloc/page_state.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class IpoSearchPage extends StatefulWidget {
  const IpoSearchPage({super.key});

  @override
  State<IpoSearchPage> createState() => _IpoSearchPageState();
}

class _IpoSearchPageState extends State<IpoSearchPage> {
  late IpoBloc _ipoBloc;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  PagingController _pagingController = PagingController<int, Widget>(
    firstPageKey: 0,
  );
  int _pageNumber = 0;

  @override
  void initState() {
    _ipoBloc = getIt<IpoBloc>();
    _pagingController = PagingController<int, Widget>(firstPageKey: 0)
      ..addPageRequestListener(
        (int page) {
          _pageNumber = page;
        },
      );
    super.initState();
  }

  @override
  void dispose() {
    _ipoBloc.state.ipoDetailsBySymbolListForSearch.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Grid.m,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: Grid.s,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 43,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: context.pColorScheme.stroke,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: KeyboardDoneAction(
                      focusNode: _searchFocusNode,
                      child: TextField(
                        focusNode: _searchFocusNode,
                        textAlignVertical: TextAlignVertical.center,
                        controller: _searchController,
                        maxLines: 1,
                        cursorColor: context.pColorScheme.primary,
                        enableInteractiveSelection: false,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: L10n.tr('search_past_ipos'),
                          hintStyle: context.pAppStyle.labelReg14textSecondary.copyWith(height: 2),
                          border: InputBorder.none,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(
                              Grid.s + Grid.xs,
                            ),
                            child: SvgPicture.asset(
                              ImagesPath.search,
                              colorFilter: ColorFilter.mode(context.pColorScheme.textSecondary, BlendMode.srcIn),
                            ),
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    setState(() {
                                      _pageNumber = 0;
                                      _pagingController.itemList?.clear();
                                      _pagingController.refresh();
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                      Grid.s + Grid.xs,
                                    ),
                                    child: SvgPicture.asset(
                                      ImagesPath.x,
                                      colorFilter: ColorFilter.mode(context.pColorScheme.primary, BlendMode.srcIn),
                                    ),
                                  ),
                                )
                              : null,
                          contentPadding: const EdgeInsets.symmetric(vertical: 11),
                        ),
                        onChanged: (value) {
                          if (value.isEmpty) {
                            setState(() {
                              _pageNumber = 0;
                              _pagingController.itemList?.clear();
                              _pagingController.refresh();
                            });
                            return;
                          }
                          if (value.length > 1) {
                            _ipoBloc.add(
                              GetIpoDetailsForSearch(
                                ipoSymbol: value,
                                pageNumber: _pageNumber,
                              ),
                            );

                            _ipoBloc.add(
                              IpoListResetPageNumber(),
                            );
                            setState(() {
                              _pageNumber = 0;
                              _pagingController.itemList?.clear();
                              _pagingController.refresh();
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: Grid.s,
                ),
                InkWell(
                  onTap: () {
                    if (_searchController.text.isNotEmpty) {
                      _ipoBloc.add(
                        IpoListResetPageNumber(),
                      );
                      setState(() {
                        _pageNumber = 0;
                        _pagingController.itemList?.clear();
                        _pagingController.refresh();
                      });
                    }

                    context.router.maybePop();
                  },
                  child: Text(
                    L10n.tr('vazgec'),
                    style: context.pAppStyle.labelReg16primary,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: Grid.m,
            ),
            PBlocConsumer<IpoBloc, IpoState>(
              bloc: _ipoBloc,
              listenWhen: (previous, current) {
                return previous.type != current.type && current.type == PageState.fetched;
              },
              listener: (context, state) {
                if (state.ipoDetailsBySymbolListForSearch.isEmpty) {
                  _ipoBloc.add(
                    IpoListResetPageNumber(),
                  );
                }
                if (state.type == PageState.fetched) {
                  _appendNewIpos(
                    state.ipoDetailsBySymbolListForSearch,
                    _pageNumber,
                    _pagingController,
                    () {
                      _ipoBloc.add(
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
                return Expanded(
                  child: PagedListView(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<Widget>(
                      itemBuilder: (_, dynamic item, __) => item as Widget,
                      noItemsFoundIndicatorBuilder: (context) => NoDataWidget(
                        message: L10n.tr(
                          'no_found_ipo',
                          args: [
                            L10n.tr('past'),
                          ],
                        ),
                      ),
                      newPageErrorIndicatorBuilder: (context) => NoDataWidget(
                        message: L10n.tr(
                          'no_found_ipo',
                          args: [
                            L10n.tr('past'),
                          ],
                        ),
                      ),
                      firstPageProgressIndicatorBuilder: (context) => const SizedBox.shrink(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      )),
    );
  }

  void _appendNewIpos(
    List<IpoModel> ipoList,
    int page,
    PagingController pagingController, [
    VoidCallback? onSuccess,
  ]) {
    final List<Widget> ipoTileList = _prepareIpos(
      ipoList,
      pagingController,
    );
    final isLastPage = ipoTileList.length < IpoConstant.ipoPaginationListLength;
    if (isLastPage) {
      pagingController.appendLastPage(ipoTileList);
    } else {
      pagingController.appendPage(ipoTileList, page + 1);
    }
  }

  List<Widget> _prepareIpos(
    List<IpoModel> ipoList,
    PagingController pagingController,
  ) {
    return ipoList
        .map(
          (ipo) => Column(
            children: [
              PSymbolTile(
                variant: PSymbolVariant.ipoActive,
                title: ipo.symbol ?? '',
                subTitle: ipo.companyName ?? '',
                titleWidget: ipo.companyLogo != null
                    ? ClipOval(
                        child: Image.memory(
                          base64.decode(ipo.companyLogo!),
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Utils.generateCapitalFallback(
                        context,
                        ipo.symbol ?? 'U',
                        size: 60,
                      ),
                trailingWidget: IpoLastPriceWidget(
                  ipo: ipo,
                  symbol: ipo.symbol ?? '',
                ),
                onTap: () {
                  router.push(
                    IpoDetailRoute(
                      symbolLogo: ipo.companyLogo != null ? base64.decode(ipo.companyLogo!) : null,
                      ipo: ipo,
                      isDemanded: false,
                      id: ipo.id,
                      canRequest: true,
                      fromPastIpo: true,
                      onSuccess: () {},
                    ),
                  );
                },
              ),
              const SizedBox(
                height: Grid.s,
              ),
              const PDivider(),
              const SizedBox(
                height: Grid.s,
              ),
            ],
          ),
        )
        .toList();
  }
}
