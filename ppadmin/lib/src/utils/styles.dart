import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ppadmin/src/config/color_constants.dart';

class Styles {
  static tableTitleTextStyle({
    Color color = TEXT_COLOR_TITLE,
    FontWeight fontWeight = FontWeight.w500,
    double fontSize = 15,
    FontStyle fontStyle = FontStyle.normal,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
    );
  }

  static tableValuesTextStyle({
    Color color = TEXT_COLOR_SUBTITLE,
    FontWeight fontWeight = FontWeight.w400,
    double fontSize = 14,
    FontStyle fontStyle = FontStyle.normal,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
    );
  }
}
