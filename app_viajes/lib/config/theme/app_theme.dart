import 'package:flutter/material.dart';

final List<Color> colorList = [
  Color(0xFF0A0E1A),
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.yellow,
  Colors.purple,
  Colors.orange,
  Colors.pink,
  Colors.teal,
  Colors.cyan,
  Colors.indigo,
  Colors.lime,
  Colors.amber,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
  Colors.black,
  Colors.white,
  Colors.transparent,
];

class AppTheme {
  final int selectedColor;
  final bool isDarkMode;

  AppTheme({this.selectedColor = 0, this.isDarkMode = false})
    : assert(selectedColor >= 0, 'selectedColor must be >= 0'),
      assert(
        selectedColor < colorList.length,
        'selectedColor must be < colorList.length',
      );

  ThemeData getTheme() {
    final seed = colorList[selectedColor];
    final brightness = isDarkMode ? Brightness.dark : Brightness.light;

    final baseTheme = ThemeData(
      colorSchemeSeed: seed,
      brightness: brightness,
      useMaterial3: true,
    );

    return baseTheme.copyWith(
      scaffoldBackgroundColor: baseTheme.colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: baseTheme.colorScheme.primary,
        foregroundColor: baseTheme.colorScheme.onPrimary,
        elevation: 0,
      ),
    );
  }

  AppTheme copyWith({int? selectedColor, bool? isDarkMode}) {
    return AppTheme(
      selectedColor: selectedColor ?? this.selectedColor,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}
