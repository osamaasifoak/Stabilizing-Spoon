import 'package:flutter/material.dart';
import 'package:owesome_validator/owesome_validator.dart';
import 'package:react/components/button_component.dart';
import 'package:react/components/input_component.dart';
import 'package:react/components/text_component.dart';
import 'package:react/constants/colors/colors_constants.dart';
import 'package:react/constants/strings/share_preferences_constant.dart';
import 'package:react/constants/strings/string_constants.dart';
import 'package:react/constants/styles/font_styles_constants.dart';
import 'package:react/services/firebase_services.dart';
import 'package:react/services/shared_preferences_services.dart';
import 'package:react/uiUtils/loading.dart';
import 'package:react/uiUtils/size_config.dart';
import 'package:react/uiUtils/snackbar.dart';
import 'package:react/views/home.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
                      fontSize: 80,
                      color: ColorConstant.purple,
                      letterSpacing: 3),
                ),
                SizedBox(
                  height: 40,
                ),
                TextInputComponent(
                  title: StringConstant.email,
                  controller: _emailTextEditingConrtroller,
                  fillColor: ColorConstant.paleGrey,
                  filled: true,
                  validator: (value) {
                    if (!OwesomeValidator.email(
                        value, OwesomeValidator.patternEmail)) {
                      return "Invalid email";
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
                  validator: (value) {
                    if (!OwesomeValidator.password(
                        value,
                        OwesomeValidator
                            .passwordMinLen8withLowerCaseAndSpecialChar)) {
                      return "Invalid password";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 24,
                ),
                ButtonComponent(
                  onPressed: () async {
                    print(
                      await SharedPreferenceService()
                          .getStringInSF(SharedPreferenceConstant.user),
                    );
                    LoaderConstant.loadingpopups(context);
                    if (_formKey.currentState.validate()) {
                      var res = await FirebaseServices().register(
                          email: _emailTextEditingConrtroller.text,
                          password: _passwordTextEditingConrtroller.text);
                      if (res == 'weak-password') {
                        SnackbarConstant.showInSnackBar(
                            'The password provided is too weak.',
                            _scaffoldKey);
                        Navigator.pop(context);
                      } else if (res == 'email-already-in-use') {
                        SnackbarConstant.showInSnackBar(
                            'The account already exists for that email.',
                            _scaffoldKey);
                        Navigator.pop(context);
                      } else if (res.user.uid != "") {
                        await SharedPreferenceService().addStringInSF(
                            SharedPreferenceConstant.user,
                            res.user.email.toString());
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => HomeScreen()),
                            (Route<dynamic> route) => false);
                      } else {
                        SnackbarConstant.showInSnackBar(
                            'Something went wrong.', _scaffoldKey);
                      }
                    }
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
