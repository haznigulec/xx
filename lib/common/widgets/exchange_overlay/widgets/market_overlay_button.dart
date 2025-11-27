import '../model/market_overlay_model.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MarketOverlayButton extends StatefulWidget {
  final MarketOverlayModel selectedOverlayModel;
  final bool isOverlayVisible;
  final Function onTap;
  const MarketOverlayButton({
    super.key,
    required this.selectedOverlayModel,
    required this.isOverlayVisible,
    required this.onTap,
  });

  @override
  State<MarketOverlayButton> createState() => _MarketOverlayButtonState();
}

class _MarketOverlayButtonState extends State<MarketOverlayButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: context.pColorScheme.lightHigh,
          borderRadius: BorderRadius.circular(24),
        ),
        child: IntrinsicWidth(
          child: Container(
            height: 35,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: context.pColorScheme.secondary,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  widget.selectedOverlayModel.assetPath,
                  
                  width: 16,
                  height: 16,
                ),
                const SizedBox(
                  width: Grid.xs,
                ),
                Flexible(
                  child: Text(
                    widget.selectedOverlayModel.label,
                    style: context.pAppStyle.labelMed18primary,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  width: Grid.xs,
                ),
                SvgPicture.asset(
                  widget.isOverlayVisible ? ImagesPath.chevron_up : ImagesPath.chevron_down,
                  
                  colorFilter: ColorFilter.mode(context.pColorScheme.primary, BlendMode.srcIn),
                  width: 19,
                  height: 19,
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        widget.onTap();
      },
    );
  }
}
