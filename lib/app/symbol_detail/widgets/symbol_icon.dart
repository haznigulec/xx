import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_svg_image/cached_network_svg_image.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:piapiri_v2/core/cache_managers/symbol_icon_cache_manager.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/capital_fallback.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/symbol_types.dart';

// symbolTypeToCdnHandleWithExtension methodunda fundların uzantısı boş geldiği için _tryPng parametresini kullanıyoruz
// fundların uzantısı dolu geldiğinde(Birce bekleniyor) _tryPng parametresi kaldırılıp _extension değeri switch edilecek.

class SymbolIcon extends StatefulWidget {
  final double size;
  final String symbolName;
  final SymbolTypes symbolType;
  final double? borderWidth;

  const SymbolIcon({
    super.key,
    this.size = 14,
    required this.symbolName,
    required this.symbolType,
    this.borderWidth,
  });

  @override
  State<SymbolIcon> createState() => _SymbolIconState();
}

class _SymbolIconState extends State<SymbolIcon> {
  bool _tryPng = true;
  late String _imageUrl;
  late String _extension;

  @override
  void initState() {
    (String, String) symbolCdnHandle = symbolTypeToCdnHandleWithExtension(widget.symbolType);
    _imageUrl = '${getIt<AppInfo>().cdnUrl}icons/${symbolCdnHandle.$1}/${widget.symbolName}'.trim();
    _extension = symbolCdnHandle.$2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        /// Border for the symbol icon
        if (widget.borderWidth != null)
          Container(
            width: widget.size + widget.borderWidth!,
            height: widget.size + widget.borderWidth!,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: widget.borderWidth!),
            ),
          ),
        ClipOval(
          key: ValueKey(widget.symbolName),
          child: _extension == 'svg'
              ? CachedNetworkSVGImage(
                  cacheManager: SymbolIconCacheManager(),
                  '$_imageUrl.$_extension',
                  placeholder: _placeHolder(),
                  errorWidget: Builder(
                    builder: (context) {
                      //Uzantıdan hata alınma ihtimaline karşı extension boşa çekilir ve diğer type denenir.
                      if (kDebugMode) {
                        print('SymbolIconError : $_imageUrl.$_extension');
                      }
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) {
                          setState(() {
                            _extension = '';
                            _tryPng = true;
                          });
                        },
                      );
                      return CapitalFallback(
                        symbolName: widget.symbolName,
                        size: widget.size,
                      );
                    },
                  ),
                  width: widget.size,
                  height: widget.size,
                  fadeDuration: const Duration(milliseconds: 500),
                )
              : _extension == 'png'
                  ? CachedNetworkImage(
                      cacheManager: SymbolIconCacheManager(),
                      imageUrl: '$_imageUrl.$_extension',
                      placeholder: (context, url) => _placeHolder(),
                      errorWidget: (context, url, error) {
                        //Uzantıdan hata alınma ihtimaline karşı extension boşa çekilir ve diğer type denenir.
                        if (kDebugMode) {
                          print('SymbolIconError : $_imageUrl.$_extension');
                        }
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) {
                            setState(() {
                              _extension = '';
                              _tryPng = false;
                            });
                          },
                        );
                        return CapitalFallback(
                          symbolName: widget.symbolName,
                          size: widget.size,
                        );
                      },
                      width: widget.size,
                      height: widget.size,
                      fadeInDuration: const Duration(milliseconds: 500),
                    )
                  : _tryPng
                      ? CachedNetworkImage(
                          cacheManager: SymbolIconCacheManager(),
                          imageUrl: '$_imageUrl.png',
                          placeholder: (context, url) => _placeHolder(),
                          errorWidget: (context, url, error) {
                            return CapitalFallback(
                              symbolName: widget.symbolName,
                              size: widget.size,
                            );
                          },
                          width: widget.size,
                          height: widget.size,
                          fadeInDuration: const Duration(milliseconds: 500),
                        )
                      : CachedNetworkSVGImage(
                          cacheManager: SymbolIconCacheManager(),
                          '$_imageUrl.svg',
                          placeholder: _placeHolder(),
                          errorWidget: CapitalFallback(
                            symbolName: widget.symbolName,
                            size: widget.size,
                          ),
                          width: widget.size,
                          height: widget.size,
                          fadeDuration: const Duration(milliseconds: 500),
                        ),
        ),
      ],
    );
  }

  Widget _placeHolder() {
    return Shimmerize(
      enabled: true,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: context.pColorScheme.backgroundColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class RectangleSymbolIcon extends StatefulWidget {
  final double size;
  final String symbolName;
  final SymbolTypes symbolType;
  final Widget? placeholderWidget;

  const RectangleSymbolIcon({
    super.key,
    this.size = 14,
    required this.symbolName,
    required this.symbolType,
    this.placeholderWidget,
  });

  @override
  State<RectangleSymbolIcon> createState() => _RectangleSymbolIconState();
}

class _RectangleSymbolIconState extends State<RectangleSymbolIcon> {
  bool _tryPng = true;
  late String _imageUrl;
  late String _extension;

  @override
  void initState() {
    (String, String) symbolCdnHandle = symbolTypeToCdnHandleWithExtension(widget.symbolType);
    _imageUrl = '${getIt<AppInfo>().cdnUrl}icons/${symbolCdnHandle.$1}/${widget.symbolName}';
    _extension = symbolCdnHandle.$2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Grid.s),
      child: _extension == 'svg'
          ? CachedNetworkSVGImage(
              cacheManager: SymbolIconCacheManager(),
              '$_imageUrl.svg',
              placeholder: widget.placeholderWidget ??
                  CircularProgressIndicator(
                    color: context.pColorScheme.primary,
                  ),
              errorWidget: Builder(builder: (context) {
                //Uzantıdan hata alınma ihtimaline karşı extension boşa çekilir ve diğer type denenir.
                if (kDebugMode) {
                  print('SymbolIconError : $_imageUrl.$_extension');
                }
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) {
                    setState(() {
                      _extension = '';
                      _tryPng = true;
                    });
                  },
                );
                return CapitalFallback(
                  symbolName: widget.symbolName,
                  size: widget.size,
                );
              }),
              width: widget.size,
              height: widget.size,
              fadeDuration: const Duration(milliseconds: 500),
            )
          : _extension == 'png'
              ? CachedNetworkImage(
                  cacheManager: SymbolIconCacheManager(),
                  imageUrl: '$_imageUrl.png',
                  placeholder: (context, url) =>
                      widget.placeholderWidget ??
                      CircularProgressIndicator(
                        color: context.pColorScheme.primary,
                      ),
                  errorWidget: (context, url, error) {
                    //Uzantıdan hata alınma ihtimaline karşı extension boşa çekilir ve diğer type denenir.
                    if (kDebugMode) {
                      print('SymbolIconError : $_imageUrl.$_extension');
                    }
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) {
                        setState(() {
                          _extension = '';
                          _tryPng = false;
                        });
                      },
                    );
                    return CapitalFallback(
                      symbolName: widget.symbolName,
                      size: widget.size,
                    );
                  },
                  width: widget.size,
                  height: widget.size,
                  fadeInDuration: const Duration(milliseconds: 500),
                )
              : _tryPng
                  ? CachedNetworkImage(
                      cacheManager: SymbolIconCacheManager(),
                      imageUrl: '$_imageUrl.png',
                      placeholder: (context, url) =>
                          widget.placeholderWidget ??
                          CircularProgressIndicator(
                            color: context.pColorScheme.primary,
                          ),
                      errorWidget: (context, url, error) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() => _tryPng = false);
                        });
                        return CapitalFallback(
                          symbolName: widget.symbolName,
                          size: widget.size,
                        );
                      },
                      width: widget.size,
                      height: widget.size,
                      fadeInDuration: const Duration(milliseconds: 500),
                    )
                  : CachedNetworkSVGImage(
                      cacheManager: SymbolIconCacheManager(),
                      '$_imageUrl.svg',
                      placeholder: widget.placeholderWidget ??
                          CircularProgressIndicator(
                            color: context.pColorScheme.primary,
                          ),
                      errorWidget: CapitalFallback(
                        symbolName: widget.symbolName,
                        size: widget.size,
                      ),
                      width: widget.size,
                      height: widget.size,
                      fadeDuration: const Duration(milliseconds: 500),
                    ),
    );
  }
}

class CardImage extends StatelessWidget {
  final double size;
  final String imageUrl;

  const CardImage({
    super.key,
    this.size = 14,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isSvg = imageUrl.toLowerCase().endsWith('.svg');
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        Grid.s,
      ),
      child: isSvg
          ? CachedNetworkSVGImage(
              cacheManager: SymbolIconCacheManager(),
              imageUrl,
              placeholder: CircularProgressIndicator(
                color: context.pColorScheme.primary,
              ),
              errorWidget: CapitalFallback(
                symbolName: imageUrl,
                size: size,
              ),
              width: size,
              height: size,
              fit: BoxFit.cover,
              fadeDuration: const Duration(milliseconds: 500),
            )
          : CachedNetworkImage(
              cacheManager: SymbolIconCacheManager(),
              imageUrl: imageUrl,
              placeholder: (context, url) => CircularProgressIndicator(
                color: context.pColorScheme.primary,
              ),
              errorWidget: (context, url, error) => CapitalFallback(
                symbolName: imageUrl,
                size: size,
              ),
              width: size,
              height: size,
              fit: BoxFit.cover,
              fadeInDuration: const Duration(milliseconds: 500),
            ),
    );
  }
}
