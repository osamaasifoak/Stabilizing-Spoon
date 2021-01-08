import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:react/components/text_component.dart';
import 'package:react/constants/assets/assets_constants.dart';
import 'package:react/constants/colors/colors_constants.dart';
import 'package:react/constants/routes/routes_constants.dart';
import 'package:react/constants/strings/string_constants.dart';
import 'package:react/constants/styles/font_styles_constants.dart';
import 'package:react/routes.dart';
import 'package:react/services/firebase_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (RouteSettings settings) {
        return onGenerateRoutes(settings);
      },
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    // FirebaseServices().signOut();
    Future.delayed(Duration(seconds: 3), () {
      if (user != null) {
        Navigator.pushNamed(context, RouteConstants.homeScreen);
      } else {
        Navigator.pushNamed(context, RouteConstants.onboarding);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(AssetConstant.splash),
            TextComponent(
              text: StringConstant.react.toUpperCase(),
              textAlign: TextAlign.center,
              textStyle: FontStyles.patuaOneCustomFonSizeAndWeight(
                  fontSize: 80, color: ColorConstant.purple, letterSpacing: 3),
            ),
            TextComponent(
              text: StringConstant.eatingPartner,
              textAlign: TextAlign.center,
              textStyle: FontStyles.patuaOneCustomFonSizeAndWeight(
                  fontSize: 26, color: ColorConstant.purple, letterSpacing: 3),
            )
          ],
        ),
      ),
    );
  }
}
