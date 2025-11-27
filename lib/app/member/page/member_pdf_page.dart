import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/pdf_viewer/pdf_viewer.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class MemberPdfPage extends StatefulWidget {
  final String? title;
  final Function(bool) selectedKVKK;

  const MemberPdfPage({
    this.title,
    required this.selectedKVKK,
    super.key,
  });

  @override
  State<MemberPdfPage> createState() => _MemberPdfPageState();
}

class _MemberPdfPageState extends State<MemberPdfPage> {
  bool _isLastPage = false;
  late PdfControllerPinch pdfControllerPinch;

  @override
  void initState() {
    pdfControllerPinch = PdfControllerPinch(
      document: PdfDocument.openData(
        InternetFile.get(AppConfig.instance.memberKvkk),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
        ),
      ),
      child: Scaffold(
        appBar: widget.title == null
            ? null
            : PInnerAppBar(
                title: widget.title!,
              ),
        body: Column(
          children: [
            Expanded(
              child: PPdfViewer(
                pdfControllerPinch: pdfControllerPinch,
                url: AppConfig.instance.memberKvkk,
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
            ),
          ],
        ),
        persistentFooterButtons: [
          PButton(
            text: L10n.tr('onayla'),
            fillParentWidth: true,
            onPressed: _isLastPage
                ? () {
                    widget.selectedKVKK(true);
                    router.maybePop();
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
