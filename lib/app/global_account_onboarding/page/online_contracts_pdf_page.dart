import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/pdf_viewer/pdf_viewer.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class OnlineContractsPdfPage extends StatefulWidget {
  final String pdfUrl;
  const OnlineContractsPdfPage({
    super.key,
    required this.pdfUrl,
  });

  @override
  State<OnlineContractsPdfPage> createState() => _OnlineContractsPdfPageState();
}

class _OnlineContractsPdfPageState extends State<OnlineContractsPdfPage> {
  late PdfControllerPinch _pdfControllerPinch;
  bool _isLastPage = false;

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
        title: L10n.tr('alpacaCustomerContracts'),
      ),
      body: PPdfViewer(
        pdfControllerPinch: _pdfControllerPinch,
        url: widget.pdfUrl,
        onError: (error) => PBottomSheet.showError(
          context,
          content: error.toString(),
        ),
        hasSlider: true,
        onPageChanged: (int? page, int? total) {
          if (page != null && total != null && page == total) {
            setState(() {
              _isLastPage = true;
            });
          }
        },
        isLast: (isLast) {
          setState(() {
            _isLastPage = true;
          });
        },
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Grid.s,
          ),
          child: PButton(
            text: L10n.tr('onayla'),
            fillParentWidth: true,
            onPressed: _isLastPage
                ? () {
                    router.maybePop();
                  }
                : null,
          ),
        ),
      ],
    );
  }
}
