import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:react/components/button_component.dart';
import 'package:react/components/input_component.dart';
import 'package:react/components/text_component.dart';
import 'package:react/constants/colors/colors_constants.dart';
import 'package:react/constants/strings/share_preferences_constant.dart';
import 'package:react/constants/strings/string_constants.dart';
import 'package:react/constants/styles/font_styles_constants.dart';
import 'package:react/main.dart';
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
  TextEditingController _mobileTextEditingConrtroller;
  TextEditingController _fullnameTextEditingConrtroller;
  TextEditingController _ageTextEditingConrtroller;
  GlobalKey<FormState> _formKey;
  GlobalKey<ScaffoldState> _scaffoldKey;
  User _user = FirebaseAuth.instance.currentUser;
  final databaseReference = FirebaseDatabase.instance.reference();
  @override
  void initState() {
    super.initState();
    _emailTextEditingConrtroller = new TextEditingController();
    _mobileTextEditingConrtroller = new TextEditingController();
    _fullnameTextEditingConrtroller = new TextEditingController();
    _ageTextEditingConrtroller = new TextEditingController();
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
          text: "Profile",
          textAlign: TextAlign.left,
          textStyle: FontStyles.patuaOneCustomFonSizeAndWeight(
              fontSize: 18, color: ColorConstant.purple, letterSpacing: 3),
        ),
        actions: [
          InkWell(
            onTap: () async {
              await FirebaseServices().signOut();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => SplashScreen(),
                  ),
                  (Route<dynamic> route) => false);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.exit_to_app,
                color: ColorConstant.purple,
              ),
            ),
          )
        ],
      ),
      body: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 20),
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
                        allowMultiple: false,
                        type: FileType.image,
                      );
                      String fileName;
                      File path;
                      if (_imageFile.files.length != 0) {
                        try {
                          path = new File(_imageFile.files[0].path);
                          fileName = basename(_imageFile.files[0].name);
                          var snapshot = FirebaseStorage.instance
                              .ref()
                              .child("profile_images/");
                          await snapshot.child(fileName).putFile(path);
                          var url = await snapshot.getDownloadURL();

                          databaseReference
                              .child("users")
                              .child(_user.uid.toString())
                              .set({"profile_image": url});
                          print(url);
                        } catch (ex) {
                          SnackbarConstant.showInSnackBar(
                              "Something went wrong during change profile.",
                              _scaffoldKey);
                        }
                      }
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
                    title: StringConstant.fullName,
                    controller: _fullnameTextEditingConrtroller,
                    fillColor: ColorConstant.paleGrey,
                    filled: true,
                    validator: (value) {
                      if (value == "") {
                        return "Fullname field can't be empty";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextInputComponent(
                    title: StringConstant.mobileNumber,
                    controller: _mobileTextEditingConrtroller,
                    fillColor: ColorConstant.paleGrey,
                    filled: true,
                    inputType: TextInputType.number,
                    validator: (value) {
                      if (value == "") {
                        return "Mobile number field can't be empty";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextInputComponent(
                    title: "Age",
                    controller: _ageTextEditingConrtroller,
                    fillColor: ColorConstant.paleGrey,
                    inputType: TextInputType.number,
                    filled: true,
                    validator: (value) {
                      if (value == "") {
                        return "Age field can't be empty";
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
                        try {
                          databaseReference
                              .child("users")
                              .child(_user.uid.toString())
                              .set({
                            "fullname": _fullnameTextEditingConrtroller.text,
                            "mobile_number": _mobileTextEditingConrtroller.text,
                            "age": _ageTextEditingConrtroller.text
                          });
                        } catch (ex) {
                          print(ex);
                        }
                      }
                      Navigator.pop(context);
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
      ),
    );
  }
}
