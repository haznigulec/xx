import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/pdf_viewer/pdf_viewer.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class NotificationDetailPdfPage extends StatefulWidget {
  final String pdfUrl;
  const NotificationDetailPdfPage({
    super.key,
    required this.pdfUrl,
  });

  @override
  State<NotificationDetailPdfPage> createState() => _NotificationDetailPdfPageState();
}

class _NotificationDetailPdfPageState extends State<NotificationDetailPdfPage> {
  late PdfControllerPinch _pdfControllerPinch;

  @override
  void initState() {
    _pdfControllerPinch = PdfControllerPinch(
      document: PdfDocument.openData(
        InternetFile.get(widget.pdfUrl),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PInnerAppBar(
        title: L10n.tr('notification_detail'),
      ),
      body: PPdfViewer(
        url: widget.pdfUrl,
        pdfControllerPinch: _pdfControllerPinch,
        onError: (error) {
          return PBottomSheet.showError(
            context,
            content: error.toString(),
          );
        },
      ),
    );
  }
}
