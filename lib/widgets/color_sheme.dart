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

final MaterialStateProperty<Icon?> THUMB_ICON =
    MaterialStateProperty.resolveWith<Icon?>((states) {
  if (states.contains(MaterialState.selected)) {
    return const Icon(Icons.check);
  }
  return const Icon(Icons.close);
});

ThemeData getAppDarkTheme() {
  ThemeData themeDark = ThemeData.dark(useMaterial3: true);
  return themeDark.copyWith(
      colorScheme: themeDark.colorScheme.copyWith(
        // Firmenfarbe
        secondary: COMPANY_COLOR,
        background: Colors.black,
        primary: COMPANY_COLOR,
        surface: Color.fromARGB(255, 49, 49, 49),
      ),
      // Text colors
      textSelectionTheme: themeDark.textSelectionTheme.copyWith(
        selectionColor: COMPANY_COLOR,
        selectionHandleColor: COMPANY_COLOR,
        cursorColor: COMPANY_COLOR,
      ),
      switchTheme: themeDark.switchTheme.copyWith(thumbIcon: THUMB_ICON),
      checkboxTheme: CheckboxThemeData(
        side: BorderSide(
          color: themeDark.disabledColor,
          width: 2.0,
        ),
      ),
      chipTheme: themeDark.chipTheme.copyWith(
        side: BorderSide(style: BorderStyle.none),
        shape: StadiumBorder(side: BorderSide(style: BorderStyle.none)),
      ),
      outlinedButtonTheme: OUTLINED_BUTTON_THEMEDATA,
      textButtonTheme: TEXT_BUTTON_THEMEDATA,
      textTheme: TextTheme(
        labelSmall: TextStyle(color: COMPANY_COLOR),
      ),
      datePickerTheme: themeDark.datePickerTheme.copyWith(
          rangeSelectionBackgroundColor: COMPANY_COLOR.withAlpha(100)),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: COMPANY_COLOR),
      dividerColor: Colors.white,
      cardColor: Color.fromARGB(255, 49, 49, 49));
}

ThemeData getAppLightTheme() {
  ThemeData themeLight = ThemeData.light(useMaterial3: true);

  return themeLight.copyWith(
      colorScheme: themeLight.colorScheme.copyWith(
        secondary: COMPANY_COLOR,
        background: Colors.white,
        primary: COMPANY_COLOR,
        outline: Colors.black54,
      ),
      textSelectionTheme: themeLight.textSelectionTheme.copyWith(
        selectionColor: COMPANY_COLOR,
        selectionHandleColor: COMPANY_COLOR,
        cursorColor: COMPANY_COLOR,
      ),
      primaryTextTheme:
          Typography.material2021(platform: TargetPlatform.android)
              .black
              .apply(bodyColor: Colors.black87),
      textTheme: Typography.material2021(platform: TargetPlatform.android)
          .black
          .apply(bodyColor: Colors.black87),
      outlinedButtonTheme: OUTLINED_BUTTON_THEMEDATA,
      textButtonTheme: TEXT_BUTTON_THEMEDATA,
      checkboxTheme: CheckboxThemeData(
        side: BorderSide(color: themeLight.disabledColor, width: 2.0),
      ),
      switchTheme: themeLight.switchTheme.copyWith(thumbIcon: THUMB_ICON),
      chipTheme: themeLight.chipTheme.copyWith(
        side: BorderSide(style: BorderStyle.none),
        shape: StadiumBorder(side: BorderSide(style: BorderStyle.none)),
      ),
      datePickerTheme: themeLight.datePickerTheme.copyWith(
          rangeSelectionBackgroundColor: COMPANY_COLOR.withAlpha(100)),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: COMPANY_COLOR),
      primaryIconTheme: IconThemeData(color: Colors.black),
      listTileTheme: themeLight.listTileTheme
          .copyWith(textColor: Color.fromARGB(200, 0, 0, 0)),
      dividerColor: Colors.black,
      dividerTheme: themeLight.dividerTheme.copyWith(color: Colors.black54));
}
