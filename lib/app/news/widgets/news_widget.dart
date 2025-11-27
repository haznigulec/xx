import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/news/bloc/news_bloc.dart';
import 'package:piapiri_v2/app/news/bloc/news_event.dart';
import 'package:piapiri_v2/app/news/bloc/news_state.dart';
import 'package:piapiri_v2/app/news/widgets/journal_tile.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class NewsWidget extends StatefulWidget {
  final MarketListModel symbol;
  final SymbolTypes type;
  final bool? fromSymbolDetail;
  const NewsWidget({
    super.key,
    required this.symbol,
    required this.type,
    this.fromSymbolDetail = false,
  });

  @override
  State<NewsWidget> createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  late NewsBloc _newsBloc;
  @override
  initState() {
    super.initState();
    _newsBloc = getIt<NewsBloc>();
    _newsBloc.add(
      GetNewsEvent(
        page: 0,
        symbolName:
            widget.type == SymbolTypes.future || widget.type == SymbolTypes.option || widget.type == SymbolTypes.warrant
                ? widget.symbol.underlying
                : widget.symbol.symbolCode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PBlocBuilder<NewsBloc, NewsState>(
      bloc: _newsBloc,
      builder: (context, state) {
        if (state.news.isEmpty || state.isLoading) return const SizedBox.shrink();
        return Column(
          children: [
            Row(
              children: [
                Text(
                  L10n.tr('haberler'),
                  style: context.pAppStyle.labelMed18textPrimary,
                ),
                const Spacer(),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    router.push(
                      NewsRoute(
                        symbolName: widget.type == SymbolTypes.future ||
                                widget.type == SymbolTypes.option ||
                                widget.type == SymbolTypes.warrant
                            ? widget.symbol.underlying
                            : widget.symbol.symbolCode,
                        fromSymbolDetail: widget.fromSymbolDetail!,
                      ),
                    );
                  },
                  child: Text(
                    L10n.tr('see_all'),
                    style: context.pAppStyle.labelReg16primary,
                  ),
                ),
              ],
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.news.length < 2 ? state.news.length : 2,
              separatorBuilder: (context, index) => const PDivider(),
              itemBuilder: (context, index) {
                return JournalTile(
                  news: state.news[index],
                  appBarTitle: L10n.tr('haber_detayi'),
                );
              },
            ),
            const SizedBox(
              height: Grid.l,
            ),
          ],
        );
      },
    );
  }
}
