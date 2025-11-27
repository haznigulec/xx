import 'dart:async';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/market_carousel/market_carousel_alpaca_vertical_item.dart';
import 'package:piapiri_v2/app/market_carousel/market_carousel_matriks_vertical_item.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_carousel_model.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_soruce_enum.dart';

class MarketCarouselVerticalWidget extends StatefulWidget {
  const MarketCarouselVerticalWidget({super.key});

  @override
  State<MarketCarouselVerticalWidget> createState() =>
      _MarketCarouselVerticalWidgetState();
}

class _MarketCarouselVerticalWidgetState
    extends State<MarketCarouselVerticalWidget> {
  late final SymbolBloc _symbolBloc;
  late final List<MarketCarouselModel> _carouselItems;
  late Timer _autoScrollTimer;
  int _currentIndex = 0;

  static const _fadeDuration = Duration(milliseconds: 500);
  static const _switchInterval = Duration(milliseconds: 5000);

  @override
  void initState() {
    super.initState();
    _symbolBloc = getIt<SymbolBloc>();
    _carouselItems = _symbolBloc.state.marketCarousel;

    if (_carouselItems.isNotEmpty) {
      _autoScrollTimer = Timer.periodic(_switchInterval, (_) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _carouselItems.length;
        });
      });
    }
  }

  @override
  void dispose() {
    _autoScrollTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_carouselItems.isEmpty) return const SizedBox.shrink();
    final model = _carouselItems[_currentIndex];
    return Container(
      key: ValueKey(model.code),
      color: context.pColorScheme.transparent,
      child: model.symbolSource == SymbolSourceEnum.alpaca
          ? MarketCarouselAlpacaVerticalItem(
              symbolName: model.code,
              symbolType: model.symbolType,
              currencyType: model.currencyType,
              fadeDuration: _fadeDuration,
              onTap: () {
                router.push(SymbolUsDetailRoute(symbolName: model.code));
              },
            )
          : model.symbolSource == SymbolSourceEnum.matriks
              ? MarketCarouselMatriksVerticalItem(
                  symbolName: model.code,
                  symbolType: model.symbolType,
                  currencyType: model.currencyType,
                  fadeDuration: _fadeDuration,
                  onTap: () {
                    router.push(SymbolDetailRoute(
                      symbol: MarketListModel(
                        symbolCode: model.code,
                        symbolType: model.symbolType.dbKey,
                        updateDate: '',
                      ),
                      ignoreDispose: true,
                    ));
                  },
                )
              : const SizedBox.shrink(),
    );
  }
}
