import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF1467CB); // 183D5D
  static const secondary = Color(0xFFCBE1F3);
  static const shadowColor = Colors.black;
  static const appBgColor = Color(0xFFF2F1F6);
  static const textBoxColor = Colors.white;
  static const white = Colors.white;
  static const inActiveColor = Colors.grey;
  static const darker = Color(0xFF3E4249);
  static const red = Color(0xFFff4b60);
  static const gray = Color(0xFF68686B);
  static const gray45 = Color(0xFFB5B5B6);
  static const calendarTextColor = Color.fromRGBO(51, 51, 51, 1);
  static const calendarBackgroundColor = Color.fromRGBO(0, 116, 227, 1);
  static const blue = Color.fromRGBO(0, 116, 227, 1);
  static const green = Colors.green;
  static const orange = Colors.orange;
  static const purple = Colors.purple;
  static const transparent = Colors.transparent;
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
