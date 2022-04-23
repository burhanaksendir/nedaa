import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

const pageTransition = PageTransitionsTheme(builders: {
  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
});

//Option 1:
// var _light = FlexThemeData.light(
//   colors: const FlexSchemeColor(
//     primary: Color(0xff0b3c5f),
//     primaryContainer: Color(0xff006585),
//     secondary: Color(0xffaf8937),
//     secondaryContainer: Color(0xffa99874),
//     tertiary: Color(0xff629aa2),
//     tertiaryContainer: Color(0xff7ba4aa),
//     appBarColor: Color(0xffa99874),
//     error: Color(0xffb00020),
//   ),
//   surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
//   blendLevel: 20,
//   appBarOpacity: 0.95,
//   subThemesData: const FlexSubThemesData(
//     blendOnLevel: 20,
//     blendOnColors: false,
//   ),
//   visualDensity: FlexColorScheme.comfortablePlatformDensity,
//   useMaterial3: true,
//   // To use the playground font, add GoogleFonts package and uncomment
//   // fontFamily: GoogleFonts.notoSans().fontFamily,
// ).copyWith(pageTransitionsTheme: pageTransition);

var _light = FlexThemeData.light(
  colors: const FlexSchemeColor(
    primary: Color(0xff125579),
    primaryContainer: Color(0xff007a97),
    secondary: Color(0xffb18a37),
    secondaryContainer: Color(0xff2f4858),
    tertiary: Color(0xff629aa2),
    tertiaryContainer: Color(0xff7ba4aa),
    appBarColor: Color(0xff2f4858),
    error: Color(0xffb00020),
  ),
  usedColors: 4,
  surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
  blendLevel: 20,
  appBarOpacity: 0.85,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 20,
    blendOnColors: false,
  ),
  keyColors: const FlexKeyColors(
    useTertiary: true,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
).copyWith(pageTransitionsTheme: pageTransition);

var _dark = FlexThemeData.dark(
  colors: const FlexSchemeColor(
    primary: Color(0xff125579),
    primaryContainer: Color(0xff007a97),
    secondary: Color(0xffb18a37),
    secondaryContainer: Color(0xff2f4858),
    tertiary: Color(0xff629aa2),
    tertiaryContainer: Color(0xff7ba4aa),
    appBarColor: Color(0xff2f4858),
    error: Color(0xffb00020),
  ),
  usedColors: 4,
  surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
  blendLevel: 15,
  appBarStyle: FlexAppBarStyle.background,
  appBarOpacity: 0.90,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 30,
  ),
  keyColors: const FlexKeyColors(
    useTertiary: true,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
).copyWith(pageTransitionsTheme: pageTransition);

class CustomTheme {
  static final ThemeData light = _light;
  static final ThemeData dark = _dark;
}
