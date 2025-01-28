import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:krystl/core/base/base_model.dart';
import 'package:krystl/core/enums/app_theme.dart';
import 'package:krystl/core/enums/pref.dart';
import 'package:krystl/core/notifier/theme_notifier.dart';
import 'package:krystl/product/analytics/firebase.dart';
import 'package:provider/provider.dart';
/// Created by Balaji Malathi on 1/28/2025 at 21:56.

class ProfileViewModel extends BaseModel with BaseViewModel {
  @override
  void setContext(BuildContext context) => this.context = context;

  //region Variable Initialization
  String? profile, displayName;
  String uid = "";
  //endregion
  @override
  void init() {
    profile = localManager.getString(Pref.profile);
    displayName = localManager.getString(Pref.displayName);
    uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    notifyListeners();
  }

  AppThemes _appThemes = AppThemes.system;

  void changeTheme() {
    _appThemes =
        getTheme() == AppThemes.light ? AppThemes.dark : AppThemes.light;

    FBAnalytics.logEvent(name: "theme", parameters: {'theme': _appThemes.name});

    context.read<ThemeNotifier>().changeValue(_appThemes);
  }

  getTheme() {
    var theme = localManager.getString(Pref.theme);
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    if (theme == 'system') {
      return isDarkMode ? AppThemes.dark : AppThemes.light;
    }
    if (theme == 'light') {
      return AppThemes.light;
    }
    if (theme == 'dark') {
      return AppThemes.dark;
    }
  }
}
