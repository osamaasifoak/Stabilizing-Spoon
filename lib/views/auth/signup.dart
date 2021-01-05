import 'package:flutter/material.dart';
import 'package:react/components/button_component.dart';
import 'package:react/components/input_component.dart';
import 'package:react/components/text_component.dart';
import 'package:react/constants/colors/colors_constants.dart';
import 'package:react/constants/routes/routes_constants.dart';
import 'package:react/constants/strings/string_constants.dart';
import 'package:react/constants/styles/font_styles_constants.dart';
import 'package:react/uiUtils/size_config.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _fullNameTextEditingConrtroller;
  TextEditingController _mobileNumberTextEditingConrtroller;
  @override
  void initState() {
    super.initState();
    _fullNameTextEditingConrtroller = new TextEditingController();
    _mobileNumberTextEditingConrtroller = new TextEditingController();
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
                TextInputComponent(
                  title: StringConstant.fullName,
                  controller: _fullNameTextEditingConrtroller,
                  fillColor: ColorConstant.paleGrey,
                  filled: true,
                ),
                SizedBox(
                  height: 16,
                ),
                TextInputComponent(
                  title: StringConstant.fullName,
                  controller: _fullNameTextEditingConrtroller,
                  fillColor: ColorConstant.paleGrey,
                  filled: true,
                ),
                SizedBox(
                  height: 16,
                ),
                TextInputComponent(
                  title: StringConstant.fullName,
                  controller: _fullNameTextEditingConrtroller,
                  fillColor: ColorConstant.paleGrey,
                  filled: true,
                ),
                SizedBox(
                  height: 16,
                ),
                TextInputComponent(
                  title: StringConstant.mobileNumber,
                  controller: _mobileNumberTextEditingConrtroller,
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
                  buttonText: StringConstant.signup,
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
                TextComponent(
                  text: StringConstant.login,
                  textAlign: TextAlign.center,
                  textStyle: FontStyles.loraCustomFonSizeAndWeight(
                      fontSize: 16,
                      color: ColorConstant.purple,
                      letterSpacing: 5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
