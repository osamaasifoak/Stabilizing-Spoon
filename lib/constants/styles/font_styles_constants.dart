import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontStyles {
  static TextStyle heeboNormalF12WithW400({
    @required Color color,
    double letterSpacing = 0.0,
    double fontSize = 12.0,
  }) =>
      GoogleFonts.heebo(
          color: color,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          letterSpacing: letterSpacing,
          fontSize: fontSize);

  static TextStyle heeboNormalCustomFonSizetWithW500(
          {@required Color color,
          double letterSpacing = 0.0,
          double fontSize = 12.0,
          FontWeight fontWeight = FontWeight.w500}) =>
      GoogleFonts.heebo(
          color: color,
          fontWeight: fontWeight,
          fontStyle: FontStyle.normal,
          letterSpacing: letterSpacing,
          fontSize: fontSize);

  static TextStyle kateNormalF60WithW400(
          {@required Color color, double letterSpacing = 0.0}) =>
      TextStyle(
          color: color,
          fontWeight: FontWeight.w400,
          fontFamily: "Kate",
          fontStyle: FontStyle.normal,
          letterSpacing: letterSpacing,
          fontSize: 60.0);

  static TextStyle kateMediumF25WithW400(
          {@required Color color, double letterSpacing = 0.0}) =>
      TextStyle(
        color: color,
        fontWeight: FontWeight.w400,
        fontFamily: "Kate",
        fontStyle: FontStyle.normal,
        letterSpacing: letterSpacing,
        fontSize: 25.0,
      );
}
