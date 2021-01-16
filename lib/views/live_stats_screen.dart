import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:react/components/button_component.dart';
import 'package:react/components/text_component.dart';
import 'package:react/constants/colors/colors_constants.dart';
import 'package:react/constants/routes/routes_constants.dart';
import 'package:react/constants/strings/string_constants.dart';
import 'package:react/constants/styles/font_styles_constants.dart';
import 'package:react/models/spoon_value_model.dart';
import 'package:react/uiUtils/size_config.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LiveStatsScreen extends StatefulWidget {
  @override
  _LiveStatsScreenState createState() => _LiveStatsScreenState();
}

class _LiveStatsScreenState extends State<LiveStatsScreen> {
  String stringJson;
  DateTime selectedDate = new DateTime.now();
  final databaseReference = FirebaseDatabase.instance.reference();
  User _user = FirebaseAuth.instance.currentUser;
  bool recordStats = false;
  List<_SalesData> chartsData = [
    // _SalesData('Jan-2020', 35),
    // _SalesData('Feb-2020', 28),
    // _SalesData('Mar-2020', 34),
    // _SalesData('Apr-2020', 32),
    // _SalesData('May-2020', 40)
  ];
  Future<Null> _selectDate(BuildContext context) async {
    showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1, 5),
      lastDate: DateTime(DateTime.now().year + 1, 9),
      initialDate: selectedDate,
      locale: Locale("en"),
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
        child: Padding(
          padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
          child: Column(children: [
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
                    child: Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Image.network(
                        "https://avatars2.githubusercontent.com/u/49792938?s=460&u=8a709ffa10b8cfd08c4561b37c02d17abb70927f&v=4",
                        height: 40,
                        width: 40,
                      ),
                    ),
                  ),
                )
              ],
            ),
            recordStats
                ? StreamBuilder(
                    stream: databaseReference.child("spoon_value").onValue,
                    builder: (context, AsyncSnapshot snapshot) {
                      SpoonValues _spoonValue = new SpoonValues(x: "0", y: "0");
                      if (snapshot.hasData &&
                          !snapshot.hasError &&
                          snapshot.data.snapshot.value != null) {
                        DataSnapshot _spoonSnapshot = snapshot.data.snapshot;
                        _spoonValue =
                            new SpoonValues.fromJson(_spoonSnapshot.value);
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
                      return Column(
                        children: [
                          Container(
                            child: SfCircularChart(
                              // Enables the tooltip for all the series in chart
                              tooltipBehavior: TooltipBehavior(enable: true),
                              series: [
                                // Initialize line series
                                PieSeries<_SalesData, String>(
                                    // Enables the tooltip for individual series
                                    enableTooltip: true,
                                    dataSource: [
                                      // Bind data source
                                      _SalesData(
                                          'x', double.parse(_spoonValue.x),
                                          color: ColorConstant.purple),
                                      _SalesData(
                                          'y', double.parse(_spoonValue.y),
                                          color: ColorConstant.warmGrey),
                                    ],
                                    pointColorMapper: (_SalesData sales, _) =>
                                        sales.color,
                                    xValueMapper: (_SalesData sales, _) =>
                                        sales.year,
                                    yValueMapper: (_SalesData sales, _) =>
                                        sales.sales),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextComponent(
                                text: "X-AXIS: " + _spoonValue.x.toString(),
                                textAlign: TextAlign.left,
                                textStyle:
                                    FontStyles.patuaOneCustomFonSizeAndWeight(
                                        fontSize: 25,
                                        color: ColorConstant.purple,
                                        letterSpacing: 3),
                              ),
                              TextComponent(
                                text: "Y-AXIS: " + _spoonValue.y.toString(),
                                textAlign: TextAlign.left,
                                textStyle:
                                    FontStyles.patuaOneCustomFonSizeAndWeight(
                                        fontSize: 25,
                                        color: ColorConstant.purple,
                                        letterSpacing: 3),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  )
                : SizedBox(
                    height: SizeConfig.screenHeight / 1.5,
                    child: Center(
                      child: TextComponent(
                        text: "Press start recording button to record stats",
                        textAlign: TextAlign.center,
                        textStyle: FontStyles.patuaOneCustomFonSizeAndWeight(
                            fontSize: 20,
                            color: ColorConstant.warmGrey,
                            letterSpacing: 3),
                      ),
                    ),
                  ),

            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   //Initialize the spark charts widget
            //   child: SfSparkLineChart.custom(
            //     //Enable the trackball
            //     trackball: SparkChartTrackball(
            //         activationMode: SparkChartActivationMode.tap),
            //     //Enable marker
            //     marker:
            //         SparkChartMarker(displayMode: SparkChartMarkerDisplayMode.all),
            //     //Enable data label
            //     labelDisplayMode: SparkChartLabelDisplayMode.all,
            //     xValueMapper: (int index) => data[index].year,
            //     yValueMapper: (int index) => data[index].sales,
            //     dataCount: 5,
            //   ),
            // )
          ]),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 150,
        child: ButtonComponent(
          onPressed: () async {
            setState(() {
              if (recordStats) {
                recordStats = false;
              } else {
                recordStats = true;
              }
            });
          },
          buttonText: recordStats ? "Stop Recording" : "Start Recording",
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
