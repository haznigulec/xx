import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:piapiri_v2/theme/theme_context_extension.dart';

class CountDownTimer extends StatefulWidget {
  final int smsDuration;
  final Function(bool) timeIsOver;
  final AnimationController? controller;
  const CountDownTimer({
    super.key,
    required this.smsDuration,
    required this.timeIsOver,
    required this.controller,
  });

  @override
  State<CountDownTimer> createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> with TickerProviderStateMixin {
  String get timerString {
    Duration duration = _controller.duration! * _controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  late AnimationController _controller;
  @override
  void initState() {
    _controller = widget.controller!;
    super.initState();
    _controller.reverse(from: _controller.value == 0.0 ? 1.0 : _controller.value);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        widget.timeIsOver(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 112,
        width: 112,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: CustomPaint(
                      painter: CustomTimerPainter(
                        animation: _controller,
                        backgroundColor: context.pColorScheme.card,
                        color: context.pColorScheme.primary,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      timerString,
                      style: context.pAppStyle.labelMed18primary,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

//Timer widgetı
class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    required this.animation,
    required this.backgroundColor,
    required this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    // 1. Arka planı dolduran daire
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill; // İçini doldurur
    canvas.drawCircle(center, radius, backgroundPaint);

    // 2. İlerleme çemberi
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.butt;

    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, progress, false, progressPaint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter oldDelegate) {
    return oldDelegate.animation.value != animation.value ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.color != color;
  }
}
