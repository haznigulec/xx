import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:flutter/material.dart';

class PBottomNavigationBar extends StatefulWidget {
  final List<BottomNavigationBarItem> navigationItems;
  final void Function(int) onTap;
  final int currentIndex;
  const PBottomNavigationBar({
    super.key,
    required this.navigationItems,
    required this.onTap,
    required this.currentIndex,
  });

  @override
  State<PBottomNavigationBar> createState() => _PPBottomNavigationBar();
}

class _PPBottomNavigationBar extends State<PBottomNavigationBar> {
  @override
  void initState() {
    _currentIndex = widget.currentIndex;
    super.initState();
  }

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: context.pColorScheme.transparent,
        highlightColor: context.pColorScheme.transparent,
        hoverColor: context.pColorScheme.transparent,
      ),
      child: BottomNavigationBarTheme(
        data: Theme.of(context).bottomNavigationBarTheme.copyWith(
              selectedItemColor: context.pColorScheme.primary,
            ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          elevation: 0.0,
          items: [
            ...widget.navigationItems,
            const BottomNavigationBarItem(
              icon: SizedBox(
                width: 60,
              ),
              label: '',
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            widget.onTap(index);
          },
        ),
      ),
    );
  }
}
