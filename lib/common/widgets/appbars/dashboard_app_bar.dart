import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/app/home/widgets/header_buttons.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: context.pColorScheme.transparent,
        elevation: 0,
        shadowColor: context.pColorScheme.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: Grid.m),
          width: double.infinity,
          height: preferredSize.height,
          child: const HeaderButtons(),
        ),
      ),
    );
  }
}
