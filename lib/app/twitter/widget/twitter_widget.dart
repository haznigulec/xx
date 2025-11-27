import 'package:piapiri_v2/common/widgets/place_holder/divider.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/twitter/bloc/twitter_bloc.dart';
import 'package:piapiri_v2/app/twitter/bloc/twitter_event.dart';
import 'package:piapiri_v2/app/twitter/bloc/twitter_state.dart';
import 'package:piapiri_v2/app/twitter/widget/twitter_tile.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_builder.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class TwitterWidget extends StatefulWidget {
  final MarketListModel symbol;
  final SymbolTypes type;
  const TwitterWidget({
    super.key,
    required this.symbol,
    required this.type,
  });

  @override
  State<TwitterWidget> createState() => _TwitterWidgetState();
}

class _TwitterWidgetState extends State<TwitterWidget> {
  late TwitterBloc _twitterBloc;
  @override
  initState() {
    super.initState();
    _twitterBloc = getIt<TwitterBloc>();
    _twitterBloc.add(
      GetListEvent(
        symbol:
            widget.type == SymbolTypes.future || widget.type == SymbolTypes.option || widget.type == SymbolTypes.warrant
                ? widget.symbol.underlying
                : widget.symbol.symbolCode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PBlocBuilder<TwitterBloc, TwitterState>(
          bloc: _twitterBloc,
          builder: (context, state) {
            if (state.twitterList == null || state.twitterList!.isEmpty) return const SizedBox.shrink();

            return Column(
              children: [
                Row(
                  children: [
                    Text(
                      L10n.tr('shared_on_x'),
                      style: context.pAppStyle.labelMed18textPrimary,
                    ),
                    const Spacer(),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        router.push(
                          TwitterRoute(
                            symbolName: widget.type == SymbolTypes.future ||
                                    widget.type == SymbolTypes.option ||
                                    widget.type == SymbolTypes.warrant
                                ? widget.symbol.underlying
                                : widget.symbol.symbolCode,
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
                  itemCount: state.twitterList!.length < 2 ? state.twitterList!.length : 2,
                  separatorBuilder: (_, __) => const PDivider(),
                  itemBuilder: (context, index) {
                    return TwitterTile(
                      twitter: state.twitterList![index],
                    );
                  },
                ),
                const SizedBox(
                  height: Grid.l,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
