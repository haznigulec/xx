import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedProgressImage extends StatefulWidget {
  final double progress; // 0.0 - 1.0 arası dışardan gelen değer
  final Widget imageWidget;
  const AnimatedProgressImage({
    super.key,
    required this.progress,
    required this.imageWidget,
  });

  @override
  State<AnimatedProgressImage> createState() => _AnimatedProgressImageState();
}

class _AnimatedProgressImageState extends State<AnimatedProgressImage> with TickerProviderStateMixin {
  late AnimationController progressController;
  late Animation<double> progressAnimation;
  double previousProgress = 0.0;

  @override
  void initState() {
    super.initState();
    previousProgress = widget.progress;
    progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(
      CurvedAnimation(
        parent: progressController,
        curve: Curves.easeInOut,
      ),
    );
    progressController.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedProgressImage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.progress != widget.progress) {
      progressController.reset();
      progressAnimation = Tween<double>(
        begin: oldWidget.progress,
        end: widget.progress,
      ).animate(
        CurvedAnimation(
          parent: progressController,
          curve: Curves.easeInOut,
        ),
      );
      progressController.forward();
    }
  }

  @override
  void dispose() {
    progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double imageSize = Grid.xl + Grid.xl;
    const double outerSize = imageSize + Grid.s;

    return AnimatedBuilder(
      animation: progressAnimation,
      builder: (context, child) {
        return SizedBox(
          width: outerSize,
          height: outerSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(
                  outerSize,
                  outerSize,
                ),
                painter: _ProgressRingPainter(
                  progress: progressAnimation.value,
                  progressColor: context.pColorScheme.primary,
                ),
              ),
              Container(
                width: imageSize,
                height: imageSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: widget.imageWidget,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color progressColor;

  _ProgressRingPainter({
    required this.progress,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double strokeWidth = 6.0;
    final center = size.center(Offset.zero);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
