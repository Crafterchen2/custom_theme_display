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
  ColorSeed colorSelected = ColorSeed.baseColor;
  ColorImageProvider imageSelected = ColorImageProvider.leaves;
  ColorScheme? imageColorScheme = const ColorScheme.light();
  ColorSelectionMethod colorSelectionMethod = ColorSelectionMethod.colorSeed;

  bool get useLightMode {
    switch (themeMode) {
      case ThemeMode.system:
        return View.of(context).platformDispatcher.platformBrightness ==
            Brightness.light;
      case ThemeMode.light:
        return true;
      case ThemeMode.dark:
        return false;
    }
  }

  bool getIsMat3() {
    return useMaterial3;
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
    ColorScheme.fromImageProvider(provider: NetworkImage(url))
        .then((newScheme) {
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
      darkTheme: (colorSelectionMethod == ColorSelectionMethod.colorSeed &&
              colorSelected == ColorSeed.custom)
          ? getCustomDarkTheme()
          : ThemeData(
              colorSchemeSeed:
                  colorSelectionMethod == ColorSelectionMethod.colorSeed
                      ? colorSelected.color
                      : imageColorScheme!.primary,
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
    return ThemeData(
      colorScheme: customLightScheme,
      sliderTheme: SliderThemeData(
        activeTrackColor: customLightScheme.secondary,
      ),
      useMaterial3: useMaterial3,
    );
  }

  ThemeData getCustomDarkTheme() {
    return ThemeData(
      colorScheme: customDarkScheme,
      sliderTheme: SliderThemeData(
        activeTrackColor: customLightScheme.secondary,
      ),
      useMaterial3: useMaterial3,
    );
  }

  static ColorScheme customLightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff092551),
    onPrimary: Color(0xffffffff),
    primaryContainer: Color(0xffd8e2ff),
    onPrimaryContainer: Color(0xff001a42),
    secondary: Color(0xffffac02),
    onSecondary: Color(0xff000000),
    secondaryContainer: Color(0xfffadebc),
    onSecondaryContainer: Color(0xff271904),
    tertiary: Color(0xff4e5f7d),
    onTertiary: Color(0xffffffff),
    tertiaryContainer: Color(0xffd6e3ff),
    onTertiaryContainer: Color(0xff091b36),
    error: Color(0xffba1a1a),
    onError: Color(0xffffffff),
    errorContainer: Color(0xffffdad6),
    onErrorContainer: Color(0xff410002),
    background: Color(0xfffefbff),
    onBackground: Color(0xff1b1b1f),
    surface: Color(0xfffefbff),
    onSurface: Color(0xff1b1b1f),
    surfaceVariant: Color(0xffe1e2ec),
    onSurfaceVariant: Color(0xff44474f),
    outline: Color(0xff75777f),
    outlineVariant: Color(0xffc5c6d0),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xff303034),
    onInverseSurface: Color(0xfff2f0f4),
    inversePrimary: Color(0xffaec6ff),
    surfaceTint: Color(0xff325ca8),
  );

  static ColorScheme customDarkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xffa0c9ff),
    onPrimary: Color(0xff003259),
    primaryContainer: Color(0xff00497f),
    onPrimaryContainer: Color(0xffd2e4ff),
    secondary: Color(0xffe7bdb0),
    onSecondary: Color(0xff442a21),
    secondaryContainer: Color(0xff5d4036),
    onSecondaryContainer: Color(0xffffdbd0),
    tertiary: Color(0xffa4cddc),
    onTertiary: Color(0xff043542),
    tertiaryContainer: Color(0xff224c59),
    onTertiaryContainer: Color(0xffbfe9f9),
    error: Color(0xffffb4ab),
    onError: Color(0xff690005),
    errorContainer: Color(0xff93000a),
    onErrorContainer: Color(0xffffb4ab),
    background: Color(0xff1d2023),
    onBackground: Color(0xffe3e2e6),
    surface: Color(0xff1c1e21),
    onSurface: Color(0xffe3e2e6),
    surfaceVariant: Color(0xff444950),
    onSurfaceVariant: Color(0xffc3c6cf),
    outline: Color(0xff8d9199),
    outlineVariant: Color(0xff43474e),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xffe1e1e6),
    onInverseSurface: Color(0xff2f3033),
    inversePrimary: Color(0xff0b61a4),
    surfaceTint: Color(0xffa0c9ff),
  );
}
