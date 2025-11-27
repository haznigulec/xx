import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:flutter/material.dart';

class InkWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const InkWrapper({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.pColorScheme.transparent,
      child: InkWell(
        onTap: onTap,
        child: child,
      ),
    );
  }
}
