import 'package:flutter/material.dart';

class ColorHelpers {
  static Color convertHexStringToColor(String hexString) {
    int value = int.parse(hexString, radix: 16);
    return Color(value);
  }
}
