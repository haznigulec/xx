import 'package:cached_network_image/cached_network_image.dart';
import 'package:piapiri_v2/app/auth/bloc/auth_bloc.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/utils.dart';
import 'package:piapiri_v2/core/config/app_info.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/model/banner_model.dart';

class BannerWidget extends StatelessWidget {
  final int index;
  final BannerModel banner;
  final bool isExpanded;
  final Function() isExpandedChanged;
  const BannerWidget({
    super.key,
    required this.index,
    required this.banner,
    required this.isExpanded,
    required this.isExpandedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!isExpanded) {
          isExpandedChanged.call();
        } else {
          if (banner.destination != null) {
            if (!getIt<AuthBloc>().state.isLoggedIn) {
              Utils.urlHandler(context, Utils.getDestination(banner.destination!));
            } else {
              Utils.urlHandler(context, banner.destination!);
            }
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Grid.xxs),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Grid.m),
          child: !isExpanded
              ? Container(
                  height: Grid.xxl,
                  padding: const EdgeInsets.only(
                    left: Grid.m - Grid.xxs,
                    right: Grid.xl,
                  ),
                  color: banner.backgroundColor ?? context.pColorScheme.card,
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.sizeOf(context).width - Grid.m * 2,
                  child: Text(
                    banner.headerText ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.pAppStyle.labelMed14primary.copyWith(
                      color: banner.headerTextColor ?? context.pColorScheme.textPrimary,
                    ),
                  ),
                )
              : SizedBox(
                  width: MediaQuery.sizeOf(context).width - Grid.m * 2,
                  child: CachedNetworkImage(
                    imageUrl: '${getIt<AppInfo>().cdnUrl}banners/${banner.guid}/img.png',
                    fit: BoxFit.fill,
                  ),
                ),
        ),
      ),
    );
  }
}
