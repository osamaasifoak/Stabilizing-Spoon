import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:react/components/button_component.dart';
import 'package:react/components/input_component.dart';
import 'package:react/components/text_component.dart';
import 'package:react/constants/colors/colors_constants.dart';
import 'package:react/constants/routes/routes_constants.dart';
import 'package:react/constants/strings/share_preferences_constant.dart';
import 'package:react/constants/strings/string_constants.dart';
import 'package:react/constants/styles/font_styles_constants.dart';
import 'package:react/services/firebase_services.dart';
import 'package:react/services/shared_preferences_services.dart';
import 'package:react/uiUtils/loading.dart';
import 'package:react/uiUtils/size_config.dart';
import 'package:react/uiUtils/snackbar.dart';
import '../home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailTextEditingConrtroller;
  TextEditingController _passwordTextEditingConrtroller;
  GlobalKey<FormState> _formKey;
  GlobalKey<ScaffoldState> _scaffoldKey;
  @override
  void initState() {
    super.initState();
    _emailTextEditingConrtroller = new TextEditingController();
    _passwordTextEditingConrtroller = new TextEditingController();
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
                TextInputComponent(
                  title: StringConstant.password,
                  controller: _passwordTextEditingConrtroller,
                  fillColor: ColorConstant.paleGrey,
                  filled: true,
                  obscureText: true,
                  validator: (value) {
                    if (value == "") {
                      return "Password field can't be empty";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 24,
                ),
                ButtonComponent(
                  onPressed: () async {
                    LoaderConstant.loadingpopups(context);
                    if (_formKey.currentState.validate()) {
                      var res = await FirebaseServices().signIn(
                          email: _emailTextEditingConrtroller.text,
                          password: _passwordTextEditingConrtroller.text);
                      if (res == 'user-not-found') {
                        SnackbarConstant.showInSnackBar(
                            'No user found for that email.', _scaffoldKey);
                        Navigator.pop(context);
                      } else if (res == 'wrong-password') {
                        SnackbarConstant.showInSnackBar(
                            'Wrong password provided for that user.',
                            _scaffoldKey);
                        Navigator.pop(context);
                      } else if (res.user.uid != "") {
                        await SharedPreferenceService().addStringInSF(
                            SharedPreferenceConstant.user,
                            res.user.email.toString());
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                            (Route<dynamic> route) => false);
                      }
                    } else {
                      Navigator.pop(context);
                    }
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
                  child: InkWell(
                    enableFeedback: true,
                    onTap: () async {
                      Navigator.pushNamed(
                          context, RouteConstants.forgotPassword);
                    },
                    child: TextComponent(
                      text: StringConstant.forgotPassword,
                      textAlign: TextAlign.center,
                      textStyle: FontStyles.loraCustomFonSizeAndWeight(
                          fontSize: 16,
                          color: ColorConstant.purple,
                          letterSpacing: 5),
                    ),
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
