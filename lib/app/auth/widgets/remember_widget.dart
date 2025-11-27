import 'package:flutter/material.dart';
import 'package:piapiri_v2/theme/theme_context_extension.dart';

import 'package:piapiri_v2/core/utils/localization_utils.dart';

class RememberWidget extends StatefulWidget {
  final bool isRemember;
  final Function(bool) rememberMeValue;

  const RememberWidget({
    super.key,
    required this.rememberMeValue,
    required this.isRemember,
  });

  @override
  State<RememberWidget> createState() => _RememberWidgetState();
}

class _RememberWidgetState extends State<RememberWidget> {
  bool _rememberMe = false;
  final String _selectedIconUrl = "assets/images/selected_remember_icon.png";
  final String _unSelectedIconUrl = "assets/images/unselected_remember_icon.png";

  @override
  void initState() {
    _rememberMe = widget.isRemember;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _rememberMe = !_rememberMe;
          widget.rememberMeValue(_rememberMe);
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            L10n.tr('hatirla'),
            style: TextStyle(
              color: context.pColorScheme.lightMedium,
              fontFamily: "Inter-Medium",
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 5),
          Image.asset(
            _rememberMe ? _selectedIconUrl : _unSelectedIconUrl,
            width: 25,
            height: 25,
          ),
          const SizedBox(width: 5),
        ],
      ),
    );
  }
}
