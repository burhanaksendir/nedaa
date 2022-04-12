import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

const pageTransition = PageTransitionsTheme(builders: {
  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
});

var _light = FlexThemeData.light(
  colors: const FlexSchemeColor(
    primary: Color(0xff45948f),
    primaryContainer: Color(0xff45948f),
    secondary: Color(0xffbcddd2),
    secondaryContainer: Color(0xffbcddd2),
    tertiary: Color(0xff87c7be),
    tertiaryContainer: Color(0xff87c7be),
    appBarColor: Color(0xffbcddd2),
    error: Color(0xffb00020),
  ),
  surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
  blendLevel: 20,
  appBarOpacity: 0.95,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 20,
    blendOnColors: false,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  // fontFamily: GoogleFonts.notoSans().fontFamily,
).copyWith(pageTransitionsTheme: pageTransition);

var _dark = FlexThemeData.dark(
  scheme: FlexScheme.blumineBlue,
  surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
  blendLevel: 15,
  appBarStyle: FlexAppBarStyle.background,
  appBarOpacity: 0.90,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 30,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
).copyWith(pageTransitionsTheme: pageTransition);

class CustomTheme {
  static final ThemeData light = _light;
  static final ThemeData dark = _dark;
}
