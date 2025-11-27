import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

//Bize Ulaşın sosyal medya butonları
class SocialMediaButtons extends StatelessWidget {
  const SocialMediaButtons({
    super.key,
  });

  void _redirectToApp(context, String url) async {
    try {
      bool launched = await launchUrlString(
        url,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        throw Exception('Could not launch URL');
      }
    } catch (e) {
      PBottomSheet.showError(
        context,
        content: L10n.tr(e.toString()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSocialButton(
          ImagesPath.youtube,
          'url_youtube',
          context,
        ),
        _buildSocialButton(
          ImagesPath.instagram,
          'url_instagram',
          context,
        ),
        _buildSocialButton(
          ImagesPath.facebook,
          'url_facebook',
          context,
        ),
        _buildSocialButton(
          ImagesPath.linkedin,
          'url_linkedin',
          context,
        ),
        _buildSocialButton(
          ImagesPath.twitterIcon,
          'url_twitter',
          context,
        ),
      ],
    );
  }

  Widget _buildSocialButton(String assetPath, String url, BuildContext context) {
    return InkWell(
      splashColor: context.pColorScheme.transparent,
      highlightColor: context.pColorScheme.transparent,
      focusColor: context.pColorScheme.transparent,
      onTap: () => _redirectToApp(
        context,
        L10n.tr(
          url,
        ),
      ),
      child: SvgPicture.asset(
        assetPath,
        height: 36,
        fit: BoxFit.cover,
      ),
    );
  }
}
