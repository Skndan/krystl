import 'package:flutter/material.dart';

import '../../product/theme/material_theme.dart';
import '../cache/local_manager.dart';
import '../enums/app_theme.dart';
import '../enums/pref.dart';

class ThemeNotifier extends ChangeNotifier implements IThemeNotifier {
  ThemeData _currentTheme = MaterialTheme().getTheme();

  AppThemes _currentThemeEnum = MaterialTheme().getAppTheme();

  /// Application theme enum.
  /// Default value is [AppThemes.system]
  AppThemes get currentThemeEnum => _currentThemeEnum;

  ThemeData get currentTheme => _currentTheme;

  @override
  void changeValue(AppThemes theme) {
    if (theme == AppThemes.light) {
      _currentTheme = MaterialTheme().light();
      _currentThemeEnum = AppThemes.light;
      LocalManager.instance.setString(Pref.theme, 'light');
    } else {
      _currentTheme = MaterialTheme().dark();
      _currentThemeEnum = AppThemes.dark;
      LocalManager.instance.setString(Pref.theme, 'dark');
    }
    notifyListeners();
  }
}

abstract class IThemeNotifier {
  void changeValue(AppThemes theme);
}
