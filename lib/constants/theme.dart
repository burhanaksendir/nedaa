import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

var _light = FlexThemeData.light(
  colors: const FlexSchemeColor(
    primary: Color(0xff327d77),
    primaryVariant: Color(0xffbcddd2),
    secondary: Color(0xff87c7be),
    secondaryVariant: Color(0xff6ebab5),
    appBarColor: Color(0xff6ebab5),
    error: Color(0xffb00020),
  ),
  surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
  blendLevel: 18,
  appBarStyle: FlexAppBarStyle.primary,
  appBarOpacity: 0.95,
  appBarElevation: 15,
  transparentStatusBar: true,
  tabBarStyle: FlexTabBarStyle.forAppBar,
  tooltipsMatchBackground: true,
  swapColors: false,
  lightIsWhite: false,
  useSubThemes: true,
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  // To use playground font, add GoogleFonts package and uncomment:
  // fontFamily: GoogleFonts.notoSans().fontFamily,
  subThemesData: const FlexSubThemesData(
    useTextTheme: true,
    fabUseShape: true,
    interactionEffects: true,
    bottomNavigationBarElevation: 0,
    bottomNavigationBarOpacity: 0.95,
    navigationBarOpacity: 0.95,
    navigationBarMutedUnselectedText: true,
    navigationBarMutedUnselectedIcon: true,
    inputDecoratorIsFilled: true,
    inputDecoratorBorderType: FlexInputBorderType.outline,
    inputDecoratorUnfocusedHasBorder: true,
    blendOnColors: true,
    blendTextTheme: true,
    popupMenuOpacity: 0.95,
  ),
);

var _dark = FlexThemeData.dark(
  colors: const FlexSchemeColor(
    primary: Color(0xff327d77),
    primaryVariant: Color(0xffbcddd2),
    secondary: Color(0xff87c7be),
    secondaryVariant: Color(0xff6ebab5),
    appBarColor: Color(0xff6ebab5),
    error: Color(0xffb00020),
  ).defaultError.toDark(35),
  surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
  blendLevel: 18,
  appBarStyle: FlexAppBarStyle.background,
  appBarOpacity: 0.95,
  appBarElevation: 15,
  transparentStatusBar: true,
  tabBarStyle: FlexTabBarStyle.forAppBar,
  tooltipsMatchBackground: true,
  swapColors: false,
  darkIsTrueBlack: false,
  useSubThemes: true,
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  // To use playground font, add GoogleFonts package and uncomment:
  // fontFamily: GoogleFonts.notoSans().fontFamily,
  subThemesData: const FlexSubThemesData(
    useTextTheme: true,
    fabUseShape: true,
    interactionEffects: true,
    bottomNavigationBarElevation: 0,
    bottomNavigationBarOpacity: 0.95,
    navigationBarOpacity: 0.95,
    navigationBarMutedUnselectedText: true,
    navigationBarMutedUnselectedIcon: true,
    inputDecoratorIsFilled: true,
    inputDecoratorBorderType: FlexInputBorderType.outline,
    inputDecoratorUnfocusedHasBorder: true,
    blendOnColors: true,
    blendTextTheme: true,
    popupMenuOpacity: 0.95,
  ),
);

class CustomTheme {
  static final ThemeData light = _light;
  static final ThemeData dark = _dark;
}
