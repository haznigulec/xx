import 'package:piapiri_v2/common/widgets/buttons/button.dart';
import 'package:piapiri_v2/common/widgets/pdf_viewer/pdf_viewer.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class RealEstateCertificatePdf extends StatefulWidget {
  final String refCode;
  final VoidCallback onApproved;
  const RealEstateCertificatePdf({
    super.key,
    required this.refCode,
    required this.onApproved,
  });

  @override
  State<RealEstateCertificatePdf> createState() => _RealEstateCertificatePdfState();
}

class _RealEstateCertificatePdfState extends State<RealEstateCertificatePdf> {
  late bool _isLastPage;

  @override
  void initState() {
    _isLastPage = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Grid.s,
      children: [
        Expanded(
          child: PPdfViewer(
            pdfControllerPinch: PdfControllerPinch(
              document: PdfDocument.openData(
                InternetFile.get('${AppConfig.instance.contractUrl}${widget.refCode}'),
              ),
            ),
            url: '${AppConfig.instance.contractUrl}${widget.refCode}',
            onError: (error) {
              return PBottomSheet.showError(
                context,
                content: error.toString(),
              );
            },
            onPageChanged: (int? page, int? total) {
              if (page != null && total != null && page == total) {
                setState(() {
                  _isLastPage = true;
                });
              }
            },
            onTotalPage: (totalPage) => {
              if (totalPage == 1)
                {
                  setState(() {
                    _isLastPage = true;
                  }),
                }
            },
            isLast: (isLast) {
              setState(() {
                _isLastPage = true;
              });
            },
            hasSlider: true,
          ),
        ),
        PButton(
          text: L10n.tr('onayla'),
          fillParentWidth: true,
          onPressed: _isLastPage
              ? () {
                  widget.onApproved();
                  router.maybePop();
                }
              : null,
        )
      ],
    );
  }
}
