import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/model/splash_story_model.dart';
import 'package:piapiri_v2/core/cache_managers/symbol_icon_cache_manager.dart';
import 'package:piapiri_v2/core/utils/localization_utils.dart';

class StoryItemViewWidget extends StatefulWidget {
  const StoryItemViewWidget({
    super.key,
    required this.story,
  });
  final SplashStoryModel story;

  @override
  State<StoryItemViewWidget> createState() => _StoryItemViewWidgetState();
}

class _StoryItemViewWidgetState extends State<StoryItemViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.pColorScheme.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: Grid.m),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Grid.m),
            child: Text(
              L10n.tr(widget.story.title),
              style: context.pAppStyle.labelMed20primary,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: Grid.l),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Grid.m),
            child: AutoSizeText(
              L10n.tr(widget.story.message),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: context.pAppStyle.labelReg16textPrimary,
              minFontSize: Grid.m - Grid.xs,
            ),
          ),
          const SizedBox(height: Grid.l),
          Expanded(
            child: Container(
              color: context.pColorScheme.transparent,
              padding: EdgeInsets.zero,
              child: CachedNetworkImage(
                width: double.infinity,
                cacheManager: SymbolIconCacheManager(),
                imageUrl: widget.story.imageUrl,
                errorWidget: (context, url, error) {
                  return const SizedBox.shrink();
                },
                progressIndicatorBuilder: (context, url, progress) {
                  return const SizedBox.shrink();
                },
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
