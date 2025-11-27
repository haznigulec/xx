import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/constant.dart';

class SearchIcon extends StatelessWidget {
  const SearchIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.search,
      size: tabPageIconSize,
      color: Theme.of(context).focusColor,
    );
  }
}
