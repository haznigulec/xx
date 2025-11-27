import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';

class PCircularProgressIndicator extends StatelessWidget {
  final double? value;
  final double? size;
  final String? loadingText;
  final Color? loadingColor;
  final double? height;
  final double? strokeWidth;

  const PCircularProgressIndicator({
    super.key,
    this.value,
    this.size = Grid.xxl,
    this.loadingText,
    this.loadingColor,
    this.height,
    this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: Grid.m),
            child: loadingText?.isNotEmpty == true
                ? Text(
                    loadingText!,
                    style: context.pAppStyle.interMediumBase.copyWith(
                      fontSize: Grid.m,
                      color: loadingColor ?? context.pColorScheme.iconPrimary.shade700,
                    ),
                  )
                : Container(),
          ),
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: strokeWidth ?? 4.0,
              valueColor: AlwaysStoppedAnimation<Color>(
                loadingColor ?? context.pColorScheme.primary.shade500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PLinearProgressIndicator extends StatelessWidget {
  final double? value;
  final double width;
  final double? minHeight;
  final Color? color;
  final Color? backgroundColor;
  final double borderRadius;

  const PLinearProgressIndicator({
    super.key,
    this.value,
    this.width = double.infinity,
    this.minHeight,
    this.color,
    this.backgroundColor,
    this.borderRadius = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        child: LinearProgressIndicator(
          value: value,
          minHeight: minHeight,
          color: color ?? context.pColorScheme.primary,
          backgroundColor: backgroundColor ?? context.pColorScheme.primary.shade100,
        ),
      ),
    );
  }
}

class PAppBarLinearProgressIndicator extends StatelessWidget implements PreferredSizeWidget {
  final ValueNotifier<double?> progressValueNotifier;

  const PAppBarLinearProgressIndicator({
    super.key,
    required this.progressValueNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: progressValueNotifier,
      builder: (_, double? progress, __) => PLinearProgressIndicator(
        value: progress,
        color: progress == 100 ? context.pColorScheme.primary.shade100 : context.pColorScheme.primary,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(Grid.s);
}
