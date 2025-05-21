// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

const Color companyColor = Color(0xFFCD2E32);
final OutlinedButtonThemeData OUTLINED_BUTTON_THEMEDATA =
    OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
  foregroundColor: companyColor,
));
final TextButtonThemeData TEXT_BUTTON_THEMEDATA = TextButtonThemeData(
  style: ButtonStyle(
    foregroundColor: WidgetStateProperty.resolveWith((states) => companyColor),
  ),
);

final WidgetStateProperty<Icon?> thumbIcon =
    WidgetStateProperty.resolveWith<Icon?>((states) {
  if (states.contains(WidgetState.selected)) {
    return const Icon(Icons.check);
  }
  return const Icon(Icons.close);
});

ThemeData getAppDarkTheme() {
  ThemeData themeDark = ThemeData.dark(useMaterial3: true);
  return themeDark.copyWith(
      colorScheme: themeDark.colorScheme.copyWith(
        // Firmenfarbe
        secondary: companyColor,
        primary: companyColor,
        surface: Color.fromARGB(255, 49, 49, 49),
      ),
      appBarTheme: themeDark.appBarTheme.copyWith(
        backgroundColor: Colors.black,
      ),
      // Text colors
      textSelectionTheme: themeDark.textSelectionTheme.copyWith(
        selectionColor: companyColor,
        selectionHandleColor: companyColor,
        cursorColor: companyColor,
      ),
      switchTheme: themeDark.switchTheme.copyWith(thumbIcon: thumbIcon),
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
        labelSmall: TextStyle(color: companyColor),
      ),
      datePickerTheme: themeDark.datePickerTheme
          .copyWith(rangeSelectionBackgroundColor: companyColor.withAlpha(100)),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: companyColor),
      dividerColor: Colors.white,
      cardColor: Color.fromARGB(255, 49, 49, 49));
}

ThemeData getAppLightTheme() {
  ThemeData themeLight = ThemeData.light(useMaterial3: true);

  return themeLight.copyWith(
      colorScheme: themeLight.colorScheme.copyWith(
        secondary: companyColor,
        primary: companyColor,
        outline: Colors.black54,
      ),
      appBarTheme: themeLight.appBarTheme.copyWith(
        backgroundColor: Colors.white,
      ),
      textSelectionTheme: themeLight.textSelectionTheme.copyWith(
        selectionColor: companyColor,
        selectionHandleColor: companyColor,
        cursorColor: companyColor,
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
      switchTheme: themeLight.switchTheme.copyWith(thumbIcon: thumbIcon),
      chipTheme: themeLight.chipTheme.copyWith(
        side: BorderSide(style: BorderStyle.none),
        shape: StadiumBorder(side: BorderSide(style: BorderStyle.none)),
      ),
      datePickerTheme: themeLight.datePickerTheme
          .copyWith(rangeSelectionBackgroundColor: companyColor.withAlpha(100)),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: companyColor),
      primaryIconTheme: IconThemeData(color: Colors.black),
      listTileTheme: themeLight.listTileTheme
          .copyWith(textColor: Color.fromARGB(200, 0, 0, 0)),
      dividerColor: Colors.black,
      dividerTheme: themeLight.dividerTheme.copyWith(color: Colors.black54));
}
