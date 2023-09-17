// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

const Color COMPANY_COLOR = Color(0xFFCD2E32);
final OutlinedButtonThemeData OUTLINED_BUTTON_THEMEDATA =
    OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
  foregroundColor: COMPANY_COLOR,
));
final TextButtonThemeData TEXT_BUTTON_THEMEDATA = TextButtonThemeData(
  style: ButtonStyle(
    foregroundColor:
        MaterialStateProperty.resolveWith((states) => COMPANY_COLOR),
  ),
);

ThemeData getAppDarkTheme() {
  ThemeData themeDark = ThemeData.dark();
  return themeDark.copyWith(
    colorScheme: themeDark.colorScheme.copyWith(
      // Firmenfarbe
      secondary: COMPANY_COLOR,
      background: Colors.black,
      primary: COMPANY_COLOR,
    ),
    // Text colors
    textSelectionTheme: themeDark.textSelectionTheme.copyWith(
      selectionColor: COMPANY_COLOR,
      selectionHandleColor: COMPANY_COLOR,
      cursorColor: COMPANY_COLOR,
    ),
    checkboxTheme: CheckboxThemeData(
      side: BorderSide(
        color: themeDark.disabledColor,
        width: 2.0,
      ),
      // fillColor: MaterialStateProperty.resolveWith((states) => COMPANY_COLOR),
    ),
    // Only OutlinedButtons are used as buttons in this app
    outlinedButtonTheme: OUTLINED_BUTTON_THEMEDATA,
    // Used in showAboutDialog
    textButtonTheme: TEXT_BUTTON_THEMEDATA,
    textTheme: TextTheme(
      labelSmall: TextStyle(color: COMPANY_COLOR),
    ),
    // Used in LoadingIndicator and another loading animations
    progressIndicatorTheme: ProgressIndicatorThemeData(color: COMPANY_COLOR),
    //Iconcolors und Widgetcolors
    dividerColor: Colors.white,
  );
}

ThemeData getAppLightTheme() {
  ThemeData themeLight = ThemeData.light();

  return themeLight.copyWith(
    colorScheme: themeLight.colorScheme.copyWith(
      // Firmenfarbe
      secondary: COMPANY_COLOR,
      background: Colors.white,
      primary: COMPANY_COLOR,
    ),
    // Text colors
    textSelectionTheme: themeLight.textSelectionTheme.copyWith(
      selectionColor: COMPANY_COLOR,
      selectionHandleColor: COMPANY_COLOR,
      cursorColor: COMPANY_COLOR,
    ),
    primaryTextTheme:
        Typography.material2021(platform: TargetPlatform.android).black,
    textTheme: Typography.material2021(platform: TargetPlatform.android).black,
    // Only OutlinedButtons are used as buttons in this app
    outlinedButtonTheme: OUTLINED_BUTTON_THEMEDATA,
    // Used in showAboutDialog
    textButtonTheme: TEXT_BUTTON_THEMEDATA,
    checkboxTheme: CheckboxThemeData(
      side: BorderSide(color: themeLight.disabledColor, width: 2.0),
      // checkColor: MaterialStateProperty.resolveWith((states) => COMPANY_COLOR),
    ),
    // Used in LoadingIndicator and another loading animations
    progressIndicatorTheme: ProgressIndicatorThemeData(color: COMPANY_COLOR),
    primaryIconTheme: IconThemeData(color: Colors.black),
    dividerColor: Colors.black,
  );
}
