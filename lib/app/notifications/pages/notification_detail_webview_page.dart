import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/pdf_viewer/pdf_viewer.dart';
import 'package:piapiri_v2/common/widgets/place_holder/no_data_widget.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class NotificationDetailWebViewPage extends StatefulWidget {
  final String url;
  const NotificationDetailWebViewPage({
    super.key,
    required this.url,
  });

  @override
  State<NotificationDetailWebViewPage> createState() => _NotificationDetailWebViewPageState();
}

class _NotificationDetailWebViewPageState extends State<NotificationDetailWebViewPage> {
  PdfControllerPinch? _pdfControllerPinch;
  bool isHtml = false;

  @override
  void initState() {
    super.initState();

    isHtml = widget.url.contains('www.');

    if (Platform.isAndroid && !isHtml) {
      _pdfControllerPinch = PdfControllerPinch(
        document: PdfDocument.openData(
          InternetFile.get(
            widget.url,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('notification_detail'),
      ),
      body: Platform.isAndroid && !isHtml
          ? _pdfControllerPinch == null
              ? NoDataWidget(
                  message: L10n.tr('no_data'),
                )
              : PPdfViewer(
                  pdfControllerPinch: _pdfControllerPinch!,
                  url: widget.url,
                  onError: (error) => PBottomSheet.showError(
                    context,
                    content: error.toString(),
                  ),
                )
          : InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(
                  widget.url,
                ),
              ),
              initialSettings: InAppWebViewSettings(),
              onLoadStop: (controller, url) => setState(
                () {},
              ),
              onLoadStart: (controller, url) => setState(
                () {},
              ),
            ),
    );
  }
}
