import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:flutter/material.dart';

class PLoading extends StatefulWidget {
  final bool isFullScreen;
  final double? height;
  final double? width;
  const PLoading({
    super.key,
    this.isFullScreen = false,
    this.height,
    this.width,
  });

  @override
  State<PLoading> createState() => _PLoadingState();
}

class _PLoadingState extends State<PLoading> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  final Tween<double> _tween = Tween(begin: 0.50, end: 1);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _controller!.forward();

    _controller!.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.isFullScreen ? MediaQuery.sizeOf(context).height : widget.height,
      width: widget.isFullScreen ? MediaQuery.sizeOf(context).width : widget.width,
      color: context.pColorScheme.backgroundColor,
      child: Center(
        child: ScaleTransition(
          scale: _tween.animate(
            CurvedAnimation(
              parent: _controller!,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          child: SizedBox(
            height: 40,
            width: 40,
            child: Image.asset(
              ImagesPath.piapiriCombinedShape,
              width: 25,
              height: 25,
              color: Theme.of(context).hoverColor,
            ),
          ),
        ),
      ),
    );
  }
}
