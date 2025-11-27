import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class InAppWebviewWidget extends StatelessWidget {
  final String id;
  final String text;
  final bool shouldParse;
  final bool addHtmlTag;
  final String? jsUrl;
  final String? jsScript;
  final VoidCallback? onLoadStart;
  final VoidCallback? onLoadEnd;

  const InAppWebviewWidget({
    super.key,
    required this.text,
    required this.id,
    this.shouldParse = true,
    this.addHtmlTag = true,
    this.jsUrl,
    this.jsScript,
    this.onLoadStart,
    this.onLoadEnd,
  });

  @override
  Widget build(BuildContext context) {
    InAppWebViewController? webViewController;

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    String content = shouldParse ? _convertStringToLink(text) : text;

    content = content.replaceAll('&-nbsp;', ' ').replaceAll('&nbsp;', ' ');

    String htmlContent = '<!DOCTYPE html>'
        '<html>'
        '<head>'
        '<meta name="viewport" content="width=device-width, initial-scale=1.0">'
        '<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300&display=swap" rel="stylesheet">'
        '<style>'
        'html, body {margin:0; padding:0; height:100%;}'
        '.viewcontent {'
        'margin:0;'
        'padding:0;'
        'font-weight:300;'
        'font-family:\'Open Sans\',sans-serif;'
        'color:#${isDarkMode ? 'FFFFFF' : '000000'};'
        'display:block;'
        'width:100%;'
        'height:100%;'
        'line-height:1;'
        '-webkit-font-smoothing:antialiased;'
        '}'
        '</style>'
        '</head>'
        '<body>'
        '<div class="viewcontent">$content</div>'
        '</body>'
        '</html>';
    return InAppWebView(
      key: ValueKey(id),
      initialSettings: InAppWebViewSettings(
        useHybridComposition: false,
        transparentBackground: true,
        useShouldOverrideUrlLoading: true,
        javaScriptEnabled: true,
        javaScriptCanOpenWindowsAutomatically: true,
      ),
      onWebViewCreated: (controller) async {
        webViewController = controller;
        webViewController!.loadData(
          data: addHtmlTag ? '<!DOCTYPE html><html>$htmlContent' : htmlContent,
        );

        if (jsUrl != null) {
          await webViewController!.injectJavascriptFileFromUrl(urlFile: WebUri(jsUrl!));
        }
      },
      onLoadStart: (controller, url) {
        onLoadStart?.call();
      },
      onLoadStop: (controller, url) async {
        onLoadEnd?.call();
        if (jsScript != null) {
          await controller.evaluateJavascript(source: jsScript!);
        }
      },
      onPageCommitVisible: (con, uri) {
        con.goBack();
      },
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        String url = navigationAction.request.url!.toString().trim().replaceAll('\n', '');
        Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          // Launches the URL in an external browser
          await launchUrl(uri);
          return NavigationActionPolicy.CANCEL;
        }

        return NavigationActionPolicy.ALLOW;
      },
      onCreateWindow: (controller, createWindowAction) async {
        HeadlessInAppWebView? headlessWebView;
        headlessWebView = HeadlessInAppWebView(
          windowId: createWindowAction.windowId,
          onLoadStart: (controller, url) async {
            if (url != null && url.toString().isNotEmpty) {
              launchUrl(url);
            }
            await headlessWebView?.dispose();
            headlessWebView = null;
          },
        );
        headlessWebView?.run();
        return true;
      },
    );
  }

  String _convertStringToLink(String textData) {
    textData = textData.replaceAll('\n', '<br>').replaceAll('style="width:100%"', '').replaceAll('\'', '');

    // Eğer content <br> ile başlıyorsa ilkini kaldır
    if (textData.startsWith('<br><br>')) {
      textData = textData.replaceFirst('<br>', '');
      if (textData.startsWith('<br>')) {
        textData = textData.replaceFirst('<br>', '');
      }
    }
    if (textData.startsWith('<br>')) {
      textData = textData.replaceFirst('<br>', '');
    }

    final urlRegExp = RegExp(
      r"(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?",
    );
    final urlMatches = urlRegExp.allMatches(textData);
    List<String> urls = urlMatches
        .map(
          (urlMatch) => textData.substring(urlMatch.start, urlMatch.end),
        )
        .toList();

    List linksString = [];
    for (var linkText in urls) {
      if (!linkText.startsWith('http')) {
        textData = textData.replaceAll(
          '[$linkText]',
          '',
        );
      } else {
        linksString.add(linkText);
      }
    }

    if (linksString.isNotEmpty) {
      Set<String> uniqueSet = Set<String>.from(linksString);

      for (var linkTextData in uniqueSet) {
        var rng = Random();
        int randomGuid = rng.nextInt(10000); // generates a random integer from 0 to 9999
        textData = textData.replaceAll(
          '[$linkTextData]',
          '',
        );
        textData = textData.replaceAll(linkTextData, '''
          <a id='tappable-$randomGuid' href="" target="_blank">$linkTextData</a>
          <script>
              document.querySelector('#tappable-$randomGuid').addEventListener('click', function(event) {
                  window.open('$linkTextData', '_blank', 'location=yes')
              });
          </script>
          ''');
      }
    }
    return textData;
  }
}
