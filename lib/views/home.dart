import 'package:flutter/material.dart';
import 'package:react/components/text_component.dart';
import 'package:react/constants/colors/colors_constants.dart';
import 'package:react/constants/routes/routes_constants.dart';
import 'package:react/constants/strings/string_constants.dart';
import 'package:react/constants/styles/font_styles_constants.dart';
import 'package:react/uiUtils/size_config.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<_SalesData> data = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 34),
    _SalesData('Apr', 32),
    _SalesData('May', 40)
  ];
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
            //Initialize the chart widget
            SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              title: ChartTitle(text: 'Your daily stats'),
              // Enable legend
              legend: Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<_SalesData, String>>[
                LineSeries<_SalesData, String>(
                    dataSource: data,
                    xValueMapper: (_SalesData sales, _) => sales.year,
                    yValueMapper: (_SalesData sales, _) => sales.sales,
                    name: 'Sales',
                    isVisibleInLegend: false,
                    color: ColorConstant.purple,
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: true))
              ],
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
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
