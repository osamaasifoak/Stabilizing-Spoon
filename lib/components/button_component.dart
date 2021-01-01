
import 'package:flutter/material.dart';
import 'package:react/components/text_component.dart';
import 'package:react/constants/colors/colors_constants.dart';
import 'package:react/constants/styles/font_styles_constants.dart';

class ButtonComponent extends StatelessWidget {
  final void Function() onPressed;
  final String buttonText;
  final double border;
  final Color color;
  final TextStyle textStyle;
  const ButtonComponent(
      {Key key,
      this.onPressed,
      @required this.buttonText,
      this.border = 0.0,
      this.color,
      this.textStyle})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(border),
      ),
      color: color,
      height: 48,
      minWidth: MediaQuery.of(context).size.width,
      child: TextComponent(
        text: buttonText,
        textStyle: textStyle != null
            ? textStyle
            : FontStyles.heeboNormalF12WithW400(color: ColorConstant.white),
      ),
      onPressed: onPressed != null ? onPressed : () => {},
    );
  }
}
