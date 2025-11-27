import 'package:cached_network_image/cached_network_image.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/symbol_detail/widgets/capital_fallback.dart';
import 'package:piapiri_v2/core/cache_managers/symbol_icon_cache_manager.dart';
import 'package:shimmer/shimmer.dart';

class SectorGroupTile extends StatelessWidget {
  final String title;
  final String cdnUrl;
  final Function()? onTap;

  const SectorGroupTile({
    super.key,
    required this.title,
    required this.cdnUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: SizedBox(
        width: 112,
        child: Column(
          spacing: Grid.xs,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                Grid.s,
              ),
              child: CachedNetworkImage(
                width: 112,
                height: 72,
                cacheManager: SymbolIconCacheManager(),
                imageUrl: cdnUrl,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: context.pColorScheme.textSecondary.withValues(
                    alpha: 0.3,
                  ),
                  highlightColor: context.pColorScheme.textSecondary.withValues(
                    alpha: 0.1,
                  ),
                  child: Container(
                    width: 112,
                    height: 72,
                    decoration: BoxDecoration(
                      color: context.pColorScheme.lightHigh,
                      borderRadius: BorderRadius.circular(Grid.s),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) {
                  return CapitalFallback(
                    symbolName: title,
                    size: 72,
                  );
                },
                fadeInDuration: const Duration(
                  milliseconds: 500,
                ),
              ),
            ),
            Text(
              title,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: context.pAppStyle.labelMed14textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
