import 'package:flutter/material.dart';

class DynamicIndexedStack extends StatelessWidget {
  final int index;
  final List<Widget> children;

  const DynamicIndexedStack({
    required this.index,
    required this.children,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(
        children.length,
        (i) {
          return Offstage(
            offstage: i != index,
            child: TickerMode(
              enabled: i == index,
              child: children[i],
            ),
          );
        },
      ),
    );
  }
}
