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
      primary: Color(4286077440),
      surfaceTint: Color(4286077440),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4294953547),
      onPrimaryContainer: Color(4283447808),
      secondary: Color(4285815582),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4294959266),
      onSecondaryContainer: Color(4284237064),
      tertiary: Color(4283852032),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4291223114),
      onTertiaryContainer: Color(4281942784),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      background: Color(4294965490),
      onBackground: Color(4280294161),
      surface: Color(4294965490),
      onSurface: Color(4280294161),
      surfaceVariant: Color(4293976518),
      onSurfaceVariant: Color(4283385394),
      outline: Color(4286740063),
      outlineVariant: Color(4292134315),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281741348),
      inverseOnSurface: Color(4294701022),
      inversePrimary: Color(4294622464),
      primaryFixed: Color(4294959005),
      onPrimaryFixed: Color(4280621568),
      primaryFixedDim: Color(4294622464),
      onPrimaryFixedVariant: Color(4284171008),
      secondaryFixed: Color(4294959005),
      onSecondaryFixed: Color(4280621568),
      secondaryFixedDim: Color(4293182075),
      onSecondaryFixedVariant: Color(4284105478),
      tertiaryFixed: Color(4292275801),
      onTertiaryFixed: Color(4279770624),
      tertiaryFixedDim: Color(4290433599),
      onTertiaryFixedVariant: Color(4282469376),
      surfaceDim: Color(4293188040),
      surfaceBright: Color(4294965490),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294898401),
      surfaceContainer: Color(4294503643),
      surfaceContainerHigh: Color(4294109141),
      surfaceContainerHighest: Color(4293714384),
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4283842304),
      surfaceTint: Color(4286077440),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4287917824),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4283842307),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4287394098),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4282206208),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4285234176),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      background: Color(4294965490),
      onBackground: Color(4280294161),
      surface: Color(4294965490),
      onSurface: Color(4280294161),
      surfaceVariant: Color(4293976518),
      onSurfaceVariant: Color(4283122222),
      outline: Color(4285095497),
      outlineVariant: Color(4286937443),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281741348),
      inverseOnSurface: Color(4294701022),
      inversePrimary: Color(4294622464),
      primaryFixed: Color(4287917824),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4285880064),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4287394098),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4285618204),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4285234176),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4283720192),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4293188040),
      surfaceBright: Color(4294965490),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294898401),
      surfaceContainer: Color(4294503643),
      surfaceContainerHigh: Color(4294109141),
      surfaceContainerHighest: Color(4293714384),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4281212928),
      surfaceTint: Color(4286077440),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4283842304),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4281212928),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4283842307),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4280231168),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4282206208),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      background: Color(4294965490),
      onBackground: Color(4280294161),
      surface: Color(4294965490),
      onSurface: Color(4278190080),
      surfaceVariant: Color(4293976518),
      onSurfaceVariant: Color(4281017106),
      outline: Color(4283122222),
      outlineVariant: Color(4283122222),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281741348),
      inverseOnSurface: Color(4294967295),
      inversePrimary: Color(4294961858),
      primaryFixed: Color(4283842304),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4282067456),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4283842307),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4282067456),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4282206208),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4280823808),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4293188040),
      surfaceBright: Color(4294965490),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294898401),
      surfaceContainer: Color(4294503643),
      surfaceContainerHigh: Color(4294109141),
      surfaceContainerHighest: Color(4293714384),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4294962896),
      surfaceTint: Color(4294622464),
      onPrimary: Color(4282330624),
      primaryContainer: Color(4294556672),
      onPrimaryContainer: Color(4282790656),
      secondary: Color(4293182075),
      onSecondary: Color(4282330624),
      secondaryContainer: Color(4283382016),
      onSecondaryContainer: Color(4293905540),
      tertiary: Color(4293131365),
      onTertiary: Color(4281086976),
      tertiaryContainer: Color(4290367806),
      onTertiaryContainer: Color(4281416192),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      background: Color(4279767817),
      onBackground: Color(4293714384),
      surface: Color(4279767817),
      onSurface: Color(4293714384),
      surfaceVariant: Color(4283385394),
      onSurfaceVariant: Color(4292134315),
      outline: Color(4288450424),
      outlineVariant: Color(4283385394),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293714384),
      inverseOnSurface: Color(4281741348),
      inversePrimary: Color(4286077440),
      primaryFixed: Color(4294959005),
      onPrimaryFixed: Color(4280621568),
      primaryFixedDim: Color(4294622464),
      onPrimaryFixedVariant: Color(4284171008),
      secondaryFixed: Color(4294959005),
      onSecondaryFixed: Color(4280621568),
      secondaryFixedDim: Color(4293182075),
      onSecondaryFixedVariant: Color(4284105478),
      tertiaryFixed: Color(4292275801),
      onTertiaryFixed: Color(4279770624),
      tertiaryFixedDim: Color(4290433599),
      onTertiaryFixedVariant: Color(4282469376),
      surfaceDim: Color(4279767817),
      surfaceBright: Color(4282333228),
      surfaceContainerLowest: Color(4279373317),
      surfaceContainerLow: Color(4280294161),
      surfaceContainer: Color(4280557332),
      surfaceContainerHigh: Color(4281280798),
      surfaceContainerHighest: Color(4282004520),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  static MaterialScheme darkMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4294962896),
      surfaceTint: Color(4294622464),
      onPrimary: Color(4282330624),
      primaryContainer: Color(4294556672),
      onPrimaryContainer: Color(4279701248),
      secondary: Color(4293511039),
      onSecondary: Color(4280227072),
      secondaryContainer: Color(4289432907),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4293131365),
      onTertiary: Color(4281086976),
      tertiaryContainer: Color(4290367806),
      onTertiaryContainer: Color(4279112192),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      background: Color(4279767817),
      onBackground: Color(4293714384),
      surface: Color(4279767817),
      onSurface: Color(4294966007),
      surfaceVariant: Color(4283385394),
      onSurfaceVariant: Color(4292397487),
      outline: Color(4289700233),
      outlineVariant: Color(4287529579),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293714384),
      inverseOnSurface: Color(4281280798),
      inversePrimary: Color(4284302336),
      primaryFixed: Color(4294959005),
      onPrimaryFixed: Color(4279832576),
      primaryFixedDim: Color(4294622464),
      onPrimaryFixedVariant: Color(4282790656),
      secondaryFixed: Color(4294959005),
      onSecondaryFixed: Color(4279832576),
      secondaryFixedDim: Color(4293182075),
      onSecondaryFixedVariant: Color(4282790656),
      tertiaryFixed: Color(4292275801),
      onTertiaryFixed: Color(4279177984),
      tertiaryFixedDim: Color(4290433599),
      onTertiaryFixedVariant: Color(4281416192),
      surfaceDim: Color(4279767817),
      surfaceBright: Color(4282333228),
      surfaceContainerLowest: Color(4279373317),
      surfaceContainerLow: Color(4280294161),
      surfaceContainer: Color(4280557332),
      surfaceContainerHigh: Color(4281280798),
      surfaceContainerHighest: Color(4282004520),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme darkHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4294966007),
      surfaceTint: Color(4294622464),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4294951169),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294966007),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4293511039),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294574031),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4290696771),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      background: Color(4279767817),
      onBackground: Color(4293714384),
      surface: Color(4279767817),
      onSurface: Color(4294967295),
      surfaceVariant: Color(4283385394),
      onSurfaceVariant: Color(4294966007),
      outline: Color(4292397487),
      outlineVariant: Color(4292397487),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293714384),
      inverseOnSurface: Color(4278190080),
      inversePrimary: Color(4281804544),
      primaryFixed: Color(4294960302),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4294951169),
      onPrimaryFixedVariant: Color(4280227072),
      secondaryFixed: Color(4294960302),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4293511039),
      onSecondaryFixedVariant: Color(4280227072),
      tertiaryFixed: Color(4292539229),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4290696771),
      onTertiaryFixedVariant: Color(4279506944),
      surfaceDim: Color(4279767817),
      surfaceBright: Color(4282333228),
      surfaceContainerLowest: Color(4279373317),
      surfaceContainerLow: Color(4280294161),
      surfaceContainer: Color(4280557332),
      surfaceContainerHigh: Color(4281280798),
      surfaceContainerHighest: Color(4282004520),
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
        scaffoldBackgroundColor: colorScheme.background,
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
      background: background,
      onBackground: onBackground,
      surface: surface,
      onSurface: onSurface,
      surfaceVariant: surfaceVariant,
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
