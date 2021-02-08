import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:react/components/text_component.dart';
import 'package:react/constants/colors/colors_constants.dart';
import 'package:react/constants/styles/font_styles_constants.dart';
import 'package:react/services/firebase_services.dart';
import 'package:react/uiUtils/size_config.dart';
import 'package:react/views/auth/login.dart';

class DemoReadingsScreen extends StatefulWidget {
  @override
  _DemoReadingsScreenState createState() => _DemoReadingsScreenState();
}

class _DemoReadingsScreenState extends State<DemoReadingsScreen> {
  String stringJson;
  DateTime selectedDate = new DateTime.now();
  final databaseReference = FirebaseDatabase.instance.reference();
  User _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        child: Padding(
          padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  await FirebaseServices().signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                      (Route<dynamic> route) => false);
                },
                child: Container(
                  child: TextComponent(
                    text: "logout",
                    textAlign: TextAlign.left,
                    textStyle: FontStyles.patuaOneCustomFonSizeAndWeight(
                        fontSize: 25,
                        color: ColorConstant.purple,
                        letterSpacing: 3),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Container(
                  width: SizeConfig.screenWidth,
                  color: ColorConstant.appBlack,
                  child: Center(
                    child: InkWell(
                      onTap: () async {
                        stringJson = "{\"month\":" +
                            selectedDate.month.toString() +
                            ",\"year\":\"" +
                            selectedDate.year.toString() +
                            "\",\"date\":\"" +
                            selectedDate.day.toString() +
                            "\",\"x\":\"" +
                            random(1, 100).toString() +
                            "\",\"y\":\"" +
                            random(-100, 100).toString() +
                            "\",\"date_time\":\"" +
                            selectedDate.toString() +
                            "\"}";
                        await databaseReference
                            .child(_user.uid.toString())
                            .child(selectedDate.year.toString())
                            .child(selectedDate.month.toString())
                            .push()
                            .set(
                          {"user_data": stringJson},
                        );
                      },
                      child: TextComponent(
                        text: "send data",
                        textAlign: TextAlign.left,
                        textStyle: FontStyles.patuaOneCustomFonSizeAndWeight(
                            fontSize: 25,
                            color: ColorConstant.white,
                            letterSpacing: 3),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  random(min, max) {
    var rn = new Random();
    return min + rn.nextInt(max - min);
  }
}

class _SalesData {
  _SalesData(this.year, this.sales, {this.color});

  final String year;
  final double sales;
  final Color color;
}
