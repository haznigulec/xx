import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:piapiri_v2/core/model/user_model.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class Utils {
  static Future<Uint8List> createVirementPDF(String institutionName) {
    return rootBundle.load('assets/fonts/Inter/Inter-Medium.ttf').then((value) async {
      final Uint8List fontData = value.buffer.asUint8List();
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            final ttf = pw.Font.ttf(fontData.buffer.asByteData());
            pw.TextStyle textStyle = pw.TextStyle(
              font: ttf,
              fontSize: 12,
            );
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    L10n.tr('investor_instruction_form'),
                    style: textStyle.copyWith(
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  '$institutionName nezdindeki hesabımda yer alan tüm hisselerimin ÜNLÜ MENKUL DEĞERLER A.Ş. (Takasbank Kurum Kodu: UNS) nezdindeki ${UserModel.instance.customerId ?? ''} numarali hesabıma virman yapılmasını rica ederim.',
                  style: textStyle,
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Tarih: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                  style: textStyle,
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Ad Soyad: ${UserModel.instance.name}',
                  style: textStyle,
                ),
              ],
            );
          },
        ),
      );
      Uint8List pdfFile = await pdf.save();
      return pdfFile;
    });
  }
}
