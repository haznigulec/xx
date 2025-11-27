import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PPdfViewer extends StatefulWidget {
  final String url;
  final PdfControllerPinch pdfControllerPinch;
  final Function(int?)? onRender;
  final Function(int?, int?)? onPageChanged;
  final Function(dynamic)? onError;
  final Function(int?, dynamic)? onPageError;
  final Function(String?)? onLinkHandler;
  final bool? hasSlider;
  final Function(bool)? isLast;
  final Function(int)? onTotalPage;

  const PPdfViewer({
    super.key,
    required this.url,
    required this.pdfControllerPinch,
    this.onRender,
    this.onPageChanged,
    this.onError,
    this.onPageError,
    this.onLinkHandler,
    this.hasSlider,
    this.isLast,
    this.onTotalPage,
  });

  @override
  State<PPdfViewer> createState() => _PPdfViewerState();
}

class _PPdfViewerState extends State<PPdfViewer> {
  late PdfControllerPinch pdfViewController;
  bool isReady = false;
  String filePath = '';
  String? errorMessage;
  int currentPage = 1;
  int totalPages = 1;

  @override
  void initState() {
    pdfViewController = widget.pdfControllerPinch;
    _loadPdf();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!isReady) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            if (errorMessage != null)
              Text(
                errorMessage!,
              ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        PdfViewPinch(
          controller: pdfViewController,
          onPageChanged: (page) {
            widget.onPageChanged?.call(page, pdfViewController.pagesCount);
            setState(() {
              currentPage = page;
            });
          },
        ),
        if ((widget.hasSlider ?? false) && totalPages > 1)
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            child: RotatedBox(
              quarterTurns: 1,
              child: Slider(
                thumbColor: context.pColorScheme.primary,
                activeColor: context.pColorScheme.iconPrimary.shade300.withValues(alpha: .5),
                inactiveColor: context.pColorScheme.iconPrimary.shade100.withValues(alpha: .5),
                value: currentPage.toDouble(),
                min: 1,
                divisions: totalPages,
                max: totalPages.toDouble(),
                onChanged: (value) {
                  setState(() {
                    currentPage = value.toInt();
                    if (currentPage == pdfViewController.pagesCount) {
                      widget.isLast?.call(true);
                    }
                  });
                  pdfViewController.jumpToPage(currentPage - 1);
                },
              ),
            ),
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }

  Future<void> _loadPdf() async {
    try {
      setState(() {
        isReady = false;
      });

      pdfViewController.document.then((doc) {
        setState(() {
          totalPages = doc.pagesCount;
          if (widget.onTotalPage != null) {
            widget.onTotalPage!(totalPages);
          }
          isReady = true;
        });
      }).catchError((e) {
        setState(() {
          errorMessage = e.toString();
          isReady = true;
        });
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }
}
