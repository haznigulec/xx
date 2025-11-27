import 'dart:convert';
import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:webview_flutter/webview_flutter.dart';

@RoutePage()
class TradingviewPage extends StatefulWidget {
  final String symbol;
  final String? symbolExchange;
  final String? usSymbolExchange;

  const TradingviewPage({
    super.key,
    required this.symbol,
    this.symbolExchange,
    this.usSymbolExchange,
  });

  @override
  State<TradingviewPage> createState() => _TradingviewPageState();
}

class _TradingviewPageState extends State<TradingviewPage> {
  late final WebViewController _controller;
  Offset _buttonPosition = Offset.zero;

  String _qualifySymbol(String symbol, String? exchange) {
    final s = symbol.trim().toUpperCase();
    final jsonKey = AppConfig.instance.flavor == Flavor.prod ? 'prod_prefix_to_tv' : 'dev_prefix_to_tv';
    final jsonString = remoteConfig.getString(jsonKey);
    if (jsonString.isEmpty) return s;

    try {
      final root = json.decode(jsonString);
      if (root is! Map) return s;

      String defaultPrefix = (root['default_prefix']?.toString() ?? '').toUpperCase();

      final allowedRaw = root['allowed_prefixes'];
      final allowedPrefixes =
          (allowedRaw is List) ? allowedRaw.map((e) => e.toString().toUpperCase()).toSet() : <String>{};
      if (!allowedPrefixes.contains(defaultPrefix)) {
        defaultPrefix = '';
      }

      final exRaw = root['exchange_to_tv'];
      final Map<String, String> exToTv = {};
      if (exRaw is Map) {
        exRaw.forEach((k, v) {
          final key = k.toString().trim().toUpperCase();
          final val = v.toString().toUpperCase();
          exToTv[key] = allowedPrefixes.contains(val) ? val : defaultPrefix;
        });
      }

      final exKey = (exchange ?? '').trim().toUpperCase();
      final String ex = exToTv[exKey] ?? defaultPrefix;
      return ex.isNotEmpty ? '$ex:$s' : s;
    } catch (e, st) {
      log('TV_PREFIX_RC_PARSE_ERROR: $e\n$st');
      return s;
    }
  }

  String _qualifyUsSymbol(String symbol, String? exchange) {
    final s = symbol.trim().toUpperCase();
    final jsonKey = AppConfig.instance.flavor == Flavor.prod ? 'prod_us_prefix_to_tv' : 'dev_us_prefix_to_tv';
    final jsonString = remoteConfig.getString(jsonKey);
    if (jsonString.isEmpty) return s;

    try {
      final root = json.decode(jsonString);
      if (root is! Map) return s;

      String defaultPrefix = (root['default_prefix']?.toString() ?? '').toUpperCase();

      final allowedRaw = root['allowed_prefixes'];
      final allowedPrefixes =
          (allowedRaw is List) ? allowedRaw.map((e) => e.toString().toUpperCase()).toSet() : <String>{};
      if (!allowedPrefixes.contains(defaultPrefix)) {
        defaultPrefix = '';
      }

      final micRaw = root['mic_to_tv'];
      final Map<String, String> micToTv = {};
      if (micRaw is Map) {
        micRaw.forEach((k, v) {
          final key = k.toString().trim().toUpperCase();
          final val = v.toString().toUpperCase();
          micToTv[key] = allowedPrefixes.contains(val) ? val : defaultPrefix;
        });
      }

      final mic = (exchange ?? '').trim().toUpperCase();
      final ex = micToTv[mic] ?? defaultPrefix;
      return ex.isNotEmpty ? '$ex:$s' : s;
    } catch (e, st) {
      log('TV_RC_PARSE_ERROR: $e\n$st');
      return s;
    }
  }

  @override
  void initState() {
    super.initState();

    String qualified;
    if (widget.symbolExchange?.isNotEmpty == true) {
      qualified = _qualifySymbol(widget.symbol, widget.symbolExchange);
    } else if (widget.usSymbolExchange?.isNotEmpty == true) {
      qualified = _qualifyUsSymbol(widget.symbol, widget.usSymbolExchange);
    } else {
      qualified = widget.symbol;
    }

    const host = 'www.tradingview.com';
    final uri = Uri.https(host, '/chart/', {'symbol': qualified});
    log('TV url qualified -> $qualified');
    log('TV url -> $uri');
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith("https://www.tradingview.com/chart/")) {
              return NavigationDecision.navigate; // sadece bu URL
            }
            return NavigationDecision.prevent; // diğer her şeyi engelle
          },
        ),
      )
      ..loadRequest(uri);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // Eğer ilk kez çiziliyorsa sağ alta koy
    if (_buttonPosition == Offset.zero) {
      _buttonPosition = Offset(screenSize.width - 70, screenSize.height - 150);
    }
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // WebView Tam ekran
            RotatedBox(
              quarterTurns: 1,
              child: WebViewWidget(controller: _controller),
            ),

            // Sürüklenebilir X butonu
            Positioned(
              left: _buttonPosition.dx,
              top: _buttonPosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _buttonPosition += details.delta; // sürükleme
                  });
                },
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.black.withValues(alpha: 0.6),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
