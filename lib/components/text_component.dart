import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:react/constants/colors/colors_constants.dart';

class TextComponent extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final TextStyle textStyle;
  const TextComponent(
      {Key key, this.text, this.textAlign = TextAlign.left, this.textStyle})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign,
        style: textStyle != null
            ? textStyle
            : GoogleFonts.patuaOne(
                fontSize: 12, color: ColorConstant.charcoal));
  }
}
