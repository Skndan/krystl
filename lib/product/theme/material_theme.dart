import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:krystl/core/cache/local_manager.dart";
import "package:krystl/core/enums/app_theme.dart";

import "../../config.dart";
import "../../core/enums/pref.dart";

/// Created by Balaji Malathi on 3/3/2024 at 12:55 PM.

class MaterialTheme {
  getTheme() {
    var theme = LocalManager.instance.getString(Pref.theme);
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    if (theme == 'system') {
      return isDarkMode ? dark() : light();
    }
    if (theme == 'light') {
      return light();
    }
    if (theme == 'dark') {
      return dark();
    }
  }

  getAppTheme() {
    var theme = LocalManager.instance.getString(Pref.theme);
    if (theme == 'dark') {
      return AppThemes.dark;
    }
    if (theme == 'light') {
      return AppThemes.light;
    }
    if (theme == 'system') {
      return AppThemes.system;
    }
  }

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff785a00),
      surfaceTint: Color(0xff785a00),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffffca4b),
      onPrimaryContainer: Color(0xff503a00),
      secondary: Color(0xff745b1e),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffffe0a2),
      onSecondaryContainer: Color(0xff5c4508),
      tertiary: Color(0xff566500),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffc6de4a),
      onTertiaryContainer: Color(0xff394300),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      background: Color(0xfffff8f2),
      onBackground: Color(0xff201b11),
      surface: Color(0xfffff8f2),
      onSurface: Color(0xff201b11),
      surfaceVariant: Color(0xfff0e1c6),
      onSurfaceVariant: Color(0xff4f4632),
      outline: Color(0xff82765f),
      outlineVariant: Color(0xffd4c5ab),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff363024),
      inverseOnSurface: Color(0xfffbefde),
      inversePrimary: Color(0xfffabd00),
      primaryFixed: Color(0xffffdf9d),
      onPrimaryFixed: Color(0xff251a00),
      primaryFixedDim: Color(0xfffabd00),
      onPrimaryFixedVariant: Color(0xff5b4300),
      secondaryFixed: Color(0xffffdf9d),
      onSecondaryFixed: Color(0xff251a00),
      secondaryFixedDim: Color(0xffe4c27b),
      onSecondaryFixedVariant: Color(0xff5a4306),
      tertiaryFixed: Color(0xffd6ee59),
      onTertiaryFixed: Color(0xff181e00),
      tertiaryFixedDim: Color(0xffbad23f),
      onTertiaryFixedVariant: Color(0xff414c00),
      surfaceDim: Color(0xffe4d9c8),
      surfaceBright: Color(0xfffff8f2),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffef2e1),
      surfaceContainer: Color(0xfff8ecdb),
      surfaceContainerHigh: Color(0xfff2e7d5),
      surfaceContainerHighest: Color(0xffece1d0),
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff563f00),
      surfaceTint: Color(0xff785a00),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff946f00),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff563f03),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff8c7132),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff3d4800),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff6b7c00),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfffff8f2),
      onBackground: Color(0xff201b11),
      surface: Color(0xfffff8f2),
      onSurface: Color(0xff201b11),
      surfaceVariant: Color(0xfff0e1c6),
      onSurfaceVariant: Color(0xff4b422e),
      outline: Color(0xff695e49),
      outlineVariant: Color(0xff857963),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff363024),
      inverseOnSurface: Color(0xfffbefde),
      inversePrimary: Color(0xfffabd00),
      primaryFixed: Color(0xff946f00),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff755700),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff8c7132),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff71581c),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff6b7c00),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff546200),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe4d9c8),
      surfaceBright: Color(0xfffff8f2),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffef2e1),
      surfaceContainer: Color(0xfff8ecdb),
      surfaceContainerHigh: Color(0xfff2e7d5),
      surfaceContainerHighest: Color(0xffece1d0),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff2e2000),
      surfaceTint: Color(0xff785a00),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff563f00),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff2e2000),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff563f03),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff1f2500),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff3d4800),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      background: Color(0xfffff8f2),
      onBackground: Color(0xff201b11),
      surface: Color(0xfffff8f2),
      onSurface: Color(0xff000000),
      surfaceVariant: Color(0xfff0e1c6),
      onSurfaceVariant: Color(0xff2b2312),
      outline: Color(0xff4b422e),
      outlineVariant: Color(0xff4b422e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff363024),
      inverseOnSurface: Color(0xffffffff),
      inversePrimary: Color(0xffffeac2),
      primaryFixed: Color(0xff563f00),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff3b2a00),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff563f03),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff3b2a00),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff3d4800),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff283000),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe4d9c8),
      surfaceBright: Color(0xfffff8f2),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffef2e1),
      surfaceContainer: Color(0xfff8ecdb),
      surfaceContainerHigh: Color(0xfff2e7d5),
      surfaceContainerHighest: Color(0xffece1d0),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffeed0),
      surfaceTint: Color(0xfffabd00),
      onPrimary: Color(0xff3f2e00),
      primaryContainer: Color(0xfff9bc00),
      onPrimaryContainer: Color(0xff463300),
      secondary: Color(0xffe4c27b),
      onSecondary: Color(0xff3f2e00),
      secondaryContainer: Color(0xff4f3900),
      onSecondaryContainer: Color(0xffefcc84),
      tertiary: Color(0xffe3fc65),
      onTertiary: Color(0xff2c3400),
      tertiaryContainer: Color(0xffb9d13e),
      onTertiaryContainer: Color(0xff313a00),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      background: Color(0xff181309),
      onBackground: Color(0xffece1d0),
      surface: Color(0xff181309),
      onSurface: Color(0xffece1d0),
      surfaceVariant: Color(0xff4f4632),
      onSurfaceVariant: Color(0xffd4c5ab),
      outline: Color(0xff9c8f78),
      outlineVariant: Color(0xff4f4632),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffece1d0),
      inverseOnSurface: Color(0xff363024),
      inversePrimary: Color(0xff785a00),
      primaryFixed: Color(0xffffdf9d),
      onPrimaryFixed: Color(0xff251a00),
      primaryFixedDim: Color(0xfffabd00),
      onPrimaryFixedVariant: Color(0xff5b4300),
      secondaryFixed: Color(0xffffdf9d),
      onSecondaryFixed: Color(0xff251a00),
      secondaryFixedDim: Color(0xffe4c27b),
      onSecondaryFixedVariant: Color(0xff5a4306),
      tertiaryFixed: Color(0xffd6ee59),
      onTertiaryFixed: Color(0xff181e00),
      tertiaryFixedDim: Color(0xffbad23f),
      onTertiaryFixedVariant: Color(0xff414c00),
      surfaceDim: Color(0xff181309),
      surfaceBright: Color(0xff3f382c),
      surfaceContainerLowest: Color(0xff120e05),
      surfaceContainerLow: Color(0xff201b11),
      surfaceContainer: Color(0xff241f14),
      surfaceContainerHigh: Color(0xff2f291e),
      surfaceContainerHighest: Color(0xff3a3428),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  static MaterialScheme darkMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffeed0),
      surfaceTint: Color(0xfffabd00),
      onPrimary: Color(0xff3f2e00),
      primaryContainer: Color(0xfff9bc00),
      onPrimaryContainer: Color(0xff170f00),
      secondary: Color(0xffe9c77f),
      onSecondary: Color(0xff1f1500),
      secondaryContainer: Color(0xffab8d4b),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffe3fc65),
      onTertiary: Color(0xff2c3400),
      tertiaryContainer: Color(0xffb9d13e),
      onTertiaryContainer: Color(0xff0e1200),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      background: Color(0xff181309),
      onBackground: Color(0xffece1d0),
      surface: Color(0xff181309),
      onSurface: Color(0xfffffaf7),
      surfaceVariant: Color(0xff4f4632),
      onSurfaceVariant: Color(0xffd8c9af),
      outline: Color(0xffafa189),
      outlineVariant: Color(0xff8e826b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffece1d0),
      inverseOnSurface: Color(0xff2f291e),
      inversePrimary: Color(0xff5d4400),
      primaryFixed: Color(0xffffdf9d),
      onPrimaryFixed: Color(0xff191000),
      primaryFixedDim: Color(0xfffabd00),
      onPrimaryFixedVariant: Color(0xff463300),
      secondaryFixed: Color(0xffffdf9d),
      onSecondaryFixed: Color(0xff191000),
      secondaryFixedDim: Color(0xffe4c27b),
      onSecondaryFixedVariant: Color(0xff463300),
      tertiaryFixed: Color(0xffd6ee59),
      onTertiaryFixed: Color(0xff0f1300),
      tertiaryFixedDim: Color(0xffbad23f),
      onTertiaryFixedVariant: Color(0xff313a00),
      surfaceDim: Color(0xff181309),
      surfaceBright: Color(0xff3f382c),
      surfaceContainerLowest: Color(0xff120e05),
      surfaceContainerLow: Color(0xff201b11),
      surfaceContainer: Color(0xff241f14),
      surfaceContainerHigh: Color(0xff2f291e),
      surfaceContainerHighest: Color(0xff3a3428),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme darkHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffffaf7),
      surfaceTint: Color(0xfffabd00),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffc101),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffffaf7),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffe9c77f),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfff9ffcf),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffbed643),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      background: Color(0xff181309),
      onBackground: Color(0xffece1d0),
      surface: Color(0xff181309),
      onSurface: Color(0xffffffff),
      surfaceVariant: Color(0xff4f4632),
      onSurfaceVariant: Color(0xfffffaf7),
      outline: Color(0xffd8c9af),
      outlineVariant: Color(0xffd8c9af),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffece1d0),
      inverseOnSurface: Color(0xff000000),
      inversePrimary: Color(0xff372700),
      primaryFixed: Color(0xffffe4ae),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffffc101),
      onPrimaryFixedVariant: Color(0xff1f1500),
      secondaryFixed: Color(0xffffe4ae),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffe9c77f),
      onSecondaryFixedVariant: Color(0xff1f1500),
      tertiaryFixed: Color(0xffdaf35d),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffbed643),
      onTertiaryFixedVariant: Color(0xff141800),
      surfaceDim: Color(0xff181309),
      surfaceBright: Color(0xff3f382c),
      surfaceContainerLowest: Color(0xff120e05),
      surfaceContainerLow: Color(0xff201b11),
      surfaceContainer: Color(0xff241f14),
      surfaceContainerHigh: Color(0xff2f291e),
      surfaceContainerHighest: Color(0xff3a3428),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme().toColorScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        fontFamily: Config.fontFamily,
        colorScheme: colorScheme,
        textTheme: const TextTheme().apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary,
    required this.surfaceTint,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.inverseOnSurface,
    required this.inversePrimary,
    required this.primaryFixed,
    required this.onPrimaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.onSecondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.onTertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixedVariant,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      surface: surface,
      onSurface: onSurface,
      surfaceContainerHighest: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
    );
  }
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
