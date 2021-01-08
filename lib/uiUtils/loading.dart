import 'package:flutter/material.dart';
import 'package:react/constants/colors/colors_constants.dart';

class LoaderConstant {
  static loadingpopups(context, {String message}) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => true,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(
                      strokeWidth: 10,
                      backgroundColor: ColorConstant.purple,
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          ColorConstant.white),
                    )),
                SizedBox(height: 10),
              ],
            )),
          );
        });
  }
}
