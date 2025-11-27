import 'dart:async';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/core/model/splash_story_model.dart';
import 'package:piapiri_v2/common/widgets/story/story_item_view_widget.dart';
import 'package:piapiri_v2/common/widgets/story/story_view_progress_bar_widget.dart';

class StoryViewWidget extends StatefulWidget {
  final List<SplashStoryModel> stories;

  const StoryViewWidget({super.key, required this.stories});

  @override
  State<StoryViewWidget> createState() => _StoryViewWidgetState();
}

class _StoryViewWidgetState extends State<StoryViewWidget>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animController;
  Timer? _timer;
  bool _isPaused = false;
  bool _isForward = true;
  final Duration _storyDuration = const Duration(seconds: 3);
  final Duration _switchDuration = const Duration(milliseconds: 250);

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: _storyDuration,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _nextStory();
        }
      });

    _startStory();
  }

  void _startStory() {
    _animController.forward(from: 0);
    _timer?.cancel();
    _timer = Timer(_storyDuration, _nextStory);
  }

  void _nextStory() {
    _isForward = true;
    final next =
        _currentIndex < widget.stories.length - 1 ? _currentIndex + 1 : 0;
    setState(() => _currentIndex = next);
    _startStory();
  }

  void _prevStory() {
    _isForward = false;
    final prev = _currentIndex > 0 ? _currentIndex - 1 : 0;
    setState(() => _currentIndex = prev);
    _startStory();
  }

  void _pauseStory() {
    if (!_isPaused) {
      _animController.stop();
      _timer?.cancel();
      _isPaused = true;
    }
  }

  void _resumeStory() {
    if (_isPaused) {
      final remaining = _animController.duration! * (1 - _animController.value);
      _animController.forward();
      _timer = Timer(remaining, _nextStory);
      _isPaused = false;
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stories = widget.stories;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) {
        final width = MediaQuery.of(context).size.width;
        if (details.globalPosition.dx < width / 3) {
          _prevStory();
        } else if (details.globalPosition.dx > 2 * width / 3) {
          _nextStory();
        }
      },
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null) {
          if (details.primaryVelocity! < 0) {
            _nextStory();
          } else if (details.primaryVelocity! > 0) {
            _prevStory();
          }
        }
      },
      onLongPress: _pauseStory,
      onLongPressUp: _resumeStory,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Grid.l,
              horizontal: Grid.m - Grid.xs,
            ),
            child: Row(
              children: List.generate(
                stories.length,
                (index) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Grid.xxs),
                    child: StoryViewProgressBarWidget(
                      animController: _animController,
                      position: index,
                      currentIndex: _currentIndex,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ClipRect(
              child: AnimatedSwitcher(
                duration: _switchDuration,
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                layoutBuilder: (currentChild, previousChildren) {
                  return Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      ...previousChildren,
                      if (currentChild != null) currentChild,
                    ],
                  );
                },
                transitionBuilder: (child, animation) {
                  final isIncoming = child.key == ValueKey<int>(_currentIndex);
                  late Animation<Offset> slideAnim;
                  final fadeIn = Tween<double>(begin: 0, end: 1).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
                    ),
                  );
                  final fadeOut = Tween<double>(begin: 1, end: 0).animate(
                    CurvedAnimation(
                      parent: ReverseAnimation(animation),
                      curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
                    ),
                  );

                  if (_isForward) {
                    if (isIncoming) {
                      slideAnim = Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation);
                      return FadeTransition(
                        opacity: fadeIn,
                        child:
                            SlideTransition(position: slideAnim, child: child),
                      );
                    } else {
                      slideAnim = Tween<Offset>(
                        begin: Offset.zero,
                        end: const Offset(-1.0, 0.0),
                      ).animate(ReverseAnimation(animation));

                      return FadeTransition(
                        opacity: fadeOut,
                        child:
                            SlideTransition(position: slideAnim, child: child),
                      );
                    }
                  } else {
                    if (isIncoming) {
                      slideAnim = Tween<Offset>(
                        begin: const Offset(-1.0, 0.0),
                        end: Offset.zero,
                      ).animate(animation);
                      return FadeTransition(
                        opacity: fadeIn,
                        child:
                            SlideTransition(position: slideAnim, child: child),
                      );
                    } else {
                      slideAnim = Tween<Offset>(
                        begin: Offset.zero,
                        end: const Offset(1.0, 0.0),
                      ).animate(ReverseAnimation(animation));
                      return FadeTransition(
                        opacity: fadeOut,
                        child:
                            SlideTransition(position: slideAnim, child: child),
                      );
                    }
                  }
                },
                child: StoryItemViewWidget(
                  key: ValueKey<int>(_currentIndex),
                  story: stories[_currentIndex],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
