import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:piapiri_v2/app/market_carousel/market_carousel_alpaca_item.dart';
import 'package:piapiri_v2/app/market_carousel/market_carousel_matriks_item.dart';
import 'package:piapiri_v2/core/bloc/symbol/symbol_bloc.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/market_carousel_model.dart';
import 'package:piapiri_v2/core/model/market_list_model.dart';
import 'package:piapiri_v2/core/model/symbol_soruce_enum.dart';

class MarketCarouselWidget extends StatefulWidget {
  const MarketCarouselWidget({
    super.key,
  });

  @override
  State<MarketCarouselWidget> createState() => _MarketCarouselWidgetState();
}

class _MarketCarouselWidgetState extends State<MarketCarouselWidget> {
  late SymbolBloc _symbolBloc;
  final ScrollController _scrollController = ScrollController();
  Timer? _scrollTimer;
  Timer? _resumeTimer;
  bool _isUserScrolling = false;
  bool _hasTriggeredTap = false; // Tek tıklama kontrolü

  @override
  void initState() {
    _symbolBloc = getIt<SymbolBloc>();
    _startAutoScroll();
    super.initState();
  }

  /// Otomatik kaydırmayı başlat
  void _startAutoScroll() {
    _scrollTimer?.cancel(); // Eski timer'ı iptal et
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!_isUserScrolling && _scrollController.hasClients) {
        double nextPosition = _scrollController.position.pixels + 3;

        if (nextPosition >= _scrollController.position.maxScrollExtent) {
          nextPosition = 0; // Başa sar
        }

        _scrollController.animateTo(
          nextPosition,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  /// Kullanıcı kaydırmaya başladığında (Gerçekten dokunduğunda)
  void _onUserScrollStart() {
    setState(() {
      _isUserScrolling = true;
    });
    _scrollTimer?.cancel(); // Otomatik kaydırmayı durdur
    _resumeTimer?.cancel(); // Önceki bekleme süresini iptal et
  }

  /// Kullanıcı kaydırmayı bıraktığında 3 saniye sonra tekrar başlat
  void _onUserStopScrolling() {
    _resumeTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _isUserScrolling = false;
      });
      _startAutoScroll(); // Kaydırmayı tekrar başlat
    });
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _resumeTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is UserScrollNotification) {
          // Sadece kullanıcı gerçekten kaydırıyorsa algıla
          if (notification.direction != ScrollDirection.idle) {
            _onUserScrollStart();
          } else {
            _onUserStopScrolling();
          }
        }
        return false;
      },
      child: SizedBox(
        height: 38,
        child: Listener(
          // liste otomatik olarak scroll edildiginden bu esnada tiklamalar algilanmiyor.
          // bu yuzden tiklama olayini simule etmek icin pointer eventi dinliyoruz.
          // tiklama olayi gerceklesirse 50ms sonra pointer down ve up eventi tetikleniyor.
          onPointerDown: (PointerDownEvent event) {
            if (_hasTriggeredTap) {
              _hasTriggeredTap = false;
              return; // Eğer zaten tıklandıysa tekrar çalıştırma
            }
            _scrollTimer?.cancel();
            _resumeTimer?.cancel();
            _scrollController.jumpTo(_scrollController.offset); // Kaydırmayı durdur

            final Offset tappedPosition = event.position;
            _hasTriggeredTap = true; // Tıklamayı engelle

            // 50ms sonra dokunma olayını simüle et
            Future.delayed(const Duration(milliseconds: 50), () {
              GestureBinding.instance.handlePointerEvent(PointerDownEvent(position: tappedPosition));
              GestureBinding.instance.handlePointerEvent(PointerUpEvent(position: tappedPosition));
            });

            _onUserStopScrolling();
          },
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal, // Yatay kaydırma
            itemBuilder: (context, index) {
              // Sonsuz döngü için mod alıyoruz
              final loopIndex = index % _symbolBloc.state.marketCarousel.length;
              MarketCarouselModel model = _symbolBloc.state.marketCarousel[loopIndex];
              if (model.symbolSource == SymbolSourceEnum.alpaca) {
                return InkWell(
                  onTapDown: (_) {
                    router.push(
                      SymbolUsDetailRoute(
                        symbolName: model.code,
                      ),
                    );
                  },
                  child: MarketCarouselAlpacaItem(
                    symbolName: model.code,
                    symbolType: model.symbolType,
                    currencyType: model.currencyType,
                  ),
                );
              }
              if (model.symbolSource == SymbolSourceEnum.matriks) {
                return InkWell(
                  onTapDown: (_) {
                    router.push(
                      SymbolDetailRoute(
                        symbol: MarketListModel(
                          symbolCode: model.code,
                          symbolType: model.symbolType.dbKey,
                          updateDate: '',
                        ),
                        ignoreDispose: true,
                      ),
                    );
                  },
                  child: MarketCarouselMatriksItem(
                    symbolName: model.code,
                    symbolType: model.symbolType,
                    currencyType: model.currencyType,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
