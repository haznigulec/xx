import 'package:collection/collection.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/ink_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/symbol_icon.dart';
import 'package:piapiri_v2/common/utils/money_utils.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/diff_percentage.dart';
import 'package:piapiri_v2/core/bloc/bloc/p_bloc_consumer.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_state.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/currency_enum.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

class MarketCarouselMatriksVerticalItem extends StatefulWidget {
  final String symbolName;
  final SymbolTypes symbolType;
  final CurrencyEnum currencyType;
  final Duration fadeDuration;
  final Function()? onTap;

  const MarketCarouselMatriksVerticalItem({
    super.key,
    required this.symbolName,
    required this.symbolType,
    required this.currencyType,
    required this.fadeDuration,
    required this.onTap,
  });

  @override
  State<MarketCarouselMatriksVerticalItem> createState() =>
      _MarketCarouselMatriksVerticalItemState();
}

class _MarketCarouselMatriksVerticalItemState
    extends State<MarketCarouselMatriksVerticalItem> {
  final SymbolBloc _symbolBloc = getIt<SymbolBloc>();
  late MarketListModel _marketListModel;

  @override
  initState() {
    _marketListModel = _symbolBloc.state.watchingItems.firstWhereOrNull(
            (element) => element.symbolCode == widget.symbolName) ??
        MarketListModel(
            symbolCode: widget.symbolName,
            updateDate: '',
            type: widget.symbolType.dbKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PBlocConsumer<SymbolBloc, SymbolState>(
      bloc: _symbolBloc,
      listenWhen: (previous, current) =>
          current.isUpdated &&
          current.updatedSymbol.symbolCode == widget.symbolName,
      listener: (context, state) {
        setState(() {
          _marketListModel = state.watchingItems.firstWhereOrNull(
                  (element) => element.symbolCode == widget.symbolName) ??
              state.updatedSymbol;
        });
      },
      builder: (context, state) {
        double price = MoneyUtils().getPrice(_marketListModel, null);
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              width: Grid.m,
            ),
            const Spacer(),
            Expanded(
              flex: 6,
              child: InkWrapper(
                onTap: widget.onTap,
                child: Container(
                  height: Grid.l + Grid.m - Grid.xs,
                  padding: const EdgeInsets.all(
                    Grid.xs,
                  ),
                  decoration: BoxDecoration(
                    color: context.pColorScheme.card,
                    borderRadius: BorderRadius.circular(
                      Grid.m + Grid.xxs,
                    ),
                  ),
                  child: Row(
                    children: [
                      SymbolIcon(
                        symbolName: widget.symbolName,
                        symbolType: widget.symbolType,
                        size: 28,
                      ),
                      const SizedBox(
                        width: Grid.s,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _marketListModel.symbolCode,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.pAppStyle.labelReg10textPrimary,
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      '${widget.currencyType.symbol}${MoneyUtils().readableMoney(price)}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: context
                                          .pAppStyle.labelMed10textPrimary,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: Grid.xs,
                                  ),
                                  DiffPercentage(
                                    percentage:
                                        _marketListModel.differencePercent,
                                    fontSize: Grid.s + Grid.xxs,
                                    iconSize: Grid.s + Grid.xxs,
                                    rowMainAxisAlignment:
                                        MainAxisAlignment.start,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        );
      },
    );
  }
}
