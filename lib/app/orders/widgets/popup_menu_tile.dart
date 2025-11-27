import 'package:flutter/material.dart';

class PopUpMenuTile extends StatelessWidget {
  final String title;
  final Color color;
  final Color? textColor;

  const PopUpMenuTile({
    super.key,
    required this.title,
    required this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      height: kMinInteractiveDimension,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
