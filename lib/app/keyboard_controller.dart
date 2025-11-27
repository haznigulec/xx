// lib/keyboard_controller.dart
import 'package:flutter/material.dart';

// Klavye durumunu yöneten singleton sınıf
class KeyboardController with WidgetsBindingObserver {
  // Singleton örneği
  static final KeyboardController _instance = KeyboardController._internal();

  factory KeyboardController() {
    return _instance;
  }

  KeyboardController._internal() {
    WidgetsBinding.instance.addObserver(this);
  }

  // Klavye görünürlüğünü tutan ve yayınlayan ValueNotifier
  final ValueNotifier<bool> isKeyboardVisible = ValueNotifier<bool>(false);

  @override
  void didChangeMetrics() {
    // PlatformDispatcher kullanarak güncel klavye yüksekliğini al
    final bottomInset = WidgetsBinding.instance.platformDispatcher.views.first.viewInsets.bottom;
    final newKeyboardVisible = bottomInset > 0;

    // Eğer durum değiştiyse, ValueNotifier'ı güncelle
    if (isKeyboardVisible.value != newKeyboardVisible) {
      isKeyboardVisible.value = newKeyboardVisible;
    }
  }

  // Uygulama kapatıldığında observer'ı kaldırmak için
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}

// Global erişim için bir getter
final keyboardController = KeyboardController();
