import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/p_inner_navigation_bar.dart';

class PInnerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool usePopScope;
  final String title;
  final String? subtitle;
  final String? ledingIcon;
  final List<Widget>? actions;
  final Widget? tabBar;
  final bool hasBottom;
  final bool implyLeading;
  final bool showClose;
  final double dividerHeight;
  final Function()? onPressed;
  final bool backButtonPressedDisposeClosedPage;
  final Function()? backButtonPressedDisposeClosedFunction;

  const PInnerAppBar({
    super.key,
    this.usePopScope = true,
    required this.title,
    this.subtitle,
    this.ledingIcon,
    this.actions,
    this.tabBar,
    this.hasBottom = false,
    this.implyLeading = true,
    this.showClose = false,
    this.dividerHeight = 0.5,
    this.onPressed,
    //Device'ın back tuşuna engel olması durumu için eklendi.
    //back tuşu ile kapatmak dispose edilsin mi anlamını taşır. True set edilirse can pop false olur sayfa kapatılamaz.
    this.backButtonPressedDisposeClosedPage = false,
    //Device'ın back tuşuna basınca çalışması istenen method olması için eklendi.
    this.backButtonPressedDisposeClosedFunction,
  });

  @override
  Widget build(BuildContext context) {
    return !usePopScope
        ? PInnerNavigationBar(
            ledingIcon: ledingIcon,
            implyLeading: implyLeading,
            onPressed: onPressed,
            title: title,
            subtitle: subtitle,
            actions: actions,
            showClose: showClose,
          )
        : PopScope(
            canPop: !backButtonPressedDisposeClosedPage,
            onPopInvokedWithResult: (bool didPop, Object? result) {
              //canPop true ise sayfa kapanır ve bu methoda düşer. didPop true gelir.
              //didPop true ise zaten sayfa kapanmış olur.
              if (didPop) return;
              //canPop false ise didPop false gelir, sayfa kapanmamış olur.
              // 1-) sayfa içerisindeki backButtonPressedDisposeClosedFunction methodunda
              // 2-) backButtonPressedDisposeClosedPage parametresi false ' a çekilirse sayfa kapanabilir olur.
              // 3-) backButtonPressedDisposeClosedPage parametresi false ' a çekilmezse
              // 4-) sayfa kapatılmak istendiğinde backButtonPressedDisposeClosedFunction methodu tekrar çalışır.
              backButtonPressedDisposeClosedFunction?.call();
            },
            child: PInnerNavigationBar(
              ledingIcon: ledingIcon,
              implyLeading: implyLeading,
              onPressed: onPressed,
              title: title,
              subtitle: subtitle,
              actions: actions,
              showClose: showClose,
            ),
          );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (hasBottom ? 181 : 0),
      );
}
