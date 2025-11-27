import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PodcastTypeWidget extends StatefulWidget {
  final String url;
  const PodcastTypeWidget({
    super.key,
    required this.url,
  });

  @override
  State<PodcastTypeWidget> createState() => _PodcastTypeWidgetState();
}

class _PodcastTypeWidgetState extends State<PodcastTypeWidget> with WidgetsBindingObserver {
  WebViewController controller = WebViewController();
  InAppWebViewController? webViewController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      if (webViewController != null) {
        Future.delayed(const Duration(milliseconds: 300), () {
          webViewController?.evaluateJavascript(source: """
       document.querySelector('button[aria-label="Pause"]')?.click();
      """);

          // WebView'i tamamen durdur
          webViewController!.pause();
          webViewController!.pauseTimers();
        });
      }
    } else if (state == AppLifecycleState.resumed) {
      if (webViewController != null) {
        // WebView'i geri getirir.
        webViewController!.resume();
        webViewController!.resumeTimers();
        Future.delayed(const Duration(milliseconds: 500), () {
          webViewController?.evaluateJavascript(source: """
          document.querySelector('button[aria-label="Play"]')?.click();
        """);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InAppWebView(
          windowId: 10,
          initialSettings: InAppWebViewSettings(
            transparentBackground: true,
            useShouldOverrideUrlLoading: true,
            javaScriptEnabled: true,
            javaScriptCanOpenWindowsAutomatically: true,
            supportMultipleWindows: false,
          ),
          onWebViewCreated: (controller) {
            webViewController = controller;

            webViewController!.loadUrl(
              urlRequest: URLRequest(
                url: WebUri(widget.url),
              ),
            );
          },
          onPageCommitVisible: (con, uri) {
            con.goBack();
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            return navigationAction.request.url!.rawValue != 'about:blank'
                ? NavigationActionPolicy.ALLOW
                : NavigationActionPolicy.CANCEL;
          },
          onCreateWindow: (controller, createWindowAction) async {
            HeadlessInAppWebView? headlessWebView;
            headlessWebView = HeadlessInAppWebView(
              windowId: createWindowAction.windowId,
              onLoadStart: (controller, url) async {
                if (url != null) {
                  InAppBrowser.openWithSystemBrowser(url: url);
                }
                await headlessWebView?.dispose();
                headlessWebView = null;
              },
            );
            headlessWebView?.run();
            return true;
          },
          onLoadStop: (controller, url) async {
            setState(() {
              _isLoading = false;
            });
          },
        ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
