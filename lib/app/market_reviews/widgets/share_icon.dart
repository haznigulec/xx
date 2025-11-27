import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/model/report_model.dart';
import 'package:share_plus/share_plus.dart';

class ShareIcon extends StatelessWidget {
  final ReportModel reportModel;
  const ShareIcon({
    super.key,
    required this.reportModel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: Grid.s,
      ),
      child: GestureDetector(
        onTap: () => _doShare(),
        child: SvgPicture.asset(
          ImagesPath.share,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(
            context.pColorScheme.iconPrimary,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  _doShare() async {
    String text = '';
    if (reportModel.typeId == 1) {
      // Analizler
      text =
          '${reportModel.title}\n\n\n${reportModel.file}  \n\nPiapiri tarafından gönderildi.\nDetaylı bilgi için www.piapiri.com';
      Share.share(text, subject: reportModel.title);
    } else if (reportModel.typeId == 2) {
      // Raporlar
      text =
          '${reportModel.title}\n\n\n${reportModel.file}  \n\nPiapiri tarafından gönderildi.\nDetaylı bilgi için www.piapiri.com';
      Share.share(text, subject: reportModel.title);
    } else if (reportModel.typeId == 3) {
      // Podcastler
      text =
          'Düz Metin\n\n\n${reportModel.description}  \n\nPiapiri tarafından gönderildi.\nDetaylı bilgi için www.piapiri.com';
      Share.share(text);
    } else {
      // Video Yorumlar
      text =
          '${reportModel.title}\n\n\n${reportModel.file}  \n\nPiapiri tarafından gönderildi.\nDetaylı bilgi için www.piapiri.com';
      Share.share(text, subject: reportModel.title);
    }
  }
}
