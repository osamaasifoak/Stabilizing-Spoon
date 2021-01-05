import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:react/constants/colors/colors_constants.dart';
import 'package:react/constants/styles/font_styles_constants.dart';

class TextInputComponent extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String action;
  final bool enabled, filled;
  final TextInputAction textInputAction;
  final FocusNode currentFocus, nextFocus;
  final Color fillColor;
  final String intialValue;
  final int maxLength;
  final ValueChanged<String> onChanged;
  final void Function(String) onFieldSubmitted;
  final String Function(String) validator;
  const TextInputComponent(
      {Key key,
      this.controller,
      @required this.title,
      this.action,
      this.enabled,
      this.textInputAction,
      this.currentFocus,
      this.nextFocus,
      this.maxLength,
      this.fillColor,
      this.onChanged,
      this.intialValue,
      this.filled,
      this.onFieldSubmitted,
      this.validator})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        initialValue: intialValue,
        onChanged: onChanged,
        maxLength: maxLength != null ? maxLength : null,
        obscureText: false,
        enabled: this.enabled,
        focusNode: currentFocus,
        textInputAction: textInputAction,
        onFieldSubmitted: (value) {
          if (textInputAction == TextInputAction.next) {
            print(value + "callback");
            currentFocus.unfocus();
            FocusScope.of(context).requestFocus(nextFocus);
          }
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            labelText: title,
            fillColor: fillColor,
            filled: filled,
            suffixIcon: SizedBox(),
            labelStyle:
                FontStyles.heeboNormalF12WithW400(color: ColorConstant.purple),
            enabledBorder: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(24.0),
              borderSide: new BorderSide(color: ColorConstant.paleGrey),
            ),
            focusedBorder: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(24.0),
                borderSide: new BorderSide(
                  color: ColorConstant.paleGrey,
                ))),
        cursorColor: ColorConstant.darkGreyBlue,
        style: TextStyle(
          fontSize: 14.0,
          color: ColorConstant.darkGreyBlue,
        ),
        validator: validator);
  }
}
