import 'package:flutter/material.dart';
import 'package:react/components/button_component.dart';
import 'package:react/components/input_component.dart';
import 'package:react/components/text_component.dart';
import 'package:react/constants/colors/colors_constants.dart';
import 'package:react/constants/routes/routes_constants.dart';
import 'package:react/constants/strings/string_constants.dart';
import 'package:react/constants/styles/font_styles_constants.dart';
import 'package:react/uiUtils/size_config.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailTextEditingConrtroller;
  TextEditingController _passwordTextEditingConrtroller;
  @override
  void initState() {
    super.initState();
    _emailTextEditingConrtroller = new TextEditingController();
    _passwordTextEditingConrtroller = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextComponent(
                  text: StringConstant.react.toUpperCase(),
                  textAlign: TextAlign.center,
                  textStyle: FontStyles.patuaOneCustomFonSizeAndWeight(
                      fontSize: 80,
                      color: ColorConstant.purple,
                      letterSpacing: 3),
                ),
                SizedBox(
                  height: 40,
                ),
                TextComponent(
                  text: "Please " + StringConstant.login,
                  textAlign: TextAlign.center,
                  textStyle: FontStyles.loraCustomFonSizeAndWeight(
                      fontSize: 16,
                      color: ColorConstant.purple,
                      letterSpacing: 5),
                ),
                SizedBox(
                  height: 30,
                ),
                TextInputComponent(
                  title: StringConstant.email,
                  controller: _emailTextEditingConrtroller,
                  fillColor: ColorConstant.paleGrey,
                  filled: true,
                ),
                SizedBox(
                  height: 16,
                ),
                TextInputComponent(
                  title: StringConstant.password,
                  controller: _passwordTextEditingConrtroller,
                  fillColor: ColorConstant.paleGrey,
                  filled: true,
                ),
                SizedBox(
                  height: 24,
                ),
                ButtonComponent(
                  onPressed: () => {
                    Navigator.pushNamed(context, RouteConstants.otpVerification)
                  },
                  buttonText: StringConstant.login,
                  color: ColorConstant.purple,
                  border: 20,
                  textStyle: FontStyles.patuaOneCustomFonSizeAndWeight(
                      color: ColorConstant.white,
                      letterSpacing: 1.3,
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0),
                ),
                SizedBox(
                  height: 16,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextComponent(
                    text: StringConstant.forgotPassword,
                    textAlign: TextAlign.center,
                    textStyle: FontStyles.loraCustomFonSizeAndWeight(
                        fontSize: 16,
                        color: ColorConstant.purple,
                        letterSpacing: 5),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RouteConstants.signup);
                  },
                  child: TextComponent(
                    text: StringConstant.signup,
                    textAlign: TextAlign.center,
                    textStyle: FontStyles.loraCustomFonSizeAndWeight(
                        fontSize: 16,
                        color: ColorConstant.purple,
                        letterSpacing: 5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
