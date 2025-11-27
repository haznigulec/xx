import 'package:auto_route/auto_route.dart';
import 'package:piapiri_v2/common/widgets/pdf_viewer/pdf_viewer.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';
import 'package:piapiri_v2/app/market_reviews/widgets/pdf_content_widget.dart';
import 'package:piapiri_v2/app/market_reviews/widgets/podcast_type_widget.dart';
import 'package:piapiri_v2/app/market_reviews/widgets/share_icon.dart';
import 'package:piapiri_v2/common/utils/date_time_utils.dart';
import 'package:piapiri_v2/common/widgets/appbars/p_inner_app_bar.dart';
import 'package:piapiri_v2/common/widgets/video_player/video_player.dart';
import 'package:piapiri_v2/core/model/report_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

@RoutePage()
class MarketReviewDetailPage extends StatefulWidget {
  final ReportModel reportModel;
  final String mainGroup;
  const MarketReviewDetailPage({
    super.key,
    required this.reportModel,
    required this.mainGroup,
  });

  @override
  State<MarketReviewDetailPage> createState() => _MarketReviewDetailPageState();
}

class _MarketReviewDetailPageState extends State<MarketReviewDetailPage> {
  String _title = '';
  Widget _bodyWidget = const SizedBox.shrink();
  late PdfControllerPinch _pdfControllerPinch;

  @override
  void initState() {
    super.initState();

    /// Analiz ve Raporlar'da Pdf olduğu için, sadece bu tiplerdeyse PdfControllerPinch oluşturuluyor
    if (widget.reportModel.typeId == 1 || widget.reportModel.typeId == 2) {
      _pdfControllerPinch = PdfControllerPinch(
        document: PdfDocument.openData(
          InternetFile.get(
            widget.reportModel.file,
          ),
        ),
      );
    }

    _handleTitle();
  }

  _handleTitle() async {
    /// Rapor tipine göre body widget ayarlanıyor.
    switch (widget.reportModel.typeId) {
      case 1:
        _title = L10n.tr('analiz_detay');
        _bodyWidget = PPdfViewer(
          url: widget.reportModel.file,
          pdfControllerPinch: _pdfControllerPinch,
          onError: (error) {
            return PBottomSheet.showError(
              context,
              content: error.toString(),
            );
          },
        );
        break;
      case 2:
        _title = L10n.tr('rapor_detay');
        _bodyWidget = PPdfViewer(
          url: widget.reportModel.file,
          pdfControllerPinch: _pdfControllerPinch,
          onError: (error) {
            return PBottomSheet.showError(
              context,
              content: error.toString(),
            );
          },
        );
        break;
      case 3:
        _title = L10n.tr('podcast_detay');
        _bodyWidget = PodcastTypeWidget(url: widget.reportModel.description);
        break;
      case 4:
        _title = L10n.tr('video_yorumlar');
        _bodyWidget = PVideoPlayer(videoUrl: widget.reportModel.file);
        break;
      case 5:
        _title = L10n.tr('egitim_detay');
        // Eğitim kategorisi olmadığı için boş bırakıldı
        _bodyWidget = const SizedBox.shrink();
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isPdfContent = widget.reportModel.typeId == 1 || widget.reportModel.typeId == 2;

    return isPdfContent
        ? PdfContentWidget(
            reportModel: widget.reportModel,
            title: _title,
            bodyWidget: _bodyWidget,
            mainGroup: widget.mainGroup,
          )
        : Scaffold(
            appBar: PInnerAppBar(
              title: _title,
              actions: [
                ShareIcon(
                  reportModel: widget.reportModel,
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Grid.m,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _titleWidget(context),
                  const SizedBox(height: Grid.s),
                  _dateText(context),
                  const SizedBox(height: Grid.s),
                  Expanded(
                    child: _bodyWidget,
                  ),
                ],
              ),
            ),
          );
  }

  Widget _titleWidget(BuildContext context) {
    return Text(
      widget.reportModel.title,
      textAlign: TextAlign.left,
      style: context.pAppStyle.labelMed16textPrimary,
    );
  }

  Widget _dateText(BuildContext context) {
    return Text(
      DateTimeUtils.dayMonthAndYear(
        widget.reportModel.dateTime,
      ),
      style: context.pAppStyle.labelMed14textSecondary,
    );
  }
}
