import 'dart:math';
import 'package:flutter/material.dart';

const Map<String, Color> habitColors = {
  'Amber': Colors.amber,
  'Red Accent': Colors.redAccent,
  'Light Blue': Colors.lightBlue,
  'Light Green': Color(0xFF8BC34A),
  'Purple Accent': Colors.purpleAccent,
  'Orange': Color(0xFFFF9800),
  'Teal': Color(0xFF009688),
  'Deep Purple': Colors.deepPurple,
};

Color getColorFromHex(String hexColor) {
  hexColor = hexColor.replaceAll('#', '').trim();
  if (hexColor.length == 6) {
    hexColor = 'FF$hexColor';
  }
  return Color(int.parse('0x$hexColor'));
}

String colorToHex(Color color) {
  return color
      .toARGB32()
      .toRadixString(16)
      .padLeft(8, '0')
      .substring(2)
      .toUpperCase();
}

String getRandomColorHex() {
  final random = Random();
  final colorValues = habitColors.values.toList();
  final randomColor = colorValues[random.nextInt(colorValues.length)];
  return colorToHex(randomColor);
}
