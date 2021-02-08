import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:react/components/button_component.dart';
import 'package:react/components/text_component.dart';
import 'package:react/constants/assets/assets_constants.dart';
import 'package:react/constants/colors/colors_constants.dart';
import 'package:react/constants/routes/routes_constants.dart';
import 'package:react/constants/strings/string_constants.dart';
import 'package:react/constants/styles/font_styles_constants.dart';
import 'package:react/models/spoon_value_model.dart';
import 'package:react/uiUtils/size_config.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String stringJson;
  DateTime selectedDate = new DateTime.now();
  final databaseReference = FirebaseDatabase.instance.reference();
  User _user = FirebaseAuth.instance.currentUser;
  // List<double> _crossHair = [];
  List<SpoonValues> _todayStats = [];
  List<_SalesData> chartsData = [];
  @override
  void initState() {
    super.initState();
    databaseReference.child("spoon_value").onValue.listen((event) {
      SpoonValues _spoonValue = new SpoonValues(x: "0", y: "0");
      if (event.snapshot.value != null) {
        // DataSnapshot _spoonSnapshot = event.snapshot.value;
        _spoonValue = new SpoonValues.fromJson(event.snapshot.value);
        stringJson = "{\"month\":" +
            selectedDate.month.toString() +
            ",\"year\":\"" +
            selectedDate.year.toString() +
            "\",\"date\":\"" +
            selectedDate.day.toString() +
            "\",\"x\":\"" +
            _spoonValue.x.toString() +
            "\",\"y\":\"" +
            _spoonValue.y.toString() +
            "\",\"date_time\":\"" +
            selectedDate.toString() +
            "\"}";
        databaseReference
            .child(_user.uid.toString())
            .child(selectedDate.year.toString())
            .child(selectedDate.month.toString())
            .push()
            .set({"user_data": stringJson});
      }
    });
  }

  Future<Null> _selectDate(BuildContext context) async {
    showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1, 5),
      lastDate: DateTime.now(),
      initialDate: selectedDate,
      locale: Locale("en"),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: ColorConstant.purple,
            accentColor: ColorConstant.purple,
            colorScheme: ColorScheme.light(
              primary: ColorConstant.purple,
            ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    ).then((date) {
      if (date != null) {
        // String test;
        setState(() {
          selectedDate = date;
        });
        print(selectedDate);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        height: SizeConfig.screenHeight,
        width: SizeConfig.screenWidth,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextComponent(
                      text: StringConstant.react.toUpperCase(),
                      textAlign: TextAlign.left,
                      textStyle: FontStyles.patuaOneCustomFonSizeAndWeight(
                          fontSize: 35,
                          color: ColorConstant.purple,
                          letterSpacing: 3),
                    ),
                    InkWell(
                      onTap: () {
                        // User _user = FirebaseAuth.instance.currentUser;
                        Navigator.pushNamed(context, RouteConstants.profile);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: FutureBuilder(
                            future: databaseReference
                                .child("users")
                                .child(_user.uid)
                                .child("profile_image")
                                .once(),
                            builder: (context, snapshot) {
                              return Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Image.network(
                                  snapshot.hasData &&
                                          snapshot.data.value != null
                                      ? snapshot.data.value
                                      : "https://www.mountsinai.on.ca/wellbeing/our-team/team-images/person-placeholder/image",
                                  height: 40,
                                  width: 40,
                                ),
                              );
                            }),
                      ),
                    )
                  ],
                ),
                //Initialize the chart widget
                FutureBuilder(
                  future: databaseReference
                      .child(_user.uid)
                      .child(selectedDate.year.toString())
                      .child(selectedDate.month.toString())
                      .once(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        !snapshot.hasError &&
                        snapshot.data.value != null) {
                      // DataSnapshot _spoonSnapshot = snapshot.data.value;
                      Map<dynamic, dynamic> data = snapshot.data.value;
                      double sumXvalues = 0.0;
                      double sumYvalues = 0.0;
                      int count = 0;
                      chartsData.clear();
                      data.forEach((key, value) {
                        var temp = json.decode(value["user_data"]);
                        if (selectedDate.day == int.parse(temp["date"])) {
                          sumXvalues = sumXvalues + double.parse(temp["x"]);
                          sumYvalues = sumYvalues + double.parse(temp["y"]);
                          count = ++count;
                        }
                        print(count);
                      });
                      if (count != 0) {
                        chartsData
                            .add(_SalesData("x", ((sumXvalues / count) * 100)));
                        chartsData.add(_SalesData(
                            "stable point", ((sumXvalues - sumYvalues))));
                        chartsData
                            .add(_SalesData("y", ((sumYvalues / count) * 100)));
                      } else {
                        chartsData.add(_SalesData("x", 0));
                        chartsData.add(_SalesData("stable point", 0));
                        chartsData.add(_SalesData("y", 0));
                      }
                    }
                    return SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      // Chart title
                      title: ChartTitle(
                          text: 'Your stats of: ' +
                              selectedDate.day.toString() +
                              '-' +
                              selectedDate.month.toString() +
                              '-' +
                              selectedDate.year.toString()),
                      // Enable legend
                      legend: Legend(isVisible: true),
                      // Enable tooltip
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <ChartSeries<_SalesData, String>>[
                        LineSeries<_SalesData, String>(
                            dataSource: chartsData,
                            xValueMapper: (_SalesData sales, _) => sales.year,
                            yValueMapper: (_SalesData sales, _) => sales.sales,
                            // pointColorMapper: ,
                            name: 'Stats',
                            isVisibleInLegend: false,
                            color: ColorConstant.purple,
                            // Enable data label
                            dataLabelSettings:
                                DataLabelSettings(isVisible: true))
                      ],
                    );
                  },
                ),
                SizedBox(
                  height: 24,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextComponent(
                    text: "Trend",
                    textAlign: TextAlign.left,
                    textStyle: FontStyles.patuaOneCustomFonSizeAndWeight(
                        fontSize: 25,
                        color: ColorConstant.purple,
                        letterSpacing: 3),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: SizeConfig.screenWidth,
                  decoration: new BoxDecoration(
                      color: ColorConstant.purple,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.trending_up,
                              color: ColorConstant.white,
                              size: 50,
                            ),
                            TextComponent(
                              text:
                                  "Hey Keep it up\nyou're on the \nright track",
                              textAlign: TextAlign.left,
                              textStyle: FontStyles.loraCustomFonSizeAndWeight(
                                  fontSize: 16,
                                  color: ColorConstant.white,
                                  letterSpacing: 3),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        AssetConstant.happyPana,
                        height: 200,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 120,
        child: ButtonComponent(
          onPressed: () async {
            _selectDate(context);
          },
          buttonText: StringConstant.selectDate,
          color: ColorConstant.purple,
          border: 20,
          textStyle: FontStyles.loraCustomFonSizeAndWeight(
              color: ColorConstant.white,
              letterSpacing: 0.2,
              fontWeight: FontWeight.w400,
              fontSize: 14.0),
        ),
      ),
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales, {this.color});

  final String year;
  final double sales;
  final Color color;
}
