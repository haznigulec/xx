import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  bool isAfter(TimeOfDay other) {
    if (hour < other.hour) {
      return false;
    }
    if (hour > other.hour) {
      return true;
    }
    if (minute < other.minute) {
      return false;
    }
    if (minute > other.minute) {
      return true;
    }
    return false;
  }
}
