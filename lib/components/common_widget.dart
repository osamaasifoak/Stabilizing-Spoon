

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:react/constants/assets/assets_constants.dart';
import 'package:react/constants/colors/colors_constants.dart';
import 'package:react/constants/strings/string_constants.dart';
import 'package:react/constants/styles/font_styles_constants.dart';
import 'package:react/uiUtils/size_config.dart';

class CommonWidgets {

  // service
  static Padding buildServicesDetailListItemWidget(int index,
      {String serviceTitle = StringConstant.selectedServices,
      bool fromCart = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          index == 0 || index == 5
              ? buildServiceCategoryNameWidget(serviceTitle)
              : Container(),
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorConstant.paleGrey,
              borderRadius: BorderRadius.all(
                Radius.circular(6),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: SizeConfig.screenWidth / 5.5,
                  width: SizeConfig.screenWidth / 5.5,
                  decoration: BoxDecoration(
                    color: ColorConstant.lightKhaki,
                    borderRadius: BorderRadius.all(
                      Radius.circular(6),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SvgPicture.asset(
                      AssetConstant.flash,
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(16, 16, 8, 14),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quick Booking',
                              style:
                                  FontStyles.heeboNormalCustomFonSizetWithW500(
                                      color: ColorConstant.darkGreyBlue,
                                      fontSize: 12.0),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(AssetConstant.moneyService),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Rs. 550 PKR',
                                  style: FontStyles
                                      .heeboNormalCustomFonSizetWithW500(
                                          color: ColorConstant.darkGreyBlue,
                                          fontSize: 12.0),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              StringConstant.servicesInclude,
                              style:
                                  FontStyles.heeboNormalCustomFonSizetWithW500(
                                      color: ColorConstant.darkGreyBlue,
                                      fontSize: 10.0),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '• General leakage of pipes',
                              style:
                                  FontStyles.heeboNormalCustomFonSizetWithW500(
                                      color: ColorConstant.charcoal,
                                      fontSize: 10.0),
                            ),
                            Text(
                              '• Basic fixes of exposed pipe',
                              style:
                                  FontStyles.heeboNormalCustomFonSizetWithW500(
                                      color: ColorConstant.charcoal,
                                      fontSize: 10.0),
                            ),
                            Text(
                              '• Leakage Protection with ins',
                              style:
                                  FontStyles.heeboNormalCustomFonSizetWithW500(
                                      color: ColorConstant.charcoal,
                                      fontSize: 10.0),
                            ),
                          ],
                        ),
                        Positioned(
                          right: 0,
                          child: fromCart
                              ? _buildRemoveOrderWidget()
                              : Container(
                                  height: 25,
                                  width: 80,
                                  child: _addedButtonWidget(),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  //TODO add ripple effect on this , ripple effect isn't working because previous layout has background color
  static InkWell _buildRemoveOrderWidget() {
    return InkWell(
      enableFeedback: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.delete,
              color: ColorConstant.darkGreyBlue,
              size: 15,
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              StringConstant.removeFromOrder,
              style: FontStyles.heeboNormalCustomFonSizetWithW500(
                  color: ColorConstant.darkGreyBlue, fontSize: 12.0),
            ),
          ],
        ),
      ),
      onTap: () {
        print('yes');
      },
    );
  }

  static FlatButton _addButtonWidget() {
    return FlatButton(
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color: ColorConstant.darkGreyBlue,
              width: 1,
              style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(3)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            StringConstant.serviceAdd,
            style: FontStyles.heeboNormalCustomFonSizetWithW500(
                color: ColorConstant.charcoal, fontSize: 10.0),
          ),
          SizedBox(
            width: 3,
          ),
          Icon(
            Icons.add,
            size: 12,
          ),
        ],
      ),
      onPressed: () {},
    );
  }

  static FlatButton _addedButtonWidget() {
    return FlatButton(
      color: ColorConstant.kellyGreen,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            StringConstant.servicesAdded,
            style: FontStyles.heeboNormalCustomFonSizetWithW500(
                color: ColorConstant.white, fontSize: 10.0),
          ),
          SizedBox(
            width: 3,
          ),
          Icon(
            Icons.check,
            size: 12,
            color: ColorConstant.white,
          ),
        ],
      ),
      onPressed: () {},
    );
  }

  static Text buildServiceCategoryNameWidget(String serviceName) {
    return Text(
      serviceName,
      style: FontStyles.heeboNormalCustomFonSizetWithW500(
          color: ColorConstant.darkGreyBlue, fontSize: 15.0),
    );
  }
}
