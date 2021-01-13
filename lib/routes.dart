import 'package:flutter/material.dart';
import 'package:react/views/auth/forgotPassword.dart';
import 'package:react/views/auth/login.dart';
import 'package:react/views/auth/signup.dart';
import 'package:react/views/bottom_screen.dart';
import 'package:react/views/home.dart';
import 'package:react/views/live_stats_screen.dart';
import 'package:react/views/on_boarding/on_boarding_view.dart';
import 'package:react/views/profile.dart';
import 'constants/routes/routes_constants.dart';

onGenerateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case RouteConstants.onboarding:
      return MaterialPageRoute(builder: (_) => OnBoardingScreen());
    case RouteConstants.login:
      return MaterialPageRoute(builder: (_) => LoginScreen());
    case RouteConstants.signup:
      return MaterialPageRoute(builder: (_) => SignupScreen());
    case RouteConstants.homeScreen:
      return MaterialPageRoute(builder: (_) => HomeScreen());
    case RouteConstants.profile:
      return MaterialPageRoute(builder: (_) => ProfileScreen());
    case RouteConstants.forgotPassword:
      return MaterialPageRoute(builder: (_) => ForgotPassword());
    case RouteConstants.bottomBarScreen:
      return MaterialPageRoute(builder: (_) => BottomBarScreen());
    case RouteConstants.liveStatsscreen:
      return MaterialPageRoute(builder: (_) => LiveStatsScreen());
    default:
  }
}
