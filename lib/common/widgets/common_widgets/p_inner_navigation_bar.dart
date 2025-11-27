import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';

class PInnerNavigationBar extends StatelessWidget {
  const PInnerNavigationBar({
    super.key,
    required this.ledingIcon,
    required this.implyLeading,
    required this.onPressed,
    required this.title,
    required this.subtitle,
    required this.actions,
    required this.showClose,
  });

  final String? ledingIcon;
  final bool implyLeading;
  final Function()? onPressed;
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool showClose;

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
        border: null,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: implyLeading,
        leading: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: context.pColorScheme.transparent,
            highlightColor: context.pColorScheme.transparent,
            onTap: onPressed ?? () => router.maybePop(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  ledingIcon ?? ImagesPath.chevron_left,
                  width: Grid.l - Grid.xs,
                  height: Grid.l - Grid.xs,
                  colorFilter: ColorFilter.mode(
                    context.pColorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(
                  width: Grid.xs,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.pAppStyle.labelMed18primary,
                      ),
                      const SizedBox(
                        height: Grid.xxs,
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ...actions ?? [],
            if (showClose)
              IconButton(
                onPressed: () {
                  router.maybePop();
                },
                icon: Icon(
                  Icons.close,
                  color: Theme.of(context).focusColor,
                ),
              ),
          ],
        ));
  }
}
