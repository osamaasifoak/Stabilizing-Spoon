import 'package:flutter/material.dart';
import 'package:react/views/on_boarding/on_boarding_view.dart';
import 'constants/routes/routes_constants.dart';

onGenerateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case RouteConstants.onboarding:
      return MaterialPageRoute(builder: (_) => OnBoardingView());
    // case RouteConstants.login:
    //   return MaterialPageRoute(builder: (_) => LoginScreen());
    default:
  }
}
