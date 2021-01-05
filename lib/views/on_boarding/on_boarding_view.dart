import 'package:flutter/material.dart';
import 'package:react/components/button_component.dart';
import 'package:react/components/text_component.dart';
import 'package:react/constants/assets/assets_constants.dart';
import 'package:react/constants/colors/colors_constants.dart';
import 'package:react/constants/routes/routes_constants.dart';
import 'package:react/constants/strings/string_constants.dart';
import 'package:react/constants/styles/font_styles_constants.dart';
import 'package:react/uiUtils/size_config.dart';

class OnBoardingView extends StatefulWidget {
  @override
  _OnBoardingViewState createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  int pageIndex = 0;
  final pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        height: SizeConfig.screenHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: PageView(
                controller: pageController,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index) {
                  setState(() {
                    pageIndex = index;
                  });
                },
                children: [
                  _centerImageWithText(
                      image: AssetConstant.onboarding_1,
                      text: StringConstant.onboarding_1),
                  _centerImageWithText(
                      image: AssetConstant.onboarding_2,
                      text: StringConstant.onboarding_2),
                  _centerImageWithText(
                      image: AssetConstant.onboarding_3,
                      text: StringConstant.onboarding_3),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 3; i++)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _indicatorDotsWidget(
                        color: pageIndex == i
                            ? ColorConstant.purple
                            : ColorConstant.warmGrey,
                        width: pageIndex == i ? 24 : 10),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10, top: 20, bottom: 80),
              child: ButtonComponent(
                buttonText: StringConstant.gettingStarted,
                textStyle: FontStyles.patuaOneCustomFonSizeAndWeight(
                    fontSize: 18,
                    color: ColorConstant.white,
                    letterSpacing: 3,
                    fontWeight: FontWeight.normal),
                onPressed: () =>
                    {Navigator.pushNamed(context, RouteConstants.login)},
                color: ColorConstant.purple,
                border: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _centerImageWithText({@required String text, @required String image}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(image),
        Container(
          width: SizeConfig.screenWidth / 1.3,
          padding: EdgeInsets.only(top: 30),
          child: TextComponent(
            text: text,
            textAlign: TextAlign.center,
            textStyle: FontStyles.patuaOneCustomFonSizeAndWeight(
                fontSize: 18, color: ColorConstant.purple, letterSpacing: 3),
          ),
        ),
      ],
    );
  }

  Container _indicatorDotsWidget(
      {@required Color color, @required double width}) {
    return Container(
      height: 8,
      width: width,
      decoration: new BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(10)),
    );
  }
}
