import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/model/twitter_model.dart';

class TwitterTile extends StatelessWidget {
  final TwitterModel twitter;
  const TwitterTile({
    super.key,
    required this.twitter,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Grid.m),
      child: Card(
        color: context.pColorScheme.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              twitter.tweetText,
              textAlign: TextAlign.left,
              style: context.pAppStyle.labelReg14textPrimary,
            ),
            const SizedBox(
              height: Grid.s,
            ),
            Row(
              children: [
                SvgPicture.asset(
                  ImagesPath.twitterIcon,
                  width: 17.25,
                  height: 14,
                  colorFilter: ColorFilter.mode(
                    context.pColorScheme.iconSecondary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(
                  width: Grid.s,
                ),
                Expanded(
                  child: Text(
                    twitter.createdAt,
                    style: context.pAppStyle.labelMed14textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
