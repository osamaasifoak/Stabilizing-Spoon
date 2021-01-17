import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:react/components/button_component.dart';
import 'package:react/components/input_component.dart';
import 'package:react/components/text_component.dart';
import 'package:react/constants/colors/colors_constants.dart';
import 'package:react/constants/strings/string_constants.dart';
import 'package:react/constants/styles/font_styles_constants.dart';
import 'package:react/services/firebase_services.dart';
import 'package:react/uiUtils/loading.dart';
import 'package:react/uiUtils/size_config.dart';
import 'package:react/uiUtils/snackbar.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _emailTextEditingConrtroller;
  GlobalKey<FormState> _formKey;
  GlobalKey<ScaffoldState> _scaffoldKey;
  @override
  void initState() {
    super.initState();
    _emailTextEditingConrtroller = new TextEditingController();
    _formKey = GlobalKey<FormState>();
    _scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextComponent(
                  text: StringConstant.react.toUpperCase(),
                  textAlign: TextAlign.center,
                  textStyle: FontStyles.patuaOneCustomFonSizeAndWeight(
                      fontSize: 35,
                      color: ColorConstant.purple,
                      letterSpacing: 3),
                ),
                SizedBox(
                  height: 40,
                ),
                TextComponent(
                  text: "Enter your email for reset password link",
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
                  validator: (value) {
                    if (value == "") {
                      return "Email field can't be empty";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                ButtonComponent(
                  onPressed: () async {
                    LoaderConstant.loadingpopups(context);
                    var res = await FirebaseServices().forgotPassword(
                        email: _emailTextEditingConrtroller.text);
                    if (res == true) {
                      SnackbarConstant.showInSnackBar(
                          'Password reset link send to your email. ',
                          _scaffoldKey);
                    } else if (res == "user-not-found") {
                      SnackbarConstant.showInSnackBar(
                          'There is no user record corresponding to this identifier. The user may have been deleted.',
                          _scaffoldKey);
                    } else {
                      SnackbarConstant.showInSnackBar(
                          'Something went wrong.', _scaffoldKey);
                    }
                    Navigator.pop(context);
                  },
                  buttonText: StringConstant.resetPassword,
                  color: ColorConstant.purple,
                  border: 20,
                  textStyle: FontStyles.patuaOneCustomFonSizeAndWeight(
                      color: ColorConstant.white,
                      letterSpacing: 1.3,
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
