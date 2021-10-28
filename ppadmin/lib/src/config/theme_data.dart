// copy from muse asia app
/// contains theme data for app
// copy from muse asia app
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ppadmin/src/config/constants.dart';
import 'package:ppadmin/src/utils/styles.dart';

/// contains theme data for app

final myTheme = ThemeData(
  primaryColor: ORANGE,
  iconTheme: const IconThemeData(color: PRIMARY_COLOR, size: 24),
  appBarTheme: AppBarTheme(
    centerTitle: true,
    elevation: 2,
    color: Colors.white,
    actionsIconTheme: const IconThemeData(color: PRIMARY_COLOR, size: 20),
    iconTheme: const IconThemeData(color: PRIMARY_COLOR, size: 20),
    titleTextStyle: Styles.appBarTextStyle(),
  ),
  floatingActionButtonTheme:
      const FloatingActionButtonThemeData(backgroundColor: PRIMARY_COLOR),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: PRIMARY_COLOR,
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: Styles.inputFieldTextStyle(),
    focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: PRIMARY_COLOR, width: 2),
        borderRadius: BorderRadius.circular(10)),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  ),
  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.all(PRIMARY_COLOR),
  ),
);
