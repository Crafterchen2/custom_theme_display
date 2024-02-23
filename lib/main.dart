// Copyright 2021 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'constants.dart';
import 'home.dart';

void main() {
  runApp(
    const App(),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool useMaterial3 = true;
  ThemeMode themeMode = ThemeMode.system;
  ColorSeed colorSelected = ColorSeed.custom;
  ColorImageProvider imageSelected = ColorImageProvider.leaves;
  ColorScheme? imageColorScheme = const ColorScheme.light();
  ColorSelectionMethod colorSelectionMethod = ColorSelectionMethod.colorSeed;

  bool get useLightMode {
    switch (themeMode) {
      case ThemeMode.system:
        return View.of(context).platformDispatcher.platformBrightness == Brightness.light;
      case ThemeMode.light:
        return true;
      case ThemeMode.dark:
        return false;
    }
  }

  void handleBrightnessChange(bool useLightMode) {
    setState(() {
      themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void handleMaterialVersionChange() {
    setState(() {
      useMaterial3 = !useMaterial3;
    });
  }

  void handleColorSelect(int value) {
    setState(() {
      colorSelectionMethod = ColorSelectionMethod.colorSeed;
      colorSelected = ColorSeed.values[value];
    });
  }

  void handleImageSelect(int value) {
    final String url = ColorImageProvider.values[value].url;
    ColorScheme.fromImageProvider(provider: NetworkImage(url)).then((newScheme) {
      setState(() {
        colorSelectionMethod = ColorSelectionMethod.image;
        imageSelected = ColorImageProvider.values[value];
        imageColorScheme = newScheme;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material 3',
      themeMode: themeMode,
      theme: colorSelectionMethod == ColorSelectionMethod.image
          ? ThemeData(
              colorSchemeSeed: null,
              colorScheme: imageColorScheme,
              useMaterial3: useMaterial3,
              brightness: Brightness.light,
            )
          : colorSelected == ColorSeed.custom
              ? getCustomLightTheme()
              : ThemeData(
                  colorSchemeSeed: colorSelected.color,
                  colorScheme: null,
                  useMaterial3: useMaterial3,
                  brightness: Brightness.light,
                ),
      darkTheme: (colorSelectionMethod == ColorSelectionMethod.colorSeed && colorSelected == ColorSeed.custom)
          ? getCustomDarkTheme()
          : ThemeData(
              colorSchemeSeed: colorSelectionMethod == ColorSelectionMethod.colorSeed ? colorSelected.color : imageColorScheme!.primary,
              useMaterial3: useMaterial3,
              brightness: Brightness.dark,
            ),
      home: Home(
        useLightMode: useLightMode,
        useMaterial3: useMaterial3,
        colorSelected: colorSelected,
        imageSelected: imageSelected,
        handleBrightnessChange: handleBrightnessChange,
        handleMaterialVersionChange: handleMaterialVersionChange,
        handleColorSelect: handleColorSelect,
        handleImageSelect: handleImageSelect,
        colorSelectionMethod: colorSelectionMethod,
      ),
    );
  }

  ThemeData getCustomLightTheme() {
    final double backgroundDisabledOpacity = 0.12;
    final double foregroundDisabledOpacity = 0.38;
    final OutlinedBorder buttonShape = ContinuousRectangleBorder();
    return ThemeData(
      colorScheme: customLightScheme,
      sliderTheme: SliderThemeData(
        activeTrackColor: customLightScheme.secondary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) return customLightScheme.onSurface.withOpacity(backgroundDisabledOpacity);
            return customLightScheme.secondary;
          }),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) return customLightScheme.onSurface.withOpacity(foregroundDisabledOpacity);
            if (states.contains(MaterialState.hovered)) return customLightScheme.onSecondary;
            return customLightScheme.primary;
          }),
          surfaceTintColor: MaterialStateProperty.resolveWith((states) {
            return Colors.transparent;
          }),
          elevation: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) return 0;
            if (states.contains(MaterialState.pressed)) return 2;
            if (states.contains(MaterialState.hovered)) return 10;
            return 5;
          }),
          shape: MaterialStateProperty.resolveWith((states) => buttonShape),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.resolveWith((states) => buttonShape),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.resolveWith((states) => buttonShape),
          side: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) return BorderSide(width: 1, color: customLightScheme.onSurface.withOpacity(backgroundDisabledOpacity));
            if (states.contains(MaterialState.pressed)) return BorderSide(width: 1, color: customLightScheme.primary);
            if (states.contains(MaterialState.hovered)) return BorderSide(width: 4, color: customLightScheme.primary);
            return BorderSide(width: 2, color: customLightScheme.primary);
          }),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.resolveWith((states) => buttonShape),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 5,
        backgroundColor: customLightScheme.primary,
        focusElevation: 10,
        foregroundColor: customLightScheme.onPrimary,
      ),
      switchTheme: SwitchThemeData(thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) return customLightScheme.onSurface.withOpacity(foregroundDisabledOpacity);
        if (states.contains(MaterialState.selected)) return customLightScheme.onPrimary;
        if (states.contains(MaterialState.hovered)) return customLightScheme.onSurfaceVariant;
        return customLightScheme.primary;
      })),
      scrollbarTheme: ScrollbarThemeData(
        thumbVisibility: MaterialStateProperty.resolveWith((states) {
          return true;
        }),
      ),
      useMaterial3: useMaterial3,
    );
  }

  ThemeData getCustomDarkTheme() {
    final double backgroundDisabledOpacity = 0.12;
    final double foregroundDisabledOpacity = 0.38;
    final OutlinedBorder buttonShape = ContinuousRectangleBorder();
    return ThemeData(
      colorScheme: customDarkScheme,
      sliderTheme: SliderThemeData(
        activeTrackColor: customDarkScheme.secondary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) return customDarkScheme.onSurface.withOpacity(backgroundDisabledOpacity);
            return customDarkScheme.secondary;
          }),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) return customDarkScheme.onSurface.withOpacity(foregroundDisabledOpacity);
            return customDarkScheme.onSecondary;
          }),
          surfaceTintColor: MaterialStateProperty.resolveWith((states) {
            return Colors.transparent;
          }),
          elevation: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) return 0;
            if (states.contains(MaterialState.pressed)) return 2;
            if (states.contains(MaterialState.hovered)) return 10;
            return 5;
          }),
          shape: MaterialStateProperty.resolveWith((states) => buttonShape),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.resolveWith((states) => buttonShape),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.resolveWith((states) => buttonShape),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.resolveWith((states) => buttonShape),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 5,
        backgroundColor: customDarkScheme.primary,
        focusElevation: 10,
        foregroundColor: customDarkScheme.onPrimary,
      ),
      switchTheme: SwitchThemeData(thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) return customDarkScheme.onSurface.withOpacity(foregroundDisabledOpacity);
        if (states.contains(MaterialState.selected)) return customDarkScheme.onPrimary;
        if (states.contains(MaterialState.hovered)) return customDarkScheme.onSurfaceVariant;
        return customDarkScheme.primary;
      })),
      scrollbarTheme: ScrollbarThemeData(
        thumbVisibility: MaterialStateProperty.resolveWith((states) {
          return true;
        }),
      ),
      useMaterial3: useMaterial3,
    );
  }
}

class SimpleColorScheme {
  final Color primarySeed;
  final Color secondarySeed;
  final Color tertiarySeed;
  final Color whiteSeed;
  final Color blackSeed;
  final Color errorSeed;
  final double lighterGreyLerp;
  final double lightGreyLerp;
  final double greyLerp;
  final double darkGreyLerp;
  final double onPrimaryLerp;
  final double onSecondaryLerp;
  final double onTertiaryLerp;
  final double onErrorLerp;
  final bool whiteForPrimaryLerp;
  final bool whiteForSecondaryLerp;
  final bool whiteForTertiaryLerp;
  final bool whiteForErrorLerp;

  late ColorScheme lightScheme;
  late ColorScheme darkScheme;
  late Color lighterGrey;
  late Color lightGrey;
  late Color grey;
  late Color darkGrey;
  late Color onPrimary;
  late Color onSecondary;
  late Color onTertiary;
  late Color onError;

  SimpleColorScheme({
    required this.primarySeed,
    required this.secondarySeed,
    required this.tertiarySeed,
    required this.whiteSeed,
    required this.blackSeed,
    this.errorSeed = const Color(0xffba1a1a),
    this.lighterGreyLerp = 0.1,
    this.lightGreyLerp = 0.25,
    this.greyLerp = 0.5,
    this.darkGreyLerp = 0.6,
    this.onPrimaryLerp = 0.6,
    this.onSecondaryLerp = 0.6,
    this.onTertiaryLerp = 0.6,
    this.onErrorLerp = 0.6,
    this.whiteForPrimaryLerp = true,
    this.whiteForSecondaryLerp = true,
    this.whiteForTertiaryLerp = true,
    this.whiteForErrorLerp = true,
  }) {
    lighterGrey = Color.lerp(whiteSeed, blackSeed, lighterGreyLerp)!;
    lightGrey = Color.lerp(whiteSeed, blackSeed, lightGreyLerp)!;
    grey = Color.lerp(whiteSeed, blackSeed, greyLerp)!;
    darkGrey = Color.lerp(whiteSeed, blackSeed, darkGreyLerp)!;
    onPrimary = Color.lerp(primarySeed, whiteForPrimaryLerp ? whiteSeed : blackSeed, onPrimaryLerp)!;
    onSecondary = Color.lerp(secondarySeed, whiteForSecondaryLerp ? whiteSeed : blackSeed, onSecondaryLerp)!;
    onTertiary = Color.lerp(tertiarySeed, whiteForTertiaryLerp ? whiteSeed : blackSeed, onTertiaryLerp)!;
    onError = Color.lerp(errorSeed, whiteForErrorLerp ? whiteSeed : blackSeed, onErrorLerp)!;
    lightScheme = makeLightScheme();
    darkScheme = makeDarkScheme();
  }

  ColorScheme makeLightScheme() {
    return ColorScheme(
      brightness: Brightness.light,
      primary: primarySeed,
      onPrimary: whiteSeed,
      primaryContainer: onPrimary,
      onPrimaryContainer: blackSeed,
      secondary: secondarySeed,
      onSecondary: whiteSeed,
      secondaryContainer: onSecondary,
      onSecondaryContainer: blackSeed,
      tertiary: tertiarySeed,
      onTertiary: whiteSeed,
      tertiaryContainer: onTertiary,
      onTertiaryContainer: blackSeed,
      error: errorSeed,
      onError: whiteSeed,
      errorContainer: onError,
      onErrorContainer: blackSeed,
      background: whiteSeed,
      onBackground: blackSeed,
      surface: whiteSeed,
      onSurface: blackSeed,
      surfaceVariant: lighterGrey,
      onSurfaceVariant: blackSeed,
      outline: grey,
      outlineVariant: lightGrey,
      shadow: blackSeed,
      scrim: blackSeed,
      inverseSurface: darkGrey,
      onInverseSurface: whiteSeed,
      inversePrimary: onPrimary,
      surfaceTint: primarySeed,
    );
  }

  ColorScheme makeDarkScheme() {
    return ColorScheme(
      brightness: Brightness.dark,
      primary: onPrimary,
      onPrimary: blackSeed,
      primaryContainer: primarySeed,
      onPrimaryContainer: whiteSeed,
      secondary: onSecondary,
      onSecondary: blackSeed,
      secondaryContainer: secondarySeed,
      onSecondaryContainer: whiteSeed,
      tertiary: onTertiary,
      onTertiary: blackSeed,
      tertiaryContainer: tertiarySeed,
      onTertiaryContainer: whiteSeed,
      error: onError,
      onError: blackSeed,
      errorContainer: errorSeed,
      onErrorContainer: whiteSeed,
      background: blackSeed,
      onBackground: whiteSeed,
      surface: blackSeed,
      onSurface: whiteSeed,
      surfaceVariant: darkGrey,
      onSurfaceVariant: whiteSeed,
      outline: lightGrey,
      outlineVariant: grey,
      shadow: blackSeed,
      scrim: blackSeed,
      inverseSurface: lighterGrey,
      onInverseSurface: blackSeed,
      inversePrimary: primarySeed,
      surfaceTint: onPrimary,
    );
  }
}

SimpleColorScheme schemeSrc = SimpleColorScheme(
  primarySeed: Color(0xFF092551),
  secondarySeed: Color(0xffffac02),
  tertiarySeed: Color(0xff00531f),
  whiteSeed: Color(0xffffffff),
  blackSeed: Color(0xff1a1a1a),
);

ColorScheme customLightScheme = schemeSrc.lightScheme;

ColorScheme customDarkScheme = schemeSrc.darkScheme;

ColorScheme customLegacyLightScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF092551), //Pionix primaryBlue
  onPrimary: Color(0xffffffff), //== Colors.white
  primaryContainer: Color(0xffd9e2ff), //== inversePrimary
  onPrimaryContainer: Color(0xff000000), //== Colors.black
  secondary: Color(0xffffac02), //Pionix primaryAmber
  onSecondary: Color(0xffffffff), //== Colors.white
  secondaryContainer: Color(0xffffddb2), //
  onSecondaryContainer: Color(0xff000000), //== Colors.black
  tertiary: Color(0xff00531f), //
  onTertiary: Color(0xffffffff), //== Colors.white
  tertiaryContainer: Color(0xffc6ffc7), //
  onTertiaryContainer: Color(0xff000000), //== Colors.black
  error: Color(0xffba1a1a), //
  onError: Color(0xffffffff), //== Colors.white
  errorContainer: Color(0xffffedea), //
  onErrorContainer: Color(0xff000000), //== Colors.black
  background: Color(0xffffffff), //== Colors.white
  onBackground: Color(0xff000000), //== Colors.black
  surface: Color(0xffffffff), //== Colors.white
  onSurface: Color(0xff000000), //== Colors.black
  surfaceVariant: Color(0xfff1f0f7), //
  onSurfaceVariant: Color(0xff000000), //== Colors.black
  outline: Color(0xff5d5e64), //
  outlineVariant: Color(0xffaaabb1), //
  shadow: Color(0xff000000), //== Colors.black
  scrim: Color(0xff000000), //== Colors.black
  inverseSurface: Color(0xff303033), //
  onInverseSurface: Color(0xffffffff), //== Colors.white
  inversePrimary: Color(0xffd9e2ff), //== primaryContainer
  surfaceTint: Color(0xFF092551), //== primary
);

ColorScheme customLegacyDarkScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xffd9e2ff),
  onPrimary: Color(0xff000000),
  primaryContainer: Color(0xff00429a),
  onPrimaryContainer: Color(0xffffffff),
  secondary: Color(0xffffddb2),
  onSecondary: Color(0xff000000),
  secondaryContainer: Color(0xff624000),
  onSecondaryContainer: Color(0xffffffff),
  tertiary: Color(0xFF00CE7C),
  onTertiary: Color(0xff000000),
  tertiaryContainer: Color(0xFF00531F),
  onTertiaryContainer: Color(0xffffffff),
  error: Color(0xffffb4ab),
  onError: Color(0xff000000),
  errorContainer: Color(0xff93000a),
  onErrorContainer: Color(0xffffffff),
  background: Color(0xff0b0b0d),
  onBackground: Color(0xffffffff),
  surface: Color(0xff000000),
  onSurface: Color(0xffffffff),
  surfaceVariant: Color(0xff373940),
  onSurfaceVariant: Color(0xffffffff),
  outline: Color(0xffc6c6cd),
  outlineVariant: Color(0xff76777d),
  shadow: Color(0xff000000),
  scrim: Color(0xff000000),
  inverseSurface: Color(0xffe3e2e6),
  onInverseSurface: Color(0xff000000),
  inversePrimary: Color(0xff1359c3),
  surfaceTint: Color(0xffd9e2ff),
);
