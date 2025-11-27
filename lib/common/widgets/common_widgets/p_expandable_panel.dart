import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:flutter/material.dart';

class PExpandablePanel extends StatefulWidget {
  const PExpandablePanel({
    super.key,
    required this.initialExpanded,
    this.isExpandedChanged,
    required this.titleBuilder,
    this.titleSubChild,
    required this.child,
    this.animationDuration = const Duration(milliseconds: 500),
    this.setTitleAtBottom = false,
  });

  final bool initialExpanded;
  final Function(bool)? isExpandedChanged;
  final Function(bool) titleBuilder;
  final Widget? titleSubChild;
  final Widget child;
  final Duration animationDuration;
  final bool setTitleAtBottom;

  @override
  State<PExpandablePanel> createState() => _PExpandablePanelState();
}

class _PExpandablePanelState extends State<PExpandablePanel> with SingleTickerProviderStateMixin {
  late AnimationController _expandController;
  late Animation<double> _animation;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initialExpanded;
    _prepareAnimations();
    _runExpandCheck();
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  void _prepareAnimations() {
    _expandController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _animation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _runExpandCheck() {
    if (_isExpanded) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!widget.setTitleAtBottom)
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
              _runExpandCheck();
              widget.isExpandedChanged?.call(_isExpanded);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: context.pColorScheme.transparent,
                  child: IgnorePointer(
                    child: widget.titleBuilder.call(_isExpanded),
                  ),
                ),
                if (widget.titleSubChild != null) ...[
                  widget.titleSubChild!,
                ]
              ],
            ),
          ),
        SizeTransition(
          axisAlignment: 1.0,
          sizeFactor: _animation,
          child: widget.child,
        ),
        if (widget.setTitleAtBottom)
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
              _runExpandCheck();
              widget.isExpandedChanged?.call(_isExpanded);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.titleSubChild != null) ...[
                  widget.titleSubChild!,
                ],
                Container(
                  color: context.pColorScheme.transparent,
                  child: IgnorePointer(
                    child: widget.titleBuilder.call(_isExpanded),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
