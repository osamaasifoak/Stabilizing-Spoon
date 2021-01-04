import 'package:flutter/material.dart';
import 'package:react/constants/assets/assets_constants.dart';

class OnBoardingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset(AssetConstant.onboarding_1),
          Container(),
        ],
      ),
    );
  }
}
