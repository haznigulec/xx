import 'package:flutter/material.dart';
import 'package:p_core/utils/platform_utils.dart';

class KeyboardUtils {
  static void dismissKeyboard() {
    if (PlatformUtils.isMobile) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  void scrollOnFocus(
    BuildContext context,
    GlobalKey key,
    ScrollController scrollController,
  ) {
    final renderObject = key.currentContext?.findRenderObject();
    if (renderObject is! RenderBox) {
      return;
    }

    final RenderBox box = renderObject;
    final Offset position = box.localToGlobal(Offset.zero);
    final double y = position.dy + box.size.height;
    final double scrollPosition = scrollController.position.pixels;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double kKeyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    if (y > screenHeight - kKeyboardHeight - 10) {
      scrollController.animateTo(
        scrollPosition + y - kKeyboardHeight,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
}
