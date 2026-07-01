import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccesibilidadController extends GetxController {
  // Modo oscuro
  final RxBool isDarkMode = false.obs;
  
  // Tamaño de fuente (escala: 0.8 a 1.4, default 1.0)
  final RxDouble fontScale = 1.0.obs;
  
  static const String _darkModeKey = 'dark_mode';
  static const String _fontScaleKey = 'font_scale';

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool(_darkModeKey) ?? false;
    fontScale.value = prefs.getDouble(_fontScaleKey) ?? 1.0;
    _applyTheme();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, isDarkMode.value);
    await prefs.setDouble(_fontScaleKey, fontScale.value);
  }

  void toggleDarkMode() {
    isDarkMode.value = !isDarkMode.value;
    _applyTheme();
    _saveSettings();
  }

  void _applyTheme() {
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void increaseFontSize() {
    if (fontScale.value < 1.4) {
      fontScale.value += 0.1;
      _saveSettings();
    }
  }

  void decreaseFontSize() {
    if (fontScale.value > 0.8) {
      fontScale.value -= 0.1;
      _saveSettings();
    }
  }

  void resetFontSize() {
    fontScale.value = 1.0;
    _saveSettings();
  }

  ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1976D2),
      brightness: Brightness.light,
    ),
    cardTheme: const CardThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
  );

  ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF64B5F6),
      brightness: Brightness.dark,
    ),
    cardTheme: const CardThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
  );
}
