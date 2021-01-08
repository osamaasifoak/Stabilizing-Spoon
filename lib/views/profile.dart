import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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
import 'package:path/path.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _emailTextEditingConrtroller;
  TextEditingController _passwordTextEditingConrtroller;
  GlobalKey<FormState> _formKey;
  GlobalKey<ScaffoldState> _scaffoldKey;
  User _user = FirebaseAuth.instance.currentUser;

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
      appBar: AppBar(
        backgroundColor: ColorConstant.white,
        centerTitle: false,
        elevation: 0.5,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            color: ColorConstant.purple,
          ),
        ),
        title: TextComponent(
          text: StringConstant.react.toUpperCase(),
          textAlign: TextAlign.left,
          textStyle: FontStyles.patuaOneCustomFonSizeAndWeight(
              fontSize: 35, color: ColorConstant.purple, letterSpacing: 3),
        ),
      ),
      body: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 40),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                _user.photoURL == ""
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Image.network(
                            "https://avatars2.githubusercontent.com/u/49792938?s=460&u=8a709ffa10b8cfd08c4561b37c02d17abb70927f&v=4",
                            height: 150,
                            width: 150,
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Image.network(
                            "https://pakembsofia.org.pk/wp-content/uploads/person-placeholder.jpg",
                            height: 150,
                            width: 150,
                          ),
                        ),
                      ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    FilePickerResult _imageFile =
                        await FilePicker.platform.pickFiles(
                      type: FileType.image,
                    );
                    String fileName = basename(_imageFile.files[0].path);
                    FirebaseStorage.instance.ref().child(fileName);
                  },
                  child: TextComponent(
                    text: "change profile photo",
                    textAlign: TextAlign.center,
                    textStyle: FontStyles.loraCustomFonSizeAndWeight(
                        fontSize: 14,
                        color: ColorConstant.purple,
                        letterSpacing: 2),
                  ),
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
                        // Navigator.of(context).pushAndRemoveUntil(
                        //     MaterialPageRoute(builder: (context) => Home()),
                        //     (Route<dynamic> route) => false);
                      }
                    }
                  },
                  buttonText: StringConstant.saveChanges,
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
